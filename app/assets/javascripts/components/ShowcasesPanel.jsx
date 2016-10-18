var React = require('react');
var mui = require("material-ui");

var ItemActions = require("../actions/ItemActions");
var ItemActionTypes = require("../constants/ItemActionTypes");
var ItemStore = require("../stores/ItemStore");

var Avatar = mui.Avatar;

var ShowcasesPanel = React.createClass({
  mixins: [TitleConcatMixin, MuiThemeMixin],
  propTypes: {
    id: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      showcases: [],
    };
  },

  componentDidMount: function() {
    if (!ItemStore.getShowcases(this.props.id)) {
      ItemStore.on("ItemShowcaseLoadFinished", this.setShowcases);
      ItemActions.itemShowcases(this.props.id);
    } else {
      this.setShowcases();
    }
  },

  setShowcases: function() {
    this.setState({ showcases: ItemStore.getShowcases(this.props.id) });
  },

  showcaseImageDiv: function (showcase) {
    if(showcase.image && showcase.image.status == "ready") {
      return (
        <div className="image">
          <Avatar src={ showcase.image["thumbnail/small"]["contentUrl"] } />
        </div>
      )
    } else {
      return (
        <div className="image" >
          <Avatar>{ showcase.name_line_1[0].toUpperCase() }</Avatar>
        </div>
      )
    }
  },

  showcaseNameDiv: function (showcase) {
    return (
      <div className="name">
        { this.titleConcat(showcase.name_line_1, showcase.name_line_2) }
      </div>
    )
  },

  showcaseNodes: function () {
    if(this.state.showcases.length <= 0)
      return <p>This item is not in any showcases.</p>;

    return this.state.showcases.map(function(showcase, index) {
      key = "showcase-" + showcase.id;
      reg = new RegExp( '^(.*/)v1/(.*)$', 'i' );
      strings = reg.exec(showcase["@id"]);

      url = strings[0];
      if(strings && strings.length == 3) {
        url = strings[1] + strings[2];
      }

      return (
        <div key={key} className="row">
          <a href={url}>
            { this.showcaseImageDiv(showcase) }
            { this.showcaseNameDiv(showcase) }
          </a>
        </div>
      )
    }.bind(this));
  },

  embedPanel: function () {

    return (
      <Panel>
        <PanelHeading>Showcases</PanelHeading>
        <PanelBody>
          <div className="info-panel">
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
