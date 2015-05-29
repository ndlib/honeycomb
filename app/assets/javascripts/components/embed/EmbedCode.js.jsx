/** @jsx React.DOM */

var EmbedCode = React.createClass({
  propTypes: {
    item: React.PropTypes.object.isRequired,
    embedBaseUrl: React.PropTypes.string.isRequired,
  },

  style: function() {
    return {
      width: "100%",
    };
  },

  render: function () {
    var width = 400;
    var height = 400;
    var embedUrl = this.props.embedBaseUrl + "/embed/items/" + this.props.item.unique_id;
    var embedString = '<iframe src="' + embedUrl + '" width="' + width + '" height="' + height + '" seamless="seamless" style="overflow: hidden;" scrolling="no">Your browser or security settings does not allow iFrames.</iframe>';
    return (
      <Panel>
        <PanelHeading>Embed This Item</PanelHeading>
        <PanelBody>
          <p>Copy and Paste this code into any site you want this item to be viewable.</p>
          <textarea value={embedString} style={this.style()} rows="5" />
        </PanelBody>
      </Panel>
    )
  }
});
