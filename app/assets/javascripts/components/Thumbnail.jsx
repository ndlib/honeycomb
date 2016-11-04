var React = require("react");
var mui = require("material-ui");
var classNames = require("classnames");

var Thumbnail = React.createClass({
  propTypes: {
    thumbnailUrl: React.PropTypes.string,
    thumbType: React.PropTypes.oneOf(['item', 'page', 'showcase', 'collection']).isRequired,
    extraStyle: React.PropTypes.object,
    mediaType: React.PropTypes.string,
  },

  mediaOverlay: function() {
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
  },

  render: function() {
    var thumbUrl = this.props.thumbnailUrl

    if (!thumbUrl || thumbUrl == "") {
      switch (this.props.thumbType) {
        case 'item':
          thumbUrl = Img.assetPath("meta-only-item.jpg");
          break;

        case 'page':
          thumbUrl = Img.assetPath("no-page.png");
          break;

        case 'showcase':
          thumbUrl = Img.assetPath("no-showcase.png");
          break;

        case 'collection':
          return (<div></div>);

        default:
          throw new Error("Trying to show thumbnail for unknown type");
      }
    }



    return (
      <div style={{ position: "relative" }} >
        <img src={thumbUrl} style={ this.props.extraStyle } className="hc-thumbnail-image"/>
        { this.mediaOverlay() }
      </div>
    );
  }
});
module.exports = Thumbnail;
