//app/assets/javascripts/components/forms/FormErrorMsg.jsx
var React = require('react');
var FormErrorMsg = React.createClass({
  propTypes: {
    message: React.PropTypes.string.isRequired,
    type: React.PropTypes.string.isRequired,
  },

  getClassName: function() {
    switch(this.props.type)
    {
      case "warning":
        return "alert alert-warning";
        break;
      case "error":
        return "alert alert-danger";
        break;
      case "success":
        return "alert alert-success";
        break;
      default:
        return "alert alert-warning";
        break;
    }
  },

  render: function () {
    return (
      <div className={this.getClassName()} role="alert">
        {this.props.message}
      </div>
    );
  }
});

module.exports = FormErrorMsg;
