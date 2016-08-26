var AppDispatcher = require("../dispatcher/AppDispatcher");
var PageActionTypes = require("../constants/PageActionTypes");
var AppEventEmitter = require("../EventEmitter");
var NodeEventEmitter = require("events").EventEmitter;
var APIResponseMixin = require("../mixins/APIResponseMixin");

class PageActions extends NodeEventEmitter {

  get(id) {
    $.ajax({
      url: this.url(id),
      dataType: "json",
      method: "GET",
      success: (function(data) {
        AppDispatcher.dispatch({
          actionType: PageActionTypes.PAGE_LOADED,
          page: data.pages
        });
      }).bind(this),
      error: (function(xhr) {
        this.emit("PageLoadFinished", false, xhr);
        AppEventEmitter.emit("MessageCenterDisplay", "error", "Page Load Failed.  Please try again if the problem persists please contact WSE unit.");
      }).bind(this),
    });
  }

  url(id) {
    return "/v1/pages/" + id;
  }
}

module.exports = new PageActions();
