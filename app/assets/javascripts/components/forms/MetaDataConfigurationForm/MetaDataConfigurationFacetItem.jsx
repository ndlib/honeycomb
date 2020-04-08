const React = require("react")
const mui = require("material-ui")
const Colors = require("material-ui/lib/styles/colors")
const DragSource = require('react-dnd').DragSource
const EventEmitter = require('../../../EventEmitter')
const MetadataConfigurationEventTypes = require("./MetaDataConfigurationEventTypes")

const ListItem = mui.ListItem
const FontIcon = mui.FontIcon
const IconButton = mui.IconButton

const metadataCollectionSource = {
  beginDrag: function (props, monitor, component) {
    return props
  },

  endDrag: function (props, monitor, component) {
    if (monitor.didDrop()) {
      const item = monitor.getItem()
      const dropResult = monitor.getDropResult()
      EventEmitter.emit(MetadataConfigurationEventTypes.FacetDroppedOnTarget, dropResult, item)
    }
  }
}

function source_collect(connect, monitor) {
  return {
    connectDragSource: connect.dragSource(),
    connectDragPreview: connect.dragPreview(),
    isDragging: monitor.isDragging(),
  }
}

const MetaDataConfigurationFacetItem = React.createClass({
  propTypes: {
    facet: React.PropTypes.shape({
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

  render() {
    const name = this.props.facet.name || this.props.facet.field.name
    const label = this.props.facet.label || this.props.facet.field.label
    const { connectDragSource, connectDragPreview, isDragging } = this.props

    const reorderHandle = connectDragSource(
      <div><FontIcon className='material-icons' style={{ cursor: 'move', marginRight: '24px' }}>reorder</FontIcon></div>
    )
    return (
      <mui.Paper>
        {connectDragPreview(
          <div onClick={(event) => this.props.handleEditClick(this.props.facet, event)} className='facet-list-item'>
            <div className='left-side'>
              {reorderHandle}
              {label}
            </div>
            <IconButton onTouchTap={() => this.props.handleRemoveClick(name)}>
              <FontIcon className='material-icons' color={Colors.grey500} hoverColor={Colors.red500}>delete</FontIcon>
            </IconButton>
          </div>
        )}
      </mui.Paper>
    )
  }
})

module.exports = DragSource(MetadataConfigurationEventTypes.FacetDnD, metadataCollectionSource, source_collect)(MetaDataConfigurationFacetItem)
