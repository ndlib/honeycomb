/** @jsx React.DOM */

var DragContent = React.createClass({
  getInitialState: function() {
    return {
      mounted: false,
    };
  },

  style: function() {
    var left = this.props.left;
    var top = this.props.top;

    if (this.state.mounted) {
      var box = this.getDOMNode().getBoundingClientRect();
      console.log(box);
      top = top - (box.height / 2);
      left = left - (box.width / 2);
    }
    var styles = {
      position: 'fixed',
      left: left,
      top: top,
      zIndex: 1000,
      pointerEvents: 'none',
      boxShadow: '0 2px 5px rgba(0, 0, 0, 0.8)',
    };
    if (!this.props.dragging) {
      styles.display = 'none';
    }
    return styles;
  },

  componentDidMount: function() {
    this.setState({
      mounted: true,
    });
  },

  render: function() {
    var dragclass = " drag ";
    if (this.props.dragging) {
      dragclass = "" + dragclass + " dragging";
    } else {
      dragclass = "" + dragclass + " hidden";
    }
    return (
      <div className={dragclass} style={this.style()}>
        {this.props.content}
      </div>
    );
  }
});
