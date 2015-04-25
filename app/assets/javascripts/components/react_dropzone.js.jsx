/** @jsx React.DOM */
Dropzone.autoDiscover = false;


var ReactDropzone = React.createClass({
  propTypes: {
    formUrl: React.PropTypes.string.isRequired,
    authenticityToken: React.PropTypes.string.isRequired,
    multifileUpload: React.PropTypes.bool,
    modalTitle: React.PropTypes.string.isRequired,
    closeText: React.PropTypes.string,
    modalId: React.PropTypes.string,
  },

  getDefaultProps: function() {
    return {
      multifileUpload: true,
      closeText: 'Close',
      modalId: "add-items",
    };
  },

  getInitialState: function() {
    return { closed: false };
  },

  componentDidMount: function() {
    if (!this.dropzone) {
      this.dropzone = new Dropzone(this.refs.uploadForm.getDOMNode(), this.options());
    }
  },

  componentWillUnmount: function() {
    this.dropzone.destroy();
    this.dropzone = null;
  },

  options: function() {
    return {
      paramName: "item[uploaded_image]",
      acceptedFiles: "image/*",
      addRemoveLinks: true,
      autoProcessQueue: true,
      url: this.props.formUrl,
      previewsContainer: "#dz-preview-" + this.props.modalId,
      clickable: "#dz-" + this.props.modalId,
      parallelUploads: 100,
      maxFiles: (this.props.multifileUpload ? 100 : 1),
      dictRemoveFile: "Cancel Upload",
      init: function () {
        this.on('addedfile', function () {
          this.element.classList.add("dz-started");
        });
      },
      complete: this.completeCallback,
    };
  },

  closeCallback: function(e) {
    if (this.dropzone.files.length > 0) {
      this.setState({closed: true});
      window.location.reload();
      e.preventDefault();
    }
  },

  completeCallback: function() {
    if (!this.props.multifileUpload) {
      $("#" + this.props.modalId).modal('hide');
    }
  },

  spinner: function () {
    if (this.state.closed) {
      return ( <LoadingImage /> );
    } else {
      return null;
    }
  },

  dropzoneForm: function() {
    if (!this.state.closed) {
      return (
        <form method="post" className="dropzone" ref={"uploadForm"} id={"dz-" + this.props.modalId}>
          <div>
            <input name="utf8" type="hidden" value="✓" />
            <input name="authenticity_token" type="hidden" value={this.props.authenticityToken} />
            { this.formMethod() }
          </div>
          <div className="dz-clickable">
            <div className="dropzone-previews" id={"dz-preview-" + this.props.modalId}></div>
            <div className="dz-message">
              Drop files here or click to upload.
            </div>
          </div>
        </form>
        )
    } else {
      return null;
    }
  },
  formMethod: function() {
    if (!this.props.multifileUpload) {
      return (<input name="_method" type="hidden" value="put" />)
    } else {
      return null
    }

  },
  render: function() {

    return (
      <Modal title={this.props.modalTitle} id={this.props.modalId} closeCallback={this.closeCallback} closeText={this.props.closeText} >
        { this.dropzoneForm() }
        { this.spinner() }
      </Modal>);
  }
});
