/** @jsx React.DOM */

var PanelFooter = React.createClass({
  propTypes: {
    children: React.PropTypes.element.isRequired
  },
  render: function () {
    return (
      <div className="panel-footer">
        {this.props.children}
      </div>
    );
  }
});
