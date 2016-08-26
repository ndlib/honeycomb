var AppDispatcher = require("../dispatcher/AppDispatcher");
var PageActionTypes = require("../constants/PageActionTypes");

var EventEmitter = require("events").EventEmitter;

class PageStore extends EventEmitter {
  constructor() {
    this._pages = {};
    AppDispatcher.register(this.receiveAction.bind(this));
  }

  // Receives actions sent by the AppDispatcher
  receiveAction(action) {
    switch(action.actionType) {
      case PageActionTypes.PAGE_LOADED:
        this._pages[action.page.id] = action.page;
        this.emit("PageLoadFinished");
        break;
    }
  }

  get(id) {
    return this._pages[id];
  }
}

module.exports = new PageStore();
