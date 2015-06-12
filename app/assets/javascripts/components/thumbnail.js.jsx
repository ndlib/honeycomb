var Thumbnail = React.createClass({
  propTypes: {
    image: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.object,
    ]),
    thumbnailSrc: React.PropTypes.string,
  },

  getInitialState: function() {
    return {
      image: null,
    };
  },

  setImage: function(image) {
    var imageObject = image['thumbnail/small'];
    if (!imageObject) {
      imageObject = image;
    }
    this.setState({
      image: imageObject,
    });
  },

  componentDidMount: function() {
    if (!this.props.thumbnailSrc) {
      if (typeof(this.props.image) == 'object') {
        this.setImage(this.props.image);
      } else {
        $.get(this.props.image, function(result) {
          this.setImage(result);
        }.bind(this));
      }
    }
  },

  thumbnailSrc: function() {
    if (this.props.thumbnailSrc) {
      return this.props.thumbnailSrc;
    } else if (this.state.image) {
      return this.state.image.contentUrl;
    } else {
      return '/images/blank.png';
    }
  },

  classes: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'hc-thumbnail': true,
      'hc-thumbnail-loading': !this.props.thumbnailSrc && !this.state.image
    });
    return classes;
  },

  render: function() {
    return (
      <span className={this.classes()}><span className="hc-thumbnail-helper"></span><img src={this.thumbnailSrc()} className="hc-thumbnail-image"/></span>
    );
  }
});
