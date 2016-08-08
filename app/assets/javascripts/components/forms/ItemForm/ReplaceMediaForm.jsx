var React = require('react');
var mui = require("material-ui");
var RaisedButton = mui.RaisedButton;

var ItemActions = require("../../../actions/ItemActions");

var ReplaceMedia = React.createClass({
  mixins: [MuiThemeMixin, DialogMixin],

  propTypes: {
    item: React.PropTypes.object.isRequired,
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

  dropzoneInitialized: function(dropzone) {
    this.dropzone = dropzone;
    this.dropzone.on('addedfile', this.checkfileCallback);
    this.dropzone.on('removedfile', this.checkfileCallback);
  },

  uploady: function() {
    var signerUrl = "https://testlibnd-wse-honeycomb-jon.s3.amazonaws.com/b1da95d0b41348a0d95f6c637b21de35.txt?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAI4H7VJ5KTYBQIISQ%2F20160805%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20160805T173307Z&X-Amz-Expires=900&X-Amz-SignedHeaders=host&X-Amz-Signature=b62b671a62a581fe242f1ebfb50c5ef9c00d595682e313dce4010a99cdec0a2c";

    var f = document.getElementById("uploadFile"); // this.refs.uploadFile;
    console.log(f);
    var xhr = new XMLHttpRequest();
    xhr.open('PUT', signerUrl);
    xhr.onreadystatechange = () => {
      if(xhr.readyState === 4) {
        if(xhr.status === 200) {
          alert ("UPLOADED !! ");
        } else {
          alert('Could not upload file.');
        }
      }
    };
    console.log(f.files[0]);
    xhr.send(f.files[0]);
//
//<input type="file" id="uploadFile" ref={ "uploadFile" } name="upload" />
//  <RaisedButton label="Uploady" onClick={ this.uploady } />
//</div>
//
  },

  completeCallback: function() {
    if (this.dropzone.files.length > 0) {
      ItemActions.get(this.props.item.id);
    }
  },

  checkfileCallback: function () {
    var hasFiles = (this.dropzone.files.length > 0);
    this.setState( { hasFiles: hasFiles } );
  },

  render: function() {
    return (
      <div>
        <DropzoneForm
          authenticityToken={this.props.authenticityToken}
          baseID={this.props.modalId}
          completeCallback={this.completeCallback}
          formUrl={ ItemActions.url(this.props.item.id) }
          initializeCallback={this.dropzoneInitialized}
          method="put"
          multifileUpload={ true }
          paramName="item[uploaded_image]"
        />
    );
  }
});
module.exports = ReplaceMedia;
