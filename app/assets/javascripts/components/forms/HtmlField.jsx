//app/assets/javascripts/components/forms/HtmlField.jsx
var React = require('react');
var HtmlField = React.createClass({

  propTypes: {
    objectType: React.PropTypes.string.isRequired,
    name: React.PropTypes.string.isRequired,
    title: React.PropTypes.string.isRequired,
    handleFieldChange: React.PropTypes.func.isRequired,
    value: React.PropTypes.string,
    required: React.PropTypes.bool,
    placeholder: React.PropTypes.string,
    help: React.PropTypes.string,
    errorMsg: React.PropTypes.array,
  },

  getDefaultProps: function() {
    return {
      value: "",
      required: false,
    };
  },

  requiredClass: function() {
    var css = 'form-control';
    if (this.props.required) {
      css += ' required';
    }

    return css;
  },

  componentDidMount: function() {
    if (!this.redactor) {
      this.redactor = jQuery("#" + this.formId()).redactor({
        changeCallback: this.handleChange,
      });
    }
  },

  changeCallback: function () {

  },

  handleChange: function(event) {
    this.props.handleFieldChange(this.props.name, this.redactor.redactor('code.get'));
  },

  formName: function() {
    return this.props.objectType + "[" + this.props.name + "]";
  },

  formId: function() {
    return this.props.objectType + "_" + this.props.name;
  },

  render: function () {
    return (
        <FormRow id={this.formId()} type="string" required={this.props.required} title={this.props.title} help={this.props.help} errorMsg={this.props.errorMsg} >
          <textarea name={this.formName()} className={this.requiredClass()} id={this.formId()} onChange={this.handleChange} placeholder={this.props.placeholder} value={this.props.value} />
        </FormRow>
      );
  }
});

module.exports = HtmlField;
