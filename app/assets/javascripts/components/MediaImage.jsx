var React = require('react');
var MediaImage = React.createClass({
  propTypes: {
    media: React.PropTypes.object.isRequired,
    style: React.PropTypes.string,
  },

  getDefaultProps: function() {
    return {
      style: "original",
      cssStyle: {},
      alt: "",
      title: "",
    };
  },

  image: function() {
    var thumb = null;
    if(this.props.media["@type"] == "ImageObject") {
      thumb = this.honeypot_src();
    } else {
      thumb = this.props.media.thumbnailUrl;
    }

    return (
      <Thumbnail thumbnailUrl={thumb} extraStyle={this.props.cssStyle} thumbType="item"
        mediaType={this.props.media["@type"]} title={this.props.title} alt={this.props.alt} />
    );
  },

  buzz_src: function() {
    return this.props.media['thumbnailUrl'];
  },

  honeypot_src: function() {
    var imageObject;
    if (this.props.style != "original") {
      imageObject = this.props.media["thumbnail/" + this.props.style];
    }
    if (!imageObject) {
      imageObject = this.props.media;
    }
    return imageObject.contentUrl;
  },

  render: function() {
    return this.image();
  },
});
module.exports = MediaImage;
