//app/assets/javascripts/components/forms/TextField.jsx

var DateField = React.createClass({

  propTypes: {
    objectType: React.PropTypes.string.isRequired,
    name: React.PropTypes.string.isRequired,
    title: React.PropTypes.string.isRequired,
    handleFieldChange: React.PropTypes.func.isRequired,
    value: React.PropTypes.any,
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
    if (!this.props.value) {
      return;
    }

    var date = this.splitDate();

    this.setState({
      year: date[2],
      month: date[3],
      day: date[4],
      bc: (date[1] === '-'),
      displayText: this.props.value.display_text,
      chooseDisplayText: (this.props.value.display_text ? true : false)
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
      display_text: displayText,
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
    var re = /^([-]?)(\d{4})[-]?(\d{1,2})?[-]?(\d{1,2})?/;
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
          <fieldset>
            <div className="row form-inline">
              <div className="form-group">
                <label className="sr-only" htmlFor={"year" + this.props.name}>Year</label>
                <input id={"year" + this.props.name} type="number" max="2100" min="0" step="1" onChange={this.handleChange} placeholder="YYYY" className="form-control" ref="year" style={{display: 'inline', width: '6em' }} value={this.state.year} />
              </div>
              <div className="form-group">
                <label className="sr-only" htmlFor={"month" + this.props.name}>Month</label>
                <input id={"month" + this.props.name} onChange={this.handleChange} type="number" max="12" min="1" step="1" placeholder="MM" className="form-control" style={{display: 'inline', width: '6em' }} ref="month" value={this.state.month} />
              </div>
              <div className="form-group">
                <label className="sr-only" htmlFor={"day" + this.props.name}>Day</label>
                <input id={"day" + this.props.name} onChange={this.handleChange} type="number" max="31" min="1" step="1" placeholder="DD" className="form-control" ref="day" style={{display: 'inline', width: '6em' }} value={this.state.day} />
              </div>
              <div className="form-group">
                <label className="control-label">
                  BC
                  <input type="checkbox" ref="bc" checked={this.state.bc} onChange={this.handleChange} />
                </label>
              </div>
            </div>
            <div className="row">
              <label className="help-block">
                <input onChange={this.clickChooseDisplayText} type="checkbox" ref="chooseDisplayText" checked={this.state.chooseDisplayText} /> Let me choose how this date is displayed
              </label>
            </div>
          </fieldset>
          {this.customDisplayField()}
        </FormRow>
      );
  }
});

