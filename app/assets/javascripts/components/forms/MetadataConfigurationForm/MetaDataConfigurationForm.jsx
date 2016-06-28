var React = require("react");
var mui = require("material-ui");

var ReactLink = require('react/lib/ReactLink');
var ReactStateSetters = require('react/lib/ReactStateSetters');
var MetaDataConfigurationActions = require("../../../actions/MetaDataConfigurationActions");
var Colors = require("material-ui/lib/styles/colors");
var MoreVertIcons = require("material-ui/lib/svg-icons/navigation/more-vert");
var FloatingActionButton = require("material-ui/lib/floating-action-button");
var ContentAdd = require("material-ui/lib/svg-icons/content/add");
var Paper = mui.Paper;
var List = mui.List;
var FontIcon = mui.FontIcon;
var IconButton = mui.IconButton;
var Toggle = mui.Toggle;
var Toolbar = mui.Toolbar;
var ToolbarGroup = mui.ToolbarGroup;
var ToolbarTitle = mui.ToolbarTitle;

var MetaDataConfigurationForm = React.createClass({
  propTypes: {
    baseUpdateUrl: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      fields: this.filteredFields(false),
      selectedField: undefined,
      showInactive: false,
    };
  },

  componentDidMount: function() {
    MetaDataConfigurationStore.on("MetaDataConfigurationStoreChanged", this.setFormFieldsFromConfiguration);
    MetaDataConfigurationStore.getAll();
  },

  filteredFields: function(showInactive) {
    var fields = _.filter(MetaDataConfigurationStore.fields, function(field) {  return showInactive || field.active; }.bind(this));
    return this.sortedFields(fields);
  },

  sortedFields: function(fields) {
    return _.sortBy(fields, 'order');
  },

  setFormFieldsFromConfiguration: function() {
    this.setState({
      fields: this.filteredFields(this.state.showInactive),
      selectedField: undefined,
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

  backgroundStyle: function() {
    return {
      maxWidth: "500px",
      marginTop: "0px",
      marginLeft: "48px",
    };
  },

  addButtonStyle: function() {
    return {
      position: "absolute",
      top: "2.5em",
      left: "-16px",
      zIndex: "1"
    };
  },

  listStyle: function() {
    return {
      paddingBottom: "0px"
    };
  },

  getListTitle: function() {
    return this.state.showInactive ? "All Metadata Fields" : "Active Metadata Fields";
  },

  getFieldItems: function() {
    return this.state.fields.map(function(field) {
      console.log("here");
      return (<MetadataConfigurationListItem field={ field } handleEditClick={ this.handleEditClick } />);
    }.bind(this));
  },

  handleRemove: function(fieldName) {
    MetaDataConfigurationActions.changeActive(fieldName, false, this.props.baseUpdateUrl)
  },

  handleRestore: function(fieldName) {
    MetaDataConfigurationActions.changeActive(fieldName, true, this.props.baseUpdateUrl)
  },

  handleEditClick: function(fieldName) {
    this.setState({ selectedField: fieldName });
  },

  handleShowInactive: function(e, value) {
    this.setState({
      showInactive: value,
      fields: this.filteredFields(value),
      selectedField: undefined,
    });
  },

  handleNewClick: function() {
    this.setState({ selectedField: Math.random().toString(36).substring(2)});
  },

  render: function(){
    var { selectedField } = this.state;
    return (
      <Paper style={ this.backgroundStyle() } zDepth={1}>
        <MetaDataFieldDialog fieldName={ selectedField } open={ selectedField != undefined } baseUpdateUrl={ this.props.baseUpdateUrl }/>
        <Toolbar>
          <ToolbarTitle style={{ paddingLeft: "48px" }} text={ this.getListTitle() } />
          <ToolbarGroup float="left">
            <FloatingActionButton onMouseDown={ this.handleNewClick } onTouchStart={ this.handleNewClick } mini={true} style={ this.addButtonStyle() }>
              <ContentAdd />
            </FloatingActionButton>
          </ToolbarGroup>
          <ToolbarGroup float="right" style={{ top: "25%" }}>
            <Toggle onToggle={ this.handleShowInactive }/>
          </ToolbarGroup>
        </Toolbar>
        <List style={ this.listStyle() }>
          {this.getFieldItems()}
        </List>
      </Paper>
    );
  }
});

module.exports = MetaDataConfigurationForm;
