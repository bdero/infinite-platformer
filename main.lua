local Camera = require 'camera'
local Player = require 'player'
local Map = require 'map'

IDEAL_SIZE = {x=640, y=480}


function love.load(arg)
  love.window.setMode(IDEAL_SIZE['x'], IDEAL_SIZE['y'], {
    resizable=true, minwidth=130, minheight=100, highdpi=true
  })
  love.window.setTitle("Test")
  love.graphics.getBackgroundColor(200, 210, 230)

  camera = Camera()
  camera:setActive()

  map = Map()
end

function love.update(dt)
  Camera.update(dt)
end

function love.draw()
  Camera.set()
    map:draw()
  Camera.unset()
end
