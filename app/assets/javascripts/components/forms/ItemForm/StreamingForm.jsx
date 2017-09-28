var React = require('react');
var mui = require("material-ui");
var Dialog = mui.Dialog;
var RaisedButton = mui.RaisedButton;
var LoadingImage = require("../../LoadingImage");

var ItemActions = require("../../../actions/ItemActions");
var ItemStore = require("../../../stores/ItemStore");
var AppEventEmitter = require("../../../EventEmitter");

var StreamingForm = React.createClass({
  mixins: [DialogMixin],

  propTypes: {
    item: React.PropTypes.object,
    creating: React.PropTypes.bool.isRequired,
    fileUploadStarted: React.PropTypes.func,
    fileUploadComplete: React.PropTypes.func
  },

  getDefaultProps: function() {
    return {
      creating: true
    }
  },

  getInitialState: function() {
    return {
      processing: false,
      item: this.props.item,
      hasFile: false,
    }
  },

  componentDidMount: function() {
    if (this.props.item) {
      this.setState({ item: this.props.item, creating: true })
    }
  },

  addFile() {
    this.setState({ hasFile: true });
  },

  createFinished: function(data) {
    ItemStore.removeListener("ItemCreateFinished", this.createFinished);
    this.setItem(data);
  },

  handleError: function() {
    this.setState({ processing: false });
    AppEventEmitter.emit("MessageCenterDisplay", "error", "Upload Error. Please try again if the problem persists please contact WSE unit.");
    if (this.props.creating && this.state.item) {
      ItemActions.delete(this.state.item.id, false)
    }
  },

  setItem(data) {
    if (this.state.processing) {
      this.setState({ item: data }, this.loadSigningUrl);
    }
  },

  button_click: function() {
    var f = this.refs.uploadFile;
    if (f.files[0]) {
      this.setState({ processing: true });
      if (this.props.fileUploadStarted) {
        this.props.fileUploadStarted();
      }
      this.createNewItem(f.files[0]);
    }
  },

  createNewItem: function(file) {
    if (this.props.creating) {
      ItemStore.on("ItemCreateFinished", this.createFinished);
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
        this.handleError();
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
          this.finishUpload(media)
        } else {
          this.handleError();
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
        this.setState({ processing: false, hasFile: false });
        if (this.props.fileUploadCompleted) {
          this.props.fileUploadCompleted(this.state.item);
        }
      }.bind(this)),
      error: (function(xhr) {
        this.handleError();
      }.bind(this)),
    });
  },

  codecInformation: function() {
    this.refs.showCodec.show();
  },

  dismissMessage: function() {
    this.refs.showCodec.dismiss();
  },

  typeCompatability: function() {
    if(this.props.type == "video") {
      return "video/*";
    } else if(this.props.type == "audio") {
      return "audio/*";
    } else {
      return "image/*";
    }
  },

  render: function() {
    if (this.state.processing) {
      var button = (<LoadingImage />);
    } else {
      var button = (<RaisedButton label="Upload" primary={ true } onClick={ this.button_click } disabled={ !this.state.hasFile } />)
    }
    return (
      <div style={{ marginTop: "14px" }}>
        <input style={{ display: "inline" }} type="file" id="uploadFile" ref={ "uploadFile" } name="upload" onChange={ this.addFile } accept={this.typeCompatability()} />
        { button }
        <RaisedButton label="Supported Playback" primary={true} onClick={this.codecInformation} style={{float: "right"}} />
        <Dialog
          ref="showCodec"
          autoDetectWindowHeight={true}
          autoScrollBodyContent={true}
          modal={true}
          title="Supported File Playback"
          actions={[this.okDismiss()]}
          defaultOpen={false}
          style={{zIndex: 10}}
        >
          <div>
            <p>
              Any file may be uploaded. However, we only support playback of these types.
            </p>
            <h3>Video</h3>
            <ul>
              <li>
                MP4 encoded with Video: H.265, H.264, VP9 or VP8 video and AAC audio
              </li>
            </ul>

            <h3>Audio</h3>
            <ul>
              <li>
                AAC (.aac, .m4a, .f4a)
              </li>
              <li>
                MP3 (.mp3)
              </li>
              <li>
                Vorbis (.ogg, .oga)
              </li>
            </ul>
          </div>
        </Dialog>
      </div>
    );
  }
});

module.exports = StreamingForm;
