var React = require('react');
var mui = require("material-ui");
var RaisedButton = mui.RaisedButton;
var StreamingForm = require("./StreamingForm");
var ImageForm = require("./StreamingForm");

var ItemActions = require("../../../actions/ItemActions");

var ReplaceMedia = React.createClass({
  mixins: [MuiThemeMixin, DialogMixin],

  propTypes: {
    item: React.PropTypes.object.isRequired,
    authenticityToken: React.PropTypes.string.isRequired,
  },

  render: function() {
    if (this.props.item.image) {
      return (
        <ImageForm
          item={ this.props.item }
          authenticityToken={this.props.authenticityToken}
          formUrl={ ItemActions.url(this.props.item.id) }
          method="put"
        />
      );
    } else {
      return (
        <StreamingForm
          item={ this.props.item } />
      );
    }
  }
});
module.exports = ReplaceMedia;
