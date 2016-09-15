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
          <div>
            <h4>Change Associated Media</h4>
            <StreamingForm
              item={ this.props.item }
              type="video"
              creating={ false }
              fileUploadCompleted={ this.uploadComplete }
            />
            <hr />
            <h4>Add Video Image</h4>
            <DropzoneForm
              authenticityToken={this.props.authenticityToken}
              baseID="replace-image"
              completeCallback={ this.uploadComplete }
              formUrl={ "/v1/media/" + this.props.item.media["@id"] }
              method={ "put" }
              multifileUpload={ true }
              paramName="media[uploaded_image]"
            />
          <p>With a video image the link to play this video will include this image rather than a generic video image</p>
          </div>
        );
      case "AudioObject":
        return (
          <div>
            <h4>Change Associated Media</h4>
            <StreamingForm
              item={ this.props.item }
              type="audio"
              fileUploadComplete={ this.uploadComplete }
            />
            <hr />
            <h4>Add Audio Image</h4>
            <DropzoneForm
              authenticityToken={this.props.authenticityToken}
              baseID="replace-image"
              completeCallback={ this.uploadComplete }
              formUrl={ "/v1/media/" + this.props.item.media["@id"] }
              method={ "put" }
              multifileUpload={ true }
              paramName="media[uploaded_image]"
            />
          <p>With an audio image the link to play this video will include this image rather than a generic video image</p>
          </div>
        );
    }
  }
});
module.exports = ReplaceMedia;
