var React = require("react");
var mui = require("material-ui");
var Colors = require("material-ui/lib/styles/colors");
var MetadataConfigurationEventTypes = require("./MetaDataConfigurationEventTypes");
var DragSource = require('react-dnd').DragSource;
var EventEmitter = require('../../../EventEmitter');

var ListItem = mui.ListItem;
var FontIcon = mui.FontIcon;
var IconButton = mui.IconButton;

var metadataCollectionSource = {
  beginDrag: function (props, monitor, component) {
    return props;
  },

  endDrag: function (props, monitor, component) {
    var item = monitor.getItem();

    if(monitor.didDrop()){
      dropResult = monitor.getDropResult();
      EventEmitter.emit(MetadataConfigurationEventTypes.CardDroppedOnTarget, dropResult, item)
    } else {
      EventEmitter.emit(MetadataConfigurationEventTypes.CardDroppedOnNothing, item);
    }
  }
};

function source_collect(connect, monitor) {
  return {
    connectDragSource: connect.dragSource(),
    connectDragPreview: connect.dragPreview(),
    isDragging: monitor.isDragging()
  };
}

var MetaDataConfigurationListItem = React.createClass({
  propTypes: {
    id: React.PropTypes.number.isRequired,
    field: React.PropTypes.object.isRequired,
    index: React.PropTypes.number,
    handleEditClick: React.PropTypes.func.isRequired,
  },

  getLeftIcon: function(type) {
    switch(type){
      case 'string':
        return (<FontIcon className="material-icons">short_text</FontIcon>);
      case 'html':
        return (<FontIcon className="material-icons">format_size</FontIcon>);
      case 'date':
        return (<FontIcon className="material-icons">date_range</FontIcon>);
      default:
        return null;
    }
  },

  getRightIcon: function(field) {
    if(_.contains(field.immutable, "active")) {
      return null;
    }

    if(field.active) {
      var icon = "delete";
      return (
        <IconButton
          tooltip="Remove"
          tooltipPosition="top-center"
          onTouchTap={function() { this.handleRemove(field.name) }.bind(this) }
        >
          field.active && <FontIcon className="material-icons" color={Colors.grey500} hoverColor={Colors.red500}>{icon}</FontIcon>
        </IconButton>
      );
    } else {
      return (
        <IconButton
          tooltip="Restore"
          tooltipPosition="top-center"
          onTouchTap={function() { this.handleRestore(field.name) }.bind(this) }
        >
          field.active && <FontIcon className="material-icons" color={Colors.grey500} hoverColor={Colors.green500}>undo</FontIcon>
        </IconButton>
      );
    }
  },

  listItemStyle: function() {
    return {
      borderBottomStyle: "solid",
      borderBottomWidth: "1px",
      borderBottomColor: Colors.grey500
    };
  },

  render: function() {
    var { connectDragSource, connectDragPreview, isDragging } = this.props;
    return (connectDragSource(<div>
      <mui.Card style={{ cursor: "move" }}>
        <mui.CardHeader title={ this.props.field.name }  />
      </mui.Card>
    </div>)
    );
  },
});

function Instantiate(type) {
  return DragSource(type, metadataCollectionSource, source_collect)(MetaDataConfigurationListItem);
}

/*
<ListItem
    key={ this.props.field.name }
    primaryText={ this.props.field.label }
    secondaryText={ this.props.field.required && "Required" }
    leftIcon={ this.getLeftIcon(this.props.field.type) }
    rightIconButton={ this.getRightIcon(this.props.field) }
    onTouchTap={ function() { this.props.handleEditClick(this.props.field.name) }.bind(this) }
    style={ this.listItemStyle() }
  />
  */


module.exports = Instantiate;
