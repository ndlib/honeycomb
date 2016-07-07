var React = require("react");
var mui = require("material-ui");

var HTML5Backend = require('react-dnd-html5-backend');
var DragDropContext = require('react-dnd').DragDropContext;

var MetaDataConfigurationList = require("./MetaDataConfigurationList");
var MetaDataConfigurationReorder = require("./MetaDataConfigurationReorder");
var MetaDataConfigurationUndelete = require("./MetaDataConfigurationUndelete");

var Tabs = mui.Tabs;
var Tab = mui.Tab;

var MetaDataConfigurationForm = React.createClass({
  propTypes: {
    baseUpdateUrl: React.PropTypes.string.isRequired,
  },

  backgroundStyle: function() {
    return {
      backgroundColor: "#7F8C8D",
    };
  },

  render: function(){
    return (
      <Tabs tabItemContainerStyle={ this.backgroundStyle() }>
        <Tab label="Edit" >
          <MetaDataConfigurationList baseUpdateUrl={this.props.baseUpdateUrl} />
        </Tab>
        <Tab label="Reorder">
          <MetaDataConfigurationReorder baseUpdateUrl={this.props.baseUpdateUrl} />
        </Tab>
        <Tab label="Undelete">
          <MetaDataConfigurationUndelete baseUpdateUrl={this.props.baseUpdateUrl} />
        </Tab>
      </Tabs>
    );
  }
});

module.exports = DragDropContext(HTML5Backend)(MetaDataConfigurationForm);
