'use strict'
var React = require('react');
var mui = require("material-ui");
var AppDispatcher = require("../../dispatcher/AppDispatcher");
var SearchActions = require('../../actions/SearchActions');
var SearchStore = require('../../stores/SearchStore');

var styles = {
  outerDiv: {
    display: "inline-block"
  },
  cells:{
    thumbnail: {
      height: "80px",
      paddingTop: "8px",
      paddingBottom: "8px",
      paddingLeft: "24px",
      paddingRight: "24px",
      width: "97px",
    },
    thumbnailImage: {
      maxHeight: "100%",
      maxWidth: "100%",
      verticalAlign: "middle",
      display: "inline-block",
      height: "auto",
      width: "auto",
      opacity: "1",
      padding: "4px",
      backgroundColor: "white",
      border: "1px solid #dddddd",
      borderRadius: "4px",
    },
    name: {},
    status: {},
    lastModifiedAt: {},
  },
  headers: {
    thumbnail: {
      height: "80px",
      paddingTop: "8px",
      paddingBottom: "8px",
      paddingLeft: "24px",
      paddingRight: "24px",
      width: "97px",
    },
    name: {},
    status: {},
    lastModifiedAt: {},
  },
};

var SearchPage = React.createClass({
  propTypes: {
    searchUrl: React.PropTypes.string.isRequired,
    searchTerm: React.PropTypes.string
  },

  componentWillMount: function() {
    console.log(this.props.searchUrl);
    SearchStore.addChangeListener(this.resultsAreIn);
    SearchActions.executeQuery(this.props.searchUrl, { searchTerm: this.props.searchTerm, rowLimit: 15 })
  },

  resultsAreIn: function(){
    this.forceUpdate();
  },

  items: function(){
    return SearchStore.hits.map(function(hit) {
      var dateOptions = { year: "numeric", month: "short", day: "numeric" };
      var dateString = (new Date(hit.updated)).toLocaleDateString("en-US", dateOptions);
      var todayString = (new Date()).toLocaleDateString("en-US", dateOptions);
      if(dateString == todayString) {
        dateString = (new Date(hit.updated)).toLocaleTimeString("en-US");
      }
      return (
        <mui.TableRow key={ hit["@id"] }>
            <mui.TableRowColumn style={ styles.cells.thumbnail }>
              <img src={ hit.thumbnailURL } style={ styles.cells.thumbnailImage }/>
            </mui.TableRowColumn>
            <mui.TableRowColumn style={ styles.cells.itemName }>{ hit.name }</mui.TableRowColumn>
            <mui.TableRowColumn style={ styles.cells.status }>OK</mui.TableRowColumn>
            <mui.TableRowColumn style={ styles.cells.lastModifiedAt }>{ dateString }</mui.TableRowColumn>
        </mui.TableRow>
      );
    }.bind(this));
  },

  render() {
    return (
      <div style={ styles.outerDiv }>
        <mui.Table selectable={false}>
          <mui.TableHeader displaySelectAll={false} adjustForCheckbox={false}>
            <mui.TableRow>
              <mui.TableHeaderColumn style={styles.headers.thumbnail}></mui.TableHeaderColumn>
              <mui.TableHeaderColumn style={styles.headers.itemName}>Items</mui.TableHeaderColumn>
              <mui.TableHeaderColumn style={styles.headers.status}>Status</mui.TableHeaderColumn>
              <mui.TableHeaderColumn style={styles.headers.lastModifiedAt}>Last Modified At</mui.TableHeaderColumn>
            </mui.TableRow>
          </mui.TableHeader>
          <mui.TableBody displayRowCheckbox={false} showRowHover={true}>
          { this.items() }
          </mui.TableBody>
        </mui.Table>
      </div>
    );
  }
});

module.exports = SearchPage;
