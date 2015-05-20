/** @jsx React.DOM */

var Panel = React.createClass({
  propTypes: {
    PanelTitle: React.PropTypes.string.isRequired,
    PanelHelp: React.PropTypes.string,
    children: React.PropTypes.element.isRequired
  },
  handleClick: function () {
    this.props.togglePublished();
  },
  render: function () {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">{this.props.PanelTitle}</h3>
        </div>
        <div className="panel-body">
          <p>{this.props.PanelHelp}</p>
          {this.props.children}
        </div>
      </div>
    )
  }
});
