var ItemShowImageBox = React.createClass({
  propTypes: {
    image: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.object,
    ]),
    thumbnailSrc: React.PropTypes.string,
    itemID: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      image: null,
    };
  },

  render: function() {
    return (
      <div className="hc-item-show-image-box">
        <ItemImageZoomButton image={this.props.image} itemID={this.props.itemID} />
        <Thumbnail image={this.props.image} thumbnailSrc={this.props.thumbnailSrc} />
      </div>
    );
  }
});
