//app/assets/javascripts/components/OpenseadragonViewer.jsx
var React = require('react');
var OpenseadragonViewer = React.createClass({
  propTypes: {
    image: React.PropTypes.object,
    containerID: React.PropTypes.string.isRequired,
    fullPage: React.PropTypes.bool,
    height: React.PropTypes.number,
  },

  getInitialState: function() {
    return {
      image: null,
      viewer: null,
    };
  },

  componentDidMount: function() {
    this.buildViewer(this.props.image);
  },

  shouldComponentUpdate: function(nextProps, nextState) {
    if (nextProps.fullPage) {
      this.fullPageOn();
    } else {
      this.fullPageOff();
    }
    return false;
  },

  fullPageOn: function() {
    if (this.state.viewer) {
      this.state.viewer.setFullPage(true);
      this.state.viewer.viewport.goHome();
      $(document).bind('keyup', this.state.escapeHandler);
    }
  },

  fullPageOff: function() {
    if (this.state.viewer) {
      this.state.viewer.setFullPage(false);
      $(document).unbind('keyup', this.state.escapeHandler);
    }
  },

  buildViewer: function(image) {
    var options;
    if (/^http:\/\/localhost/.test(image.contentUrl)) {
      options = this.legacyOptions(image);
    } else {
      options = this.dziOptions(image);
    }
    var viewer = OpenSeadragon(options);
    var escapeHandler = function(event) {
      if (event.keyCode === 27) {
        this.fullPageOff();
      }
      return true;
    }.bind(this)
    this.setState({
      image: image,
      viewer: viewer,
      escapeHandler: escapeHandler,
    })
  },

  baseOptions: function() {
    return {
      id: this.props.containerID,
      element: this.getDOMNode(),
      prefixUrl: "/openseadragon/",
      showNavigator: false,
      showRotationControl: true,
      immediateRender: true,
      visibilityRatio: 0.5,
      springStiffness: 9,
      gestureSettingsMouse: {
        flickEnabled: true,
        flickMomentum: 0.2
      },
      gestureSettingsTouch: {
        flickMomentum: 0.2
      }
    };
  },

  dziOptions: function(image) {
    var options;
    options = this.baseOptions();
    options.tileSources = image['thumbnail/dzi']['contentUrl'];
    return options;
  },

  legacyOptions: function(image) {
    var options;
    options = this.baseOptions();
    options.tileSources = {
      id: image.id,
      type: 'legacy-image-pyramid',
      levels: [
        {
          url: image.contentUrl,
          height: parseInt(image.height),
          width: parseInt(image.width)
        }
      ]
    };
    return options;
  },

  style: function() {
    return {
      height: "" + this.props.height + "px",
    };
  },

  render: function() {
    return (
      <div className="hc-openseadragon-viewer" id={this.props.containerID} style={this.style()}></div>
    );
  }
});

// each file will export exactly one component
module.exports = OpenseadragonViewer;
