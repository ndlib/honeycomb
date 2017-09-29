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

var MetaDataConfigurationReorderItem = React.createClass({
  propTypes: {
    id: React.PropTypes.number,
    field: React.PropTypes.object.isRequired,
    index: React.PropTypes.number.isRequired,
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
      <mui.Card style={{ cursor: "move", height: "55px" }}>
        <mui.CardHeader
          title={ this.props.field.label }
          avatar={ <FontIcon className="material-icons">reorder</FontIcon> } />
      </mui.Card>
    </div>)
    );
  },
});

function Instantiate(type) {
  return DragSource(type, metadataCollectionSource, source_collect)(MetaDataConfigurationReorderItem);
}


module.exports = Instantiate;
