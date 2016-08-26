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
    switch(this.props.media["@type"]){
      case "ImageObject":
        return (<img src={this.honeypot_src()} style={this.props.cssStyle} title={this.props.title} alt={this.props.alt} />);
      default:
        return (<img src={this.props.media.thumbnailUrl} style={this.props.cssStyle} title={this.props.title} alt={this.props.alt} />);
    }
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
