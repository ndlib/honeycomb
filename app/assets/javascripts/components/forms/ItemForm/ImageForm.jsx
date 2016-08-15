var React = require('react');
var mui = require("material-ui");
var RaisedButton = mui.RaisedButton;

var ItemActions = require("../../../actions/ItemActions");

var ImageForm = React.createClass({
  propTypes: {
    item: React.PropTypes.object.isRequired,
  }

  getInitialState: function() {
    return {
      processing: false,
    }
  },

  componentDidMount: function() {
    ItemActions.on("GotSignedUrl", this.getSignedUrl);

  }

  uploady: function() {
    this.setState({ processing: true});
    ItemActions.getSignedUrl(this.props.item.id)
  },

  getSignedUrl: function(d1, d2) {
    console.log(d1);
    console.log(d2);
  },

  uploadFile: function() {
    var f = this.refs.uploadFile;
    var xhr = new XMLHttpRequest();
    xhr.open('PUT', signerUrl);
    xhr.onreadystatechange = () => {
      if(xhr.readyState === 4) {
        this.setState({ processing: true});
        if(xhr.status === 200) {
          alert ("UPLOADED !! ");
        } else {
          alert('Could not upload file.');
        }
      }
    };
    xhr.send(f.files[0]);
  },

  render: function() {
    return (
      <div>
        <input type="file" id="uploadFile" ref={ "uploadFile" } name="upload" />
        <RaisedButton label="Uploady" onClick={ this.uploady } />
      </div>
    );
  }
});

module.exports = ImageForm;
