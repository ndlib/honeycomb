var React = require("react");
var mui = require("material-ui");

var RaisedButton = mui.RaisedButton;
var Toolbar = mui.Toolbar;
var ToolbarGroup = mui.ToolbarGroup;

var ToolbarStyle = {
  width: "100%",
};

var PageForm = React.createClass({
  propTypes: {
    id: React.PropTypes.string.isRequired,
    data: React.PropTypes.object.isRequired
    },

  render: function() {
    return (
      <div>
        <Toolbar style={ ToolbarStyle }>
          <ToolbarGroup key={0}>
            <RaisedButton href={ this.props.previewUrl } linkButton={ true } target="_blank" label="Preview" />
          </ToolbarGroup>
        </Toolbar>

        <form className="simple_form form-horizontal" noValidate="novalidate" id="edit_page" encType="multipart/form-data" action={ this.props.page } acceptCharset="UTF-8" method="post">
          <input name="utf8" type="hidden" value="✓" />
          <input type="hidden" name="_method" value="patch" />
          <input type="hidden" name="authenticity_token" value="n85SARd07FkhEzRZIvWDxQyW4ISPiDV4Ils5QkQPShHZySU4xVmb9uKrEjS9CHf58oqme38BmXdHNjlQ4v4zNQ==" />
          <div className="form-group string required page_name">
            <label className="string required control-label" htmlFor={ this.props.pageName }>
              <abbr title="required">*</abbr> Name
            </label>
            <input className="string required form-control" type="text" value={ this.props.pageName } id="page_name" />
          </div>

          <div className="form-group file optional page_uploaded_image">
            <label className="file optional control-label" htmlFor={ this.props.updloadedImage } >Uploaded image
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
