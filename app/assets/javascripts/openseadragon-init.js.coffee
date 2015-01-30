jQuery ($) ->
  window.initializeZoom = (elements) ->
    elements.each ->
      container = $(this)
      initializeOpenseadragon(container)

  initializeFullscreenButtons = (elements) ->
    elements.each ->
      button = $(this)
      initializeFullscreenButton(button)

  initializeFullscreenButton = (button) ->
    button.click (event) ->
      event.preventDefault()
      container = $(button.data('target'))
      viewer = getViewer(container)
      viewer.setFullPage(true)
      viewer.viewport.goHome()
      true
    $(document).keyup (event) ->
      if event.keyCode == 27
        container = $(button.data('target'))
        viewer = getViewer(container)
        viewer.setFullPage(false)
      true

  initializeOpenseadragon = (container) ->
    if !container.data('zoom-initialized')
      container.data('zoom-initialized', true)
      options = viewerOptions(container)
      viewer = OpenSeadragon(options)
      container.data('openseadragonviewer', viewer)
    container.data('openseadragonviewer')

  getViewer = (container) ->
    container.data('openseadragonviewer')

  viewerOptions = (container) ->
    if /dzi/.test(container.data('target'))
      options = dziOptions(container)
    else
      options = legacyOptions(container)
    console.log(options)
    options

  baseOptions = (container) ->
    {
      id: container.attr('id')
      element: container.get(0)
      prefixUrl: "/openseadragon/"
      showNavigator: false
      showRotationControl: true
      immediateRender: true
      visibilityRatio:  0.5
      springStiffness:  9
      gestureSettingsMouse: {
        flickEnabled: true
        flickMomentum: 0.2
      }
      gestureSettingsTouch: {
        flickMomentum: 0.2
      }
    }

  dziOptions = (container) ->
    options = baseOptions(container)
    options.tileSources = container.data('target')
    options

  legacyOptions = (container) ->
    options = baseOptions(container)
    options.tileSources =
      type: 'legacy-image-pyramid'
      levels: [{
        url: container.data('target'),
        height: container.data('target-height')
        width: container.data('target-width')
      }]
    options


  ready = ->
    window.initializeZoom($('.image-zoom-immediate'))
    initializeFullscreenButtons($('.image-zoom-fullscreen'))

  $(document).ready(ready)
