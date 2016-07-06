var React = require("react");
var mui = require("material-ui");

var ReactLink = require('react/lib/ReactLink');
var ReactStateSetters = require('react/lib/ReactStateSetters');
var MetaDataConfigurationActions = require("../../../actions/MetaDataConfigurationActions");
var update = require('react/lib/update');

var HTML5Backend = require('react-dnd-html5-backend');
var DragDropContext = require('react-dnd').DragDropContext;
var EventEmitter = require('../../../EventEmitter');

var MetadataConfigurationEventTypes = require("./MetaDataConfigurationEventTypes");
var MetaDataConfigurationReorderItem = require("./MetaDataConfigurationReorderItem");
var ListItem = MetaDataConfigurationReorderItem(MetadataConfigurationEventTypes.MetaDataConfigurationDnD);
var AvailableDropTarget = StylableDropTarget(MetadataConfigurationEventTypes.MetaDataConfigurationDnD);

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

var MetaDataConfigurationReorder = React.createClass({

  getInitialState: function() {
    EventEmitter.on(MetadataConfigurationEventTypes.CardDroppedOnTarget, this.handleDrop);

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

  handleDrop: function(target, source) {
    if(source.index == target.index){
      return;
    }

    this.moveCard(source.index, target.index, source.field);
  },

  moveCard: function(fromIndex, toIndex, field) {
    var removeIndex = fromIndex;
    if(toIndex < fromIndex) {
      removeIndex++;
    }

    this.setState(update(this.state, {
      fields: {
        $splice: [
          [toIndex, 0, field],
          [removeIndex, 1],
        ]
      }
    }), this.pushChanges);
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

  render() {
    return (
      <List style={ this.listStyle() } >
        <AvailableDropTarget
          className="metadata-configuration-target"
          dragClassName="metadata-configuration-target-footer-ondrag"
          hoverClassName="metadata-configuration-target-onhover"
          data={{ site_object_list: "ordered", index: 0 }}
        />
        {this.getFieldItems()}
      </List>
    );
  },
});

module.exports = MetaDataConfigurationReorder;
