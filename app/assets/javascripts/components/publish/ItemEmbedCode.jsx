var React = require('react');

var TextareaStyle = {
  width: "100%",
};

var ItemEmbedCode = React.createClass({
  propTypes: {
    id: React.PropTypes.string.isRequired,
    embedBaseUrl: React.PropTypes.string.isRequired,
  },

  render: function () {
    var width = "100%";
    var height = 800;
    var embedUrl = this.props.embedBaseUrl + "/search?q=&view=list&item=" + this.props.id + "&compact=true";
    var embedString = '<iframe src="' + embedUrl + '" width="' + width + '" height="' + height + '" seamless="seamless" style="overflow: hidden;" scrolling="no">Your browser or security settings does not allow iFrames.</iframe>';
    return (
      <div>
        <p>Copy and Paste this code into any site you want this item to be viewable.</p>
        <textarea readOnly={true} value={embedString} style={ TextareaStyle } rows="5" />
      </div>
    );
  }
});

module.exports = ItemEmbedCode;
