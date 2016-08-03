var React = require("react");
var mui = require("material-ui");

var ItemEmbedCode = require("../../publish/ItemEmbedCode");
var ItemActions = require("../../../actions/ItemActions");
var ItemActionTypes = require("../../../constants/ItemActionTypes");
var ItemStore = require("../../../stores/ItemStore");
var DeleteItemForm = require("./DeleteItemForm");
var ReplaceMediaForm = require("./ReplaceMediaForm");

var Tabs = mui.Tabs;
var Tab = mui.Tab;
var RaisedButton = mui.RaisedButton;
var Toolbar = mui.Toolbar;
var ToolbarGroup = mui.ToolbarGroup;
var SwipeableViews = mui.SwipeableViews;

var TabStyle = {
  borderRight: "1px white solid",
};
var TabContainerStyle = {
  marginTop: "15px"
};
var TabsStyle = {
  backgroundColor: "#7F8C8D",
  marginTop: "5px",
};
var ToolbarStyle = {
  minWidth: "70%",
};

var ItemForm = React.createClass({
  propTypes: {
    id: React.PropTypes.string.isRequired,
    authenticityToken: React.PropTypes.string.isRequired,
    method: React.PropTypes.string.isRequired,
    data: React.PropTypes.object.isRequired,
    objectType: React.PropTypes.string,
    embedBaseUrl: React.PropTypes.string.isRequired,
    previewUrl: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      item: undefined,
      selectedIndex: "metadata",
    }
  },

  componentDidMount: function() {
    ItemStore.on("ItemLoadFinished", this.setItem);
    this.loadItem();
  },

  setItem: function() {
    var item = ItemStore.get(this.props.id);
    this.setState({ item: ItemStore.get(this.props.id)})

    if (item.image.status == "processing") {
      setTimeout(this.loadItem, 4000);
    }
  },

  loadItem: function() {
    ItemActions.get(this.props.id);
  },

  metdataUrl: function() {
    return ItemActions.url(this.props.id) + "/metadata";
  },

  _handleChangeTabs: function(value, event) {
    this.setState({ selectedIndex: value });
  },

  form: function() {
    if (this.state.selectedIndex == "metadata") {
      return (
        <ItemMetaDataForm
          authenticityToken={ this.props.authenticityToken }
          method={ this.props.method }
          data={ this.props.data }
          url={ this.metdataUrl() }
          objectType={ this.props.objectType }
        />
      );
    } else if (this.state.selectedIndex == "media") {
      return (
        <div>
          <ReplaceMediaForm
            item={ this.state.item }
            authenticityToken={ this.props.authenticityToken }
            modalTitle="Replace"
            multifileUpload={ false }
          />
        </div>
      );
    } else if (this.state.selectedIndex == "embed") {
      return (
        <ItemEmbedCode
          id={ this.props.id }
          embedBaseUrl={ this.props.embedBaseUrl }
        />
      );
    } else if (this.state.selectedIndex == "delete") {
      return (
        <div>
          <ShowcasesPanel
            id={ this.props.id }
          />
          <PagesPanel
            id={ this.props.id }
          />
        <DeleteItemForm item={ this.state.item }/>
        </div>
      );
    } else {
      console.log("invalid tab");
      return "";
    }
  },

  render: function() {
    if (!this.state.item) {
      return (<div>Loading...</div>);
    }

    return (
      <div>
        <Toolbar style={ ToolbarStyle }>
          <ToolbarGroup key={0} float="left">
            <RaisedButton href={ this.props.previewUrl } linkButton={ true } target="_blank" label="Preview" />
          </ToolbarGroup>
          <ToolbarGroup key={1} float="right" style={ ToolbarStyle }>
            <Tabs tabItemContainerStyle={ TabsStyle } onChange={this._handleChangeTabs} value={ this.state.selectedIndex }>
              <Tab label="Metadata" style={TabStyle} value="metadata" />
              <Tab label="Media" style={TabStyle} value="media" />
              <Tab label="Embed" style={TabStyle} value="embed" />
              <Tab label="Delete" style={ TabStyle } value="delete" />
            </Tabs>
          </ToolbarGroup>
        </Toolbar>
        <div className="row" style={ TabContainerStyle }>
          <div className="col-md-9">
            { this.form() }
          </div>
          <div className="col-md-3">
            <ItemShowImageBox
                item={ this.state.item }
            />
          </div>
        </div>
      </div>
    );
  }
});

module.exports = ItemForm;
