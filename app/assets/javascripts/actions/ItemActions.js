var AppDispatcher = require("../dispatcher/AppDispatcher");
var ItemActionTypes = require("../constants/ItemActionTypes");
//var ItemStore = require("../stores/ItemStore");
var AppEventEmitter = require("../EventEmitter");
var NodeEventEmitter = require("events").EventEmitter;
var APIResponseMixin = require("../mixins/APIResponseMixin");


class ItemActions extends NodeEventEmitter {

  get(id) {
    $.ajax({
      url: this.url(id),
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

  itemShowcases(id) {
    var url = this.url(id) + "/showcases";

    $.ajax({
      url: url,
      dataType: "json",
      method: "GET",
      success: (function(data) {
        AppDispatcher.dispatch({
          actionType: ItemActionTypes.ITEM_SHOWCASES_LOADED,
          item: data
        });
      }).bind(this),
      error: (function(xhr) {
        this.emit("ItemShowcaseLoadFinished", false, xhr);
        AppEventEmitter.emit("MessageCenterDisplay", "error", "Item Load Failed.  Please try again if the problem persists please contact WSE unit.");
      }).bind(this),
    });
  }

  itemPages(id) {
    var url = this.url(id) + "/pages";

    $.ajax({
      url: url,
      dataType: "json",
      method: "GET",
      success: (function(data) {
        AppDispatcher.dispatch({
          actionType: ItemActionTypes.ITEM_PAGES_LOADED,
          item: data
        });
      }).bind(this),
      error: (function(xhr) {
        this.emit("ItemPageLoadFinished", false, xhr);
        AppEventEmitter.emit("MessageCenterDisplay", "error", "Item Load Failed.  Please try again if the problem persists please contact WSE unit.");
      }).bind(this),
    });
  }

  delete(id) {
    $.ajax({
      url: this.url(id),
      dataType: "json",
      method: "DELETE",
      success: (function(data) {
        AppDispatcher.dispatch({
          actionType: ItemActionTypes.ITEM_DELETED,
          item: id
        });
        AppEventEmitter.emit("MessageCenterDisplay", "info", "Item Deleted");
      }).bind(this),
      error: (function(xhr) {
        this.emit("ItemDeleteFailed", false, xhr);
        AppEventEmitter.emit("MessageCenterDisplay", "error", "Item Delete Failed.  Please try again if the problem persists please contact WSE unit.");
      }).bind(this),
    });
  }

  url(id) {
    return "/v1/items/" + id;
  }
}

module.exports = new ItemActions();
