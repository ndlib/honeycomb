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
    uploadStarted: React.PropTypes.func,
    uploadComplete: React.PropTypes.func
  },

  getInitialState: function() {
    return {
      processing: false
    }
  },

  componentDidMount: function() {
    ItemStore.on("ItemCreateFinished", this.goToNewItem);
  },

  goToNewItem: function(data) {
    this.props.uploadComplete(data);
  },

  checkEnter: function(event) {
    if (event.key == "Enter") {
      this.uploady();
    }
  },

  uploady: function() {
    var f = this.refs.newItem;
    ItemActions.create(f.value);
    this.props.uploadStarted();
    this.setState( { processing: true });
  },

  render: function() {
    var button = (<RaisedButton label="Save" primary={ true } onClick={ this.uploady } />);
    if (this.state.saving) {
      button = <LoadingImage />
    }

    return (
      <div>
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
