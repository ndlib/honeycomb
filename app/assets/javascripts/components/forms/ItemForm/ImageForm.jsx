var React = require('react');
var mui = require("material-ui");
var RaisedButton = mui.RaisedButton;

var ItemActions = require("../../../actions/ItemActions");

var ImageForm = React.createClass({
  mixins: [MuiThemeMixin, DialogMixin],

  propTypes: {
    item: React.PropTypes.object.isRequired,
    authenticityToken: React.PropTypes.string.isRequired,
    primary: React.PropTypes.bool,
  },

  getDefaultProps: function() {
    return {
      modalId: "add-items",
    };
  },

  dropzoneInitialized: function(dropzone) {
    this.dropzone = dropzone;
    this.dropzone.on('addedfile', this.checkfileCallback);
    this.dropzone.on('removedfile', this.checkfileCallback);
  },

  completeCallback: function() {
    if (this.dropzone.files.length > 0) {
      ItemActions.get(this.props.item.id);
    }
  },

  checkfileCallback: function () {
    var hasFiles = (this.dropzone.files.length > 0);
    this.setState( { hasFiles: hasFiles } );
  },

  render: function() {
    return (
      <div>
        <DropzoneForm
          authenticityToken={this.props.authenticityToken}
          baseID={this.props.modalId}
          completeCallback={this.completeCallback}
          formUrl={ ItemActions.url(this.props.item.id) }
          initializeCallback={this.dropzoneInitialized}
          method="put"
          multifileUpload={ true }
          paramName="item[uploaded_image]"
        />
    </div>
    );
  }
});
module.exports = ImageForm;
