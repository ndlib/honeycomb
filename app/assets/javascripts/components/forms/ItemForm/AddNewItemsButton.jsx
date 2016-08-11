var React = require('react');
var mui = require("material-ui");
var StreamingForm = require("./StreamingForm");


var Dialog = mui.Dialog;
var RaisedButton = mui.RaisedButton;
var Tab = mui.Tab;
var Tabs = mui.Tabs;


var ItemActions = require("../../../actions/ItemActions");

var AddNewItemsButton = React.createClass({
  mixins: [MuiThemeMixin, DialogMixin],

  getInitialState: function() {
    return {
      closed: false,
      hasFiles: false,
    };
  },

  closeCallback: function() {
    this.setState({closed: true});
    window.location.reload();
  },

  dismissMessage: function() {
    this.refs.addItems.dismiss();
  },

  completeCallback: function() {
    if (!this.props.multifileUpload) {
      this.closeCallback();
    }
  },

  showModal: function() {
    this.refs.addItems.show();
  },

  setHasFiles: function() {
    this.setState({ hasFiles: true });
  },

  render: function() {
    return (
      <div>
        <RaisedButton
          primary={ true }
          onTouchTap={this.showModal}
          label="Add New Items"

          />
        <Dialog
          ref="addItems"
          autoDetectWindowHeight={true}
          autoScrollBodyContent={true}
          modal={true}
          title="Add New Items"
          actions={this.okDismiss()}
          openImmediately={false}
          onDismiss={this.closeCallback}
          style={{zIndex: 100}}
        >
          <Tabs>
            <Tab label="Images">
              <ReactDropzone
                formUrl={ this.props.formUrl }
                authenticityToken={ this.props.authenticityToken }
                multifileUpload={ this.props.multifileUpload }
              />
            </Tab>
            <Tab label="Video">
              <StreamingForm
                item={null}
                hasFiles={ this.setHasFiles }
              />
            </Tab>
            <Tab label="Audio">
            </Tab>
            <Tab label="No Media">
            </Tab>
          </Tabs>
        </Dialog>
      </div>
    );
  }
});
module.exports = AddNewItemsButton;
