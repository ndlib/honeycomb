var React = require("react");
var mui = require("material-ui");

var RaisedButton = mui.RaisedButton;
var Toolbar = mui.Toolbar;
var ToolbarGroup = mui.ToolbarGroup;

var ToolbarStyle = {
  width: "100%",
};

var PageForm = React.createClass({
  render: function() {

    return (
      <div>
        <Toolbar style={ ToolbarStyle }>
          <ToolbarGroup key={0}>
            <RaisedButton href={ this.props.previewUrl } linkButton={ true } target="_blank" label="Preview" />
          </ToolbarGroup>
        </Toolbar>
      </div>
    );
  }
});

module.exports = PageForm;
