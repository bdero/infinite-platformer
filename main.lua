local Camera = require 'camera'
local Map = require 'map'
local Player = require 'player'

local camera, map, player

function love.load(arg)
  local sizeX, sizeY = 640, 480

  love.window.setMode(sizeX, sizeY, {
    resizable=true, minwidth=130, minheight=100, highdpi=true
  })
  love.window.setTitle("Test")
  love.graphics.setBackgroundColor(200, 210, 230)

  camera = Camera({idealX=sizeX, idealY=sizeY})
  camera:setActive()
  camera:setScale(1, 1)

  map = Map()
  map:setActive()

  player = Player()
end

function love.update(dt)
  player:update(dt)
  Camera.ACTIVE:setPosition(player.x, player.y)
  Camera.update(dt)
end

function love.draw()
  Camera.set()
    Map.draw()
    player:draw()
  Camera.unset()
end
