$ ->
  $(".remove_curator").click ->
    $("#remove_curator_id").attr('value', $(this).attr('curator_id'))
    $("#remove_curator_form").submit()
    return
return

