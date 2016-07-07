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
      case MetaDataConfigurationActionTypes.MDC_REORDER_FIELDS:
        this.reorderFields(action.newFieldOrder);
        break;

    }
  }

  reorderFields(newFieldOrder) {
    newFieldOrder.map(function (data) {
      this._data.fields[data.name].order = data.order;
    }.bind(this));

    this.emit("MetaDataConfigurationStoreChanged");
  }

  changeField(name, values) {
    // ensure the values
    if (!values.order) {
      values.order = this.fields.length + 1;
    }
    this._data.fields[name] = values;
    this.emit("MetaDataConfigurationStoreChanged");
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
