var AppDispatcher = require("../dispatcher/AppDispatcher");
var ItemActionTypes = require("../constants/ItemActionTypes");
//var ItemStore = require("../stores/ItemStore");
var AppEventEmitter = require("../EventEmitter");
var NodeEventEmitter = require("events").EventEmitter;
var APIResponseMixin = require("../mixins/APIResponseMixin");


class ItemActions extends NodeEventEmitter {

  get(id) {
    var baseUrl = "/v1/items/" + id;

    $.ajax({
      url: baseUrl,
      dataType: "json",
      method: "GET",
      success: (function(data) {
        AppDispatcher.dispatch({
          actionType: ItemActionTypes.ITEM_LOADED,
          item: data
        });
      }).bind(this),
      error: (function(xhr) {
        this.emit("ItemLoadFinished", false, xhr);
        AppEventEmitter.emit("MessageCenterDisplay", "error", "Item Load Failed.  Please try again if the problem persists please contact WSE unit.");
      }).bind(this),
    });
  }
}

module.exports = new ItemActions();
