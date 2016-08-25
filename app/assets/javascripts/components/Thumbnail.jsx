var React = require("react");
var mui = require("material-ui");
var classNames = require("classnames");

var Thumbnail = React.createClass({
  propTypes: {
    thumbnailUrl: React.PropTypes.string
  },

  render: function() {
    if (this.props.thumbnailUrl) {
      return (
        <img src={this.props.thumbnailUrl} className="hc-thumbnail-image" />
      );
    } else {
      return (<mui.FontIcon  className="material-icons">local_offer</mui.FontIcon>);
    }
  }
});
module.exports = Thumbnail;
