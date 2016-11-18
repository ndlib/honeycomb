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
    var data = this.props.section.data;
    if(data) {
      type = data.json_response["@type"];
      if(data.thumbnail_url) {
        imgUrl = data.thumbnail_url;
      } else if(type == "ImageObject") {
        imgUrl = data.json_response.contentUrl;
      }
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
