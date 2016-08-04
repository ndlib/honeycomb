var React = require('react');
var mui = require("material-ui");
var Dialog = mui.Dialog;
var RaisedButton = mui.RaisedButton;
var FlatButton = mui.FlatButton;
var FontIcon = mui.FontIcon;

var ReactDropzone = React.createClass({
  mixins: [MuiThemeMixin, DialogMixin],

  propTypes: {
    formUrl: React.PropTypes.string.isRequired,
    authenticityToken: React.PropTypes.string.isRequired,
    multifileUpload: React.PropTypes.bool,
    modalTitle: React.PropTypes.string.isRequired,
    doneText: React.PropTypes.string,
    cancelText: React.PropTypes.string,
    primary: React.PropTypes.bool,
  },

  getDefaultProps: function() {
    return {
      multifileUpload: true,
      closeText: 'Close',
      modalId: "add-items",
    };
  },

  getInitialState: function() {
    return {
      closed: false,
      hasFiles: false,
    };
  },

  dropzoneInitialized: function(dropzone) {
    this.dropzone = dropzone;
    this.dropzone.on('addedfile', this.checkfileCallback);
    this.dropzone.on('removedfile', this.checkfileCallback);
  },

  closeCallback: function() {
    if (this.dropzone.files.length > 0) {
      this.setState({closed: true});
      window.location.reload();
    }
  },

  dismissMessage: function() {
    this.refs.addItems.dismiss();
  },

  completeCallback: function() {
    if (!this.props.multifileUpload) {
      this.closeCallback();
    }
  },

  checkfileCallback: function () {
    var hasFiles = (this.dropzone.files.length > 0);
    this.setState( { hasFiles: hasFiles } );
  },

  spinner: function () {
    if (this.state.closed) {
      return (<LoadingImage />);
    } else {
      return null;
    }
  },

  classes: function () {
    var classes = "dropzone";
    if (this.dropzone && this.dropzone.files.length > 0) {
      classes += " dz-started";
    }
    return classes;
  },

  fontIconCSS: function () {
    if (this.props.multifileUpload) {
      return "glyphicon glyphicon-plus";
    } else {
      return "mdi-content-redo";
    }
  },

  dropzoneForm: function() {
    if (!this.state.closed) {
      return (
        <DropzoneForm
          authenticityToken={this.props.authenticityToken}
          baseID={this.props.modalId}
          completeCallback={this.completeCallback}
          formUrl={this.props.formUrl}
          initializeCallback={this.dropzoneInitialized}
          method={this.formMethod()}
          multifileUpload={this.props.multifileUpload}
          paramName="item[uploaded_image]"
        />
      );
    } else {
      return null;
    }
  },

  formMethod: function() {
    if (!this.props.multifileUpload) {
      return "put"
    } else {
      return "post";
    }
  },

  closeText: function () {
    if (this.state.hasFiles) {
      return this.props.doneText;
    }

    return this.props.cancelText;
  },

  showModal: function() {
    this.refs.addItems.show();
  },

  render: function() {
    var iconStyle = {fontSize: 14, marginRight: ".5em", color: (this.props.primary ? "#fff" : "#000") };
    var buttonLabel = (
      <span style={ {"color": (this.props.primary ? "#fff" : "#000") } }>
        <FontIcon className={this.fontIconCSS()} label={this.props.modalTitle} style={iconStyle}/>
        {this.props.modalTitle}
      </span>
    );
    return (
      <div>
        <RaisedButton
          primary={this.props.primary}
          onTouchTap={this.showModal}
          label={buttonLabel}
          />
        <Dialog
          ref="addItems"
          autoDetectWindowHeight={true}
          autoScrollBodyContent={true}
          modal={true}
          title={this.props.modalTitle}
          actions={this.okDismiss()}
          openImmediately={false}
          onDismiss={this.closeCallback}
          style={{zIndex: 100}}
        >
          { this.dropzoneForm() }
          { this.spinner() }
        </Dialog>
      </div>
    );
  }
});
module.exports = ReactDropzone;
