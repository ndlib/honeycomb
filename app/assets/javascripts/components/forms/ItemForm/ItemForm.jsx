var React = require("react");
var mui = require("material-ui");

var ItemEmbedCode = require("../../publish/ItemEmbedCode");
var ItemActions = require("../../../actions/ItemActions");
var ItemActionTypes = require("../../../constants/ItemActionTypes");
var ItemStore = require("../../../stores/ItemStore");

var Tabs = mui.Tabs;
var Tab = mui.Tab;

var TabStyle = { borderRight: "1px white solid" };
var TabsStyle = {
  backgroundColor: "#7F8C8D",
};

var ItemForm = React.createClass({
  propTypes: {
    id: React.PropTypes.string.isRequired,
    authenticityToken: React.PropTypes.string.isRequired,
    method: React.PropTypes.string.isRequired,
    data: React.PropTypes.object.isRequired,
    basePath: React.PropTypes.string.isRequired,
    objectType: React.PropTypes.string,
    embedBaseUrl: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      item: undefined,
    }
  },

  componentDidMount: function() {
    ItemStore.on("ItemLoadFinished", this.setItem);
    ItemActions.get(this.props.id);
  },

  setItem: function() {
    this.setState({ item: ItemStore.get(this.props.id)})
  },

  metdataUrl: function() {
    return this.props.basePath + "/metadata";
  },

  render: function() {
    if (!this.state.item) {
      return (<div>Loading...</div>);
    }

    return (
      <Tabs tabItemContainerStyle={ TabsStyle }>
        <Tab label="Metadata" style={TabStyle}>
          <ItemMetaDataForm
            authenticityToken={ this.props.authenticityToken }
            method={ this.props.method }
            data={ this.props.data }
            url={ this.metdataUrl() }
            objectType={ this.props.objectType }
          />
        </Tab>
        <Tab label="Media" style={TabStyle}>
          <div>Media</div>
        </Tab>
        <Tab label="Embed" style={TabStyle}>
          <ItemEmbedCode
            id={ this.props.id }
            embedBaseUrl={ this.props.embedBaseUrl }
          />
        </Tab>
        <Tab label="Preview" />
        <Tab label="Delete" style={TabStyle}>
          <div>Delete</div>
        </Tab>
      </Tabs>
    );
  }
});

module.exports = ItemForm;
