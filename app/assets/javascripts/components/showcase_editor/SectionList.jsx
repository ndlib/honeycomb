var React = require('react');
var SectionList = React.createClass({
  propTypes: {
    sections: React.PropTypes.array.isRequired,
    onSectionClick: React.PropTypes.func.isRequired,
    currentDragItem: React.PropTypes.object,
    onDrop: React.PropTypes.func.isRequired
  },
  sectionRows: function() {
    var rows, self;
    rows = [];
    self = this
    if (this.props.sections.length > 0) {
      rows.push(this.dropzone_tag(0));
      $.each(this.props.sections, function(idx, section) {
        rows.push(self.section_tag(section));
        rows.push(self.dropzone_tag(idx + 1))
      });
    } else {
      rows.push(this.dropzone_tag(0, true));
    }

    return rows;
  },
  style: function() {
    return {
      height: '100%',
      display: 'inline-block',
      paddingRight: '175px',
    }
  },
  section_tag: function(section) {
    var key = section.id + '-' + section.order
    return (<Section  onDragStart={this.props.onDragStart} onDragStop={this.props.onDragStop} section={section} key={key} onSectionClick={this.props.onSectionClick} />)
  },
  dropzone_tag: function(order, expanded) {
    if (!expanded) {
      expanded = false;
    }
    var  key = "spacer-" + order;
    return (<NewSectionDropzone key={key} currentDragItem={this.props.currentDragItem} onDrop={this.props.onDrop} new_index={order} expanded={expanded} />);
  },
  render: function() {
    return (<div id="sections-content-inner" className="sections-content-inner" style={this.style()}>{this.sectionRows()}</div>);
  }
});
module.exports = SectionList;
