/** @jsx React.DOM */
var React = require('react');
var ShowcasesPanel = React.createClass({
  mixins: [TitleConcatMixin],
  propTypes: {
    showcases: React.PropTypes.array.isRequired,
    panelTitle: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      showcases: [],
    };
  },

  imageStyle: function() {
    return {
      height: '100',
    };
  },

  showcaseNodes: function () {
    if(this.props.showcases.length <= 0)
      return <p>This item is not in any showcases.</p>;

    return this.props.showcases.map(function(showcase, index) {
      key = "showcase-" + showcase.id;
      return (
        <div key={key} className="row">
          <a href={showcase["@id"]}>
            <div className="image">
              <HoneypotImage honeypot_image={showcase.image} style="small" />
            </div>
            <div className="name">
              {this.titleConcat(showcase.name_line_1, showcase.name_line_2)}
            </div>
          </a>
        </div>
      )
    }.bind(this));
  },

  embedPanel: function () {

    return (
      <Panel>
        <PanelHeading>{this.props.panelTitle}</PanelHeading>
        <PanelBody>
          <div className="showcases-panel">
          {this.showcaseNodes()}
          </div>
        </PanelBody>
      </Panel>
    )
  },

  render: function () {
    return (
      <div>
        {this.embedPanel()}
      </div>
    )
  }

});
module.exports = ShowcasesPanel;
