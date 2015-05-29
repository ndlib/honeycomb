/** @jsx React.DOM */

var PanelBody = React.createClass({
  propTypes: {
    children: React.PropTypes.any
  },
  render: function () {
    return (
      <div className="panel-body">
        {this.props.children}
      </div>
    );
  }
});
