/** @jsx React.DOM */
var React = require('react');
var mui = require("material-ui");
var FlatButton = mui.FlatButton;
var FontIcon = mui.FontIcon;

var GoogleImportButton = React.createClass({
  mixins: [MuiThemeMixin, GooglePickerMixin],

  filePicked: function(url) {
    EventEmitter.emit("ImportStarted");
    window.location.href = url;
  },

  render: function() {
    var iconStyle = {fontSize: 14, marginRight: ".5em"};
    var buttonLabel = (
      <span>
        <FontIcon className="glyphicon glyphicon-import" label="Upload" color="#000" style={iconStyle}/>
        <span>Import from Google</span>
      </span>
    );
    return (
      <div>
        <FlatButton
          primary={false}
          onTouchTap={ function() { this.loadPicker(this.filePicked); }.bind(this) }
          label={buttonLabel}
        />
      </div>
    );
  }
});

module.exports = GoogleImportButton;
