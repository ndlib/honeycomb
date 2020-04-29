var React = require("react");
var mui = require("material-ui");

var ReactLink = require('react/lib/ReactLink');
var ReactStateSetters = require('react/lib/ReactStateSetters');
var update = require('react/lib/update');

var MetaDataConfigurationSortItem = require("./MetaDataConfigurationSortItem");
var MetadataConfigurationEventTypes = require("./MetaDataConfigurationEventTypes");
var MetaDataConfigurationActions = require("../../../actions/MetaDataConfigurationActions");
var MetaDataSortDialog = require("../MetaDataSortDialog");
var AvailableDropTarget = StylableDropTarget(MetadataConfigurationEventTypes.SortDnD);

var Colors = require("material-ui/lib/styles/colors");
var MoreVertIcons = require("material-ui/lib/svg-icons/navigation/more-vert");
var FloatingActionButton = require("material-ui/lib/floating-action-button");
var ContentAdd = require("material-ui/lib/svg-icons/content/add");

var Paper = mui.Paper;
var List = mui.List;
var Toggle = mui.Toggle;
var Toolbar = mui.Toolbar;
var ToolbarGroup = mui.ToolbarGroup;
var ToolbarTitle = mui.ToolbarTitle;
var FontIcon = mui.FontIcon;

var listStyle = {
  paddingBottom: "0px",
}

var addButtonStyle = {
  position: "absolute",
  top: "-16px",
  left: "8px",
  zIndex: "1"
}

var MetaDataConfigurationSorts = React.createClass({
  propTypes: {
    baseUpdateUrl: React.PropTypes.string.isRequired,
  },

  getInitialState() {
    return {
      sorts: this.filteredSorts(false),
      selectedSort: undefined,
    }
  },

  componentDidMount() {
    EventEmitter.on(MetadataConfigurationEventTypes.SortDroppedOnTarget, this.handleDrop)
    MetaDataConfigurationStore.on("MetaDataConfigurationStoreChanged", this.setFormSortsFromConfiguration)
    MetaDataConfigurationStore.getAll()
  },

  setFormSortsFromConfiguration() {
    this.setState({
      sorts: this.filteredSorts(this.state.showInactive),
      selectedSort: undefined,
    })
  },

  filteredSorts(showInactive) {
    var sorts = _.filter(MetaDataConfigurationStore.sorts, function (sort) {
      return showInactive || sort.active;
    });
    return _.sortBy(sorts, 'order');
  },

  handleNewClick() {
    this.setState({ selectedSort: '' });
  },


  handleEditClick(sort, event) {
    // Ignore the click if it was on the drag icon
    if (!event.target.classList.contains('material-icons')) {
      this.setState({ selectedSort: sort.name || sort.field.name });
    }
  },

  handleRemove(sortName) {
    MetaDataConfigurationActions.removeSort(sortName, this.props.baseUpdateUrl);
  },

  handleClose() {
    this.setState({ selectedSort: undefined });
  },

  handleDrop(target, source) {
    var fromIndex = source.index;
    var toIndex = target.index;

    if (fromIndex === toIndex) {
      return;
    }
    var removeIndex = fromIndex;
    if (toIndex < fromIndex) {
      removeIndex++;
    }

    this.setState(update(this.state, {
      sorts: {
        $splice: [
          [toIndex, 0, source.sort],
          [removeIndex, 1],
        ]
      }
    }), this.pushChanges);
  },

  pushChanges() {
    var reorder = this.state.sorts.map(function(sort, index) {
      return { name: sort.name, order: index+1 }
    });
    MetaDataConfigurationActions.reorderSorts(reorder, this.props.baseUpdateUrl);
  },

  render() {
    return (
      <div>
        <FloatingActionButton onMouseDown={this.handleNewClick} onTouchStart={this.handleNewClick} mini={true} style={addButtonStyle}>
          <ContentAdd />
        </FloatingActionButton>
        <MetaDataSortDialog
          sortName={this.state.selectedSort}
          open={this.state.selectedSort != undefined}
          baseUpdateUrl={this.props.baseUpdateUrl}
          handleClose={this.handleClose}
        />
        <p style={{ textAlign: 'center', paddingTop: '15px', marginBottom: '0px' }}>
          Drag and drop sorts using
          <FontIcon className='material-icons' style={{ verticalAlign: 'bottom' }}>reorder</FontIcon>
          to reorder.
          Click item to edit.
        </p>
        <List style={listStyle}>
          <AvailableDropTarget
            className="metadata-configuration-target"
            dragClassName="metadata-configuration-target-ondrag"
            hoverClassName="metadata-configuration-target-onhover"
            data={{ index: 0 }}
          />
        {this.state.sorts.map(function(sort, index) {
          return (
            <div key={sort.name}>
              <MetaDataConfigurationSortItem
                sort={sort}
                handleEditClick={this.handleEditClick}
                handleRemoveClick={this.handleRemove}
                index={index}
              />
              <AvailableDropTarget
                className="metadata-configuration-target"
                dragClassName="metadata-configuration-target-ondrag"
                hoverClassName="metadata-configuration-target-onhover"
                data={{ index: index+1 }}
              />
            </div>
          )
        }.bind(this))}
        </List>
      </div>
    );
  },
})

module.exports = MetaDataConfigurationSorts;
