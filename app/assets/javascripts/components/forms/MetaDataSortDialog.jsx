var React = require('react');
var mui = require('material-ui');
var Dialog = mui.Dialog;
var RaisedButton = mui.RaisedButton;
var FlatButton = mui.FlatButton;
var update = require('react-addons-update');
var ReactLink = require('react/lib/ReactLink');
var ReactStateSetters = require('react/lib/ReactStateSetters');
var MetaDataConfigurationActions = require('../../actions/MetaDataConfigurationActions');
var MetaDataConfigurationActionTypes = require('../../constants/MetaDataConfigurationActionTypes');
var AppEventEmitter = require("../../EventEmitter");

var MetaDataSortDialog = React.createClass({
  mixins: [MuiThemeMixin],

  propTypes: {
    open: React.PropTypes.bool.isRequired,
    createForm: React.PropTypes.bool,
    baseUpdateUrl: React.PropTypes.string.isRequired,
    sortName: React.PropTypes.string,
  },

  getInitialState() {
    return {
      open: this.props.open,
      sortName: this.props.sortName,
      saving: false,
      createForm: false,
      errors: {
        field: '',
      },
    }
  },

  componentWillMount() {
    MetaDataConfigurationActions.on('ChangeSortFinished', this.handleSaved)
    MetaDataConfigurationActions.on('CreateSortFinished', this.handleSaved)
  },

  componentWillReceiveProps(nextProps) {
    if (nextProps.open) {
      // Clone store field values, otherwise the linked states will directly change the store
      var sortValues
      var createFrom
      var match = MetaDataConfigurationStore.sorts.find(function(sort) {
        return sort.name === nextProps.sortName;
      });
      if (match) {
        sortValues = match;
        createFrom = false;
      } else {
        sortValues = _. mapObject(_.find(MetaDataConfigurationStore.sorts), function() { return null; });
        createFrom = true;
      }
      if (!sortValues.direction) {
        sortValues.direction = 'asc';
      }
      this.setState({
        open: nextProps.open,
        sortName: nextProps.sortName,
        sortValues: sortValues,
        createForm: createFrom,
      });
    }
  },

  componentDidUpdate(prevProps, prevState) {
    if (this.state.open) {
      this.refs.EditMetaDialog.show();
    } else {
      this.refs.EditMetaDialog.dismiss();
    }
  },

  // Creating custom react link so that we can store the field values
  // in state.sortValues instead of flat within state, in order
  // to easily serialize this to json when updating the store.
  linkSortState(key) {
    return new ReactLink(
      this.state['sortValues'][key],
      function(value) { this.updateFieldValue(key, value); }.bind(this)
    );
  },

  // Updates a specific value within state.sortValues
  updateFieldValue(key, value) {
    var kvp = {};
    kvp[key] = value;
    if (key === 'field_name') {
      kvp['name'] = value; // Sort name should match field name
      this.validateField(value);
    }

    var sortValues = update(this.state.sortValues, {$merge: kvp});
    this.setState({ sortValues: sortValues });
  },

  validateField(newValue) {
    var result = (!newValue) ? 'Field is required.' : '';
    this.setState({
      errors: {
        ...this.state.errors,
        field: result,
      },
    });
    return result;
  },

  handleSave() {
    // We won't get state updates until the next cycle, so we need to validate all form elements here
    // and check for the result instead of just checking for errors in the state.
    var errors = Object.assign({}, this.state.errors);
    errors.field = this.validateField(this.state.sortValues.field_name);
    // Now set the state with all validation errors at once
    this.setState({
      errors: errors,
    });
    // If there were any errors, cancel saving
    if (Object.values(errors).some(function(value) { return !!value; } )) {
      AppEventEmitter.emit('MessageCenterDisplay', 'error', 'Unable to save due to invalid data.');
      return;
    }

    var values = {
      ...this.state.sortValues,
      order: this.state.sortValues.order || MetaDataConfigurationStore.sorts.length+1,
    };
    if (this.state.createForm) {
      MetaDataConfigurationActions.createSort(this.state.sortName, values, this.props.baseUpdateUrl);
    } else {
      MetaDataConfigurationActions.changeSort(this.state.sortName || values.name, values, this.props.baseUpdateUrl);
    }
    this.setState({ saving: true });
  },

  handleSaved(success, data) {
    if (success) {
      this.setState({ open: false, sortName: null });
    } else {
      console.log('Add error handling stuff here when !success', data);
    }
    this.setState({ saving: false });
    this.handleClose();
  },

  handleClose() {
    this.setState({ open: false });
    this.props.handleClose();
  },

  render() {
    var actions = [
      <FlatButton
        label='Save'
        primary={true}
        disabled={this.state.saving}
        keyboardFocused={true}
        onTouchTap={this.handleSave}
      />,
      <FlatButton
        label='Close'
        primary={false}
        disabled={this.state.saving}
        keyboardFocused={false}
        onTouchTap={this.handleClose}
      />,
    ];
    var fieldOptions = Object.values(MetaDataConfigurationStore.fields || {})
       // only allow active fields as sorts
      .filter(function(field) {
        return field.active;
      }.bind(this))
      .sort(function(a, b) { return (a.order || 0) - (b.order || 0); })
      .map(function(field) {
        return {
          payload: field.name,
          text: field.label,
        };
      });
    return (
      <div>
        <Dialog
          ref='EditMetaDialog'
          title={this.state.createForm ? 'New Sort' : 'Edit Sort'}
          actions={actions}
          modal={true}
          bodyStyle={{ overflow: 'visible', margin: '0 auto' }}
          contentStyle={{ width: '35%' }}
          style={{ zIndex: 100 }}
          openImmediately={this.props.open}
        >
          { this.state.open && (
            <div>
              <mui.SelectField
                style={{ width: '100%' }}
                className='select-field'
                disabled={!this.state.createForm}
                floatingLabelText='Field'
                menuItems={fieldOptions}
                valueLink={this.linkSortState('field_name')}
                errorText={this.state.errors.field}
                errorStyle={{ top: '-15px', bottom: '0px' }}
              />
              <mui.TextField
                style={{ width: '100%' }}
                floatingLabelText='Label'
                valueLink={this.linkSortState('label')}
              />
              <label style={{ marginTop: '32px', marginBottom: '6px' }}>
                Direction
                <mui.RadioButtonGroup
                  name='direction'
                  valueSelected={this.state.sortValues.direction}
                  onChange={function(event, value) { this.updateFieldValue('direction', value); }.bind(this)}
                >
                  <mui.RadioButton value='asc' label='Ascending' />
                  <mui.RadioButton value='desc' label='Descending' />
                </mui.RadioButtonGroup>
              </label>
            </div>
          )}
        </Dialog>
      </div>
    );
  }
})

module.exports = MetaDataSortDialog;
