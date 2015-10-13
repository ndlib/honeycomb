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
      maxRetries: 3,       // Maximum number of times it will retry to get the image status.
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

    console.log(this.props.itemPath);

    $.ajax({
      url: this.props.itemPath,
      dataType: "json",
      method: "GET",
      success: (function(data) {
        this.setState({ item: data.items, awaitingResponse: false }, this.testImageStatus);
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
    if (this.state.item.image_status == "image_invalid") {
      EventEmitter.emit("MessageCenterDisplay", "error", "There was a problem loading the media. Try replacing or contacting support.");
    } else if (this.state.item.image_status == "image_processing") {
      setTimeout(this.pingItem, this.props.retryInterval)
    }
  },

  renderMedia: function() {
    switch(this.state.item.image_status)
    {
      case "image_ready":
        return this.itemReadyHtml();
      case "image_processing":
        return this.itemProcessingHtml();
      case "no_image":
        return this.itemNoImageHtml();
      case "image_invalid":
        return this.itemImageInvalidHtml();
      default:
        EventEmitter.emit("MessageCenterDisplay", "error", "Unknown Image Status");
        break;
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
    return (<p>No Image</p>);
  },

  itemImageInvalidHtml: function () {
    return (<p className="text-danger">Image Processing Error</p>);
  },

  render: function() {
    return this.renderMedia();
  }
});
module.exports = ItemShowImageBox;
