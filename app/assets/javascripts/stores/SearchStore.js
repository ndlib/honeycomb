// This store retains data on search results retreived from the Honeycomb API.
var AppDispatcher = require("../dispatcher/AppDispatcher");
var EventEmitter = require("events").EventEmitter;
var SearchActionTypes = require("../constants/SearchActionTypes");

class SearchStore extends EventEmitter {
  constructor() {
    super();
    this.collection = null; // Collection json
    this.searchTerm = "";   // The primary search term to use when querying the API
    this.sortField = "name";  // The selected field to sort on for the queries
    this.sortDirection = "asc";
    this.hits = [];     // Subset of items returned by the query after filtering on facet, row limit,
                        // and starting item.
    this.found = null;  // Total number of items that were found using the search term.
    this.start = null;  // Start item for the query
    this.facets = null; // List of facet options available for this collection
    this.sorts = null;  // List of sort options available for this collection

    Object.defineProperty(this, "count", { get: function() { return this.hits.length; } });

    AppDispatcher.register(this.receiveAction.bind(this));
  }

  // Adds a callback to listen for changes to the resulting hits for a collection
  addChangeListener(callback) {
    this.on("SearchStoreChanged", callback);
  }

  removeChangeListener(callback) {
    this.removeListener("SearchStoreChanged", callback);
  }

  emitChange(collection) {
    this.emit("SearchStoreChanged");
  }

  // Loads the results from a json response from the api
  loadSearchResults(jsonResponse) {
    this.facets = jsonResponse.facets;
    this.sorts = jsonResponse.sorts;
    this.hits = jsonResponse.hits.hit;
    this.found = jsonResponse.hits.found;
    this.start = jsonResponse.hits.start;
  }

  // Receives actions sent by the AppDispatcher
  receiveAction(action) {
    switch(action.actionType) {
      case SearchActionTypes.SEARCH_LOAD_RESULTS:
        this.searchTerm = action.searchTerm;
        this.sortField = action.sortField;
        this.sortDirection = action.sortDirection;
        this.loadSearchResults(action.jsonResponse);
        this.emitChange();
        break;
      case SearchActionTypes.SEARCH_SET_TERM:
        this.searchTerm = action.searchTerm;
        this.emitChange();
      default:
        break;
    }
  }
}

module.exports = new SearchStore();
