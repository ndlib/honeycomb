var React = require('react');
var mui = require("material-ui");
var EventEmitter = require('../../EventEmitter');

var MetaDataConfigurationForm = React.createClass({
  mixins: [APIResponseMixin],

  getInitialState: function() {
    return {
      fields: this.sortedFields(),
    };
  },

  componentWillMount: function() {
    MetaDataConfigurationStore.on("MetaDataConfigurationStoreChanged", this.setFormFieldsFromConfiguration);
    MetaDataConfigurationStore.getAll();
  },

  sortedFields: function() {
    return _.sortBy(MetaDataConfigurationStore.fields, 'order');
  },

  setFormFieldsFromConfiguration: function() {
    this.setState({
      fields: this.sortedFields(),
    });
  },

  friendlyType: function(type) {
    switch(type){
      case 'string':
        return "Text";
      case 'html':
        return "HTML";
      case 'date':
        return "Date";
      default:
        return type;
    }
  },

  getFieldRows: function() {
    return this.state.fields.map(function(field) {
      return (
        <mui.TableRow>
          <mui.TableRowColumn>{ field.label }</mui.TableRowColumn>
          <mui.TableRowColumn>{ this.friendlyType(field.type) }</mui.TableRowColumn>
          <mui.TableRowColumn><mui.Checkbox disabled={ true } defaultChecked={ field.multiple } /></mui.TableRowColumn>
          <mui.TableRowColumn><mui.Checkbox disabled={ true } defaultChecked={ field.required } /></mui.TableRowColumn>
        </mui.TableRow>
      );
    }.bind(this));
  },

  render: function(){
    return (
      <mui.Table>
        <mui.TableHeader displaySelectAll={ false } >
          <mui.TableRow>
            <mui.TableHeaderColumn>Label</mui.TableHeaderColumn>
            <mui.TableHeaderColumn>Type</mui.TableHeaderColumn>
            <mui.TableHeaderColumn>Allows Multiples</mui.TableHeaderColumn>
            <mui.TableHeaderColumn>Required</mui.TableHeaderColumn>
          </mui.TableRow>
        </mui.TableHeader>
        <mui.TableBody displayRowCheckbox={ false } >
          { this.getFieldRows() }
        </mui.TableBody>
      </mui.Table>
    );
  }
});

module.exports = MetaDataConfigurationForm;
