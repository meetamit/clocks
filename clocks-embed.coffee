d3 = require 'd3'
Embed = require 'nn-embed'
clocks = require './src/clocks.coffee'

window.d3 = d3

do ->
  Embed.initialize
    namespace: "clocks"
    initApp: (App) ->
      App.d3 = d3
    initPlayer: (player, App) ->
      # new clocks.Clocks player.el, new clocks.DebugDriver(),  new clocks.ForwardStepper()
      new clocks.Clocks player.el, new clocks.BitmapDriver(), new clocks.DirectStepper()
