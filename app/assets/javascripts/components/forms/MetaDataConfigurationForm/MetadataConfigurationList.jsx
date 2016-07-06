var React = require("react");
var mui = require("material-ui");

var ReactLink = require('react/lib/ReactLink');
var ReactStateSetters = require('react/lib/ReactStateSetters');
var MetaDataConfigurationActions = require("../../../actions/MetaDataConfigurationActions");
var update = require('react/lib/update');

var MetadataConfigurationEventTypes = require("./MetaDataConfigurationEventTypes");
var MetaDataConfigurationListItem = require("./MetadataConfigurationListItem");

var Colors = require("material-ui/lib/styles/colors");
var MoreVertIcons = require("material-ui/lib/svg-icons/navigation/more-vert");
var FloatingActionButton = require("material-ui/lib/floating-action-button");
var ContentAdd = require("material-ui/lib/svg-icons/content/add");

var Paper = mui.Paper;
var List = mui.List;
var Toggle = mui.Toggle;
var Toolbar = mui.Toolbar;
var ToolbarGroup = mui.ToolbarGroup;
var ToolbarTitle = mui.ToolbarTitle;

var MetaDataConfigurationList = React.createClass({

  getInitialState: function() {
    return {
      fields: this.filteredFields(false),
    }
  },

  componentDidMount: function() {
    MetaDataConfigurationStore.on("MetaDataConfigurationStoreChanged", this.setFormFieldsFromConfiguration);
    MetaDataConfigurationStore.getAll();
  },

  setFormFieldsFromConfiguration: function() {
    this.setState({
      fields: this.filteredFields(this.state.showInactive),
      selectedField: undefined,
    });
  },

  filteredFields: function(showInactive) {
    var fields = _.filter(MetaDataConfigurationStore.fields, function(field) {  return showInactive || field.active; }.bind(this));
    return this.sortedFields(fields);
  },

  sortedFields: function(fields) {
    return _.sortBy(fields, 'order');
  },

  listStyle: function() {
    return {
      paddingBottom: "0px"
    };
  },

  getFieldItems: function() {
    return this.state.fields.map(function(field, index) {
      return [
      <MetaDataConfigurationListItem key={ field.name } id={ field.id } field={ field } index={ index } handleEditClick={ this.handleEditClick } />,
      ];
    }.bind(this));
  },

  render: function() {
    return (
      <List style={ this.listStyle() } >
        { this.getFieldItems() }
      </List>
    );
  },
});

module.exports = MetaDataConfigurationList;
