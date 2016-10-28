var React = require("react");
var mui = require("material-ui");
var Colors = require("material-ui/lib/styles/colors");


var ListItem = mui.ListItem;
var FontIcon = mui.FontIcon;
var IconButton = mui.IconButton;

var MetaDataConfigurationListItem = React.createClass({
  propTypes: {
    id: React.PropTypes.number.isRequired,
    field: React.PropTypes.object.isRequired,
    index: React.PropTypes.number,
    handleEditClick: React.PropTypes.func.isRequired,
    handleRightClick: React.PropTypes.func.isRequired,
  },


  getLeftIcon: function(type) {
    switch(type){
      case 'string':
        return (<FontIcon className="material-icons">short_text</FontIcon>);
      case 'html':
        return (<FontIcon className="material-icons">format_size</FontIcon>);
      case 'date':
        return (<FontIcon className="material-icons">date_range</FontIcon>);
      default:
        return null;
    }
  },

  getRightIcon: function(field) {
    if(_.contains(field.immutable, "active")) {
      return null;
    }

    if(field.active) {
      var icon = "delete";
      return (
        <IconButton
          tooltip="Remove"
          tooltipPosition="top-center"
          onTouchTap={function() { this.props.handleRightClick(field.name) }.bind(this) }
        >
          <FontIcon className="material-icons" color={Colors.grey500} hoverColor={Colors.red500}>{icon}</FontIcon>
        </IconButton>
      );
    } else {
      return (
        <IconButton
          tooltip="Restore"
          tooltipPosition="top-center"
          onTouchTap={function() { this.props.handleRightClick(field.name) }.bind(this) }
        >
          <FontIcon className="material-icons" color={Colors.grey500} hoverColor={Colors.green500}>undo</FontIcon>
        </IconButton>
      );
    }
  },

  listItemStyle: function() {
    return {
      borderBottomStyle: "solid",
      borderBottomWidth: "1px",
      borderBottomColor: Colors.grey500
    };
  },

  render: function() {
    var { connectDragSource, connectDragPreview, isDragging } = this.props;
    return (
      <ListItem
        key={ this.props.field.name }
        primaryText={ this.props.field.label }
        secondaryText={ this.props.field.required && "Required" }
        leftIcon={ this.getLeftIcon(this.props.field.type) }
        rightIconButton={ this.getRightIcon(this.props.field) }
        onTouchTap={ function() { this.props.handleEditClick(this.props.field.name) }.bind(this) }
        style={ this.listItemStyle() }
      />
    );
  },
});

module.exports = MetaDataConfigurationListItem;
