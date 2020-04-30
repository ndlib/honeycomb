var keyMirror = require('keymirror');

module.exports = keyMirror({
  MDC_CHANGE_FIELD: null, // Change a field's properties within the metadata configuration
  MDC_CHANGE_FACET: null, // Change a facet's properties within the metadata configuration
  MDC_CHANGE_SORT: null, // Change a sort's properties within the metadata configuration
  MDC_REORDER_FIELDS: null, // Change the order of fields within the metadata configuration
  MDC_REORDER_FACETS: null, // Change the order of facets within the metadata configuration
  MDC_REORDER_SORTS: null, // Change the order of sorts within the metadata configuration
  MDC_REMOVE_FACET: null, // Remove a facet from the metadata configuration
  MDC_REMOVE_SORT: null, // Remove a sort from the metadata configuration
});
