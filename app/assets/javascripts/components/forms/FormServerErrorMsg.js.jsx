//app/assets/javascripts/components/forms/FormServerErrorMsg.jsx

var FormServerErrorMsg = React.createClass({

  render: function () {
    return (
      <div className="alert alert-danger" role="alert">
        The server has encountered an error.  The form has not been saved.
      </div>
    );
  }
})
