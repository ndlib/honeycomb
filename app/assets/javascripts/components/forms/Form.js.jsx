//app/assets/javascripts/components/forms/Form.jsx

var Form = React.createClass({

  propTypes: {
    id: React.PropTypes.string,
    children: React.PropTypes.oneOfType([
      React.PropTypes.object,
      React.PropTypes.array,
    ]).isRequired,
    url: React.PropTypes.string.isRequired,
    authenticityToken: React.PropTypes.string.isRequired,
    method: React.PropTypes.string,
  },

  getDefaultProps: function() {
    return {
      method: "post",
      hasErrors: false,
    };
  },

  formMethod: function() {
    if (this.props.method == 'get') {
      return "get";
    } else {
      return "post";
    }
  },

  render: function () {
    return (
      <form action={this.props.url} method={ this.formMethod() } >
        <input name="utf8" type="hidden" value="✓" />
        <input type="hidden" name="_method" value={this.props.method} />
        <input type="hidden" name="authenticity_token" value={this.props.authenticityToken} />
        {this.props.children}
      </form>
    );
  }
});

