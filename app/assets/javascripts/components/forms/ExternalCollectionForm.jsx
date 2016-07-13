//app/assets/javascripts/components/forms/ExternalCollectionForm.jsx
var React = require('react');
var EventEmitter = require('../../EventEmitter');
var StringField = require('./StringField');
var HtmlField = require('./HtmlField');
var TextField = require('./TextField');
var UploadFileField = require('./UploadFileField');

var fieldTypeMap = {
  string: StringField,
  html: HtmlField,
  text: TextField,
  upload: UploadFileField,
};

var ExternalCollectionForm = React.createClass({
  mixins: [MuiThemeMixin, APIResponseMixin],
  propTypes: {
    authenticityToken: React.PropTypes.string.isRequired,
    method: React.PropTypes.string.isRequired,
    data: React.PropTypes.object.isRequired,
    url: React.PropTypes.string.isRequired,
    honeypotImage: React.PropTypes.string,
    objectType: React.PropTypes.string,
  },

  getDefaultProps: function() {
    return {
      method: "post",
    };
  },

  getInitialState: function() {
    return {
      formValues: this.props.data,
      formErrors: false,
    };
  },

  handleFieldChange: function(field, value) {
    this.state.formValues[field] = value;
    this.setState({
      formValues: this.state.formValues
    });
    this.setDirty();
  },

  fieldError: function (field) {
    if (this.state.formErrors[field]) {
      return this.state.formErrors[field];
    }
    return [];
  },

  thumbnailImage: function () {
      if (this.props.honeypotImage) {
        return (
          <div className="honeypot-image">
            <img src={this.props.honeypotImage} />
          </div>
        );
      } else {
        return;
      }
  },

  render: function () {
    return (
      <Form id="external_collection_form" url={this.props.url} authenticityToken={this.props.authenticityToken} method={this.props.method} >
        <StringField objectType={this.props.objectType} name="name_line_1" required={true} title="Name" value={this.state.formValues.name_line_1} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError('name_line_1')} />
        <StringField objectType={this.props.objectType} name="url" required={true} title="URL" value={this.state.formValues.url} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError('url')} />
        <HtmlField objectType={this.props.objectType} name="about" title="Description" value={this.state.formValues.about} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError('about')} placeholder="Example: This is an collection external to the honeycomb system" />
        {this.thumbnailImage()}
        <UploadFileField objectType={this.props.objectType} name="uploaded_image" title="Image" handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError('image')} />
        <SubmitButton disabled={false} />
      </Form>
    );
  }
});

module.exports = ExternalCollectionForm;
