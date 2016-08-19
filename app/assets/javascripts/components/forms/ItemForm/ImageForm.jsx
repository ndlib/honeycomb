var React = require('react');
var mui = require("material-ui");
var RaisedButton = mui.RaisedButton;

var ItemActions = require("../../../actions/ItemActions");

var ImageForm = React.createClass({
  mixins: [MuiThemeMixin, DialogMixin],

  propTypes: {
    item: React.PropTypes.object.isRequired,
    hasFiles: React.PropTypes.func
  },

  getDefaultProps: function() {
    return {
      modalId: "replace-image",
      paramName: "item[uploaded_image]",
    };
  },

  completeCallback: function() {
    ItemActions.get(this.props.item.id);
  },

  startedCallback: function () {
    if (this.props.hasFiles) {
      this.props.hasFiles();
    }
  },

  render: function() {
    return (
      <div>
        <DropzoneForm
          authenticityToken={this.props.authenticityToken}
          baseID={this.props.modalId}
          completeCallback={ this.completeCallback }
          startedCallback={ this.startedCallback }
          formUrl={ ItemActions.url(this.props.item.id) }
          method={ "put" }
          multifileUpload={ true }
          paramName={ this.props.paramName }
        />
    </div>
    );
  }
});
module.exports = ImageForm;
