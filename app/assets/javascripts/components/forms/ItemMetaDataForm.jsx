//app/assets/javascripts/components/forms/ItemMetaDataForm.jsx
var React = require('react');
var mediator = require("../../mediator");
var ItemMetaDataForm = React.createClass({
  mixins: [APIResponseMixin],
  propTypes: {
    authenticityToken: React.PropTypes.string.isRequired,
    method: React.PropTypes.string.isRequired,
    data: React.PropTypes.object.isRequired,
    url: React.PropTypes.string.isRequired,
    objectType: React.PropTypes.string,
  },

  getDefaultProps: function() {
    return {
      method: "post",
      objectType: "item",
      additionalFieldConfiguration: {
        "creator": {"title": "Creator", "placeholder": 'Example "Leonardo da Vinci"', "type": "string"},
        "alternate_name": {"title": "Alternate Name", "placeholder": "An additional name this work is known as.", "type": "string"},
        "rights": {"title": "Rights", "placeholder": 'Example "Copyright held by Hesburgh Libraries"', "type": "string"},
        "publisher": {"title": "Publisher", "placeholder": 'Example "Ballantine Books"', "type": "string"},
        "original_language": {"title": "Original Language", "placeholder": 'Example: "French"', "type": "string"},
        "date_published": {"title": "Date Published", "placeholder": '', "type": "date"},
        "date_modified": {"title": "Date Modified", "placeholder": '', "type": "date"},
      }
    };
  },

  getInitialState: function() {
    return {
      formValues: this.props.data,
      formState: "new",
      dataState: "clean",
      formErrors: false,
      responseCode: 0,
      displayedFields: _.mapObject(this.props.data, function(val, key) {
        if (val) {
          return true;
        }
        return false;
      }),
    };
  },

  componentDidMount: function() {
    window.addEventListener("beforeunload", this.unloadMsg);
  },

  componentWillUnmount: function() {
    window.removeEventListener("beforeunload", this.unloadMsg);
  },

  handleSave: function(event) {
    event.preventDefault();
    if (this.formDisabled()) {
      return;
    }
    this.setSavedStarted();

    $.ajax({
      url: this.props.url,
      dataType: "json",
      type: "POST",
      data: this.postParams(),
      success: (function(data) {
        this.setSavedSuccess();
      }).bind(this),
      error: (function(xhr, status, err) {
        if (xhr.status == "422") {
          this.setSavedFailure(xhr.responseJSON.errors);
        } else {
          this.setServerError(this.apiErrorToString(xhr));
        }
      }).bind(this),
    });
  },

  handleFieldChange: function(field, value) {
    this.state.formValues[field] = value;
    this.setState({
      formValues: this.state.formValues
    })
    this.setDirty();
  },

  postParams: function () {
    return ({
      utf8: "✓",
      _method: this.props.method,
      authenticity_token: this.props.authenticityToken,
      item: this.state.formValues
    });
  },

  setSavedFailure: function (errors) {
    mediator.send("MessageCenterDisplay", ["warning", "Please complete the highlighted fields in order to continue."]);
    this.setState({
      formState: "invalid",
      formErrors: errors,
    })
  },

  setDirty: function () {
    this.setState({
      dataState: "dirty",
    });
  },

  setSavedStarted: function () {
    this.setState({
      formState: "saveStarted",
    });
  },

  setSavedSuccess: function () {
    mediator.send("MessageCenterDisplay", ["success", "Item saved successfully."]);
    this.setState({
      dataState: "clean",
      formState: "saved",
      formErrors: false,
    });
  },

  setServerError: function (errorString) {
    mediator.send("MessageCenterDisplay", ["error", errorString]);
    this.setState({
      formState: "error",
      formErrors: errorString,
    });
  },

  formDisabled: function () {
    return (this.state.dataState == "clean" || this.state.formState == "saveStarted");
  },

  unloadMsg: function (event) {
    if (this.state.dataState == "dirty") {
      var confirmationMessage = "Caution - proceeding will cause you to lose any changes that are not yet saved. ";

      (event || window.event).returnValue = confirmationMessage;
      return confirmationMessage;
    }
  },

  fieldError: function (field) {
    if (this.state.formErrors[field]) {
      return this.state.formErrors[field];
    }
    return []
  },

  additionalFields: function() {
    var map_function = function(fieldConfig, field) {
      if (this.state.displayedFields[field]){
        if (fieldConfig['type'] == 'string') {
          return (<StringField key={field} objectType={this.props.objectType} name={field} title={fieldConfig["title"]} value={this.state.formValues[field]} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError(field)} placeholder={fieldConfig["placeholder"]} />);
        } else if (fieldConfig['type'] == 'date') {
          return (<DateField key={field} objectType={this.props.objectType} name={field} title={fieldConfig["title"]} value={this.state.formValues[field]} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError(field)} placeholder={fieldConfig["placeholder"]} />);
        } else if (fieldConfig['type'] == 'html') {
          return (<HtmlField key={field} objectType={this.props.objectType} name={field} title={fieldConfig["title"]} value={this.state.formValues[field]} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError(field)} placeholder={fieldConfig["placeholder"]} />);
        } else if (fieldConfig['type'] == 'text') {
          return (<TextField key={field} objectType={this.props.objectType} name={field} title={fieldConfig["title"]} value={this.state.formValues[field]} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError(field)} placeholder={fieldConfig["placeholder"]} />);  
        }
      }
      return "";
    };
    map_function = _.bind(map_function, this);

    return _.map(this.props.additionalFieldConfiguration, map_function);;
  },


  addFieldsSelectOptions: function () {
    var map_function = function (data, field) {
      if (!this.state.displayedFields[field]) {
        return (<option key={field} value={field}>{this.props.additionalFieldConfiguration[field]["title"]}</option>);
      }
      return;
    };
    map_function = _.bind(map_function, this);

    return [<option key="add-option">Add a New Field</option>].concat(_.map(this.props.additionalFieldConfiguration, map_function));
  },

  changeAddField: function(event) {
    if (!event.target.value) {
      return
    }

    this.state.displayedFields[event.target.value] = true;
    this.setState({
      displayedFields: this.state.displayedFields,
    });
  },

  render: function () {
    return (
      <Form id="meta_data_form" url={this.props.url} authenticityToken={this.props.authenticityToken} method={this.props.method} >
        <Panel>
          <PanelHeading>{this.state.formValues['name']} Meta Data</PanelHeading>
          <PanelBody>
              <StringField objectType={this.props.objectType} name="name" required={true} title="Name" value={this.state.formValues["name"]} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError('name')} />

              <HtmlField objectType={this.props.objectType} name="description" title="Description" value={this.state.formValues["description"]} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError('description')} placeholder="Example: &quot;Also known as 'La Giaconda' in Italian, this half-length portrait is one of the most famous paintings in the world. It is thought to depict Lisa Gherardini, the wife of Francesco del Giocondo.&quot;" />

              <DateField objectType={this.props.objectType} name="date_created" title="Date Created" value={this.state.formValues["date_created"]} handleFieldChange={this.handleFieldChange} placeholder="" errorMsg={this.fieldError('date_created')} />

              <HtmlField objectType={this.props.objectType} name="transcription" title="Transcription" value={this.state.formValues["transcription"]} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError('transcription')}  />

              <StringField objectType={this.props.objectType} name="manuscript_url" title="Digitized Manuscript URL" value={this.state.formValues["manuscript_url"]} handleFieldChange={this.handleFieldChange} placeholder="http://" help="Link to externally hosted manuscript viewer." errorMsg={this.fieldError('manuscript_url')}  />

              {this.additionalFields()}

              <select onChange={this.changeAddField}>
                {this.addFieldsSelectOptions()}
              </select>
          </PanelBody>
          <PanelFooter>
            <SubmitButton disabled={this.formDisabled()} handleClick={this.handleSave} />
          </PanelFooter>
        </Panel>
      </Form>
    );
  }
});

module.exports = ItemMetaDataForm;
