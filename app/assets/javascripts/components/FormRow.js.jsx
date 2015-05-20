//app/assets/javascripts/components/modal/Modal.jsx

var FormRow = React.createClass({
  displayName: 'Form',

  propTypes: {
    id: React.PropTypes.string.isRequired,
    children: React.PropTypes.oneOfType([
      React.PropTypes.object,
      React.PropTypes.array,
    ]).isRequired,
    type: React.PropTypes.string.isRequired,
    title: React.PropTypes.string.isRequired,
    required: React.PropTypes.string.isRequired,
    help: React.PropTypes.string,
    errorMsg: React.PropTypes.string,
  },

  getDefaultProps: function() {
    return {
      method: "post",
    };
  },

  requiredClass: function() {
    css = this.props.type + ' control-label'
    if (this.props.required) {
      css += ' required';
    }
    if (this.props.errorMsg) {
      css += ' has-error';
    }

    return css;
  },

  rowClass: function () {
    css = "form-group " + this.props.type + ' control-label'
    if (this.props.required) {
      css += ' required';
    }
    if (this.props.errorMsg) {
      css += ' has-error';
    }
    return css;
  },

  requiredStar: function() {
    if (this.props.required) {
      return (<abbr title="required">* </abbr>)
    }
    return "";
  },

  formHelp: function() {
    if (this.props.help) {
      return (<FormHelpBlock>{this.props.help}</FormHelpBlock>);
    }
    return "";
  },

  formErrorMsg: function() {
    if (this.props.errorMsg) {
      return (<FormHelpBlock>{this.props.errorMsg}</FormHelpBlock>);
    }
    return "";
  },

  render: function () {
    return (
      <div className={this.rowClass()}>
        <label className={this.requiredClass()} htmlFor={this.props.id}>
          {this.requiredStar()}
          {this.props.title}
        </label>
        {this.props.children}
        {this.formErrorMsg()}
        {this.formHelp()}
      </div>
    );
  }
});

