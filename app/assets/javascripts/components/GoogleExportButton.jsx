/** @jsx React.DOM */
var React = require('react');
var mui = require("material-ui");
var FlatButton = mui.FlatButton;
var FontIcon = mui.FontIcon;

var GoogleExportButton = React.createClass({
  mixins: [MuiThemeMixin, GoogleCreatorMixin],

  propTypes: {
    collection: React.PropTypes.object.isRequired,
  },

  touchHandler: function() {
    this.loadCreator();
  },

  getFileData: function() {
    return {
      fileName: "Export of " + this.props.collection.name_line_1 + " " + (new Date()).toLocaleString(),
      mimeType: "application/vnd.google-apps.spreadsheet"
    }
  },

  fileCreated: function(data) {
    var fileId = data.alternateLink;

    $.ajax({
      url: this.props.authUri,
      dataType: "json",
      data: {
        file_name: fileId,
        sheet_name: ""
      },
      method: "POST",
      success: (function(data, textStatus) {
        window.open(data.auth_uri, '_blank');
      }),
      error: (function(xhr) {
        alert(xhr);
      })
    });
  },

  render: function() {
    var iconStyle = {fontSize: 14, marginRight: ".5em"};
    var buttonLabel = (
      <span>
        <FontIcon className="glyphicon glyphicon-export" label="Download" color="#000" style={iconStyle}/>
        <span>Export to Google</span>
      </span>
    );
    return (
      <div>
        <FlatButton
          primary={false}
          onTouchTap={this.touchHandler}
          label={buttonLabel}
        />
      </div>
    );
  }
});

module.exports = GoogleExportButton;
