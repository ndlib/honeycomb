var keyMirror = require('keymirror');

var SearchActionTypes = keyMirror({
  SEARCH_LOAD_RESULTS: null,
  SEARCH_SET_TERM: null
});

module.exports = SearchActionTypes;
