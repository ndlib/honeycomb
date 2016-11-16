var React = require('react');
var AddItemsBar;

AddItemsBar = React.createClass({
  propTypes: {
    itemSearchUrl: React.PropTypes.string.isRequired
  },
  render: function() {
    return (<ItemList onDragStart={this.props.onDragStart} onDragStop={this.props.onDragStop} itemSearchUrl={this.props.itemSearchUrl} />);
  }
});
module.exports = AddItemsBar;
