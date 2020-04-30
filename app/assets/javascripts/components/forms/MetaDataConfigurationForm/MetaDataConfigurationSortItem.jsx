var React = require("react");
var mui = require("material-ui");
var Colors = require("material-ui/lib/styles/colors");
var DragSource = require('react-dnd').DragSource;
var EventEmitter = require('../../../EventEmitter');
var MetadataConfigurationEventTypes = require("./MetaDataConfigurationEventTypes");

var ListItem = mui.ListItem;
var FontIcon = mui.FontIcon;
var IconButton = mui.IconButton;

var metadataCollectionSource = {
  beginDrag: function (props, monitor, component) {
    return props;
  },

  endDrag: function (props, monitor, component) {
    if (monitor.didDrop()) {
      var item = monitor.getItem();
      var dropResult = monitor.getDropResult();
      EventEmitter.emit(MetadataConfigurationEventTypes.SortDroppedOnTarget, dropResult, item);
    }
  }
}

function source_collect(connect, monitor) {
  return {
    connectDragSource: connect.dragSource(),
    connectDragPreview: connect.dragPreview(),
    isDragging: monitor.isDragging(),
  };
}

var MetaDataConfigurationSortItem = React.createClass({
  propTypes: {
    sort: React.PropTypes.shape({
      name: React.PropTypes.string,
      label: React.PropTypes.string,
      limit: React.PropTypes.number,
      field: React.PropTypes.shape({
        name: React.PropTypes.string,
        label: React.PropTypes.string,
        type: React.PropTypes.string.isRequired,
      }).isRequired,
    }).isRequired,
    handleEditClick: React.PropTypes.func.isRequired,
    handleRemoveClick: React.PropTypes.func.isRequired,
    index: React.PropTypes.number.isRequired,
  },

  handleEdit(event) {
    return this.props.handleEditClick(this.props.sort, event);
  },

  render() {
    var name = this.props.sort.name || this.props.sort.field.name;
    var label = this.props.sort.label || this.props.sort.field.label;
    var { connectDragSource, connectDragPreview, isDragging } = this.props;

    var reorderHandle = connectDragSource(
      <div><FontIcon className='material-icons' style={{ cursor: 'move', marginRight: '24px' }}>reorder</FontIcon></div>
    );
    return (
      <mui.Paper>
        {connectDragPreview(
          <div onClick={this.handleEdit} className='sort-list-item'>
            <div className='left-side'>
              {reorderHandle}
              {label}
            </div>
            <IconButton onTouchTap={function() { this.props.handleRemoveClick(name) }.bind(this)}>
              <FontIcon className='material-icons' color={Colors.grey500} hoverColor={Colors.red500}>delete</FontIcon>
            </IconButton>
          </div>
        )}
      </mui.Paper>
    );
  }
})

module.exports = DragSource(MetadataConfigurationEventTypes.SortDnD, metadataCollectionSource, source_collect)(MetaDataConfigurationSortItem);
