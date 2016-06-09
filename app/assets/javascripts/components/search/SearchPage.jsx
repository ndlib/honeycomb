'use strict'
var React = require('react');
var mui = require("material-ui");
var Colors = require("material-ui/lib/styles/colors");
var EventEmitter = require("../../EventEmitter");
var SearchActions = require('../../actions/SearchActions');
var SearchStore = require('../../stores/SearchStore');

var Styles = {
  outerDiv: {
    display: "inline-block",
    width: "100%",
  },
  table: {
    display: "inline-block",
    width: "100%",
  },
  row: {
    cursor: "pointer"
  },
  paginationHeader: {
    paddingBottom: "4px"
  },
  paginationFooter: {},
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
    textItemIcon: {
      fontSize: "49px",
      color: Colors.grey600
    },
    itemName: {
      color: "#2c5882",
      fontSize: "18px"
    },
    lastModifiedAt: {
      fontSize: "14px"
    },
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
    itemName: {},
    lastModifiedAt: {},
  },
};

var SearchPage = React.createClass({
  propTypes: {
    searchUrl: React.PropTypes.string.isRequired,
    searchTerm: React.PropTypes.string,
    defaultSortField: React.PropTypes.string.isRequired,
    defaultSortDirection: React.PropTypes.string.isRequired,
    rows: React.PropTypes.number
  },

  getDefaultProps: function() {
    return { rows: 100 };
  },

  getInitialState: function() {
    return {
      searching: false,
    };
  },

  componentWillMount: function() {
    EventEmitter.on("SearchExecutingQuery", function() { this.setState({ searching: true }); }.bind(this));
    EventEmitter.on("SearchQueryComplete", this.resultsAreIn);
    SearchActions.executeQuery(this.props.searchUrl, {
      searchTerm: this.props.searchTerm,
      sortField: this.props.defaultSortField,
      sortDirection: this.props.defaultSortDirection,
      rowLimit: this.props.rows
    });
  },

  resultsAreIn: function(result, data){
    if(result == "success") {
      window.scrollTo(0,0);
    } else {
      var link = "<a target='blank' href='https://docs.google.com/a/nd.edu/forms/d/1PH99cRyKzhZ6rV-dCJjrfkzdThA2n1GvoE9PT6kCkSk/viewform?entry.1268925684=" + window.location + "'>submit feedback</a>";
      EventEmitter.emit("MessageCenterDisplay", "error", "Something went wrong. Please " + link + " if this continues to be an issue.", true);
    }
    this.setState({ searching: false });
  },

  getThumbnail: function(thumbnailUrl) {
    if(thumbnailUrl == null || thumbnailUrl == ""){
      return (<mui.FontIcon  className="material-icons" style={ Styles.cells.textItemIcon }>local_offer</mui.FontIcon>);
    }
    var reg = new RegExp( '^(.*)(\/.*)([\/].*$)', 'i' );
    var string = reg.exec(thumbnailUrl);
    if(string && string.length == 4) {
      thumbnailUrl = string[1] + "/small" + string[3];
    }
    return (<img src={ thumbnailUrl } style={ Styles.cells.thumbnailImage }/>);
  },

  openItem: function(rowNumber, columnId) {
    var selectedId = SearchStore.hits[rowNumber]["@id"];
    var reg = new RegExp( '^.*\/(.*)$', 'i' );
    var string = reg.exec(selectedId);
    var itemId = string[1];
    window.location = "/items/" + itemId + "/edit";
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
        <mui.TableRow key={ hit["@id"] } style={ Styles.row }>
            <mui.TableRowColumn style={ Styles.cells.thumbnail }>
              { this.getThumbnail(hit.thumbnailURL) }
            </mui.TableRowColumn>
            <mui.TableRowColumn style={ Styles.cells.itemName }>{ hit.name }</mui.TableRowColumn>
            <mui.TableRowColumn style={ Styles.cells.lastModifiedAt }>{ dateString }</mui.TableRowColumn>
        </mui.TableRow>
      );
    }.bind(this));
  },

  progressCircle: function(){
    if(this.state.searching){
      return (<ProgressOverlay />);
    } else {
      return null;
    }
  },

  render() {
    return (
      <div style={ Styles.outerDiv }>
        { this.progressCircle() }
        <div style={{ width: "100%" }}>
          <SearchBox searchUrl={this.props.searchUrl} rows={this.props.rows} />
          <SearchPagination key="PaginationHeader" rows={this.props.rows} searchUrl={this.props.searchUrl} style={ Styles.paginationHeader }/>
        </div>
        <div style={ Styles.table }>
          <mui.Table selectable={false} fixedFooter={true} onCellClick={ this.openItem }>
            <mui.TableHeader displaySelectAll={false} adjustForCheckbox={false}>
              <mui.TableRow>
                <mui.TableHeaderColumn style={Styles.headers.thumbnail}></mui.TableHeaderColumn>
                <mui.TableHeaderColumn style={Styles.headers.itemName}>
                  <SearchSortButton field="name" rows={this.props.rows} searchUrl={this.props.searchUrl} />
                  <span>Items</span>
                </mui.TableHeaderColumn>
                <mui.TableHeaderColumn style={Styles.headers.lastModifiedAt}>
                  <SearchSortButton field="last_updated" rows={this.props.rows} searchUrl={this.props.searchUrl} />
                  <span>Last Modified At</span>
                </mui.TableHeaderColumn>
              </mui.TableRow>
            </mui.TableHeader>
            <mui.TableBody displayRowCheckbox={false} showRowHover={true}>
              { this.items() }
            </mui.TableBody>
          </mui.Table>
        </div>
        <SearchPagination key="PaginationFooter" rows={this.props.rows} searchUrl={this.props.searchUrl} style={ Styles.paginationFooter }/>
      </div>
    );
  }
});

module.exports = SearchPage;
