/** @jsx React.DOM */
var React = require('react');
var mui = require("material-ui");
var FlatButton = mui.FlatButton;
var FontIcon = mui.FontIcon;
var ImportResultsDialog = require("./ImportResultsDialog");

var CsvImportButton = React.createClass({
  mixins: [MuiThemeMixin],

  propTypes: {
    postUri: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      uploading: false,
      uploaded: false,
      response: {}
    };
  },

  uploadFile: function(media) {
    if(this.refs.csvInput.files){
      var xhr = new XMLHttpRequest();
      xhr.open('POST', this.props.postUri);
      xhr.onreadystatechange = () => {
        if(xhr.readyState === 4) {
          if(xhr.status === 200) {
            this.setState({ uploading: false, uploaded: true, response: JSON.parse(xhr.responseText) });
            this.refs.csvInput.value = '';
          } else {
            console.log(xhr.responseText);
          }
        }
      };

      this.setState({ uploading: true, uploaded: false }, function(){
        var f = this.refs.csvInput;
        var formData = new FormData();
        formData.append("csv_file", f.files[0], f.files[0].name);
        xhr.send(formData);
      }.bind(this));
    }
  },

  render: function() {
    var iconStyle = {fontSize: 14, marginRight: ".5em"};
    var buttonLabel = (
      <span>
        <FontIcon className="glyphicon glyphicon-import" label="Upload" color="#000" style={iconStyle}/>
        <span>Import CSV</span>
      </span>
    );
    return (
      <div>
        <ImportResultsDialog open={ this.state.uploaded } results={ this.state.response } />
        <form action={ this.props.postUri } method="post" encType="multipart/form-data">
          <input ref={ "csvInput" } id="csvInput" type="file" name="csv_file" style={{ display: "none" }} onChange={ this.uploadFile } />
        </form>
        <FlatButton
          disabled={ this.state.uploading }
          primary={false}
          onTouchTap={ function() { this.refs.csvInput.click(); }.bind(this) }
          label={buttonLabel}
        />
      </div>
    );
  }
});

module.exports = CsvImportButton;
