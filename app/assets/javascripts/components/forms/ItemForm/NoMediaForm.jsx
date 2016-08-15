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
    hasFiles: React.PropTypes.func
  },

  getInitialState: function() {
    return {
      newItems: []
    }
  },

  componentDidMount: function() {
    ItemStore.on("ItemCreateFinished", this.setItem);
  },

  checkEnter: function(event) {
    if (event.key == "Enter") {
      this.uploady();
    }
  },

  setItem: function(data) {
    var f = this.refs.newItem;
    var items = this.state.newItems;
    items.push(data.name);
    f.value = "";
    this.setState({ newItems: items } );
  },

  uploady: function() {
    var f = this.refs.newItem;
    ItemActions.create(f.value);
    this.props.hasFiles();
  },

  uploadedListItems: function() {
    return this.state.newItems.map(function (name) {
      return (<ListItem key={name} primaryText={name} leftIcon={ <FontIcon className="material-icons">local_offer</FontIcon> } rightIcon={ <FontIcon className="material-icons">done</FontIcon> } />);
    });
  },

  uploadedList: function() {
    if (this.state.newItems.length > 0) {
      return (
        <div>
          <List subheader="Created Items" style={{ width: "75%" }}>
            { this.uploadedListItems() }
          </List>
          <hr />
        </div>
      );
    }
    return (<div />);
  },

  render: function() {
    return (
      <div>
        { this.uploadedList() }
        <div className="form-group string control-label required">
          <label className="string control-label required" htmlFor="item_name">
            <abbr title="required">* </abbr>
            <span>Name</span>
          </label>
          <input type="text" className="form-control required" id="item_name" ref={ "newItem" } name="name" onKeyPress={ this.checkEnter }/>
        </div>
        <div>
          <RaisedButton label="Save" primary={ true } onClick={ this.uploady } />
        </div>
      </div>
    );
  }
});

module.exports = NoMediaForm;
