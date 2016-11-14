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
    if (this.props.media.status == "error") {
      EventEmitter.emit("MessageCenterDisplay", "error", "There was a problem loading the media. Try replacing or contacting support.");
    }
  },

  renderMedia: function() {
    if (!this.props.item.media) {
      return (this.itemNoImageHtml());
    }

    switch(this.props.item.media.status)
    {
      case "ready":
        return this.itemReadyHtml();
      case "not ready":
        return this.itemProcessingHtml();
      case "error":
        return this.itemImageInvalidHtml();
      default:
        console.log("Unknown Image Status: " + this.props.item.media.status);
        return this.itemImageInvalidHtml();
    }
  },

  itemReadyHtml: function () {
    return (<Thumbnail thumbnailUrl={ this.props.item.media.thumbnailUrl } thumbType={ "item" } mediaType={this.props.item.media["@type"]} />);
  },

  itemNoImageHtml: function () {
    return (<div></div>);
  },

  itemProcessingHtml: function () {
    return (
      <div>
        <CircularProgress mode="indeterminate" size={0.5} />
      </div>
    );
  },

  itemImageInvalidHtml: function () {
    return (<p className="text-danger">Image Processing Error please try again.  If it continues to be a problem <a href="https://docs.google.com/a/nd.edu/forms/d/1PH99cRyKzhZ6rV-dCJjrfkzdThA2n1GvoE9PT6kCkSk/viewform?entry.1268925684=https://honeycomb.library.nd.edu/collections/1/items">go here</a>.</p>);
  },

  render: function() {
    return this.renderMedia();
  }
});
module.exports = ItemShowImageBox;
