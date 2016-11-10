var React = require('react');
var mui = require('material-ui')

var ItemList = React.createClass({
  propTypes: {
    items: React.PropTypes.array.isRequired,
    onDragStart: React.PropTypes.func,
    onDragStop: React.PropTypes.func,
  },

  getInitialState: function() {
    return {
      currentOptions: {}
    }
  },

  componentWillReceiveProps: function(nextProps) {
    if(this.props.items.length > 0) {
      return;
    }

    var options = {}
    for(var i = 0; i < nextProps.items.length; ++i) {
      lowerKey = nextProps.items[i].name.toLowerCase();
      options[lowerKey] = true;
    }
    this.setState({
      currentOptions: options
    });
  },

  style: function() {
    return {
      whiteSpace: 'nowrap',
      width: '100%',
      border: '1px solid #bed5cd',
      overflowX: 'scroll',
      overflowY: 'hidden',
      padding: '14px',
    };
  },

  titleStyle: function() {
    return {
      display: 'inline-block',
      marginRight: '5px',
      verticalAlign: 'top',
    };
  },

  handleInput: function(input) {
    var currentOptions = this.state.currentOptions;
    for(var i = 0; i < this.props.items.length; ++i) {
      var lowerKey = this.props.items[i].name.toLowerCase();
      var valid = lowerKey.includes(input.toLowerCase());

      if (valid) {
        currentOptions[lowerKey] = true;
      } else if(currentOptions[lowerKey]) {
        delete currentOptions[lowerKey];
      }
    }

    this.setState({ currentOptions: currentOptions })
  },

  render: function() {
    var itemNodes, onDragStart, onDragStop, key;
    onDragStart = this.props.onDragStart;
    onDragStop = this.props.onDragStop;
    itemNodes = this.props.items.map(function(item, index) {
      if(this.state.currentOptions[item.name.toLowerCase()]) {
        key = "item-" + item.id
        return <Item item={item} key={key} onDragStart={onDragStart} onDragStop={onDragStop} />
      } else {
        return null
      }
    }.bind(this));
    return (
      <div className="add-items-content-inner" style={this.style()}>
        <div className="add-items-title" style={this.titleStyle()}>
          <h2>Add Items</h2>
          <p>Click to Drag items into the showcase</p>
          <mui.AutoComplete
            hintText="Search Items"
            dataSource={[]}
            onUpdateInput={this.handleInput}
          />
        </div>
        {itemNodes}
      </div>);
  }
});
module.exports = ItemList;
