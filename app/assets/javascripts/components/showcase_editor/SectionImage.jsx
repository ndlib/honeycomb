var React = require('react');

var SectionImage = React.createClass({
  propTypes: {
    section: React.PropTypes.object.isRequired
  },

  style: function() {
    return {
      height: '100%',
      display: 'inline-block',
      verticalAlign: 'top',
      position: 'relative',
    };
  },

  captionStyle: function() {
    return {
      backgroundColor: 'white',
      position: 'absolute',
      bottom: '2em',
      right: '1em',
      padding: '0.5em',
    };
  },

  imageStyle: function() {
    return {
      height: '100%',
    };
  },

  render: function () {
    var caption = "";
    if (this.props.section.caption) {
      caption = (<div className="section-caption" style={this.captionStyle()} dangerouslySetInnerHTML={{__html: this.props.section.caption}}/>)
    }

    var imgUrl = null;
    var type = "";
    if(this.props.section.data && this.props.section.data.thumbnail_url) {
      imgUrl = this.props.section.data.thumbnail_url;
      type = this.props.section.data.json_response["@type"];
    } else if(this.props.section.image) {
      imgUrl = this.props.section.image;
    }

    if(imgUrl) {
      return (
        <div className="section-container section-container-image" style={this.style()}>
          <img src={ imgUrl } style={this.imageStyle()} />
          <MediaImageOverlay mediaType={type} />
          { caption }
        </div>
      );
    }
    else {
      return null;
    }
  }

});
module.exports = SectionImage;
