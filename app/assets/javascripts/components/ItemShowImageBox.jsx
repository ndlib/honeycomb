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

  getDefaultProps: function() {
    return {
      maxRetries: 7,       // Maximum number of times it will retry to get the image status.
      retryInterval: 5000  // Time in ms to wait before retrying request for image status.
    };
  },

  getInitialState: function() {
    return {
      requestCount: 0,
      awaitingResponse: false,
      item: this.props.item,
    };
  },

  pingItem: function() {
    if(this.state.awaitingResponse)
      return;

    this.setState({
      awaitingResponse: true,
      requestCount: this.state.requestCount + 1
    });

    $.ajax({
      url: this.props.itemPath,
      dataType: "json",
      method: "GET",
      success: (function(data) {
        if (this.state.requestCount < this.props.maxRetries) {
          this.setState({ item: data.items, awaitingResponse: false }, this.testImageStatus);
        } else {
          var item = this.state.item;
          item.image_status = "image_unavailable";
          this.setState({ item: item, awaitingResponse: false }, this.testImageStatus);
        }
      }).bind(this),
      error: (function(xhr) {
        this.setState({ awaitingResponse: false }, this.testImageStatus);
        console.log(xhr);
      }).bind(this),
    });
  },

  componentWillMount: function() {
    this.testImageStatus();
  },

  testImageStatus: function () {
    if (this.state.item.image_status == "image_unavailable") {
      EventEmitter.emit("MessageCenterDisplay", "error", "There was a problem loading the media. Try replacing or contacting support.");
    } else if (this.state.item.image_status == "image_processing") {
      setTimeout(this.pingItem, this.props.retryInterval)
    }
  },

  renderMedia: function() {
    switch(this.state.item.image.status)
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
        console.log("Unknown Image Status: " + this.state.item.image_status);
        return this.itemImageInvalidHtml();
    }
  },

  itemReadyHtml: function () {
    return (
      <div className="hc-item-show-image-box">
        <ItemImageZoomButton image={this.state.item.image} itemID={this.state.item.id} />
        <Thumbnail image={this.state.item.image} />
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
