var React = require("react");
var mui = require("material-ui");
var classNames = require("classnames");

var Thumbnail = React.createClass({
  propTypes: {
    thumbnailUrl: React.PropTypes.string,
    thumbType: React.PropTypes.oneOf(['item', 'page', 'showcase', 'collection']).isRequired,
    extraStyle: React.PropTypes.object,
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

        default:
          thumbUrl = Img.assetPath("meta-only-item.jpg");
      }
    }

    return (
      <img src={thumbUrl} className="hc-thumbnail-image" style={ this.props.extraStyle } />
    );
  }
});
module.exports = Thumbnail;
