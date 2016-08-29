var React = require("react");
var mui = require("material-ui");

var PageActions = require("../../../actions/PageActions");
var PageStore = require("../../../stores/PageStore")
var LoadingImage = require("../../LoadingImage");
var RaisedButton = mui.RaisedButton;
var Toolbar = mui.Toolbar;
var ToolbarGroup = mui.ToolbarGroup;
var StringField = require('../StringField');
var HtmlField = require('../HtmlField');
var string = {string: StringField,}

var ToolbarStyle = {
  width: "100%",
};

var PageForm = React.createClass({
  propTypes: {
    id: React.PropTypes.string.isRequired,
    previewUrl: React.PropTypes.string.isRequired,
    authenticityToken: React.PropTypes.string.isRequired,
    objectType: React.PropTypes.string,
  },

  getInitialState: function() {
    return {
      formValues: undefined,
      formErrors: false,
    };
  },

  componentDidMount: function() {
    PageStore.on("PageLoadFinished", this.setPage);
    PageActions.get(this.props.id);
  },

  setPage: function() {
      var page = PageStore.get(this.props.id);
      this.setState({ formValues: page });
  },

  fieldError: function (field) {
    if (this.state.formErrors[field]) {
      return this.state.formErrors[field];
    }
    return [];
  },

  handleFieldChange: function(field, value) {
    this.state.formValues[field] = value;
    this.setState({
      formValues: this.state.formValues
    });
  },

  render: function() {
    if (!this.state.formValues) {
      return (<LoadingImage />);
    }
    
    return (
      <div>
        <Toolbar style={ ToolbarStyle }>
          <ToolbarGroup key={0}>
            <RaisedButton
              href={ this.props.previewUrl }
              linkButton={ true }
              target="_blank"
              label="Preview" />
          </ToolbarGroup>
        </Toolbar>
        <div className="row">
          <div className="col-md-9">
            <form
              className="simple_form"
              noValidate="novalidate"
              id="edit_page"
              encType="multipart/form-data"
              acceptCharset="UTF-8"
              method="post"
              action={ "/pages/" + this.props.id }>
              <input type="hidden" name="_method" value="patch" />
              <input name="utf8" type="hidden" value="✓" />
              <input type="hidden" name="authenticity_token" value={ this.props.authenticityToken} />

              <div>
                <StringField
                  objectType={this.props.objectType}
                  name={'name'}
                  required={true}
                  title="Name"
                  value={this.state.formValues.name}
                  handleFieldChange={this.handleFieldChange}
                  errorMsg={this.fieldError('name')}
                />
                <HtmlField
                  objectType={this.props.objectType}
                  name={'content'}
                  required={true}
                  title="Content"
                  value={this.state.formValues.content}
                  handleFieldChange={this.handleFieldChange}
                  imageLoader={true}
                  errorMsg={this.fieldError('content')}
                />
              </div>

              <input type="submit" name="commit" value="Save" className="btn btn-default btn btn-primary" />
          </form>
        </div>
        <div className="col-md-3">
          <Thumbnail media={this.state.formValues.image} />
        </div>
      </div>

      <DropzoneForm
        authenticityToken={this.props.authenticityToken}
        baseID="replace-image"
        formUrl={ "/v1/pages/" + this.props.id }
        method={ "put" }
        multifileUpload={ true }
        paramName="page[uploaded_image]"
      />
      </div>
    );
  }
});

module.exports = PageForm;
