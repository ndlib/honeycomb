var React = require('react');
var mui = require("material-ui");
var ItemActions = require("../../../actions/ItemActions");

var ReplaceMedia = React.createClass({
  mixins: [MuiThemeMixin, DialogMixin],

  propTypes: {
    item: React.PropTypes.string.isRequired,
    authenticityToken: React.PropTypes.string.isRequired,
    multifileUpload: React.PropTypes.bool,
    modalTitle: React.PropTypes.string.isRequired,
    doneText: React.PropTypes.string,
    cancelText: React.PropTypes.string,
    primary: React.PropTypes.bool,
  },

  getDefaultProps: function() {
    return {
      multifileUpload: true,
      closeText: 'Close',
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
module.exports = ReplaceMedia;
