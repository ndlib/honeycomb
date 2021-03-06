var React = require("react");
var mui = require("material-ui");

var ReactLink = require('react/lib/ReactLink');
var ReactStateSetters = require('react/lib/ReactStateSetters');
var update = require('react/lib/update');

var MetaDataConfigurationListItem = require("./MetaDataConfigurationListItem");
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

  handleNewClick: function() {
    this.setState({ selectedField: Math.random().toString(36).substring(2)});
  },


  handleEditClick: function(fieldName) {
    this.setState({ selectedField: fieldName });
  },

  handleRemove: function(fieldName) {
    MetaDataConfigurationActions.changeActive(fieldName, false, this.props.baseUpdateUrl);
  },

  handleClose: function() {
    this.setState( { selectedField: undefined });
  },

  getFieldItems: function() {
    return this.state.fields.map(function(field) {
      return [
      <MetaDataConfigurationListItem
        key={ field.name }
        field={ field }
        handleEditClick={ this.handleEditClick }
        handleRightClick={ this.handleRemove } />,
      ];
    }.bind(this));
  },

  addButtonStyle: function() {
    return {
      position: "absolute",
      top: "-16px",
      left: "8px",
      zIndex: "1"
    };
  },

  render: function() {
    var { selectedField } = this.state;

    return (
      <div>
        <FloatingActionButton onMouseDown={ this.handleNewClick } onTouchStart={ this.handleNewClick } mini={true} style={ this.addButtonStyle() }>
          <ContentAdd />
        </FloatingActionButton>
        <MetaDataFieldDialog
          fieldName={ selectedField }
          open={ selectedField != undefined }
          baseUpdateUrl={ this.props.baseUpdateUrl }
          handleClose={ this.handleClose }
        />
        <List style={ this.listStyle() } >
          { this.getFieldItems() }
        </List>
      </div>
    );
  },
});

module.exports = MetaDataConfigurationList;
