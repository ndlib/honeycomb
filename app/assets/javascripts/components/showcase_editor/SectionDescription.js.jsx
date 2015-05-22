/** @jsx React.DOM */

//= require showdown
var converter = new Showdown.converter()

var SectionDescription = React.createClass({
  propTypes: {
    section: React.PropTypes.object.isRequired
  },
  style: function() {
    return {
      display: 'inline-block',
      padding: '5px',
      width: '300px',
      overflow: 'hidden',
      height: '100%',
      whiteSpace: 'normal',
    };
  },

  render: function () {
    var rawMarkup;
    if (this.props.section.description) {
      rawMarkup = this.props.section.description.toString();
    }

    if (rawMarkup || this.props.section.image == null) {
      return (
        <div className="section-container section-container-text" style={this.style()}>
          <h2>{this.props.section.name}</h2>
          <div className="section-description" dangerouslySetInnerHTML={{__html: rawMarkup}}  />
        </div>
      );
    } else {
      return (
      <div />
      )
    }
  }
});

