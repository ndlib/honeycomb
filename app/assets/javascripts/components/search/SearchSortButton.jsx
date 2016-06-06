'use strict'
var React = require('react');
var mui = require("material-ui");
var Colors = require("material-ui/lib/styles/colors");
var SearchActions = require('../../actions/SearchActions');
var SearchStore = require('../../stores/SearchStore');

var Styles = {
  sortedIcon: {
    fontSize: "15px",
    color: Colors.grey700
  },
  unsortedIcon: {
    fontSize: "15px",
    color: Colors.grey500
  },
};

var SearchSortButton = React.createClass({
  propTypes: {
    searchUrl: React.PropTypes.string.isRequired,
    field: React.PropTypes.string.isRequired,
    rows: React.PropTypes.number.isRequired
  },

  getInitialState: function() {
    return {
      direction: SearchStore.sortDirection
    };
  },

  componentWillMount: function() {
    SearchStore.addChangeListener(this.storeChanged);
  },

  storeChanged: function() {
    this.setState({ direction: SearchStore.sortDirection });
  },

  onClick: function(fieldName) {
    var newDir = this.state.direction === "desc" ? "asc" : "desc";
    SearchActions.executeQuery(this.props.searchUrl, {
      searchTerm: SearchStore.searchTerm,
      sortField: this.props.field,
      sortDirection: newDir,
      rowLimit: this.props.rows
    });
  },

  sortIcon: function() {
    if(this.props.field !== SearchStore.sortField) {
      return (
        <div>
          <mui.FontIcon className="glyphicon glyphicon-sort" label="Sort Asc" style={ Styles.unsortedIcon }/>
        </div>
      );
    }

    return (
      <div>
      {
        this.state.direction === "desc"
          && <mui.FontIcon className="glyphicon glyphicon-sort-by-attributes-alt" label="Sort Desc" style={ Styles.sortedIcon }/>
          || <mui.FontIcon className="glyphicon glyphicon-sort-by-attributes" label="Sort Asc" style={ Styles.sortedIcon }/>
      }
      </div>
    );
  },

  render: function() {
    return (
      <mui.IconButton onTouchTap={ this.onClick }>
        { this.sortIcon() }
      </mui.IconButton>
    );
  }
});

module.exports = SearchSortButton;
