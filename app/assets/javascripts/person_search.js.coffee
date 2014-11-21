$ ->
  set_id = (id) ->
    $("#curator_id").attr('value', id)
    return
  $("#add_curator").click ->
    $("#set_curator_form").submit()
    return
  $("#user_search").autocomplete
    source: "/user_search"
    minLength: 2
    delay: 100
    select: (event, ui) ->
      set_id (if ui.item then ui.item.id)
      return
return

