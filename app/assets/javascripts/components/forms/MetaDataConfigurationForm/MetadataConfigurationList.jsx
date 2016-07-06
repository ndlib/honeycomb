var React = require("react");
var mui = require("material-ui");

var ReactLink = require('react/lib/ReactLink');
var ReactStateSetters = require('react/lib/ReactStateSetters');
var update = require('react/lib/update');

var MetaDataConfigurationListItem = require("./MetadataConfigurationListItem");
var MetaDataConfigurationActions = require("../../../actions/MetaDataConfigurationActions");

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
  propTypes: {
    baseUpdateUrl: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      fields: this.filteredFields(false),
      selectedField: undefined,
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
      paddingBottom: "0px",
    };
  },

  handleEditClick: function(fieldName) {
    this.setState({ selectedField: fieldName });
  },

  handleRemove: function(fieldName) {
    MetaDataConfigurationActions.changeActive(fieldName, false, this.props.baseUpdateUrl);
  },

  getFieldItems: function() {
    return this.state.fields.map(function(field, index) {
      return [
      <MetaDataConfigurationListItem
        key={ field.name }
        id={ field.id }
        field={ field }
        index={ index }
        handleEditClick={ this.handleEditClick }
        handleRemove={ this.handleRemove } />,
      ];
    }.bind(this));
  },

  render: function() {
    var { selectedField } = this.state;

    return (
      <div>
        <MetaDataFieldDialog fieldName={ selectedField } open={ selectedField != undefined } baseUpdateUrl={ this.props.baseUpdateUrl }/>
        <List style={ this.listStyle() } >
          { this.getFieldItems() }
        </List>
      </div>
    );
  },
});

module.exports = MetaDataConfigurationList;
