var React = require("react");
var mui = require("material-ui");
var Dialog = mui.Dialog;
var FlatButton = mui.FlatButton;
var injectTapEventPlugin = require("react-tap-event-plugin");
injectTapEventPlugin();

function dismissDialog(Component) {
  var DialogDismiss = React.createClass ({
    propTypes: {
      dismiss_func: React.PropTypes.func
    },

    dismiss_func: function(dismiss_method) {
      return [
        <FlatButton
          label="Close"
          primary={true}
          onTouchTap={dismiss_method}
          />
      ];
    },

    render: function() {
      return (<Component {...this.props} {...this.state} dismiss_func={this.dismiss_func} />);
    }
  });

  return DialogDismiss;
}

module.exports = dismissDialog;
