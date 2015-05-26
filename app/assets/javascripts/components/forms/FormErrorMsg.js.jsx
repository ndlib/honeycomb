//app/assets/javascripts/components/forms/FormErrorMsg.jsx

var FormErrorMsg = React.createClass({

  render: function () {
    return (
      <div className="alert alert-warning" role="alert">
        Please complete the highlighted fields in order to continue.
      </div>
    );
  }
})
