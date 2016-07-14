class RedactorPageField
  constructor: (@fieldElement) ->
    if @fieldElement.length > 0
      @setupField()

  setupField: ->
    @fieldElement.redactor({
      focus: true
      maxWidth: '1000px'
      formatting: ['p', 'blockquote', 'h3', 'h4', 'h5']
      imageUpload: '/v1/collections/' + $("#image_collection_unique_id").val() + '/items'
      imageUploadParam: 'item[uploaded_image]'
      uploadImageFields: {
        'authenticity_token': '#image_upload_auth_token'
      }
      imageUploadCallback: (image, json) ->
        if json.errors
          EventEmitter.emit("MessageCenterDisplay", "warning", "Error Uploading Image")
        else
          $(image).attr 'alt', json.name
          $(image).attr 'title', json.name
          $(image).attr 'item_id', json.id
          $(image).attr 'src', json.image['thumbnail/medium']['contentUrl']
      imageManagerJson: '/v1/collections/' + $("#image_collection_unique_id").val() + '/items'
      plugins: ['imagemanager', 'source']
    })

jQuery ->

  setupRedactor = ->
    field = $(".honeycomb_image_redactor")
    if field.size() > 0
      new RedactorPageField(field)

  ready = ->
    setupRedactor()

  $(document).ready ->
    ready()
