"use strict"
var EventEmitter = require("../EventEmitter");
var AppDispatcher = require("../dispatcher/AppDispatcher");
var SearchActionTypes = require("../constants/SearchActionTypes");

class SearchActions {
  executeQuery(baseApiUrl, params) {
    EventEmitter.emit("SearchExecutingQuery");

    var url = baseApiUrl + "?";
    if(params.searchTerm) {
      var expandedTerms = params.searchTerm.split(" ").filter(t => t != '');
      var joinedTerms = "*" + expandedTerms.join("* AND *") + "*";
      url += "q=" + joinedTerms;
    }
    if(params.sortField) {
      url += "&sort=" + params.sortField;
      if(params.sortDirection) {
        url += " " + params.sortDirection;
      }
    }
    if(params.start) {
      url += "&start=" + params.start;
    }
    if(params.rowLimit){
      url += "&rows=" + params.rowLimit;
    }

    $.ajax({
      context: this,
      type: "GET",
      url: url,
      dataType: "json",
      success: function(result) {
        AppDispatcher.dispatch({
          actionType: SearchActionTypes.SEARCH_LOAD_RESULTS,
          searchTerm: params.searchTerm,
          sortField: params.sortField,
          sortDirection: params.sortDirection,
          jsonResponse: result
        });
        EventEmitter.emit("SearchQueryComplete", "success", result);
      },
      error: function(request, status, thrownError) {
        EventEmitter.emit("SearchQueryComplete", "error", { request: request, status: status, error: thrownError });
      }
    });
  }
}
module.exports = new SearchActions();
