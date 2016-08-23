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
    uploadStarted: React.PropTypes.func,
    uploadComplete: React.PropTypes.func
  },

  getInitialState: function() {
    return {
      processing: false,
      item: null,
      creating: true
    }
  },

  componentDidMount: function() {
    ItemStore.on("ItemCreateFinished", this.setItem);
    if (this.props.item) {
      this.setState({ item: this.props.item, creating: true })
    }
  },

  setItem(data) {
    if (this.state.processing) {
      this.setState({ item: data }, this.loadSigningUrl);
    }
  },

  uploady: function() {
    var f = this.refs.uploadFile;
    if (f.files[0]) {
      this.setState({ processing: true });
      if (this.props.uploadStarted) {
        this.props.uploadStarted();
      }
      this.createNewItem(f.files[0]);
    }
  },

  createNewItem: function(file) {
    if (this.state.creating) {
      ItemActions.create(file.name)
    } else {
      this.loadSigningUrl();
    }
  },

  loadSigningUrl: function() {
    var f = this.refs.uploadFile;
    var url = ItemActions.url(this.state.item.id) + "/media";
    var postData = { medium: { file_name: f.files[0].name, media_type: this.props.type } };

    $.ajax({
      url: url,
      dataType: "json",
      method: "POST",
      data: postData,
      success: (function(data) {
        this.uploadFile(data);
      }.bind(this)),
      error: (function(xhr) {
        AppEventEmitter.emit("MessageCenterDisplay", "error", "Upload Error. Please try again if the problem persists please contact WSE unit.");
      }.bind(this)),
    });
  },

  uploadFile: function(media) {
    var f = this.refs.uploadFile;
    var xhr = new XMLHttpRequest();
    xhr.open('PUT', media.upload_url);
    xhr.onreadystatechange = () => {
      if(xhr.readyState === 4) {
        if(xhr.status === 200) {
          console.log(this.props);          
          this.finishUpload(media)
        } else {
          AppEventEmitter.emit("MessageCenterDisplay", "error", "Upload Error. Please try again if the problem persists please contact WSE unit.");
        }
      }
    };
    xhr.send(f.files[0]);
  },

  finishUpload: function(media) {
    url = "/v1/media/" + media["@id"] + "/finish_upload";
    $.ajax({
      url: url,
      dataType: "json",
      method: "put",
      success: (function(data) {
        this.setState({ processing: false});
        this.props.uploadComplete();
        //this.goToNewItem();
      }.bind(this)),
      error: (function(xhr) {
        AppEventEmitter.emit("MessageCenterDisplay", "error", "Upload Error. Please try again if the problem persists please contact WSE unit.");
      }.bind(this)),
    });
  },

  goToNewItem: function() {
    if (this.state.creating) {
      window.location.href = "/items/" + this.state.item.id + "/edit";
    }
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
