d3 = require 'd3'

class DebugDriver
  constructor: ->
    # @buffer = [
    #   Digits['null']
    #   Digits['null']
    #   Digits['null']
    #   Digits['null']
    # ]
    @buffer = d3.time.format('%H%M')(new Date()).split('').map (digit) -> Digits[digit]
    @endState = @_stateFromBuffer @buffer

    d3.select('body')
      .on 'keydown.debug_driver', =>
        digit = Math.max 0, Math.min 9, d3.event.keyCode - 48
        @buffer.push Digits[String(digit)]
        @buffer.shift()
        @endState = @_stateFromBuffer @buffer
        @stateChanged = true

  _stateFromBuffer: (buffer) ->
    buffer.reduce (memo, char, i) ->
      memo[2 * i + 0 ] = char[0]
      memo[2 * i + 1 ] = char[1]
      memo[2 * i + 8 ] = char[2]
      memo[2 * i + 9 ] = char[3]
      memo[2 * i + 16] = char[4]
      memo[2 * i + 17] = char[5]
      memo
    , []


module.exports = DebugDriver

# -----------------------------------

Digits =
  "null": [
    [225,225], [225,225]
    [225,225], [225,225]
    [225,225], [225,225]
  ]
  1: [
    [225,225], [180,180]
    [225,225], [0  ,180]
    [225,225], [0  ,  0]
  ]
  2: [
    [90 , 90], [180,270]
    [180, 90], [270,  0]
    [0  , 90], [270,270]
  ]
  3: [
    [90 , 90], [180,270]
    [90 , 90], [270,  0]
    [90 , 90], [  0,270]
  ]
  4: [
    [180,180], [180,180]
    [0  , 90], [270,180]
    [225,225], [0  ,  0]
  ]
  5: [
    [90 ,180], [270,270]
    [0  , 90], [270,180]
    [90 , 90], [270,  0]
  ]
  6: [
    [90 ,180], [270,270]
    [0  ,180], [270,180]
    [90 ,  0], [270,  0]
  ]
  7: [
    [90 , 90], [180,270]
    [225,225], [180,  0]
    [225,225], [  0,  0]
  ]
  8: [
    [90 ,180], [270,180]
    [0  , 90], [270,  0]
    [0  , 90], [270,  0]
  ]
  9: [
    [90 ,180], [180,270]
    [0  , 90], [0  ,180]
    [90 , 90], [270,  0]
  ]
  0: [
    [90 ,180], [270,180]
    [0  ,180], [0  ,180]
    [0  , 90], [270,  0]
  ]
