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
          thumbUrl = "https://image.freepik.com/free-icon/black-paper-tag_318-33822.jpg";
          break;

        case 'page':
          thumbUrl = "http://c.dryicons.com/images/icon_sets/symbolize_icons_set/png/128x128/new_page.png";
          break;

        case 'showcase':
          thumbUrl = "https://d30y9cdsu7xlg0.cloudfront.net/png/2248-200.png";
          break;

        default:
          thumbUrl = "https://cdn4.iconfinder.com/data/icons/geomicons/32/672366-x-128.png";
      }
    }

    return (
      <img src={thumbUrl} className="hc-thumbnail-image" style={ this.props.extraStyle } />
    );
  }
});
module.exports = Thumbnail;
