jQuery ->

  ready = ->
    $(".datatable").dataTable
      paging: false


  $(document).ready(ready)
  $(document).on('page:load', ready)


