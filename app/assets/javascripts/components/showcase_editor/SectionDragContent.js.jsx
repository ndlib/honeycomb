/** @jsx React.DOM */

var SectionDragContent = React.createClass({
  propTypes: {
    section: React.PropTypes.object.isRequired,
    dragging: React.PropTypes.bool.isRequired,
    top: React.PropTypes.number.isRequired,
    left: React.PropTypes.number.isRequired,
  },

  imageStyle: function() {
    return {
      maxHeight: '100px',
      margin: '5px',
    };
  },

  textStyle: function() {
    return {
      margin: '5px',
      padding: '4px',
      maxWidth: '100px',
      maxHeight: '100px',
      fontSize: '4px',
      color: 'black',
      backgroundColor: 'white',
      overflow: 'hidden',
      whiteSpace: 'normal',
    };
  },

  textHeaderStyle: function() {
    return {
      fontSize: '10px',
      margin: 0,
      padding: 0,
    };
  },

  imageContent: function() {
    return (
      <img src={this.props.section.image} style={this.imageStyle()} />
    );
  },

  textContent: function() {
    var bodyText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages.";
    return (
      <div style={this.textStyle()}>
        <h4 style={this.textHeaderStyle()}>{this.props.section.name}</h4>
        <p>{bodyText}</p>
      </div>
    );
  },

  render: function() {
    var dragContent;
    if (this.props.section.image) {
      dragContent = this.imageContent();
    } else {
      dragContent = this.textContent();
    }
    return (
      <DragContent content={dragContent} dragging={this.props.dragging} left={this.props.left} top={this.props.top} />
    );
  }
});
