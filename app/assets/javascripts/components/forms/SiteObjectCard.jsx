// A draggable site object card.
// Events:
// SiteObjectCardDroppedOnNothing - Emitted when this source is dropped outside of a valid drop target
// SiteObjectCardDroppedOnTarget - Emitted when this source is dropped onto a valid drop target
//
var React = require('react');
var ReactDOM = require('react-dom');
var update = require('react/lib/update');
var mui = require("material-ui");
var SiteObjectEventTypes = require("./SiteObjectEventTypes");
var DragSource = require('react-dnd').DragSource;
var EventEmitter = require('../../EventEmitter');

var siteObjectSource = {
  beginDrag: function (props, monitor, component) {
    return props;
  },

  endDrag: function (props, monitor, component) {
    var item = monitor.getItem();

    if(monitor.didDrop()){
      dropResult = monitor.getDropResult();
      EventEmitter.emit(SiteObjectEventTypes.CardDroppedOnTarget, dropResult, item)
    } else {
      EventEmitter.emit(SiteObjectEventTypes.CardDroppedOnNothing, item);
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

var SiteObjectCard = React.createClass({
  propTypes: {
    id: React.PropTypes.number.isRequired,
    index: React.PropTypes.number,
    site_object: React.PropTypes.object
  },

  getAvatar: function() {
    var object = this.props.site_object;
    if(object.image && object.image["@id"])
      return (<mui.Avatar src={ object.image['thumbnail\/small'].contentUrl } />);
    else {
      var letter = this.props.site_object.name.substring(0, 1);
      return (<mui.Avatar style={{color: 'red'}}>{ letter }</mui.Avatar>);
    }
  },

  render: function () {
    var { connectDragSource, connectDragPreview, isDragging } = this.props;
    return connectDragSource(
      <div>
        <mui.Card style={{ cursor: "move" }}>
          <mui.CardHeader title={ this.props.site_object.name }  avatar={ this.getAvatar() } />
        </mui.Card>
      </div>
    );
  }
});

function Instantiate(type) {
  return DragSource(type, siteObjectSource, source_collect)(SiteObjectCard);
}

module.exports = Instantiate;
