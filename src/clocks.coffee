d3 = require 'd3'

Hand = (len) ->
  angle = 0
  color = 'black'
  w = 13

  hand = (sel) ->
    path = sel.selectAll('path')
      .data([null])
    path.enter()
      .append('path')
      .attr
        fill: '#eee'#'black'
        d: [
          "M #{w/2} 0"
          "A #{w/2} #{w/2} 90 1 1 #{-w/2} 0"
          "L #{-w/2} 0"
          "L #{-w/2} #{-len}"
          "L #{w/2} #{-len}"
        ].join ' '
    path.attr
      transform: "rotate(#{angle})"

  hand.angle = (_) ->
    return angle % 360 if !arguments.length
    angle = _
    hand

  hand.drive = (amount) ->
    angle += amount
    hand

  return hand
# -----------------------------------
Clock = ->
  radius = 50
  hand1 = Hand(radius * 0.9)
  hand2 = Hand(radius * 0.99)

  clock = (sel) ->
    shift = "translate(#{radius},#{radius})"
    bg = sel.selectAll('.bg')
      .data([null])
    bg.enter()
      .append('circle')
      .attr
        class: 'bg'
        stroke: '#ddd'
        fill: 'none'
    bg
      .attr
        r: radius
        transform: shift

    hands = sel.selectAll('.hand')
      .data([hand1, hand2])
    hands.enter()
      .append('g')
      .attr('class', 'hand')
    hands.each (hand) ->
      d3.select(@)
        .attr
          transform: shift
        .call hand

  clock.angles = (_) ->
    if !arguments.length
      return [hand1.angle(), hand2.angle()]
    clock.angle1 _[0]
    clock.angle2 _[1]
  clock.angle1 = (_) ->
    return hand1.angle() if !arguments.length
    hand1.angle _
    clock
  clock.angle2 = (_) ->
    return hand2.angle() if !arguments.length
    hand2.angle _
    clock

  clock.drive = (amounts) ->
    hand1.drive amounts[0]
    hand2.drive amounts[1]
  clock.drive1 = (amount) ->
    clock.angle1 clock.angle1() + amount
    clock
  clock.drive2 = (amount) ->
    clock.angle2 clock.angle2() + amount
    clock

  clock.hand1 = -> hand1
  clock.hand2 = -> hand2

  return clock
# -----------------------------------
Matrix = (n = 8, m = 3, unitSize = 105) ->
  clocks = []
  values = []
  matrix = (sel) ->
    clockGs = sel.selectAll('.clock')
      .data(values, (d, i) -> i)
    clockGs.enter().append('g')
      .attr
        class: 'clock'
        transform: (d, i) -> """
            translate(
              #{(i%n) * unitSize},
              #{Math.floor(i/n) * unitSize}
            )
        """
    clockGs.each (d, i) ->
      d3.select(@).call clocks[i]

  matrix.values = (_) ->
    if !arguments.length
      return clocks.map (clock) -> clock.angles()
    values = _
    clocks = values.map Clock
    matrix

  matrix.clock = (i) -> clocks[i]

  matrix.size = (_) ->
    return [n,m] if !arguments.length
    n = _[0]
    m = _[1]
    matrix

  return matrix.values [0...(n*m)].map -> [0,0]

# -----------------------------------
class Clocks
  constructor: (el, @driver, @stepper) ->
    @canvas = d3.select(el)
      .append('svg')
      .style
        display: 'block'
        margin: '0 auto'
      .attr
        width: 840
        height: 315
    @matrixG = @canvas.append('g')
    @matrix = Matrix()
    @step()

  _frameNum: 0
  step: =>
    @stepper.step @matrix, @driver.endState, @driver.stateChanged
    if @driver.stateChanged then @driver.stateChanged = false
    @matrixG.call @matrix
    if true || ++@_frameNum < 40
      window.requestAnimationFrame @step


module.exports =
  Clocks: Clocks
  DebugDriver:    require './drivers/DebugDriver.coffee'
  BitmapDriver:   require './drivers/BitmapDriver.coffee'
  DirectStepper:  require './steppers/DirectStepper.coffee'
  ForwardStepper: require './steppers/ForwardStepper.coffee'
