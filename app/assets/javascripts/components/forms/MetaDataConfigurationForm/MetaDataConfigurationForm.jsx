var React = require("react");
var mui = require("material-ui");

var HTML5Backend = require('react-dnd-html5-backend');
var DragDropContext = require('react-dnd').DragDropContext;

var MetaDataConfigurationList = require("./MetaDataConfigurationList");
var MetaDataConfigurationReorder = require("./MetaDataConfigurationReorder");
var MetaDataConfigurationFacets = require("./MetaDataConfigurationFacets");
var MetaDataConfigurationSorts = require("./MetaDataConfigurationSorts");
var MetaDataConfigurationUndelete = require("./MetaDataConfigurationUndelete");

var Tabs = mui.Tabs;
var Tab = mui.Tab;

var TabStyle = { borderRight: "1px white solid" };
var TabsStyle = {
  backgroundColor: "#7F8C8D",
};
var ComponentStyle = {
  marginBottom: "40px",
};

var MetaDataConfigurationForm = React.createClass({
  propTypes: {
    baseUpdateUrl: React.PropTypes.string.isRequired,
    facetUpdateUrl: React.PropTypes.string.isRequired,
  },

  render: function(){
    return (
      <Tabs style={ComponentStyle} tabItemContainerStyle={ TabsStyle }>
        <Tab label="Edit" style={TabStyle}>
          <MetaDataConfigurationList baseUpdateUrl={this.props.baseUpdateUrl} />
        </Tab>
        <Tab label="Reorder" style={TabStyle}>
          <MetaDataConfigurationReorder baseUpdateUrl={this.props.baseUpdateUrl} />
        </Tab>
        <Tab label="Facets" style={TabStyle}>
          <MetaDataConfigurationFacets baseUpdateUrl={this.props.facetUpdateUrl} />
        </Tab>
        <Tab label="Sorts" style={TabStyle}>
          <MetaDataConfigurationSorts baseUpdateUrl={this.props.sortUpdateUrl} />
        </Tab>
        <Tab label="Undelete" style={TabStyle}>
          <MetaDataConfigurationUndelete baseUpdateUrl={this.props.baseUpdateUrl} />
        </Tab>
      </Tabs>
    );
  }
});

module.exports = DragDropContext(HTML5Backend)(MetaDataConfigurationForm);
