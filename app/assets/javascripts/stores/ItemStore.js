var AppDispatcher = require("../dispatcher/AppDispatcher");
var ItemActionTypes = require("../constants/ItemActionTypes");

var EventEmitter = require("events").EventEmitter;

class ItemStore extends EventEmitter {
  constructor() {
    this._items = {};
    this._showcases = {};
    this._pages = {};
    AppDispatcher.register(this.receiveAction.bind(this));
  }

  // Receives actions sent by the AppDispatcher
  receiveAction(action) {
    switch(action.actionType) {
      case ItemActionTypes.ITEM_LOADED:
        this._items[action.item.items.id] = action.item.items;
        this.emit("ItemLoadFinished");
        break;
      case ItemActionTypes.ITEM_SHOWCASES_LOADED:
        this._showcases[action.item.items.id] = action.item.items.showcases;
        this.emit("ItemShowcaseLoadFinished");
        break;
      case ItemActionTypes.ITEM_PAGES_LOADED:
        this._pages[action.item.items.id] = action.item.items.pages;
        this.emit("ItemPageLoadFinished");
        break;
      case ItemActionTypes.ITEM_DELETED:
        delete this._items[action.item];
        this.emit("ItemDeleteFinished");
        break;
    }
  }

  get(id) {
    return this._items[id];
  }

  getShowcases(id) {
    return this._showcases[id];
  }

  getPages(id) {
    return this._pages[id];
  }
}

module.exports = new ItemStore();
