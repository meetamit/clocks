d3 = require 'd3'

class BitmapDriver
  scale: 10
  constructor: (@n = 8, @m = 3)->
    @bitmap = [
      0,0, 4.6,0, 0,0, 2,3, 1,9, 8,0, 2,4, 2,3
      0,9, 9,0, 0,0, 3,1, 9,5, 8,0, 4,2, 3,1

      0,9, 9,0, 0,0, 1,9, 5,0, 0,4, 2,3, 1,9
      0,9, 9,9, 9,3, 9,5, 0,2, 4,9, 3,1, 9,5

      0,9, 9,9, 9,3, 5,0, 2,4, 0,7, 1,9, 5,0
      0,0, 0,0, 0,0, 0,5, 4,2, 7,9, 9,5, 0,2
    ].map (v) -> d3.rgb Math.round(28.3333*v), Math.round(28.3333*v), Math.round(28.3333*v)

    context = d3.select('body')
      .append('canvas')
      .attr
        width:  @scale * 2 * @n
        height: @scale * 2 * @m
      .node().getContext '2d'

    for c, index in @bitmap
      i = index % (2 * @n)
      j = Math.floor index / (2 * @n)
      o = [i % 2 == 0, j % 2 == 0, i % 2 == 1, j % 2 == 1]
      context.fillStyle = "rgba(#{c.r}, #{c.g}, #{c.b}, 1)"
      context.fillRect(
        i * @scale + o[0],
        j * @scale + o[1],
        1 * @scale - o[2],
        1 * @scale - o[3]
      )

    @endState = @_stateFromBitmap(@bitmap)

  _stateFromBitmap: (bitmap) ->
    state = []
    for i in [0...@n]
      for j in [0...@m]
        # debugger if i == 0 and j == 2
        quads =
          tl: bitmap[2*i +      2*j      * 2*@n].r / 255
          tr: bitmap[2*i + 1 +  2*j      * 2*@n].r / 255
          bl: bitmap[2*i +     (2*j + 1) * 2*@n].r / 255
          br: bitmap[2*i + 1 + (2*j + 1) * 2*@n].r / 255

        diffs =
          t: quads.tr - quads.tl
          r: quads.br - quads.tr
          b: quads.bl - quads.br
          l: quads.tl - quads.bl

        sorted = Object.keys(diffs).sort (a, b) -> d3.descending Math.abs(diffs[a]) , Math.abs(diffs[b])
        console.log i, j
        # debugger #if i == j == 2
        state[i + j * @n] = [
          @_diffToAngle sorted[0], diffs[sorted[0]], quads
          @_diffToAngle sorted[1], diffs[sorted[1]], quads
        ]
    state

  _diffToAngle: (side, diff, quads) ->
    _rev = [quads.tl, quads.tr, quads.br, quads.bl, quads.tl, quads.tr, quads.br, quads.bl]
    # tilt = switch side
    #   when "t", "b"
    #     if diff < 0 then side + 'l' else side + 'r'
    #   when "r", "l"
    #     if diff < 0 then 't' + side else 'b' + side
    # tick = switch tilt
    #   when "tr" then 0
    #   when "br" then 1
    #   when "bl" then 2
    #   when "tl" then 3
    # seq = _rev.slice ref = ((tick + 3) % 4), ref + 4
    # (tick * 90) + 45 + 45 * ( (seq[2] - seq[1]) - (seq[1] - seq[0]) ) / 2

    # tick = switch side
    #   when "t" then 0
    #   when "r" then 1
    #   when "b" then 2
    #   when "l" then 3
    # seq = [ _rev[tick], _rev[tick+1] ]
    # # 90 * (tick - 1 + .5 (seq[0] + seq[1]))
    # console.log quads
    # 90 * (tick - 1 + (seq[0] + seq[1]))
    return 225 if diff == 0

    tick = switch side
      when "t" then 0
      when "r" then 1
      when "b" then 2
      when "l" then 3
    seq = [ _rev[tick], _rev[tick+1] ]
    # 90 * tick + 90 * (1 - seq[Number(diff > 0)]) * diff / Math.abs(diff)
    90 * tick + 90 * (1 - seq[Number(diff < 0)] - seq[Number(diff > 0)]) * diff / Math.abs(diff)
    # return 90



module.exports = BitmapDriver
