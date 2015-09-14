class PiG.Model.LimitedTimeScene.Time extends SUI.Model
  initialize: (attrs, options) ->
    @_init_seconds()
    @on 'change:time', @_init_seconds

  subtract: (time) ->
    seconds = @get('seconds') - @_parse_time(time)
    seconds = 0 if seconds < 0
    @set 'seconds', seconds

  add: (time) ->
    @set 'seconds', @get('seconds') + @_parse_time(time)

  reset: (time) ->
    @set 'seconds', @_parse_time(time)

  humanize: ->
    seconds     = @get 'seconds'
    output      = {}
    sub_seconds = 0

    output.hours = Math.floor seconds/3600
    sub_seconds += output.hours*3600

    output.minutes = Math.floor (seconds-sub_seconds)/60
    sub_seconds += output.minutes*60

    output.seconds = seconds-sub_seconds

    output

  _init_seconds: ->
    @set 'seconds', @_parse_time @get('time')

  _parse_time: (time_array) ->
    return parseInt(time_array) unless _(time_array).isArray()

    time_array[0] = parseInt time_array[0]
    return 0 if _(time_array[0]).isNaN()
    switch time_array[1]
      when 'seconds', 'second' then time_array[0]
      when 'minutes', 'minute' then time_array[0] * 60
      when 'hours', 'hour'     then time_array[0] * 60 * 60
      else time_array[0]

