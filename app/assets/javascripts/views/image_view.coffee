class Moon.View.ImageView extends SUI.View
  className: 'image-view'
  animate_attributes: ['scale', 'origin', 'position', 'opacity']
  initialize: (options = {}) ->
    @scene = options.scene
    @asset = options.asset

    @scale    = if _(options.scale).isUndefined() then 1 else options.scale
    @opacity  = if _(options.opacity).isUndefined() then 1 else options.opacity
    @origin   = options.origin
    @position = options.position

    @_render()
    @_position options.layer_id


  animate: (options) ->
    prepare_options = {}
    animate_options = {}

    _(@animate_attributes).each (attr) ->
      return if _(options[attr]).isUndefined()

      if _(options[attr]).isArray()
        prepare_options[attr] = options[attr][0]
        animate_options[attr] = options[attr][1]
      else
        animate_options[attr] = options[attr]

    @$el.css prepare_options
    console.log animate_options
    @$el.transition animate_options, options.duration

  _render: ->
    width  = parseInt @asset.get('width')
    height = parseInt @asset.get('height')

    width_percentage  = width/@app.screen_size.width*100
    height_percentage = height/@app.screen_size.height*100
    height_percentage_by_width = height/@app.screen_size.width*100

    @$el.css
      width:  "#{width_percentage}%"
      height: "#{height_percentage}%"
      marginLeft: "#{width_percentage*@origin.x*-1}%"
      marginTop: "#{height_percentage_by_width*@origin.y*-1}%"
      left: "#{@position.x*100}%", top: "#{@position.y*100}%"
      opacity: @opacity
      scale: @scale
      transformOrigin: "#{@origin.x*100}% #{@origin.y*100}%"

    @$image = $("<img src='#{@asset.get('src')}'>")
    @$el.append @$image


  _position: (layer_id) ->
    layer = @scene.layers.get layer_id
    layer.view.$el.append @el