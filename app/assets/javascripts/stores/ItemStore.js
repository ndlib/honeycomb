var AppDispatcher = require("../dispatcher/AppDispatcher");
var ItemActionTypes = require("../constants/ItemActionTypes");

var EventEmitter = require("events").EventEmitter;

class ItemStore extends EventEmitter {
  constructor() {
    this._items = {};
    AppDispatcher.register(this.receiveAction.bind(this));
  }

  // Receives actions sent by the AppDispatcher
  receiveAction(action) {
    switch(action.actionType) {
      case ItemActionTypes.ITEM_LOADED:
        this._items[action.item.items.id] = action.item.items;
        this.emit("ItemLoadFinished");
        break;
    }
  }

  get(id) {
    return this._items[id];
  }
}

module.exports = new ItemStore();
