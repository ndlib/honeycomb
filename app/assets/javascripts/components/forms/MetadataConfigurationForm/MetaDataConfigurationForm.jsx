var React = require("react");
var mui = require("material-ui");

var ReactLink = require('react/lib/ReactLink');
var ReactStateSetters = require('react/lib/ReactStateSetters');
var MetaDataConfigurationActions = require("../../../actions/MetaDataConfigurationActions");
var update = require('react/lib/update');

var MetaDataConfigurationList = require("./MetaDataConfigurationList");
var MetaDataConfigurationReorder = require("./MetaDataConfigurationReorder");

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

var MetaDataConfigurationForm = React.createClass({
  propTypes: {
    baseUpdateUrl: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      showInactive: false,
    };
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

  getListTitle: function() {
    return this.state.showInactive ? "All Metadata Fields" : "Active Metadata Fields";
  },

  getFieldItems: function() {
    return this.state.fields.map(function(field, index) {
      return [
        <AvailableDropTarget
          className="metadata-configuration-target"
          dragClassName="metadata-configuration-target-ondrag"
          hoverClassName="metadata-configuration-target-onhover"
          data={{ site_object_list: "ordered", index: index }}
        />,
      <ListItem key={ field.name } id={ field.id } field={ field } index={ index } handleEditClick={ this.handleEditClick } />,
      ];
    }.bind(this));
  },

  handleRestore: function(fieldName) {
    MetaDataConfigurationActions.changeActive(fieldName, true, this.props.baseUpdateUrl);
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
        <MetaDataConfigurationList baseUpdateUrl={this.props.baseUpdateUrl} />
      </Paper>
    );
  }
});

module.exports = MetaDataConfigurationForm;
