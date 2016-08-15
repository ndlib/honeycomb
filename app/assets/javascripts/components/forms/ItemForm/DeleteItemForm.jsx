var React = require("react");
var mui = require("material-ui");
var ItemActions = require("../../../actions/ItemActions");
var ItemStore = require("../../../stores/ItemStore");
var CollectionStore = require("../../../stores/Collection");
var CircularProgress = mui.CircularProgress;

var DeleteItemForm = React.createClass({
  propTypes: {
    item: React.PropTypes.object.isRequired,
  },

  getInitialState: function() {
    return ({ deleting: false })
  },

  componentDidMount: function() {
    ItemStore.on("ItemDeleteFinished", this.deleteFinished);
    ItemActions.on("ItemDeleteFailed", this.deleteFailed);
  },

  deleteFailed: function () {
    this.setState( { deleting: false });
  },

  deleteFinished: function() {
    window.location.href = "/collections/" + CollectionStore.id + "/items";
  },

  clickButton: function() {
    ItemActions.delete(this.props.item.id);
    this.setState({ deleting: true })
  },

  render: function() {
    if (this.state.deleting) {
      return (<CircularProgress mode="indeterminate" size={0.5} />)

    }

    return (
      <div className="panel panel-danger">
        <div className="panel-heading">
          <h3 className="panel-title">Delete Item</h3>
        </div>
        <div className="panel-body">
          <h4>Delete this Item</h4>
          <p>Proceed with caution. This will also remove all the items information from the site.</p>
          <mui.RaisedButton label="Delete This Item" primary={true} onClick={this.clickButton} />
        </div>
      </div>

    )
  }

});

module.exports = DeleteItemForm;
