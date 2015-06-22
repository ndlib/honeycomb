//app/assets/javascripts/components/forms/TextField.jsx

var DateField = React.createClass({

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

  handleChange: function(event) {
    var year = this.refs.year.getDOMNode().value;
    var month = this.refs.month.getDOMNode().value;

    this.props.handleFieldChange(this.props.name, year + "/" + month);
    console.log(year + "/" + month)
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
          <div className="row">
            <div className="col-xs-2">
              <input type="text" name={this.formName()} value={this.props.value} className={this.requiredClass()} id={this.formId()} onChange={this.handleChange} placeholder="YYYY" ref="year" />
            </div>
            <div className="col-xs-2">
              <input onChange={this.handleChange} type="text" name="text-2" placeholder="MM" className="form-control" ref="month" />
            </div>
            <div className="col-xs-2">
              <input type="text" name="text-3" placeholder="DD" className="form-control" ref="day" />
            </div>
          </div>
          <div className="row">
            <div className="col-xs-12">
              <input type="checkbox" name="specifydate" /> Let me choose how this date is displayed
            </div>
          </div>
          <div className="row">
            <div className="col-xs-12">
              <input type="text" className="form-control" name="specifieddate" placeholder="Example: &quot;1788&quot; or &quot;circa. 1950&quot;" />
            </div>
          </div>
        </FormRow>
      );
  }
});

