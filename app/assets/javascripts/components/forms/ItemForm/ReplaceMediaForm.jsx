var React = require('react');
var mui = require("material-ui");
var RaisedButton = mui.RaisedButton;
var StreamingForm = require("./StreamingForm");
var ImageForm = require("./ImageForm");

var ItemActions = require("../../../actions/ItemActions");

var ReplaceMedia = React.createClass({
  mixins: [MuiThemeMixin, DialogMixin],

  propTypes: {
    item: React.PropTypes.object.isRequired,
    authenticityToken: React.PropTypes.string.isRequired,
  },

  type: function() {
    if (!this.props.item.media) {
      return "NoMediaObject";
    }
    return this.props.item.media["@type"];
  },

  uploadComplete: function() {
    ItemActions.get(this.props.item.id);
  },

  render: function() {
    switch (this.type())
    {
      case "ImageObject":
        return (
          <DropzoneForm
            authenticityToken={this.props.authenticityToken}
            baseID="replace-image"
            completeCallback={ this.uploadComplete }
            formUrl={ ItemActions.url(this.props.item.id) }
            method={ "put" }
            multifileUpload={ true }
            paramName="item[uploaded_image]"
          />
        );
      case "VideoObject":
        return (
          <StreamingForm
            item={ this.props.item }
            type="video"
          />
        );
      case "AudioObject":
        return (
          <StreamingForm
            item={ this.props.item }
            type="audio"
          />
        );
    }
  }
});
module.exports = ReplaceMedia;
