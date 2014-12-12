ItemDataTablesIndexes =
  image: 0
  title: 1
  updatedAt: 2
  updatedAtTimestamps: 3
  sortableTitle: 4
  originalFilename: 5

class ItemDataTable
  constructor: (@tableElement) ->
    @filterDescriptions = []
    if @tableElement.length > 0
      @setupTable()
      @setupFilters()
      #@setupForm()

  setupTable: ->
    object = @
    infoCallback = (settings, start, end, max, total, pre) ->
      object.infoCallback(settings, start, end, max, total, pre)

    @table = @tableElement.DataTable(
      language:
        emptyTable: "There is nothing here!!  <br> Please consider creating new items or adjusting you search criteria."
      dom: "ftlpi",
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
      ,
        targets: ItemDataTablesIndexes['title']
        orderData: [ItemDataTablesIndexes['sortableTitle']]
      ,
        targets: ItemDataTablesIndexes['sortableTitle']
        visible: false
      ,
        targets: ItemDataTablesIndexes['image']
        sortable: false
        searchable: false
      ,
        targets: ItemDataTablesIndexes['originalFilename']
        sortable: false
        searchable: true
        visible: false
      ]
    )

    @container = @tableElement.parent()
    @filterContainer = @container.find('.dataTables_filter')

  setupFilters: ->
    object = @
    #@filterContainer.addClass('well').addClass('well-small')

  infoCallback: (settings, start, end, max, total, pre) ->
    if end == 0
      text = ""
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
