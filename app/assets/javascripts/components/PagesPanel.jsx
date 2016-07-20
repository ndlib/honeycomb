var React = require('react');
var mui = require("material-ui");
var Avatar = mui.Avatar;

var ItemActions = require("../actions/ItemActions");
var ItemActionTypes = require("../constants/ItemActionTypes");
var ItemStore = require("../stores/ItemStore");

var PagesPanel = React.createClass({
  mixins: [TitleConcatMixin, MuiThemeMixin],
  propTypes: {
    id: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      pages: [],
    };
  },

  componentDidMount: function() {
    ItemStore.on("ItemPageLoadFinished", this.setPages);
    ItemActions.itemPages(this.props.id);
  },

  setPages: function() {
    this.setState({ pages: ItemStore.getPages(this.props.id) });
  },

  pageImageDiv: function (page) {
    if(page.image) {
      return (
        <div className="image">
          <Avatar src={ page.image["thumbnail/small"]["contentUrl"] } />
        </div>
      )
    } else {
      return (
        <div className="image" >
          <Avatar>{ page.name[0].toUpperCase() }</Avatar>
        </div>
      )
    }
  },

  pageNameDiv: function (page) {
    return (
      <div className="name">
        { this.titleConcat(page.name) }
      </div>
    )
  },

  pageNodes: function () {
    if(this.state.pages.length <= 0)
      return <p>This item is not in any pages.</p>;

    return this.state.pages.map(function(page, index) {
      key = "page-" + page.id;
      return (
        <div key={key} className="row">
          <a href={page["@id"]}>
            { this.pageImageDiv(page) }
            { this.pageNameDiv(page) }
          </a>
        </div>
      )
    }.bind(this));
  },

  embedPanel: function () {

    return (
      <Panel>
        <PanelHeading>Pages</PanelHeading>
        <PanelBody>
          <div className="info-panel">
            {this.pageNodes()}
          </div>
        </PanelBody>
      </Panel>
    )
  },

  render: function () {
    return (
      <div>
        {this.embedPanel()}
      </div>
    )
  }

});

module.exports = PagesPanel;
