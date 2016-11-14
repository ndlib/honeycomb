var React = require("react");
var mui = require("material-ui");

var MediaImageOverlay = React.createClass({
  propTypes: {
    mediaType: React.PropTypes.string,
  },

  render: function() {
    var type = this.props.mediaType
    if (type && (type == "VideoObject" || type == "AudioObject")) {
      return (
        <mui.FontIcon color="white" className="material-icons"
          style={{
            position: "absolute",
            left: "50%",
            top: "50%",
            WebkitTransform: "translate(-50%, -50%)",
            textShadow: "2px 2px 5px black",
          }}
        >play_circle_filled</mui.FontIcon>
      );
    }

    return null;
  }
});
module.exports = MediaImageOverlay;
