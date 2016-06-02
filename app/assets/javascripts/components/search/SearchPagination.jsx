'use strict'
var React = require('react');
var mui = require('material-ui');
var SearchStore = require('../../stores/SearchStore');
var SearchActions = require('../../actions/SearchActions');

var Styles = {
  outerDiv: {
    display: "inline-block",
    color:'rgba(0, 0, 0, 0.870588)',
    float: 'right',
    textAlign: 'right',
  },
  itemRangeLabel: {
    marginRight:'15px',
    display:'inline-block',
    lineHeight: '40px'
  },
  pageButton: {
    minWidth: "34px",
    padding:'3px 5px',
    marginRight:'2px',
    verticalAlign:'top'
  }
};

var SearchPagination = React.createClass({
  propTypes: {
    searchUrl: React.PropTypes.string.isRequired,
    rows: React.PropTypes.number.isRequired
  },

  queryPage: function(i) {
    SearchActions.executeQuery(this.props.searchUrl, {
      searchTerm: SearchStore.searchTerm,
      sortField: SearchStore.sortField,
      sortDirection: SearchStore.sortDirection,
      rowLimit: this.props.rows,
      start: i
    });
  },

  componentWillMount: function() {
    SearchStore.addChangeListener(this.resultsAreIn);
  },

  resultsAreIn: function(){
    this.forceUpdate();
  },

  pageLink: function(i) {
    if(SearchStore.start === (i-1) * this.props.rows){
      return(
        <mui.RaisedButton key={ this.props.key + "CurrentPageLabel" } style={ Styles.pageButton } disabled={true}>
          { i }
        </mui.RaisedButton>
      );
    }
    else {
      var start = (i-1)*this.props.rows;
      return(
        <mui.RaisedButton key={ this.props.key + "PageLink-" + i } style={ Styles.pageButton } onTouchTap={ function(){ this.queryPage(start) }.bind(this) }>
          { i }
        </mui.RaisedButton>
      );
    }
  },

  pageLinks: function() {
    var nodes = [];
    // if not first page
    if(SearchStore.start != 0) {
      nodes.push((
        <mui.RaisedButton key={ this.props.key + "PreviousPageLink" } style={ Styles.pageButton } onTouchTap={ function(){ this.queryPage(0) }.bind(this) }>
          <i className="material-icons" style={{fontSize: '1em',}}>arrow_back</i>
        </mui.RaisedButton>
      ));
    }
    var last = Math.floor(SearchStore.found/this.props.rows);
    var cappedFirst = Math.max(1, Math.floor(SearchStore.start/this.props.rows) - 2);
    var cappedLast = Math.min(Math.floor(SearchStore.start/this.props.rows) + 4, last + 1);
    if(SearchStore.found > this.props.rows){

      if(SearchStore.found%this.props.rows != 0){
        last += 1;
      }
      for (var i = cappedFirst; i <= cappedLast; i++) {
        nodes.push(this.pageLink(i));
      }
    }

    // if not last page
    if(SearchStore.start + this.props.rows < SearchStore.found) {
      var start = this.props.rows*(last - 1);
      nodes.push((
        <mui.RaisedButton key={ this.props.key + "NextPageLink" } style={ Styles.pageButton } onTouchTap={ function(){ this.queryPage(start) }.bind(this) }>
          <i className="material-icons" style={{fontSize: '1em'}}>arrow_forward</i>
        </mui.RaisedButton>
      ));
    }
    return nodes;
  },

  rangeLabel: function() {
    if(SearchStore.count > 0){
      var startHuman = SearchStore.start + 1;
      var endHuman = Math.min(SearchStore.start + this.props.rows, SearchStore.found);
      return (
        <span style={ Styles.itemRangeLabel }>
          Showing {startHuman} - {endHuman} of {SearchStore.found}
        </span>
      );
    } else {
      return (
        <span style={ Styles.itemRangeLabel }>
          No results found.
        </span>
      );
    }
  },

  render: function() {
    return (
      <div style={ _.extend(Styles.outerDiv, this.props.style) }>
        { this.rangeLabel() }
        { this.pageLinks() }
      </div>
    );
  }
});

module.exports = SearchPagination;
