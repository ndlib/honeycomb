var React = require("react");
var mui = require("material-ui");

var ReactLink = require('react/lib/ReactLink');
var ReactStateSetters = require('react/lib/ReactStateSetters');

var HTML5Backend = require('react-dnd-html5-backend');
var DragDropContext = require('react-dnd').DragDropContext;

var MetaDataConfigurationActions = require("../../../actions/MetaDataConfigurationActions");
var update = require('react/lib/update');

var MetaDataConfigurationList = require("./MetaDataConfigurationList");
var MetaDataConfigurationReorder = require("./MetaDataConfigurationReorder");
var MetaDataConfigurationUndelete = require("./MetaDataConfigurationUndelete");

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
var Tabs = mui.Tabs;
var Tab = mui.Tab;

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
      backgroundColor: "#7F8C8D",
    };
  },

  addButtonStyle: function() {
    return {
      position: "absolute",
      top: "-16px",
      left: "8px",
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
      selectedField: undefined,
    });
  },

  handleNewClick: function() {
    this.setState({ selectedField: Math.random().toString(36).substring(2)});
  },

  render: function(){
    var { selectedField } = this.state;

    return (
      <Tabs tabItemContainerStyle={ this.backgroundStyle() }>
        <Tab label="Edit" >
          <div>
            <FloatingActionButton onMouseDown={ this.handleNewClick } onTouchStart={ this.handleNewClick } mini={true} style={ this.addButtonStyle() }>
              <ContentAdd />
            </FloatingActionButton>
            <MetaDataConfigurationList baseUpdateUrl={this.props.baseUpdateUrl} />
          </div>
        </Tab>
        <Tab label="Reorder">
          <MetaDataConfigurationReorder baseUpdateUrl={this.props.baseUpdateUrl} />
        </Tab>
        <Tab label="Undelete">
          <MetaDataConfigurationUndelete baseUpdateUrl={this.props.baseUpdateUrl} />
        </Tab>
      </Tabs>
    );
  }
});

module.exports = DragDropContext(HTML5Backend)(MetaDataConfigurationForm);
