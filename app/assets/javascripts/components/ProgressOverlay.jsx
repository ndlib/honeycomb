'use strict'
var React = require('react');
var mui = require("material-ui");

var Styles = {
  outerDiv: {
    position: "fixed",
    width: "100%",
    height: "100%",
    top: "0",
    left: "0",
    background: "rgba(0,0,0,0.50)",
    zIndex: "9999999"
  },
  circle: {
    position: "fixed",
    display: "inline-block",
    width: "50px",
    height: "50px",
    top: "50%",
    left: "50%",
    marginLeft: "-70px",
    marginTop: "-70px",
  }
};

var ProgressOverlay = React.createClass({
  render() {
    return (
      <div style={ Styles.outerDiv }>
        <mui.CircularProgress size={2} style={ Styles.circle } />
      </div>
    );
  }
});

module.exports = ProgressOverlay;
