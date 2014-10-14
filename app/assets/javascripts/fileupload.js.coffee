jQuery ->
  # Initialize the jQuery File Upload widget:
  $("#fileupload").fileupload dropZone: $("#dropzone")

  #
  # Load existing files:
  $.getJSON $("#fileupload").prop("action"), (files) ->
    fu = $("#fileupload").data("blueimpFileupload")
    template = undefined
    fu._adjustMaxNumberOfFiles -files.length
    console.log files
    template = fu._renderDownload(files).appendTo($("#fileupload .files"))

    # Force reflow:
    fu._reflow = fu._transition and template.length and template[0].offsetWidth
    template.addClass "in"
    $("#loading").remove()
    return

  $(document).bind "dragover", (e) ->
    dropZone = $("#dropzone")
    timeout = window.dropZoneTimeout
    unless timeout
      dropZone.addClass "in"
    else
      clearTimeout timeout
    found = false
    node = e.target
    loop
      if node is dropZone[0]
        found = true
        break
      node = node.parentNode
      break unless node?
    if found
      dropZone.addClass "hover"
    else
      dropZone.removeClass "hover"
    window.dropZoneTimeout = setTimeout(->
      window.dropZoneTimeout = null
      dropZone.removeClass "in hover"
      return
    , 100)
    return

