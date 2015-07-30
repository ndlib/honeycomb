/** @jsx React.DOM */
var React = require('react');
var mui = require("material-ui");
var RaisedButton = mui.RaisedButton;
var FontIcon = mui.FontIcon;

var GoogleImportButton = React.createClass({
  mixins: [MuiThemeMixin, GooglePickerMixin],

  render: function() {
    var iconStyle = {fontSize: 14, marginRight: ".5em"};
    var buttonLabel = (
      <span>
        <FontIcon className="glyphicon glyphicon-plus" label="Upload" color="#fff" style={iconStyle}/>
        <span>Import</span>
      </span>
    );
    return (
      <div>
        <RaisedButton
          primary={true}
          onTouchTap={this.loadPicker}
          label={buttonLabel}
        />
      </div>
    );
  }
});

module.exports = GoogleImportButton;
