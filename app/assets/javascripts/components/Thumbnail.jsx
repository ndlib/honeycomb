var React = require("react");
var mui = require("material-ui");
var classNames = require("classnames");

var Thumbnail = React.createClass({
  propTypes: {
    thumbnailUrl: React.PropTypes.string,
    media: React.PropTypes.object
  },

  thumbnailUrl: function() {
    if (this.props.thumbnailUrl) {
      return this.props.thumbnailUrl;
    } else if (this.props.media.thumbnailUrl) {
      return this.props.media.thumbnailUrl;
    } else if (this.props.media["thumbnail/small"]) {
      return this.props.media["thumbnail/small"];
    } else if (this.props.media["thumbnail/medium"]) {
      return this.props.media["thumbnail/medium"];
    } else if (this.props.media.contentUrl) {
      return this.props.media.contentUrl;
    }
    return "";
    console.log("Unable to determine thumbnail");
  },

  render: function() {
    if (this.thumbnailUrl()) {
      return (
        <img src={this.thumbnailUrl()} className="hc-thumbnail-image" />
      );
    } else {
      return (<mui.FontIcon  className="material-icons">local_offer</mui.FontIcon>);
    }
  }
});
module.exports = Thumbnail;
