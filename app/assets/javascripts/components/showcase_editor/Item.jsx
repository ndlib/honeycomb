var React = require('react');
var Item = React.createClass({
  mixins: [DraggableMixin],

  style: function() {
    return {
      border: 'solid',
      borderRadius: '10px',
      fontWeight: 'bold',
      fontSize: '24px',
      color: 'rgba(0, 0, 0, 0.2)',
      marginLeft: '5px',
      marginRight: '5px',
      overflow: 'hidden',
      display: 'inline-block',
      position: 'relative',
    };
  },

  titleBarStyle: function() {
    return {
      position: 'absolute',
      fontSize: '14px',
      color: 'white',
      fontWeight: '300',
      left: '50%',
      bottom: '0',
      WebkitTransform: "translate(-50%, -20%)",
      backgroundColor: "rgba(0, 0, 0, 0.4)",
      zIndex: '1',
      width: "100%",
    };
  },

  titleStyle: function() {
    return {
      overflow: "hidden",
      textOverflow: "ellipsis",
      textAlign: "center",
      margin: "0",
    }
  },

  onDragStart: function() {
    this.props.onDragStart(this.props.item, 'new_item');
  },

  onDragStop: function() {
    this.props.onDragStop();
  },

  title: function() {
    return (
      <div style={this.titleBarStyle()}>
        <p style={this.titleStyle()}>{this.props.item.name}</p>
      </div>
    );
  },

  render: function() {
    var dragContent = (
      <MediaImage media={this.props.item.media} style="small" cssStyle={{height: '100px', margin: '5px'}} title={this.props.item.name} />
    );
    return (
      <div className='cursor-grab' onMouseDown={this.onMouseDown} style={this.style()}>
        <DragContent content={dragContent} dragging={this.state.dragging} left={this.state.left} top={this.state.top} />
        {this.title()}
        <MediaImage media={this.props.item.media} style="small" cssStyle={{height: '100px', margin: '5px'}} title={this.props.item.name} />
      </div>
    );
  }
});
module.exports = Item;
