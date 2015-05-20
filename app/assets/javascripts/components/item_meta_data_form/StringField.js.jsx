//app/assets/javascripts/components/modal/Modal.jsx

var StringField = React.createClass({
  displayName: 'StringField',

  propTypes: {
    objectType: React.PropTypes.string.isRequired,
    name: React.PropTypes.string.isRequired,
    title: React.PropTypes.string.isRequired,
    value: React.PropTypes.string,
    required: React.PropTypes.bool.isRequired,
    handleFieldChange: React.PropTypes.func.isRequired,
    placeholder: React.PropTypes.string,
    help: React.PropTypes.string,
    errorMsg: React.PropTypes.string,
  },

  getDefaultProps: function() {
    return {
      value: ""
    };
  },

  requiredClass: function() {
    css = 'form-control'
    if (this.props.required) {
      css += ' required'
    }

    return css
  },

  handleChange: function(event) {
    this.props.handleFieldChange(this.props.name, event.target.value);
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
          <input type="text" name={this.formName()} value={this.props.value} className={this.requiredClass()} id={this.formId()} onChange={this.handleChange} placeholder={this.props.placeholder} />
        </FormRow>
      );
  }
});

