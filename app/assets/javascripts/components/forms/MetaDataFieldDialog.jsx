var React = require('react');
var mui = require("material-ui");
var Dialog = mui.Dialog;
var RaisedButton = mui.RaisedButton;
var FlatButton = mui.FlatButton;
var update = require('react-addons-update');
var ReactLink = require('react/lib/ReactLink');
var ReactStateSetters = require('react/lib/ReactStateSetters');
var MetaDataConfigurationActions = require("../../actions/MetaDataConfigurationActions");
var MetaDataConfigurationActionTypes = require("../../constants/MetaDataConfigurationActionTypes");

var MetaDataFieldDialog = React.createClass({
  mixins: [MuiThemeMixin],

  propTypes: {
    open: React.PropTypes.bool.isRequired,
    createForm: React.PropTypes.bool,
    baseUpdateUrl: React.PropTypes.string.isRequired,
    fieldName: React.PropTypes.string,
  },

  getDefaultProps: function() {
    return {
      createForm: false
    }
  },

  // Creating custom react link so that we can store the field values
  // in state.fieldValues instead of flat within state, in order
  // to easily serialize this to json when updating the store.
  linkFieldState: function(key) {
    return new ReactLink(
      this.state["fieldValues"][key],
      function(value) { this.updateFieldValue(key, value); }.bind(this)
    );
  },

  // Updates a specific value within state.fieldValues
  updateFieldValue: function(key, value) {
    var kvp = {};
    kvp[key] = value;
    if (key == "required") {
      kvp["defaultFormField"] = true
    }

    var fieldValues = update(this.state.fieldValues, {$merge: kvp});
    this.setState({ fieldValues: fieldValues });
  },

  getInitialState: function() {
    return {
      open: this.props.open,
      fieldName: this.props.fieldName,
      saving: false,
      createForm: false,
    };
  },

  componentWillMount: function() {
    MetaDataConfigurationActions.on("ChangeFieldFinished", this.handleSaved);
    MetaDataConfigurationActions.on("CreateFieldFinished", this.handleSaved);
  },

  componentWillReceiveProps: function(nextProps) {
    if(nextProps.open) {
      // Clone store field values, otherwise the linked states will directly change the store
      var fieldValues;
      var createFrom;
      if (MetaDataConfigurationStore.fields[nextProps.fieldName]) {
        fieldValues= MetaDataConfigurationStore.fields[nextProps.fieldName];
        createFrom = false;
      } else {
        fieldValues = _. mapObject(_.find(MetaDataConfigurationStore.fields), function() { return null; });
        createFrom = true;
      }
      this.setState({
        open: nextProps.open,
        fieldName: nextProps.fieldName,
        fieldValues: fieldValues,
        createForm: createFrom,
      });
    }
  },

  componentDidUpdate: function(prevProps, prevState) {
    if(this.state.open){
      this.refs.EditMetaDialog.show();
    } else {
      this.refs.EditMetaDialog.dismiss();
    }
  },

  handleSave: function() {
    if(this.state.createForm){
      MetaDataConfigurationActions.createField(this.state.fieldName, this.state.fieldValues, this.props.baseUpdateUrl);
    } else {
      MetaDataConfigurationActions.changeField(this.state.fieldName, this.state.fieldValues, this.props.baseUpdateUrl);
    }
    this.setState({ saving: true });
  },

  handleSaved: function(success, data) {
    if(success) {
      this.setState({ open: false, fieldName: null });
    } else {
      console.log("Add error handling stuff here when !success", data);
    }
    this.setState({ saving: false });
  },

  handleClose: function() {
    this.setState({ open: false });
    this.props.handleClose();
  },

  getTypeOptions: function() {
    return [
      { payload: 'string', text: 'Text' },
      { payload: 'html', text: 'HTML' },
      { payload: 'date', text: 'Date' }
    ];
  },

  getFieldProps: function() {
    return [
      <mui.TextField style={{ width: "100%" }} floatingLabelText="Label" valueLink={ this.linkFieldState('label') } />,
      this.selectField(),
      <hr />,
      this.allowMultipleCheckbox(),
      <mui.Checkbox style={{ width: "100%" }} label="Require presence on all items?" checkedLink={ this.linkFieldState('required') } />,
      this.defaultFormFieldCheckbox(),
      <mui.Checkbox style={{ width: "100%" }} label="Show in field search list?" checkedLink={ this.linkFieldState('fieldSearch') } />,
    ];
  },

  selectField: function() {
    if (this.state.createForm) {
      return (<mui.SelectField style={{ width: "100%" }} floatingLabelText="Type" menuItems={ this.getTypeOptions() } valueLink={ this.linkFieldState('type') } />);
    }
    return "";
  },

  allowMultipleCheckbox: function() {
    if (this.state.fieldValues["type"] == "string") {
      return (<mui.Checkbox style={{ width: "100%" }} label="Allow multiple values?" checkedLink={ this.linkFieldState('multiple') } />);
    }
    return "";
  },

  defaultFormFieldCheckbox: function() {
    var disabled = false;
    if (this.state.fieldValues["required"]) {
      disabled = true;
    }

    return (<mui.Checkbox style={{ width: "100%" }} disabled={disabled} label="Always show on the item form?" checkedLink={ this.linkFieldState('defaultFormField') } />);
  },

  title: function() {
    return this.state.createForm ? "New Metadata Field" : "Edit Metadata Field";
  },

  render: function() {
    var actions = [
      <FlatButton
        label="Save"
        primary={true}
        disabled={this.state.saving}
        keyboardFocused={true}
        onTouchTap={this.handleSave}
      />,
      <FlatButton
        label="Close"
        primary={false}
        disabled={this.state.saving}
        keyboardFocused={false}
        onTouchTap={this.handleClose}
      />,
    ];
    return (
      <div>
        <Dialog
          ref="EditMetaDialog"
          title={this.title()}
          actions={actions}
          modal={true}
          bodyStyle={{ margin: "0 auto 0 auto" }}
          contentStyle={{ width: "35%" }}
          style={{ zIndex: 100 }}
          openImmediately={this.props.open}
        >
          { this.state.open && this.getFieldProps() }
        </Dialog>
      </div>
    );
  }
});
module.exports = MetaDataFieldDialog;
