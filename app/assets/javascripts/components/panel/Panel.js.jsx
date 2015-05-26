/** @jsx React.DOM */

var Panel = React.createClass({
  propTypes: {
    children: React.PropTypes.any
  },
  render: function () {
    return (
      <div className="panel panel-default">
        {this.props.children}
      </div>
    );
  }
});
