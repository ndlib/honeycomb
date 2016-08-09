var React = require('react');
var mui = require("material-ui");
var RaisedButton = mui.RaisedButton;
var StreamingForm = require("./StreamingForm");

var ItemActions = require("../../../actions/ItemActions");

var ReplaceMedia = React.createClass({
  mixins: [MuiThemeMixin, DialogMixin],

  propTypes: {
    item: React.PropTypes.object.isRequired,
    authenticityToken: React.PropTypes.string.isRequired,
  },

  render: function() {
    if (!this.props.item.image) {
      return (
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
      );
    } else {
      return (
        <StreamingForm item={ this.props.item } />
      );
    }
  }
});
module.exports = ReplaceMedia;
