var React = require("react");
var mui = require("material-ui");

var DeleteItemForm = React.createClass({

  clickButton: function() {

  },

  render: function() {
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
