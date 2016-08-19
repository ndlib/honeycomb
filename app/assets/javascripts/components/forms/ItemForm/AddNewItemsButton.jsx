var React = require('react');
var mui = require("material-ui");
var StreamingForm = require("./StreamingForm");
var NoMediaForm = require("./NoMediaForm");

var Dialog = mui.Dialog;
var RaisedButton = mui.RaisedButton;
var Tab = mui.Tab;
var Tabs = mui.Tabs;
var FontIcon = mui.FontIcon;

var ItemActions = require("../../../actions/ItemActions");
var ItemStore = require("../../../stores/ItemStore");

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
    var iconButtonElement = (<RaisedButton icon={ <FontIcon className="material-icons">expand_more</FontIcon> } />);

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
          <Tabs style={ { marginBottom: "10px"} }>
            <Tab label="Images">
              <DropzoneForm
                authenticityToken={this.props.authenticityToken}
                baseID="add-new-item"
                startedCallback={this.setHasFiles}
                formUrl={this.props.formUrl}
                method="post"
                multifileUpload={ true }
                paramName="item[uploaded_image]"
              />
            </Tab>
            <Tab label="Video">
              <StreamingForm
                item={null}
                type="video"
                hasFiles={ this.setHasFiles }
              />
            </Tab>
            <Tab label="Audio">
              <StreamingForm
                item={null}
                type="audio"
                hasFiles={ this.setHasFiles }
              />
            </Tab>
            <Tab label="No Media">
              <NoMediaForm
                hasFiles={ this.setHasFiles }
              />
            </Tab>
          </Tabs>
        </Dialog>
      </div>
    );
  }
});
module.exports = AddNewItemsButton;
