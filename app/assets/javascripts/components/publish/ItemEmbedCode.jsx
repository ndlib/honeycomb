var React = require('react');
var mui = require("material-ui");

var FlatButton = mui.FlatButton
var FontIcon = mui.FontIcon

var TextareaStyle = {
  width: "100%",
};

var ItemEmbedCode = React.createClass({
  propTypes: {
    id: React.PropTypes.string.isRequired,
    embedBaseUrl: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      copyMessage: null,
    };
  },

  copyToClipBoard() {
    this.refs.copyEmbed.select();
    try {
        document.execCommand('copy');
        this.setState({ copyMessage: true});
      }
    catch (err) {
      this.setState({ copyMessage: false});
    }
  },

  render: function () {
    var width = "100%";
    var height = 800;
    var embedUrl = this.props.embedBaseUrl + "/search?q=&view=list&item=" + this.props.id + "&compact=true";
    var embedString = '<iframe src="' + embedUrl + '" width="' + width + '" height="' + height + '" seamless="seamless" style="overflow: hidden;" scrolling="no">Your browser or security settings does not allow iFrames.</iframe>';

    var copyMessage = '';
    if(this.state.copyMessage !== null) {
      if(this.state.copyMessage) {
        copyMessage = (<div><i>The embed code has been copied to your clipboard.</i></div>);
      }
      else {
        copyMessage = (<div><i>Please press Ctrl/Cmd+C to copy.</i></div>);
      }
    }

    return (
      <div>
        <p>Copy and Paste this code into any site you want this item to be viewable.</p>
        <textarea
          ref={ "copyEmbed" }
          onClick= { this.copyToClipBoard }
          readOnly={true}
          value={embedString}
          style={ TextareaStyle }
          rows="5" />
        <FlatButton
          onClick={ this.copyToClipBoard }
          label="Copy To Clipboard"
          icon={ <FontIcon className="material-icons">content_copy</FontIcon> }
        />
        <p>{ copyMessage }</p>
      </div>
    );
  }
});

module.exports = ItemEmbedCode;
