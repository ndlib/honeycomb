var React = require("react");
var classNames = require("classnames");

var Thumbnail = React.createClass({
  propTypes: {
    thumbnailUrl: React.PropTypes.string,
    thumbType: React.PropTypes.oneOf(['item', 'page', 'showcase', 'collection']).isRequired,
    extraStyle: React.PropTypes.object,
    mediaType: React.PropTypes.string,
  },

  getDefaultProps: function() {
    return {
      alt: "",
      title: "",
    }
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
        <img src={thumbUrl} style={ this.props.extraStyle } className="hc-thumbnail-image" alt={this.props.alt} title={this.props.title}/>
        <MediaImageOverlay mediaType={this.props.mediaType} />
      </div>
    );
  }
});
module.exports = Thumbnail;
