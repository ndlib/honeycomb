var React = require('react');
var mui = require("material-ui");
var RaisedButton = mui.RaisedButton;
var LoadingImage = require("../../LoadingImage");

var ItemActions = require("../../../actions/ItemActions");
var ItemStore = require("../../../stores/ItemStore");
var AppEventEmitter = require("../../../EventEmitter");

var StreamingForm = React.createClass({
  propTypes: {
    item: React.PropTypes.object.isRequired,
  },

  getInitialState: function() {
    return {
      processing: false,
      item: null
    }
  },

  componentDidMount: function() {
    ItemStore.on("ItemCreateFinished", this.setItem);
    this.setState({ item: this.props.item })
  },

  setItem(data) {
    this.setState({ item: data }, this.loadSigningUrl);
  },

  uploady: function() {
    var f = this.refs.uploadFile;
    if (f.files[0]) {
      this.setState({ processing: true });
      this.createNewItem(f.files[0]);
    }
  },

  createNewItem: function(file) {
    if (this.state.item) {
      this.loadSigningUrl();
    } else {
      ItemActions.create(file.name)
    }
  },

  loadSigningUrl: function() {
    var url = ItemActions.url(this.state.item.id) + "/media"

    $.ajax({
      url: url,
      dataType: "json",
      method: "POST",
      success: (function(data) {
        this.uploadFile(data.uploadURL);
      }.bind(this)),
    });
  },

  uploadFile: function(signedUrl) {
    var f = this.refs.uploadFile;
    var xhr = new XMLHttpRequest();
    xhr.open('PUT', signedUrl);
    xhr.onreadystatechange = () => {
      if(xhr.readyState === 4) {
        this.setState({ processing: false});
        if(xhr.status === 200) {

        } else {
          AppEventEmitter.emit("MessageCenterDisplay", "error", "Upload Error. Please try again if the problem persists please contact WSE unit.");
        }
      }
    };
    xhr.send(f.files[0]);
  },

  render: function() {
    if (this.state.processing) {
      var button = (<LoadingImage />);
    } else {
      var button = (<RaisedButton label="Upload" primary={ true } onClick={ this.uploady } />)
    }

    return (
      <div>
        <h2>Replace Item Media</h2>
        <p><input type="file" id="uploadFile" ref={ "uploadFile" } name="upload" /></p>
        { button }
      </div>
    );
  }
});

module.exports = StreamingForm;
