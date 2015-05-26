/** @jsx React.DOM */

var PanelHeading = React.createClass({
  propTypes: {
    children: React.PropTypes.any
  },
  render: function () {
    return (
      <div className="panel-heading">
        <h3 className="panel-title">{this.props.children}</h3>
      </div>
    );
  }
});
