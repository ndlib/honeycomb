var React = require("react");
var mui = require("material-ui");

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
    page: React.PropTypes.object.isRequired,
    previewUrl: React.PropTypes.string.isRequired,
    authenticityToken: React.PropTypes.string.isRequired,
    objectType: React.PropTypes.string,
  },

  getInitialState: function() {
    return {
      formValues: this.props.page,
      formErrors: false,
    };
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
    console.log(this.props.page)
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

        <form className="simple_form" noValidate="novalidate" id="edit_page" encType="multipart/form-data" acceptCharset="UTF-8" method="post">
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

          <div data-react-class="Thumbnail"><p>image goes here</p></div>

          <div className="form-group file optional page_uploaded_image">
            <label className="file optional control-label" htmlFor="page_uploaded_image" >Uploaded image
            </label>
            <input className="file optional form-control" type="file" name="" id="page_uploaded_image" />
          </div>
          <input type="submit" name="commit" value="Save" className="btn btn-default btn btn-primary" />
      </form>
      </div>
    );
  }
});

module.exports = PageForm;
