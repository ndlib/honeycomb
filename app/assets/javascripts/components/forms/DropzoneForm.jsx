var Dropzone = require("../../dropzone");
Dropzone.autoDiscover = false;

var DropzoneForm = React.createClass({
  propTypes: {
    authenticityToken: React.PropTypes.string.isRequired,
    baseID: React.PropTypes.string.isRequired,
    formUrl: React.PropTypes.string.isRequired,
    method: React.PropTypes.string.isRequired,
    paramName: React.PropTypes.string.isRequired,
    multifileUpload: React.PropTypes.bool,
    completeCallback: React.PropTypes.func,
    startedCallback: React.PropTypes.func,
    removedCallback: React.PropTypes.func,
    initializeCallback: React.PropTypes.func,
  },

  getDefaultProps: function() {
    return {
      multifileUpload: true,
    };
  },

  componentDidMount: function() {
    this.setupDropzone();
  },

  componentWillUnmount: function() {
    if (this.dropzone) {
      this.dropzone.destroy();
      this.dropzone = null;
    }
  },

  setupDropzone: function() {
    if (!this.dropzone) {
      this.dropzone = new Dropzone(ReactDOM.findDOMNode(this), this.options());
      this.dropzone.on('addedfile', this.startedCallback);
      this.dropzone.on('removedfile', this.startedCallback);

      if (this.props.initializeCallback) {
        this.props.initializeCallback(this.dropzone);
      }
    }
  },

  options: function() {
    return {
      paramName: "item[uploaded_image]",
      acceptedFiles: "image/*",
      addRemoveLinks: true,
      autoProcessQueue: true,
      url: this.props.formUrl,
      previewsContainer: "#dz-preview-" + this.props.baseID,
      clickable: "#dz-" + this.props.baseID,
      parallelUploads: 100,
      maxFiles: (this.props.multifileUpload ? 100 : 1),
      dictRemoveFile: "Cancel Upload",
      someprop: "prop",
      complete: this.completeCallback,
    };
  },

  startedCallback: function() {
    if (this.props.startedCallback) {
      this.props.startedCallback(this.dropzone);
    }
  },

  removedCallback:  function() {
    if (this.props.removedCallback) {
      this.props.removedCallback(this.dropzone);
    }
  },

  completeCallback: function() {
    if (this.props.completeCallback) {
      this.props.completeCallback(this.dropzone);
    }
  },

  classes: function () {
    var classes = "dropzone";
    if (this.dropzone && this.dropzone.files.length > 0) {
      classes += " dz-started";
    }
    return classes;
  },

  formMethod: function() {
    if (this.props.method == "put") {
      return (<input name="_method" type="hidden" value="put" />);
    } else {
      return null;
    }
  },

  render: function() {
    return (
      <form method="post" className={this.classes()} id={"dz-" + this.props.baseID}>
        <div>
          <input name="utf8" type="hidden" value="✓" />
          <input name="authenticity_token" type="hidden" value={this.props.authenticityToken} />
          { this.formMethod() }
        </div>
        <div className="dz-clickable">
          <div className="dropzone-previews" id={"dz-preview-" + this.props.baseID}></div>
          <div className="dz-message">
            <h4>Drag images here</h4>
            <p>or <br /> <a className="btn btn-raised">Select images from your computer.</a></p>
          </div>
        </div>
      </form>
    );
  },
})

module.exports = DropzoneForm;
