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

var MetaDataFacetDialog = React.createClass({
  mixins: [MuiThemeMixin],

  propTypes: {
    open: React.PropTypes.bool.isRequired,
    createForm: React.PropTypes.bool,
    baseUpdateUrl: React.PropTypes.string.isRequired,
    facetName: React.PropTypes.string,
  },

  getInitialState() {
    return {
      open: this.props.open,
      facetName: this.props.facetName,
      saving: false,
      createForm: false,
      errors: {
        field: '',
        limit: '',
      },
    }
  },

  componentWillMount() {
    MetaDataConfigurationActions.on('ChangeFacetFinished', this.handleSaved)
    MetaDataConfigurationActions.on('CreateFacetFinished', this.handleSaved)
  },

  componentWillReceiveProps(nextProps) {
    if (nextProps.open) {
      // Clone store field values, otherwise the linked states will directly change the store
      var facetValues
      var createFrom
      var match = MetaDataConfigurationStore.facets.find(function(facet) {
        return facet.name === nextProps.facetName;
      });
      if (match) {
        facetValues = match;
        createFrom = false;
        // Set the unlimited box to checked when opening dialog if limit is zero
        if (facetValues.limit === 0 && nextProps.open && !this.props.open) {
          facetValues.unlimited = true;
        }
      } else {
        facetValues = _. mapObject(_.find(MetaDataConfigurationStore.facets), function() { return null; });
        createFrom = true;
      }
      this.setState({
        open: nextProps.open,
        facetName: nextProps.facetName,
        facetValues: facetValues,
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
  // in state.facetValues instead of flat within state, in order
  // to easily serialize this to json when updating the store.
  linkFacetState(key) {
    return new ReactLink(
      this.state['facetValues'][key],
      function(value) { this.updateFieldValue(key, value); }.bind(this)
    );
  },

  // Updates a specific value within state.facetValues
  updateFieldValue(key, value) {
    var kvp = {};
    kvp[key] = value;
    if (key === 'field_name') {
      kvp['name'] = value; // Facet name should match field name
      this.validateField(value);
    }
    if (key === 'limit') {
      this.validateLimit(value);
    }
    if (key === 'unlimited') {
      kvp['limit'] = value ? '0' : '5';
      this.validateLimit(kvp['limit']);
    }

    var facetValues = update(this.state.facetValues, {$merge: kvp});
    this.setState({ facetValues: facetValues });
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

  validateLimit(newValue) {
    var result = (newValue !== undefined && isNaN(newValue)) ? 'Value must be a number.' : '';
    this.setState({
      errors: {
        ...this.state.errors,
        limit: result,
      },
    });
    return result;
  },

  handleSave() {
    // We won't get state updates until the next cycle, so we need to validate all form elements here
    // and check for the result instead of just checking for errors in the state.
    var errors = Object.assign({}, this.state.errors);
    errors.field = this.validateField(this.state.facetValues.field_name);
    errors.limit = this.validateLimit(this.state.facetValues.limit);
    // Now set the state with all validation errors at once
    this.setState({
      errors: errors,
    });
    // If there were any errors, cancel saving
    if (Object.values(errors).some(function(value) { return !!value; } )) {
      AppEventEmitter.emit('MessageCenterDisplay', 'error', 'Unable to save due to invalid data.');
      return;
    }

    var newLimit = parseInt(this.state.facetValues.limit, 10);
    // Anything falsy besides zero gets converted to the default value of 5
    if (!newLimit && newLimit !== 0) {
      newLimit = 5;
    }
    var values = {
      ...this.state.facetValues,
      limit: newLimit,
      order: this.state.facetValues.order || MetaDataConfigurationStore.facets.length+1,
    };
    if (this.state.createForm) {
      MetaDataConfigurationActions.createFacet(this.state.facetName, values, this.props.baseUpdateUrl);
    } else {
      MetaDataConfigurationActions.changeFacet(this.state.facetName || values.name, values, this.props.baseUpdateUrl);
    }
    this.setState({ saving: true });
  },

  handleSaved(success, data) {
    if (success) {
      this.setState({ open: false, facetName: null });
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
       // only allow active string fields as facets
      .filter(function(field) {
        return field.active && field.type === 'string' && (
          // exclude fields that already have facets, unless this is the edit form in which case it needs to be there
          !this.state.createForm || !MetaDataConfigurationStore.facets.find(function(facet) { return facet.field_name === field.name; })
        );
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
          title={this.state.createForm ? 'New Facet' : 'Edit Facet'}
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
                valueLink={this.linkFacetState('field_name')}
                errorText={this.state.errors.field}
                errorStyle={{ top: '-15px', bottom: '0px' }}
              />
              <mui.TextField
                style={{ width: '100%' }}
                floatingLabelText='Label'
                valueLink={this.linkFacetState('label')}
              />
              <div>
                <label style={{ marginTop: '32px' }}>
                  Default Options Visible
                  <mui.TextField
                    style={{ width: '100%' }}
                    disabled={this.state.facetValues.unlimited}
                    hintText='5'
                    defaultValue='5'
                    valueLink={this.linkFacetState('limit')}
                    errorText={this.state.errors.limit}
                  />
                </label>
                <mui.Checkbox
                  style={{ width: '100%' }}
                  label='Unlimited'
                  checkedLink={ this.linkFacetState('unlimited') }
                />
              </div>
            </div>
          )}
        </Dialog>
      </div>
    );
  }
})

module.exports = MetaDataFacetDialog;
