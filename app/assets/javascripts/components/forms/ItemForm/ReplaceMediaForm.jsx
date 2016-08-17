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

  render: function() {
    switch (this.type())
    {
      case "ImageObject":
        return (
          <ImageForm
            item={ this.props.item }
            authenticityToken={ this.props.authenticityToken }
            formUrl={ ItemActions.url(this.props.item.id) }
            method="put"
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
