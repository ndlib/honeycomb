var React = require('react');
var ShowcaseEditorTitle = React.createClass({
  propTypes: {
    showcase: React.PropTypes.object.isRequired,
  },

  getInitialState: function() {
    return {
      hover: false,
    };
  },

  onMouseEnter: function() {
    return this.setState({
      hover: true
    });
  },

  onMouseLeave: function() {
    return this.setState({
      hover: false
    });
  },

  style: function() {
    return {
      border: '1px solid lightgrey',
      display: 'inline-block',
      verticalAlign: 'top',
      position: 'relative',
      height: '100%',
      marginRight: '10px',
      width: '300px',

    };
  },
  imageStyle: function() {
    return {
      height: '100',
    };
  },
  titleStyle: function() {
    return {
      display: 'block',
      top: 50,
      left: 10,
      color: 'black',
      whiteSpace: 'normal',
    }
  },
  descriptionStyle: function() {
    return {
      display: 'block',
      top: 100,
      left: 10,
      color: 'black',
    }
  },
  editTitle: function() {
    window.location = this.props.showcase.editUrl;
  },

  image: function() {
    if(this.props.showcase.image && this.props.showcase.image.status == "ready") {
      return (
        <div>
          <h4>Background Image</h4>
          <img src={ this.props.showcase.image["thumbnail/small"]["contentUrl"] } style={ this.imageStyle() } />
        </div>
      );
    } else {
      return null;
    }
  },

  render: function() {
    var description;
    if (this.props.showcase.description) {
      var splitDescription = this.props.showcase.description.split(/[\n]+/);
      description = splitDescription.map(function(value, index) {
        return (
          <p key={index}>{value}</p>
        );
      });
    }
    return (
      <div className="showcase-title-page" style={this.style()} onMouseEnter={this.onMouseEnter} onMouseLeave={this.onMouseLeave}>
        <h2 style={this.titleStyle()}>{this.props.showcase.name_line_1} <small>{this.props.showcase.name_line_2}</small></h2>
        { this.image() }
        <EditLink clickHandler={this.editTitle} visible={this.state.hover} />
      </div>
    );
  }
});
module.exports = ShowcaseEditorTitle;
