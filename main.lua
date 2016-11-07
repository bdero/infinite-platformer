local Camera = require 'camera'
local Player = require 'player'
local Map = require 'map'

function love.load(arg)
  local sizeX, sizeY = 640, 480

  love.window.setMode(sizeX, sizeY, {
    resizable=true, minwidth=130, minheight=100, highdpi=true
  })
  love.window.setTitle("Test")
  love.graphics.setBackgroundColor(200, 210, 230)

  camera = Camera({idealX=sizeX, idealY=sizeY})
  camera:setActive()
  camera:setScale(3, 3)

  map = Map()
  map:setActive()
end

function love.update(dt)
  Camera.update(dt)
end

function love.draw()
  Camera.set()
    Map.draw()
  Camera.unset()
end
