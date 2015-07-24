var React = require("react");
var mediator = require("../../mediator");
var mui = require("material-ui");
var Snackbar = mui.Snackbar;

var FormMessageCenter = React.createClass({
  mixins: [MuiThemeMixin, DialogMixin],
  getInitialState: function() {
    return {
      messageType: "",
      messageText: "",
    };
  },
  componentWillMount: function() {
    mediator.subscribe("MessageCenterDisplay", this.receiveDisplay);
  },

  receiveDisplay: function(type, message) {
    this.setState({
      messageType: message[0],
      messageText: message[1],
    });
    this.refs.errorDialog.show();
  },

  dismissMessage: function() {
    this.refs.errorDialog.dismiss();
  },


  render: function () {
    return (
      <Snackbar
        ref = "errorDialog"
        message={this.state.messageText}
      >

      </Snackbar>
    );
  }
});
module.exports = FormMessageCenter;
