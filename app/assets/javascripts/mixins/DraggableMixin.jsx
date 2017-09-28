var LEFT_BUTTON = 0;
var DRAG_THRESHOLD = 3;

var DraggableMixin = {
  getInitialState: function() {
    return {
      mouseDown: false,
      dragging: false,
      top: 0,
      left: 0,
    };
  },

  draggableStyle: function() {
    if (this.state.dragging) {
      return {
        position: 'fixed',
        left: this.state.left,
        top: this.state.top,
        zIndex: '1000',
      };
    } else {
      return {};
    }
  },

  onMouseDown: function(event) {
    var pageOffset;
    if (event.button === LEFT_BUTTON) {
      event.stopPropagation();
      event.preventDefault();
      this.addEvents();
      pageOffset = ReactDOM.findDOMNode(this).getBoundingClientRect();
      return this.setState({
        mouseDown: true,
        viewportOriginX: event.pageX - document.body.scrollLeft,
        viewportOriginY: event.pageY - document.body.scrollTop,
        elementX: event.pageX - document.body.scrollLeft,
        elementY: event.pageY - document.body.scrollTop
      });
    }
  },

  onMouseUp: function() {
    this.removeEvents();
    if (this.state.dragging) {
      if (this.onDragStop) {
        this.onDragStop();
      }
      return this.setState({
        dragging: false,
        mouseDown: false
      });
    } else {
      return this.setState({
        mouseDown: false
      });
    }
  },

  onMouseMove: function(event) {
    var deltaX, deltaY, distance;
    deltaX = (event.pageX - document.body.scrollLeft) - this.state.viewportOriginX;
    deltaY = (event.pageY - document.body.scrollTop) - this.state.viewportOriginY;
    distance = Math.abs(deltaX) + Math.abs(deltaY);
    if (!this.state.dragging && distance > DRAG_THRESHOLD) {
      this.setState({
        dragging: true
      });
      if (this.onDragStart) {
        this.onDragStart();
      }
    }
    if (this.state.dragging) {
      return this.setState({
        left: this.state.elementX + deltaX,
        top: this.state.elementY + deltaY
      });
    }
  },

  addEvents: function() {
    document.addEventListener('mousemove', this.onMouseMove);
    document.addEventListener('mouseup', this.onMouseUp);
  },

  removeEvents: function() {
    document.removeEventListener('mousemove', this.onMouseMove);
    document.removeEventListener('mouseup', this.onMouseUp);
  },
};
module.exports = DraggableMixin;
