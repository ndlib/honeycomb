# coffeelint: disable=no_stand_alone_at
ExternalCollectionDataTablesIndexes =
  image: 0
  name: 1
  url: 2
  description: 3
  delete: 4

class ExternalCollectionDataTable
  constructor: (@tableElement) ->
    @filterDescriptions = []
    if @tableElement.length > 0
      @setupTable()
      @setupFilters()

  setupTable: ->
    object = @
    infoCallback = (settings, start, end, max, total, pre) ->
      object.infoCallback(settings, start, end, max, total, pre)

    @table = @tableElement.DataTable(
      language:
        emptyTable: "There are no external collections<br/><br/> \
          Please click the add button to add a new external collection."
      dom: "ftlpi",
      lengthChange: false
      deferRender: true
      pageLength: 100
      processing: true
      order: [[ ExternalCollectionDataTablesIndexes['name'], "asc" ]]
      infoCallback: infoCallback
      columnDefs: [
        targets: ExternalCollectionDataTablesIndexes['image']
        sortable: false
        searchable: false
      ,
        targets: ExternalCollectionDataTablesIndexes['name']
        sortable: true
        searchable: true
      ,
        targets: ExternalCollectionDataTablesIndexes['url']
        sortable: true
        searchable: true
      ,
        targets: ExternalCollectionDataTablesIndexes['description']
        sortable: true
        searchable: true
      ,
        targets: ExternalCollectionDataTablesIndexes['delete']
        sortable: false
        searchable: false
      ]
    )

    @container = @tableElement.parent()
    @filterContainer = @container.find('.dataTables_filter')
    object.setupFilters()

  setupFilters: ->
    _this = @
    $('.external-collection-filter').keyup ->
      _this.table.search($(this).val()).draw()


  infoCallback: (settings, start, end, max, total, pre) ->
    if end == 0
      text = ""
    else
      text = "Showing #{@numberWithCommas(start)} to \
        #{@numberWithCommas(end)} of #{@numberWithCommas(total)} items"
    if total < max
      text += " (filtered from #{@numberWithCommas(max)} total items)"
    text

  numberWithCommas: (x) ->
    x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")

jQuery ->

  setupExternalCollectionDatatable = ->
    table = $("#external-collections-table")
    if table.size() > 0
      new ExternalCollectionDataTable(table)

  ready = ->
    setupExternalCollectionDatatable()

  $(document).ready ->
    ready()

# coffeelint: enable=no_stand_alone_at
