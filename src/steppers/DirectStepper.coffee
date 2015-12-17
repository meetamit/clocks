d3 = require 'd3'

class DebugStepper
  maxSpeed: [1.8,5]
  totalSteps: 80

  constructor: ->
    @_stepsRemaining = @totalSteps

  step: (matrix, endState, stateChanged) ->
    size = matrix.size()
    currentState = matrix.values()
    if stateChanged then @_stepsRemaining = @totalSteps
    [0...(size[0] * size[1])].forEach (c, i) =>
      e = endState[i]
      c = currentState[i] ? e
      gap = [
        ( e[0] - (c[0] % 360) + 360 ) % 360
        ( e[1] - (c[1] % 360) + 360 ) % 360
      ]
      direction = [
        if gap[0] > 180 then -1 else 1
        if gap[1] > 180 then -1 else 1
      ]
      gap = [
        if direction[0] is 1 then gap[0] else 360 - gap[0]
        if direction[1] is 1 then gap[1] else 360 - gap[1]
      ]
      speed = [
        direction[0] * Math.min @maxSpeed[0], Math.abs gap[0] / Math.max(1, @_stepsRemaining)
        direction[1] * Math.min @maxSpeed[1], Math.abs gap[1] / Math.max(1, @_stepsRemaining)
      ]
      matrix.clock(i).drive speed

    @_stepsRemaining--

module.exports = DebugStepper

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
