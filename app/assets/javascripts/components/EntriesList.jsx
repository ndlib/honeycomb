'use strict'
var React = require('react');
var mui = require("material-ui");

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
  cells:{
    deleteButton: {
      fontSize: "18px",
      width: "75px",
    },
    thumbnail: {
      height: "80px",
      paddingTop: "8px",
      paddingBottom: "8px",
      paddingLeft: "24px",
      paddingRight: "24px",
      width: "97px",
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
    deleteButton: {
      width: "75px",
    },
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

var EntriesList = React.createClass({
  propTypes: {
    header: React.PropTypes.string.isRequired,
    entryType: React.PropTypes.string.isRequired,
    entries: React.PropTypes.array.isRequired,
    openUrl: React.PropTypes.string.isRequired,
    hasEntryCount: React.PropTypes.bool,
    deleteButtonType: React.PropTypes.string,
  },

  getDefaultProps: function() {
    return { hasEntryCount: false };
  },

  openItem: function(rowNumber, columnId) {
    if(columnId != 4) {
      var selectedId = this.props.entries[rowNumber].id;
      window.location = this.props.openUrl.replace("<id>", selectedId);
    }
  },

  entryCountHeader: function() {
    if (this.props.hasEntryCount) {
      return (<mui.TableHeaderColumn/>)
    }
  },

  entryCount: function(entry) {
    if (this.props.hasEntryCount) {
      var count = entry.count;

      // Todo: We're not using i18n anywhere in javascript as of yet.
      return (
        <mui.TableRowColumn>
          <span className="badge">
            { count + " Items" }
          </span>
        </mui.TableRowColumn>
      )
    }
  },

  deleteCallback: function() {
    window.location.reload();
  },

  deleteColumn: function(header, id) {
    if(this.props.deleteButtonType) {
      if(header) {
        return(<mui.TableHeaderColumn style={Styles.headers.deleteButton}></mui.TableHeaderColumn>);
      } else {
        return(
          <mui.TableRowColumn style={ Styles.cells.deleteButton }>
            <DeleteButton type={this.props.deleteButtonType} id={id} callback={this.deleteCallback}/>
          </mui.TableRowColumn>
        );
      }
    }
  },

  items: function() {
    return this.props.entries.map(function(entry) {
      var dateOptions = { year: "numeric", month: "short", day: "numeric" };
      var dateString = (new Date(entry.updated)).toLocaleDateString("en-US", dateOptions);
      var todayString = (new Date()).toLocaleDateString("en-US", dateOptions);
      if(dateString == todayString) {
        dateString = (new Date(entry.updated)).toLocaleTimeString("en-US");
      }
      return (
        <mui.TableRow key={ entry.id } style={ Styles.row }>
            <mui.TableRowColumn style={ Styles.cells.thumbnail }>
              <Thumbnail thumbnailUrl={ entry.thumb } thumbType={ this.props.entryType } />
            </mui.TableRowColumn>
            <mui.TableRowColumn style={ Styles.cells.itemName }>{ entry.name }</mui.TableRowColumn>
            { this.entryCount(entry) }
            <mui.TableRowColumn style={ Styles.cells.lastModifiedAt }>{ dateString }</mui.TableRowColumn>
            { this.deleteColumn(false, entry.id) }
        </mui.TableRow>
      );
    }.bind(this));
  },

  render() {
    return (
      <div style={ Styles.outerDiv }>
        <div style={ Styles.table }>
          <mui.Table selectable={false} fixedFooter={true} onCellClick={ this.openItem }>
            <mui.TableHeader displaySelectAll={false} adjustForCheckbox={false}>
              <mui.TableRow>
                <mui.TableHeaderColumn style={Styles.headers.thumbnail}></mui.TableHeaderColumn>
                <mui.TableHeaderColumn style={Styles.headers.itemName}>
                  <span>{this.props.header}</span>
                </mui.TableHeaderColumn>
                { this.entryCountHeader() }
                <mui.TableHeaderColumn style={Styles.headers.lastModifiedAt}>
                  <span>Last Modified At</span>
                </mui.TableHeaderColumn>
                { this.deleteColumn(true) }
              </mui.TableRow>
            </mui.TableHeader>
            <mui.TableBody displayRowCheckbox={false} showRowHover={true} className="item-list">
              { this.items() }
            </mui.TableBody>
          </mui.Table>
        </div>
      </div>
    );
  }
});

module.exports = EntriesList;
