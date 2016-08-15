var React = require("react");
var classNames = require("classnames");

var Thumbnail = React.createClass({
  propTypes: {
    image: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.object,
    ]),
  },

  thumbnailSrc: function() {
    if (this.props.image["thumbnail/small"]) {
      return this.props.image["thumbnail/small"].contentUrl;
    } else if (this.props.image) {
      return this.props.image.contentUrl;
    } else {
      return '/images/blank.png';
    }
  },

  classes: function() {
    var classes = classNames({
      'hc-thumbnail': true,
    });
    return classes;
  },

  render: function() {
    return (
      <span className={this.classes()}><span className="hc-thumbnail-helper"></span><img src={this.thumbnailSrc()} className="hc-thumbnail-image"/></span>
    );
  }
});
module.exports = Thumbnail;
