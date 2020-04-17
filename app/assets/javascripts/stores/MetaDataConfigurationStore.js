var AppDispatcher = require("../dispatcher/AppDispatcher");
var EventEmitter = require("events").EventEmitter;
var CollectionStore = require("stores/Collection");
var MetaDataConfigurationActionTypes = require("../constants/MetaDataConfigurationActionTypes");
var axios = require("axios");

class MetaDataConfigurationStore extends EventEmitter {
  constructor() {
    this._promise = null;
    this._data = {};

    Object.defineProperty(this, "fields", { get: function() { return this._data.fields; } });
    Object.defineProperty(this, "activeFields", { get: function() { return _.where(this._data.fields, {active: true}); } });
    Object.defineProperty(this, "facets", { get: function() { return this._data.facets; } });
    Object.defineProperty(this, "sorts", { get: function() { return this._data.sorts; } });
    AppDispatcher.register(this.receiveAction.bind(this));
  }

  receiveAction(action) {
    switch(action.actionType) {
      case MetaDataConfigurationActionTypes.MDC_CHANGE_FIELD:
        this.changeField(action.name, action.values);
        break;
      case MetaDataConfigurationActionTypes.MDC_CHANGE_FACET:
        this.changeFacet(action.name, action.values);
        break;
      case MetaDataConfigurationActionTypes.MDC_REORDER_FIELDS:
        this.reorderFields(action.newFieldOrder);
        break;
      case MetaDataConfigurationActionTypes.MDC_REORDER_FACETS:
        this.reorderFacets(action.newFacetOrder);
        break;
      case MetaDataConfigurationActionTypes.MDC_REMOVE_FACET:
        this.removeFacet(action.name);
        break;
    }
  }

  reorderFields(newFieldOrder) {
    newFieldOrder.map(function (data) {
      this._data.fields[data.name].order = data.order;
    }.bind(this));

    this.emit("MetaDataConfigurationStoreChanged");
  }

  reorderFacets(newFacetOrder) {
    newFacetOrder.map(data => {
      const match = this._data.facets.find(facet => facet.name === data.name)
      if (match) {
        match.order = data.order
      }
    })

    this.emit("MetaDataConfigurationStoreChanged")
  }

  changeField(name, values) {
    // ensure the values
    if (!values.order) {
      values.order = this.fields.length + 1;
    }
    this._data.fields[name] = values;
    this.emit("MetaDataConfigurationStoreChanged");
  }

  changeFacet(name, values) {
    // Must have an order value
    if (!values.order) {
      values.order = this.facets.length + 1
    }
    // Get field from the store's fields
    if (!values.field) {
      values.field = this.fields[values.field_name]
    }

    const index = this._data.facets.findIndex(facet => facet.name === name)
    if (index === -1) {
      // create
      this._data.facets.push({
        ...values,
        name: name,
      })
    } else {
      // update
      this._data.facets[index] = values
    }
    this.emit("MetaDataConfigurationStoreChanged")
  }

  removeFacet(name) {
    const index = this._data.facets.findIndex(facet => facet.name === name)
    if (index !== -1) {
      this._data.facets.splice(index, 1)
    }
    this.emit("MetaDataConfigurationStoreChanged")
  }

  // Pass false for useCache if you want to force a new load from the api
  getAll(useCache) {
    var id = CollectionStore.uniqueId;
    var url = "/v1/collections/" + id + "/configurations";

    if (!this._promise || !useCache) {
      this._promise = axios.get(url)
        .catch(function () {
          EventEmitter.emit("MessageCenterDisplay", "error", "Server Error");
      });
    }

    // add the then to the promise
    this._promise.then(function (response) {
      this._data = response.data;
      this.emit("MetaDataConfigurationStoreChanged");
      return response;
    }.bind(this));

    return this._promise;
  }
}

var MetaDataConfigurationStore = new MetaDataConfigurationStore();
module.exports = MetaDataConfigurationStore;
