var mui = require("material-ui");
var Dialog = mui.Dialog;
var FlatButton = mui.FlatButton;
var injectTapEventPlugin = require("react-tap-event-plugin");
injectTapEventPlugin();

var DialogMixin = {
  cancelDismiss: function() {
    return (
        <FlatButton
        label="Cancel"
        primary={true}
        onTouchTap={this.dismissMessage}
      />
    );
  },

  okDismiss: function() {
    return (
      <FlatButton
        label="OK"
        primary={true}
        onTouchTap={this.dismissMessage}
      />
    );
  },

}
module.exports = DialogMixin;
