var React = require('react');
var mui = require("material-ui");
var RaisedButton = mui.RaisedButton;
var List = mui.List;
var ListItem = mui.ListItem;
var ListDivider = mui.ListDivider;
var FontIcon = mui.FontIcon;
var LoadingImage = require("../../LoadingImage");

var ItemActions = require("../../../actions/ItemActions");
var ItemStore = require("../../../stores/ItemStore");
var AppEventEmitter = require("../../../EventEmitter");

var NoMediaForm = React.createClass({
  propTypes: {
    mediaSaveStarted: React.PropTypes.func,
    mediaSaveCompleted: React.PropTypes.func
  },

  getInitialState: function() {
    return {
      processing: false,
      dirty: false,
    }
  },

  createFinished: function(data) {
    ItemStore.removeListener("ItemCreateFinished", this.createFinished);
    this.goToNewItem(data);
  },

  goToNewItem: function(data) {
    if (this.props.mediaSaveCompleted) {
      this.props.mediaSaveCompleted(data);
    }
  },

  checkEnter: function(event) {
    if (event.key == "Enter") {
      this.uploady();
    }

    if (!this.state.dirty) {
      this.setState({ dirty: true });
    }
  },

  uploady: function() {
    this.setState( { processing: true });
    var f = this.refs.newItem;
    ItemStore.on("ItemCreateFinished", this.createFinished);
    ItemActions.create(f.value);
    if (this.props.mediaSaveStarted) {
      this.props.mediaSaveStarted();
    }
  },

  render: function() {
    var button = (<RaisedButton label="Save" primary={ true } disabled={ !this.state.dirty } onClick={ this.uploady } />);
    if (this.state.processing) {
      button = <LoadingImage />
    }

    return (
      <div style={{ paddingTop: "14px" }}>
        <p> Type the name of the new item you wish to create. </p>
        <div className="form-group string control-label required">
          <label className="string control-label required" htmlFor="item_name">
            <abbr title="required">* </abbr>
            <span>Name</span>
          </label>
          <input type="text" className="form-control required" id="item_name" ref={ "newItem" } name="name" onKeyPress={ this.checkEnter }/>
        </div>
        <div>
          { button }
        </div>
      </div>
    );
  }
});

module.exports = NoMediaForm;
