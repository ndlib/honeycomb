var React = require('react');
var ReactDOM = require('react-dom')

var DragContent = React.createClass({
  getInitialState: function() {
    return {
      mounted: false,
      box: null
    };
  },

  style: function() {
    var left = this.props.left;
    var top = this.props.top;

    if (this.state.mounted) {
      var box = this.state.box;
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
      box: ReactDOM.findDOMNode(this).getBoundingClientRect()
    });
  },

  render: function() {
    return (
      <div style={this.style()}>
        {this.props.content}
      </div>
    );
  }
});

module.exports = DragContent;
