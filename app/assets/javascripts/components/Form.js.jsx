//app/assets/javascripts/components/modal/Modal.jsx

var Form = React.createClass({
  displayName: 'Form',

  propTypes: {
    id: React.PropTypes.string,
    children: React.PropTypes.oneOfType([
      React.PropTypes.object,
      React.PropTypes.array,
    ]).isRequired,
    url: React.PropTypes.string.isRequired,
    authenticityToken: React.PropTypes.string.isRequired,
    method: React.PropTypes.string,
    hasErrors: React.PropTypes.object,
  },

  getDefaultProps: function() {
    return {
      method: "post",
    };
  },

  formMethod: function() {
    if (this.props.method == 'get') {
      return "get";
    } else {
      return "post";
    }
  },

  formErrorAlert: function () {
    if (this.props.hasErrors)  {
      return (
        <div className="alert alert-danger" role="alert">
          <strong>Opps!!</strong> errors prohibited this form being saved.
        </div>
      )
    }
    return "";
  },

  render: function () {
    return (
      <form action={this.props.url} method={ this.formMethod() } >
        <input name="utf8" type="hidden" value="✓" />
        <input type="hidden" name="_method" value={this.props.method} />
        <input type="hidden" name="authenticity_token" value={this.props.authenticityToken} />
        {this.formErrorAlert()}
        {this.props.children}
      </form>
    );
  }
});

