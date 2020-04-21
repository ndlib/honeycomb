var React = require("react");
var mui = require("material-ui");

var ReactLink = require('react/lib/ReactLink');
var ReactStateSetters = require('react/lib/ReactStateSetters');
var update = require('react/lib/update');

var MetaDataConfigurationFacetItem = require("./MetaDataConfigurationFacetItem");
var MetadataConfigurationEventTypes = require("./MetaDataConfigurationEventTypes");
var MetaDataConfigurationActions = require("../../../actions/MetaDataConfigurationActions");
var MetaDataFacetDialog = require("../MetaDataFacetDialog");
var AvailableDropTarget = StylableDropTarget(MetadataConfigurationEventTypes.FacetDnD);

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

var MetaDataConfigurationFacets = React.createClass({
  propTypes: {
    baseUpdateUrl: React.PropTypes.string.isRequired,
  },

  getInitialState() {
    return {
      facets: this.filteredFacets(false),
      selectedFacet: undefined,
    }
  },

  componentDidMount() {
    EventEmitter.on(MetadataConfigurationEventTypes.FacetDroppedOnTarget, this.handleDrop)
    MetaDataConfigurationStore.on("MetaDataConfigurationStoreChanged", this.setFormFacetsFromConfiguration)
    MetaDataConfigurationStore.getAll()
  },

  setFormFacetsFromConfiguration() {
    this.setState({
      facets: this.filteredFacets(this.state.showInactive),
      selectedFacet: undefined,
    })
  },

  filteredFacets(showInactive) {
    var facets = _.filter(MetaDataConfigurationStore.facets, function (facet) {
      return showInactive || facet.active;
    });
    return _.sortBy(facets, 'order');
  },

  handleNewClick() {
    this.setState({ selectedFacet: '' });
  },


  handleEditClick(facet, event) {
    // Ignore the click if it was on the drag icon
    if (!event.target.classList.contains('material-icons')) {
      this.setState({ selectedFacet: facet.name || facet.field.name });
    }
  },

  handleRemove(facetName) {
    MetaDataConfigurationActions.removeFacet(facetName, this.props.baseUpdateUrl);
  },

  handleClose() {
    this.setState({ selectedFacet: undefined });
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
      facets: {
        $splice: [
          [toIndex, 0, source.facet],
          [removeIndex, 1],
        ]
      }
    }), this.pushChanges);
  },

  pushChanges() {
    var reorder = this.state.facets.map(function(facet, index) {
      return { name: facet.name, order: index+1 }
    });
    MetaDataConfigurationActions.reorderFacets(reorder, this.props.baseUpdateUrl);
  },

  render() {
    return (
      <div>
        <FloatingActionButton onMouseDown={this.handleNewClick} onTouchStart={this.handleNewClick} mini={true} style={addButtonStyle}>
          <ContentAdd />
        </FloatingActionButton>
        <MetaDataFacetDialog
          facetName={this.state.selectedFacet}
          open={this.state.selectedFacet != undefined}
          baseUpdateUrl={this.props.baseUpdateUrl}
          handleClose={this.handleClose}
        />
        <p style={{ textAlign: 'center', paddingTop: '15px', marginBottom: '0px' }}>
          Drag and drop facets using
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
        {this.state.facets.map(function(facet, index) {
          return (
            <div key={facet.name}>
              <MetaDataConfigurationFacetItem
                facet={facet}
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

module.exports = MetaDataConfigurationFacets;
