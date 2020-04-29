var React = require('react');
var mui = require('material-ui')

var EventEmitter = require("../../EventEmitter");
var SearchStore = require('../../stores/SearchStore');
var SearchActions = require('../../actions/SearchActions');

var Styles = {
  outerDiv: {
    whiteSpace: 'nowrap',
    width: '100%',
    border: '1px solid #bed5cd',
    overflowY: 'hidden',
    padding: '14px',
  },
  title: {
    display: 'inline-block',
    marginRight: '5px',
    verticalAlign: 'top',
    float: 'left',
  },
  item: {
    overflowX: 'scroll',
  },
  pageButtonDiv: {
    display: 'inline-block',
    height: '100px',
    verticalAlign: 'top',
    paddingTop: '35px',
    paddingLeft: '2px',
  },
  pageButton: {
    minWidth: "34px",
    padding:'3px 5px',
    marginRight:'2px',
  },
  jumpArrows: {
    fontSize: '1.5em',
    minWidth: "34px",
    padding:'3px 5px',
    marginRight:'2px',
    verticalAlign:'top'
  }
};

var ItemList = React.createClass({
  propTypes: {
    itemSearchUrl: React.PropTypes.string.isRequired,
    onDragStart: React.PropTypes.func,
    onDragStop: React.PropTypes.func,
    rows: React.PropTypes.number,
  },

  setItems: function(result) {
    if(result == "success") {
      var options = {}
      var count = 0
      for(var i = 0; i < SearchStore.found; ++i) {
        options[SearchStore.hits[i].name.toLowerCase()] = true;
        count += 1;
      }
      this.setState({
        currentOptions: options,
        currentCount: count,
        haveItems: true,
      });
    }
  },

  componentWillMount: function() {
    EventEmitter.on("SearchQueryComplete", this.setItems);
    this.executeQuery();
  },

  executeQuery: function(searchTerm) {
    var rows = 1000000;
    SearchActions.executeQuery(this.props.itemSearchUrl, {
      sortField: 'last_updated',
      sortDirection: 'desc',
      rowLimit: rows,
      searchTerm: searchTerm,
    });
  },

  getDefaultProps: function() {
    return {
      rows: 40,
    }
  },

  getInitialState: function() {
    return {
      start: 0,
      currentOptions: {},
      currentCount: 0,
      haveItems: false,
    }
  },

  handleInput: function(input) {
    this.executeQuery(input)
  },

  pageButton: function(start, icon) {
    return(
      <div style={ Styles.pageButtonDiv }>
        <mui.RaisedButton key="PreviousPageLink" style={ Styles.pageButton } onTouchTap={ function(){ this.setState({ start: start }) }.bind(this) }>
          {icon}
        </mui.RaisedButton>
      </div>
    );
  },

  previous: function() {
    if(this.state.start > 0) {
      var start = Math.max(this.state.start - this.props.rows, 0);
      var icon = <i className="material-icons" style={ Styles.jumpArrows }>first_page</i>
      return this.pageButton(start, icon)
    }
  },

  next: function() {
    if(this.state.start + this.props.rows < this.state.currentCount) {
      var start = this.state.start + this.props.rows;
      var icon = (<i className="material-icons" style={ Styles.jumpArrows }>last_page</i>);
      return this.pageButton(start, icon);
    }
  },

  loading: function() {
    if(!this.state.haveItems) {
      return (
        <mui.CircularProgress />
      );
    }
  },

  render: function() {
    var onDragStart, onDragStop, key;
    onDragStart = this.props.onDragStart;
    onDragStop = this.props.onDragStop;

    var itemNodes = [];
    var currentIndex = 0;
    for(var i = 0; i < SearchStore.found && itemNodes.length < 25; ++i) {
      var item = SearchStore.hits[i];
      var lowerKey = item.name.toLowerCase();

      if(this.state.currentOptions[lowerKey]) {
        if(currentIndex >= this.state.start) {
          key = "item-" + item["@id"];

          // get just the item id instead of the full url
          var idSplit = item["@id"].split('/');
          item["id"] = idSplit[idSplit.length - 1];

          // lower levels under Item require a media object with the thumbnail and @type
          item["media"] = {
            thumbnailUrl: item.thumbnailURL,
            contentUrl: item.thumbnailURL,
          }
          item["media"]["@type"] = item.type;

          itemNodes.push(<Item item={item} key={key} onDragStart={onDragStart} onDragStop={onDragStop} />);
        }
        currentIndex += 1;
      }
    }

    return (
      <div className="add-items-content-inner" style={ Styles.outerDiv }>
        <div className="add-items-title" style={ Styles.title }>
          <h2>Add Items</h2>
          <p>Click to Drag items into the showcase</p>
          <mui.AutoComplete
            hintText="Search Items"
            dataSource={[]}
            onUpdateInput={this.handleInput}
          />
        </div>
        <div style={ Styles.item }>
          { this.loading() }
          { this.previous() }
          {itemNodes}
          { this.next() }
        </div>
      </div>);
  }
});
module.exports = ItemList;
