_.mixin
  toRGB: (hex) ->
    # http://stackoverflow.com/questions/5623838/rgb-to-hex-and-hex-to-rgb
    shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i
    hex    = hex.replace shorthandRegex, (m, r, g, b) -> r + r + g + g + b + b;
    result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec hex

    if result
      r: parseInt(result[1], 16), g: parseInt(result[2], 16), b: parseInt(result[3], 16)
    else
      null