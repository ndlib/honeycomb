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

  getInitialState: function () {
    return {
      chooseDisplay: false,
      year: null,
      month: null,
      day: null,
      customDateDisplay: null
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
    var day = this.refs.day.getDOMNode().value;
    var customDateDisplay = this.refs.customDateDisplay.getDOMNode().value;

    this.setState({
      year: year,
      month: month,
      day: day,
      customDateDisplay: customDateDisplay
    });
    //this.props.handleFieldChange(this.props.name, year + "/" + month);
  },

  clickDateDisplayed: function() {
    this.setState( { chooseDisplay: !this.state.chooseDisplay } );
  },

  formName: function() {
    return this.props.objectType + "[" + this.props.name + "]";
  },

  formId: function() {
    return this.props.objectType + "_" + this.props.name;
  },

  customDisplayField: function() {
    if (this.state.chooseDisplay) {
      return (
        <div className="row">
          <input  onChange={this.handleChange} type="text" ref="customDateDisplay" className="form-control" name="specifieddate" placeholder="Example: &quot;1788&quot; or &quot;circa. 1950&quot;" value={this.state.customDateDisplay} />
        </div>
      );
    }
    return "";
  },

  render: function () {
    return (
        <FormRow id={this.formId()} type="string" required={this.props.required} title={this.props.title} help={this.props.help} errorMsg={this.props.errorMsg} >
          <div className="row">
            <input type="number" pattern="\d*" max="2100" min="0" step="1" name={this.formName()} className={this.requiredClass()} id={this.formId()} onChange={this.handleChange} placeholder="YYYY" ref="year" style={{display: 'inline', width: '6em' }} value={this.state.year} />

            <input onChange={this.handleChange} type="number" max="12" min="1" step="1"  name="text-2" placeholder="MM" className="form-control" style={{display: 'inline', width: '6em' }} ref="month" value={this.state.month} />

            <input  onChange={this.handleChange} type="number" max="31" min="1" step="1" name="text-3" placeholder="DD" className="form-control" ref="day" style={{display: 'inline', width: '6em' }} value={this.state.day} />
          </div>
          <div className="row">
            <label className="help-block">
              <input onClick={this.clickDateDisplayed} type="checkbox" name="specifydate" /> Let me choose how this date is displayed
            </label>
          </div>
          {this.customDisplayField()}
        </FormRow>
      );
  }
});

