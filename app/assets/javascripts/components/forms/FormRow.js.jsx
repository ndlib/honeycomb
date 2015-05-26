//app/assets/javascripts/components/forms/FormRow.jsx

var FormRow = React.createClass({

  propTypes: {
    id: React.PropTypes.string.isRequired,
    children: React.PropTypes.oneOfType([
      React.PropTypes.object,
      React.PropTypes.array,
    ]).isRequired,
    type: React.PropTypes.string.isRequired,
    title: React.PropTypes.string.isRequired,
    required: React.PropTypes.bool,
    help: React.PropTypes.string,
    errorMsg: React.PropTypes.array,
  },

  getDefaultProps: function() {
    return {
      method: "post",
      required: false,
    };
  },

  requiredClass: function() {
    css = this.props.type + ' control-label'
    if (this.props.required) {
      css += ' required';
    }

    return css;
  },

  rowClass: function () {
    css = "form-group " + this.props.type + ' control-label'
    if (this.props.required) {
      css += ' required';
    }
    if (this.props.errorMsg.length > 0) {
      css += ' has-warning';
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
      return (<FieldHelp>{this.props.help}</FieldHelp>);
    }
    return "";
  },

  formErrorMsg: function() {
    if (this.props.errorMsg) {
      var messages = _.map(this.props.errorMsg, function (errMsg, index) {
        return (<FieldHelp key={index}>{errMsg}</FieldHelp>);
      });

      return messages;
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

