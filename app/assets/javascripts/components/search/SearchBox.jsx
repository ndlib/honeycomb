'use strict'
var React = require('react');
var mui = require('material-ui');
var ColorManipulator = require('material-ui/lib/utils/color-manipulator');
var SearchStore = require('../../stores/SearchStore');
var SearchActions = require('../../actions/SearchActions');

var Styles = {
  searchIcon: {
    fontSize: '18px',
    verticalAlign: 'text-bottom',
    minWidth: '26px',
    padding: '8px',
    borderRadius: '0 2px 2px 0',
    borderLeft: 'none'
  },
  searchButton: {
    zIndex: '1',
    minWidth: 'auto',
    lineHeight: '36px'
  },
  searchTextField: {
    height: '38px',
    width: '300px',
    verticalAlign:'top',
  },
  outerDiv: {
    display: 'inline-block',
  },
  clearButton: {
    marginLeft: "-50px",
    height: "38px",
    width: "50px",
  },
  searchTextFieldWithClearButton: {
    height: '38px',
    width: '300px',
    verticalAlign:'top',
    paddingRight: "50px",
  }
};

var SearchBox = React.createClass({
  propTypes: {
    searchUrl: React.PropTypes.string.isRequired,
    rows: React.PropTypes.number.isRequired
  },

  componentWillMount: function() {
    EventEmitter.on("SearchQueryComplete", this.resultsAreIn);
  }

  onChange: function(e) {
    this.setState({searchTerm: e.target.value});
  },

  onClick: function(e) {
    SearchActions.executeQuery(this.props.searchUrl, {
      searchTerm: this.state.searchTerm,
      sortField: SearchStore.sortField,
      sortDirection: SearchStore.sortDirection,
      rowLimit: this.props.rows
    });
  },

  clearClick: function() {
    this.setState({searchTerm: ""}, SearchActions.executeQuery(this.props.searchUrl, {
      searchTerm: "",
    }));
  },

  componentDidMount: function() {
    this.setState({searchTerm: SearchStore.searchTerm});
  },

  handleKeyDown: function(e) {
    var ENTER = 13;
    if( e.keyCode == ENTER ) {
        this.onClick(e);
    }
  },

  inputBox: function() {
    return (<input
      placeholder='Search'
      onChange={this.onChange}
      defaultValue={SearchStore.searchTerm}
      onKeyDown={this.handleKeyDown}
      style={SearchStore.searchTerm ? Styles.searchTextFieldWithClearButton : Styles.searchTextField }
    />);
  },

  clearButton: function() {
    if (SearchStore.searchTerm) {
      return (
        <mui.IconButton onClick={this.clearClick} style={Styles.clearButton} >
          <mui.FontIcon className="material-icons">clear</mui.FontIcon>
        </mui.IconButton>
      );
    } else {
      return;
    }
  },

  button: function() {
    return (
      <mui.RaisedButton onClick={this.onClick} style={ Styles.searchButton }>
        <mui.FontIcon className="material-icons" style={ Styles.searchIcon }>search</mui.FontIcon>
      </mui.RaisedButton>
    );
  },

  render: function() {
    return(
      <div style={ Styles.outerDiv }>
        { this.inputBox() }
        { this.clearButton() }
        { this.button() }
      </div>
    );
  }
});
module.exports = SearchBox
