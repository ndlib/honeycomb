var AppDispatcher = require("../dispatcher/AppDispatcher");
var MetaDataConfigurationActionTypes = require("../constants/MetaDataConfigurationActionTypes");
var MetaDataConfigurationStore = require("../stores/MetaDataConfigurationStore");
var AppEventEmitter = require("../EventEmitter");
var NodeEventEmitter = require("events").EventEmitter;
var APIResponseMixin = require("../mixins/APIResponseMixin");
var update = require("react-addons-update");

class MetaDataConfigurationActions extends NodeEventEmitter {

  reorder(newOrder, baseUrl) {
    var oldOrder = _.map(MetaDataConfigurationStore.fields, function (data) {
      return { name: data.name, order: data.order };
    });

    baseUrl += "/reorder";

    AppDispatcher.dispatch({
      actionType: MetaDataConfigurationActionTypes.MDC_REORDER_FIELDS,
      newFieldOrder: newOrder,
    });

    $.ajax({
      url: baseUrl,
      dataType: "json",
      method: "PUT",
      data: {
        fields: newOrder,
      },
      success: (function() {
        this.emit("ChangeReorderFinished", true);
      }).bind(this),
      error: (function(xhr) {
        AppDispatcher.dispatch({
          actionType: MetaDataConfigurationActionTypes.MDC_REORDER_FIELDS,
          newFieldOrder: oldOrder,
        });
        this.emit("ChangeReorderFinished", false, xhr);
        AppEventEmitter.emit("MessageCenterDisplay", "error", "Reorder Failed.  Please try again if the problem persists please contact WSE unit.");
      }).bind(this),
    });
  }

  changeActive(fieldName, activeValue, pushToUrl){
    // Clone values in order to revert the store if the change fails
    var previousValue = MetaDataConfigurationStore.fields[fieldName].active;
    var fieldValues = update(MetaDataConfigurationStore.fields[fieldName], {});

    // Optimistically change the store
    fieldValues.active = activeValue;
    AppDispatcher.dispatch({
      actionType: MetaDataConfigurationActionTypes.MDC_CHANGE_FIELD,
      name: fieldName,
      values: fieldValues,
    });

    pushToUrl += "/" + fieldName;
    $.ajax({
      url: pushToUrl,
      dataType: "json",
      method: "PUT",
      data: {
        fields: fieldValues,
      },
      success: (function() {
        // Store was already changed, nothing to do here
        this.emit("ChangeActiveFinished", true);
        AppEventEmitter.emit("MessageCenterDisplay", "info", "Collection updated");
      }).bind(this),
      error: (function(xhr) {
        // Request to change failed, revert the store to previous values
        fieldValues.active = previousValue;
        AppDispatcher.dispatch({
          actionType: MetaDataConfigurationActionTypes.MDC_CHANGE_FIELD,
          name: fieldName,
          values: fieldValues,
        });
        // Communicate the error to the user
        this.emit("ChangeActiveFinished", false, xhr);
        AppEventEmitter.emit("MessageCenterDisplay", "error", APIResponseMixin.apiErrorToString(xhr));
      }).bind(this)
    });
  }

  changeField(fieldName, fieldValues, pushToUrl) {
    // Clone values in order to revert the store if the change fails
    var previousValues = update(MetaDataConfigurationStore.fields[fieldName], {});

    pushToUrl += "/" + fieldName;

    $.ajax({
      url: pushToUrl,
      dataType: "json",
      method: "PUT",
      data: {
        fields: fieldValues,
      },
      success: (function(result) {
        AppDispatcher.dispatch({
          actionType: MetaDataConfigurationActionTypes.MDC_CHANGE_FIELD,
          name: result.field.name,
          values: result.field,
        });
        this.emit("ChangeFieldFinished", true, result.field);
        AppEventEmitter.emit("MessageCenterDisplay", "info", "Collection updated");
      }).bind(this),
      error: (function(xhr) {
        // Request to change failed, revert the store to previous values on if it is updated
        AppDispatcher.dispatch({
          actionType: MetaDataConfigurationActionTypes.MDC_CHANGE_FIELD,
          name: fieldName,
          values: previousValues,
        });
        // Communicate the error to the user
        this.emit("ChangeFieldFinished", false, xhr);
        AppEventEmitter.emit("MessageCenterDisplay", "error", "Save failed. Please select a type and unique label and try again.");
      }).bind(this)
    });
  }

  createField(fieldName, fieldValues, pushToUrl) {
    var requiredValues = _.pick(fieldValues, "defaultFormField", "label", "multiple", "optionalFormField", "required", "type");
    var postValues = _.omit(requiredValues, function(value) { return _.isNull(value); });

    $.ajax({
      url: pushToUrl,
      dataType: "json",
      method: "POST",
      data: {
        fields: postValues,
      },
      success: (function(result) {
        AppDispatcher.dispatch({
          actionType: MetaDataConfigurationActionTypes.MDC_CHANGE_FIELD,
          name: result.field.name,
          values: result.field,
        });
        this.emit("CreateFieldFinished", true, result.field);
        AppEventEmitter.emit("MessageCenterDisplay", "info", "Collection updated");
      }).bind(this),
      error: (function(xhr) {
        // Communicate the error to the user
        this.emit("CreateFieldFinished", false, xhr);
        AppEventEmitter.emit("MessageCenterDisplay", "error", "Create failed. Please select a unique label and try again.");
      }).bind(this)
    });
  }

  changeFacet(facetName, facetValues, pushToUrl) {
    // Clone values in order to revert the store if the change fails
    const match = MetaDataConfigurationStore.facets.find(facet => facet.name === facetName)
    if (!match) {
      return
    }
    const previousValues = update(match, {})

    $.ajax({
      url: `${pushToUrl}/${facetName}`,
      dataType: "json",
      method: "PUT",
      data: facetValues,
      success: (function(result) {
        AppDispatcher.dispatch({
          actionType: MetaDataConfigurationActionTypes.MDC_CHANGE_FACET,
          name: result.facet.name,
          values: result.facet,
        })
        this.emit("ChangeFacetFinished", true, result)
        AppEventEmitter.emit("MessageCenterDisplay", "info", "Collection updated")
      }).bind(this),
      error: (function(xhr) {
        // Request to change failed, revert the store to previous values on if it is updated
        AppDispatcher.dispatch({
          actionType: MetaDataConfigurationActionTypes.MDC_CHANGE_FACET,
          name: facetName,
          values: previousValues,
        })
        // Communicate the error to the user
        this.emit("ChangeFacetFinished", false, xhr);
        AppEventEmitter.emit("MessageCenterDisplay", "error", "Save failed. Please refresh and try again.");
      }).bind(this)
    })
  }

  createFacet(facetName, facetValues, pushToUrl) {
    const requiredValues = _.pick(facetValues, 'name', 'field_name', 'label', 'limit', 'order')
    const postValues = _.omit(requiredValues, function(value) { return _.isNull(value) })

    $.ajax({
      url: pushToUrl,
      dataType: "json",
      method: "POST",
      data: postValues,
      success: (function(result) {
        AppDispatcher.dispatch({
          actionType: MetaDataConfigurationActionTypes.MDC_CHANGE_FACET,
          name: result.facet.name,
          values: result.facet,
        })
        this.emit("CreateFacetFinished", true, result)
        AppEventEmitter.emit("MessageCenterDisplay", "info", "Collection updated")
      }).bind(this),
      error: (function(xhr) {
        // Communicate the error to the user
        this.emit("CreateFacetFinished", false, xhr)
        AppEventEmitter.emit("MessageCenterDisplay", "error", "Create failed. Please select a unique field and try again.")
      }).bind(this)
    })
  }

  removeFacet(facetName, pushToUrl) {
    // Clone values in order to revert the store if the remove fails
    const match = MetaDataConfigurationStore.facets.find(facet => facet.name === facetName)
    const previousValues = update(match, {})

    // Optimistically change the store
    AppDispatcher.dispatch({
      actionType: MetaDataConfigurationActionTypes.MDC_REMOVE_FACET,
      name: facetName,
    })

    $.ajax({
      url: `${pushToUrl}/${facetName}`,
      dataType: "json",
      method: "DELETE",
      success: (function() {
        // Store was already changed, nothing to do here
        this.emit("RemoveFacetFinished", true)
        AppEventEmitter.emit("MessageCenterDisplay", "info", "Collection updated")
      }).bind(this),
      error: (function(xhr) {
        // Request to change failed, revert the store to previous values
        AppDispatcher.dispatch({
          actionType: MetaDataConfigurationActionTypes.MDC_CHANGE_FACET,
          name: facetName,
          values: previousValues,
        });
        // Communicate the error to the user
        this.emit("RemoveFacetFinished", false, xhr)
        AppEventEmitter.emit("MessageCenterDisplay", "error", APIResponseMixin.apiErrorToString(xhr))
      }).bind(this)
    });
  }

  reorderFacets(newOrder, baseUrl) {
    const oldOrder = _.map(MetaDataConfigurationStore.facets, function (data) {
      return { name: data.name, order: data.order }
    })

    AppDispatcher.dispatch({
      actionType: MetaDataConfigurationActionTypes.MDC_REORDER_FACETS,
      newFacetOrder: newOrder,
    })

    $.ajax({
      url: `${baseUrl}/reorder`,
      dataType: "json",
      method: "PUT",
      data: {
        facets: newOrder,
      },
      success: (function() {
        this.emit("FacetReorderFinished", true)
      }).bind(this),
      error: (function(xhr) {
        AppDispatcher.dispatch({
          actionType: MetaDataConfigurationActionTypes.MDC_REORDER_FACETS,
          newFacetOrder: oldOrder,
        })
        this.emit("FacetReorderFinished", false, xhr)
        AppEventEmitter.emit("MessageCenterDisplay", "error", "Reorder Failed.  Please try again. If the problem persists, please contact WSE unit.");
      }).bind(this),
    });
  }
}

module.exports = new MetaDataConfigurationActions();
