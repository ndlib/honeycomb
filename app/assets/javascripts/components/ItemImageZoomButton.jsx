var React = require('react');
var mui = require("material-ui");
var Dialog = mui.Dialog;
var RaisedButton = mui.RaisedButton;
var FlatButton = mui.FlatButton;
var FontIcon = mui.FontIcon;
var dismissDialog = require("./utils/dismissDialog");

var ItemImageZoomButton = React.createClass({
  mixins: [MuiThemeMixin],

  propTypes: {
    image: React.PropTypes.object.isRequired,
    itemID: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      image: null,
      zoomClicked: null,
    };
  },

  handleClick: function() {
    this.setState({
      zoomClicked: Date.now()
    });
  },

  showModal: function() {
    this.refs.imageZoom.show();
  },

  dismissMessage: function() {
    this.refs.imageZoom.dismiss();
  },

  render: function() {
    var zoomID = '#hcItemZoom' + this.props.itemID;
    var fullPage = !!this.state.zoomClicked;
    var buttonStyle = { height: "30px", minWidth: "30px" };
    var buttonLabel = ( <FontIcon className="mdi-action-search" label="Zoom" /> );

    if (this.props.image && this.props.image.contentUrl) {
      return (
        <div>
          <div className="hc-image-zoom-button-outer">
            <FlatButton
              onTouchTap={this.showModal}
              label={ buttonLabel }
              style={ buttonStyle }
            />
          </div>
          <Dialog
            key="dialog-box"
            ref="imageZoom"
            actions={this.props.dismiss_func(this.dismissMessage)}
            openImmediately={false}
            style={{zIndex: 100}}
          >
            <OpenSeadragonViewer key="viewer" image={this.props.image} containerID={zoomID} height={600} />
          </Dialog>
        </div>
      );
    } else {
      return (<div />);
    }
  }
});

module.exports = dismissDialog(ItemImageZoomButton);
