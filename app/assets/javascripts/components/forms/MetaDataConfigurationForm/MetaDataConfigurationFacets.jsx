const React = require("react")
const mui = require("material-ui")

const ReactLink = require('react/lib/ReactLink')
const ReactStateSetters = require('react/lib/ReactStateSetters')
const update = require('react/lib/update')

const MetaDataConfigurationFacetItem = require("./MetaDataConfigurationFacetItem")
const MetadataConfigurationEventTypes = require("./MetaDataConfigurationEventTypes")
const MetaDataConfigurationActions = require("../../../actions/MetaDataConfigurationActions")
const MetaDataFacetDialog = require("../MetaDataFacetDialog")
const AvailableDropTarget = StylableDropTarget(MetadataConfigurationEventTypes.FacetDnD)

const Colors = require("material-ui/lib/styles/colors")
const MoreVertIcons = require("material-ui/lib/svg-icons/navigation/more-vert")
const FloatingActionButton = require("material-ui/lib/floating-action-button")
const ContentAdd = require("material-ui/lib/svg-icons/content/add")

const Paper = mui.Paper
const List = mui.List
const Toggle = mui.Toggle
const Toolbar = mui.Toolbar
const ToolbarGroup = mui.ToolbarGroup
const ToolbarTitle = mui.ToolbarTitle
const FontIcon = mui.FontIcon

const listStyle = {
  paddingBottom: "0px",
}

const addButtonStyle = {
  position: "absolute",
  top: "-16px",
  left: "8px",
  zIndex: "1"
}

const MetaDataConfigurationFacets = React.createClass({
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
    const facets = _.filter(MetaDataConfigurationStore.facets, (facet) => showInactive || facet.active)
    return _.sortBy(facets, 'order')
  },

  handleNewClick() {
    this.setState({ selectedFacet: '' })
  },


  handleEditClick(facet, event) {
    // Ignore the click if it was on the drag icon
    if (!event.target.classList.contains('material-icons')) {
      this.setState({ selectedFacet: facet.name || facet.field.name })
    }
  },

  handleRemove(facetName) {
    MetaDataConfigurationActions.removeFacet(facetName, this.props.baseUpdateUrl)
  },

  handleClose() {
    this.setState({ selectedFacet: undefined })
  },

  handleDrop(target, source) {
    const fromIndex = source.index
    const toIndex = target.index

    if (fromIndex === toIndex) {
      return
    }
    let removeIndex = fromIndex;
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
    }), this.pushChanges)
  },

  pushChanges() {
    const reorder = this.state.facets.map((facet, index) => {
      return { name: facet.name, order: index+1 }
    })
    MetaDataConfigurationActions.reorderFacets(reorder, this.props.baseUpdateUrl)
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
          {this.state.facets.map((facet, index) => (
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
          ))}
        </List>
      </div>
    )
  },
})

module.exports = MetaDataConfigurationFacets
