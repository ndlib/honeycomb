var React = require('react');
var mui = require('material-ui');
var CircularProgress = mui.CircularProgress;
var EventEmitter = require("../EventEmitter");

var ItemShowImageBox = React.createClass({
  mixins: [MuiThemeMixin],

  propTypes: {
    item: React.PropTypes.object,         // Item object from ItemDecorator
    itemPath: React.PropTypes.string,     // The path to the API to retrieve item's image details
    maxRetries: React.PropTypes.number,   // Max number of times it should retry to get the image
    retryInterval: React.PropTypes.number // How frequent it should retry to get the image, in ms
  },

  testImageStatus: function () {

    if (this.props.item.image_status == "unavailable") {
      EventEmitter.emit("MessageCenterDisplay", "error", "There was a problem loading the media. Try replacing or contacting support.");
    }
  },

  renderMedia: function() {
    if (!this.props.item.image) {
      return (
        <div className="hc-item-show-image-box">
          No Media
        </div>
      );
    }

    switch(this.props.item.image.status)
    {
      case "ready":
        return this.itemReadyHtml();
      case "processing":
        return this.itemProcessingHtml();
      case "no_image":
        return this.itemNoImageHtml();
      case "unavailable":
        return this.itemImageInvalidHtml();
      default:
        console.log("Unknown Image Status: " + this.props.item.image_status);
        return this.itemImageInvalidHtml();
    }
  },

  itemReadyHtml: function () {
    return (
      <div className="hc-item-show-image-box">
        <ItemImageZoomButton image={this.props.item.image} itemID={this.props.item.id} />
        <Thumbnail image={this.props.item.image} />
      </div>
    );
  },

  itemProcessingHtml: function () {
    return (
      <div>
        <CircularProgress mode="indeterminate" size={0.5} />
      </div>
    );
  },

  itemNoImageHtml: function () {
    return (<p>No Item Image.</p>);
  },

  itemImageInvalidHtml: function () {
    return (<p className="text-danger">Image Processing Error please try again.  If it continues to be a problem <a href="https://docs.google.com/a/nd.edu/forms/d/1PH99cRyKzhZ6rV-dCJjrfkzdThA2n1GvoE9PT6kCkSk/viewform?entry.1268925684=https://honeycomb.library.nd.edu/collections/1/items">go here</a>.</p>);
  },

  render: function() {
    return this.renderMedia();
  }
});
module.exports = ItemShowImageBox;
