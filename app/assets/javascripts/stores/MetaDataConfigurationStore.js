var AppDispatcher = require("../dispatcher/AppDispatcher");
var EventEmitter = require("events").EventEmitter;
var CollectionStore = require("stores/Collection");
var axios = require("axios");

class MetaDataConfigurationStore extends EventEmitter {
  constructor() {
    this._promise = null;
    this._data = {};

    Object.defineProperty(this, "fields", { get: function() { return this._data.fields; } });
    Object.defineProperty(this, "facets", { get: function() { return this._data.facets; } });
    Object.defineProperty(this, "sorts", { get: function() { return this._data.sorts; } });
    AppDispatcher.register(this.receiveAction.bind(this));
  }

  receiveAction() {
    // held for use when actions are sent back to the object.
  }

  // Pass false for useCache if you want to force a new load from the api
  getAll(useCache) {
    var id = CollectionStore.uniqueId;
    var url = "/v1/collections/" + id + "/metadata_configuration";

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
