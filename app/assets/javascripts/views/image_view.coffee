class Moon.View.ImageView extends Moon.View.BaseView
  className: 'image-view'
  animate_attributes: ['scale', 'origin', 'position', 'opacity']
  initialize: (options = {}) ->
    @scene = options.scene
    @asset = options.asset

    @scale    = if _(options.scale).isUndefined() then 1 else options.scale
    @opacity  = if _(options.opacity).isUndefined() then 1 else options.opacity
    @origin   = options.origin or {x: 0, y: 0}
    @position = options.position or {x: 0, y: 0}

    @_render()
    @_position_to_layer options.layer_id if options.layer_id
    @_position_to_element options.wrapper_el if options.wrapper_el


  animate: (options, callback) ->
    prepare_options = {}
    animate_options = {}

    _(@animate_attributes).each (attr) ->
      return if _(options[attr]).isUndefined()

      if _(options[attr]).isArray()
        prepare_options[attr] = options[attr][0]
        animate_options[attr] = options[attr][1]
      else
        animate_options[attr] = options[attr]

    @$el.css @_convert_position_attr prepare_options
    @$el.transition @_convert_position_attr(animate_options), options.duration, =>
      callback() if callback instanceof Function

  _render: ->
    width  = parseInt @asset.get('width')
    height = parseInt @asset.get('height')

    width_percentage  = width/@app.screen_size.width*100
    height_percentage = height/@app.screen_size.height*100
    height_percentage_by_width = height/@app.screen_size.width*100

    prepare_options =
      width:  "#{width_percentage}%"
      height: "#{height_percentage}%"
      marginLeft: "#{width_percentage*@origin.x*-1}%"
      marginTop: "#{height_percentage_by_width*@origin.y*-1}%"
      position: @position
      opacity: @opacity
      scale: @scale
      transformOrigin: "#{@origin.x*100}% #{@origin.y*100}%"

    @$el.css @_convert_position_attr prepare_options
    @$image = $("<img src='#{@asset.get('src')}'>")
    @$el.append @$image


  _position_to_layer: (layer_id) ->
    layer = @scene.layers.get layer_id
    layer.view.$el.append @el

  _position_to_element: (wrapper_el) ->
    @$el.appendTo wrapper_el



  _convert_position_attr: (options) ->
    position = options.position

    return options unless position

    options.left = "#{position.x*100}%" if position.x
    options.top  = "#{position.y*100}%" if position.y

    delete options.position

    options


