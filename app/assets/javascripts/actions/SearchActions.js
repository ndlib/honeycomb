"use strict"
var AppDispatcher = require("../dispatcher/AppDispatcher");
var SearchActionTypes = require("../constants/SearchActionTypes");

class SearchActions {
  executeQuery(baseApiUrl, params) {
    var url = baseApiUrl + "?";
    if(params.searchTerm) {
      AppDispatcher.dispatch({
        actionType: SearchActionTypes.SEARCH_SET_TERM,
        searchTerm: params.searchTerm
      });
      url += "q=" + params.searchTerm;
    }
    if(params.sortOption) {
      url += "&sort=" + params.sortOption;
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
          jsonResponse: result
        });
      },
      error: function(request, status, thrownError) {
        console.log("SearchStoreQueryFailed", { request: request, status: status, error: thrownError });
      }
    });
  }
}
module.exports = new SearchActions();
