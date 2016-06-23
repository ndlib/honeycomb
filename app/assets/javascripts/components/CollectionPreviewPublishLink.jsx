var React = require("react");
var CollectionStore = require('stores/Collection');

var CollectionPreviewPublishLink = React.createClass({
  propTypes: {
    previewLinkURL: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      copyMessage: null,
    };
  },

  copyToClipBoard() {
    this.refs.copyUrl.select();
    try {
        document.execCommand('copy');
        this.setState({ copyMessage: true});
      }
    catch (err) {
      this.setState({ copyMessage: false});
    }
  },


  render() {

    var copyMessage = '';
    if(this.state.copyMessage !== null) {
      if(this.state.copyMessage) {
        copyMessage = (<div><i>The URL has been copied to your clipboard.</i></div>);
      }
      else {
        copyMessage = (<div><i>Please press Ctrl/Cmd+C to copy.</i></div>);
      }
    }

    return (
      <div>
        <p>
          <a href={this.props.previewLinkURL} target="_blank">
            <i className="glyphicon mdi-av-web"></i>
            <span> Preview Site</span>
          </a>
        </p>
        <br />
        <h5>Copy URL:</h5>
        <div>
          <input
            ref={ 'copyUrl' }
            type="text"
            readOnly={ true }
            name="copyUrl"
            value={ this.props.previewLinkURL }
            onClick= { this.copyToClipBoard }
            style={{
              maxWidth: '60%',
              minWidth: '130px',
              verticalAlign: 'top',
            }}
          /> <i
            className="material-icons"
            onClick={ this.copyToClipBoard }
            style={{
              backgroundColor: '#224048',
              color: 'white',
              cursor: 'pointer',
              fontSize: '16px',
              height: '26px',
              padding: '5px',
              width: '26px',
            }}
          >content_copy</i>
        </div>
        <br/>
        { copyMessage }
      </div>
    );
  }

});
module.exports = CollectionPreviewPublishLink;
