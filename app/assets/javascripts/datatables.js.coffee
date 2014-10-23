ItemDataTablesIndexes =
  title: 0
  updatedAt: 1
  updatedAtTimestamps: 2
  editFields: 3

class ItemDataTable
  constructor: (@tableElement) ->
    @filterDescriptions = []
    if @tableElement.length > 0
      @setupTable()
      #@setupFilters()
      #@setupForm()

  setupTable: ->
    object = @
    infoCallback = (settings, start, end, max, total, pre) ->
      object.infoCallback(settings, start, end, max, total, pre)

    @table = @tableElement.DataTable(
      lengthChange: false
      deferRender: true
      pageLength: 100
      processing: true
      order: [[ ItemDataTablesIndexes['updatedAt'], "desc" ]]
      infoCallback: infoCallback
      columnDefs: [
        targets: ItemDataTablesIndexes['updatedAt']
        orderData: [ItemDataTablesIndexes['updatedAtTimestamps']]
      ,
        targets: ItemDataTablesIndexes['updatedAtTimestamps']
        sortable: false
        searchable: false
        visible: false
      ,
        targets: ItemDataTablesIndexes['editFields']
        sortable: false
        searchable: false
      ]
    )

  infoCallback: (settings, start, end, max, total, pre) ->
    if end == 0
      text = "No items match your search criteria."
    else
      text = "Showing #{@numberWithCommas(start)} to #{@numberWithCommas(end)} of #{@numberWithCommas(total)} items"
    if total < max
      text += " (filtered from #{@numberWithCommas(max)} total items)"
    text

  numberWithCommas: (x) ->
    x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")


jQuery ->

  setupItemDatatable = () ->
    table = $(".datatable")
    if table.size() > 0
      new ItemDataTable(table)


  ready = ->
    setupItemDatatable()

  $(document).ready ->
    ready()



