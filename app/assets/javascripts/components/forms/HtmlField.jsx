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
    if (!this.element) {
      this.element = jQuery(ReactDOM.findDOMNode(this.refs.textarea));
      this.element.redactor({
        changeCallback: this.redactorChange,
        blurCallback: this.redactorBlur,
        plugins: ['source'],
      });
    }
  },

  // Triggered when the HTML editor is changed
  redactorChange: function() {
    this.updateFieldValue(this.redactorValue());
  },

  // Triggered when the HTML editor is blurred
  redactorBlur: function(event) {
    this.handleBlur(event);
  },

  // Triggered when the textarea (aka source) is changed.
  //   We want to use the raw user input since the user is typing directly in
  //   the textarea, and any changes to the value will disrupt that flow.
  handleChange: function(event) {
    this.updateFieldValue(event.target.value);
  },

  // When either the textarea or HTML editor blur we want to get the HTML value
  //   directly from redactor.  This will potentially avoid some problems with
  //   bad markup.
  handleBlur: function(event) {
    this.updateFieldValue(this.redactorValue());
  },

  updateFieldValue: function(value) {
    this.props.handleFieldChange(this.props.name, value);
  },

  redactorValue: function() {
    return this.element.redactor('code.get');
  },

  formName: function() {
    return this.props.objectType + "[" + this.props.name + "]";
  },

  formId: function() {
    return this.props.objectType + "_" + this.props.name;
  },

  render: function () {
    return (
      <FormRow
        id={this.formId()}
        type="string"
        required={this.props.required}
        title={this.props.title}
        help={this.props.help}
        errorMsg={this.props.errorMsg}
      >
        <textarea
          ref="textarea"
          name={this.formName()}
          className={this.requiredClass()}
          id={this.formId()}
          onChange={this.handleChange}
          onBlur={this.handleBlur}
          placeholder={this.props.placeholder}
          value={this.props.value}
        />
      </FormRow>
    );
  }
});

module.exports = HtmlField;
