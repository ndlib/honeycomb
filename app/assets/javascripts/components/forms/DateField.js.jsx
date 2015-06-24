//app/assets/javascripts/components/forms/TextField.jsx

var DateField = React.createClass({

  propTypes: {
    objectType: React.PropTypes.string.isRequired,
    name: React.PropTypes.string.isRequired,
    title: React.PropTypes.string.isRequired,
    handleFieldChange: React.PropTypes.func.isRequired,
    value: React.PropTypes.object,
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
      year: null,
      month: null,
      day: null,
      bc: false,
      displayText: "",
      chooseDisplayText: false,
    };
  },

  componentDidMount: function () {
    var date = this.splitDate();

    this.setState({
      year: date[2],
      month: date[3],
      day: date[4],
      bc: (date[1] === '-'),
      displayText: this.props.value.displayText,
      chooseDisplayText: (this.props.value.displayText ? true : false)
    });
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
    var bc = this.refs.bc.getDOMNode().checked;
    var displayText = "";
    var stateDisplayText = this.state.displayText;

    if (this.state.chooseDisplayText) {
      var displayText = this.refs.displayText.getDOMNode().value;
      stateDisplayText = displayText;
    }

    this.setState({
      year: year,
      month: month,
      day: day,
      bc: bc,
      displayText: stateDisplayText,
    });

    var date = ((bc) ? "-" : "") + year;
    date += ((month) ? "-" + month : "");
    date += ((month && day) ? "-" + day : "");

    var newValue = {
      value: date,
      displayText: displayText,
    }

    this.props.handleFieldChange(this.props.name, newValue);
  },

  clickChooseDisplayText: function() {
    this.setState( { chooseDisplayText: !this.state.chooseDisplayText }, function () {
      this.handleChange();
    });
  },

  formId: function() {
    return this.props.objectType + "_" + this.props.name;
  },

  customDisplayField: function() {
    if (this.state.chooseDisplayText) {
      return (
        <div className="row">
          <input  onChange={this.handleChange} type="text" ref="displayText" className="form-control" name="specifieddate" placeholder="Example: &quot;1788&quot; or &quot;circa. 1950&quot;" value={this.state.displayText} />
        </div>
      );
    }
    return "";
  },

  splitDate: function () {
    var re = /^([-]?)(\d{4})[-](\d{1,2})[-](\d{1,2})/;
    var m;
    if ((m = re.exec(this.props.value.value)) !== null) {
      if (m.index === re.lastIndex) {
          re.lastIndex++;
      }
      return m;
    }
  },

  render: function () {

    return (
        <FormRow id={this.formId()} type="string" required={this.props.required} title={this.props.title} help={this.props.help} errorMsg={this.props.errorMsg} >
          <div className="row">
            <input type="number" max="2100" min="0" step="1" onChange={this.handleChange} placeholder="YYYY" className="form-control" ref="year" style={{display: 'inline', width: '6em' }} value={this.state.year} />

            <input onChange={this.handleChange} type="number" max="12" min="1" step="1"  name="text-2" placeholder="MM" className="form-control" style={{display: 'inline', width: '6em' }} ref="month" value={this.state.month} />

            <input onChange={this.handleChange} type="number" max="31" min="1" step="1" name="text-3" placeholder="DD" className="form-control" ref="day" style={{display: 'inline', width: '6em' }} value={this.state.day} />
            <label>
              BC
              <input type="checkbox" ref="bc" checked={this.state.bc} onChange={this.handleChange} />
            </label>
          </div>
          <div className="row">
            <label className="help-block">
              <input onChange={this.clickChooseDisplayText} type="checkbox" ref="chooseDisplayText" checked={this.state.chooseDisplayText} /> Let me choose how this date is displayed
            </label>
          </div>
          {this.customDisplayField()}
        </FormRow>
      );
  }
});

