$ ->
  enable_add = (message) ->
    $("#selected_user").text(message).prependTo "#user_selected"
    return
  $("#user_search").autocomplete
    source: "/user_search"
    minLength: 2
    select: (event, ui) ->
      enable_add (if ui.item then ui.item.value + " selected")
      return
return

