local Camera = require 'camera'
local Player = require 'player'

IDEAL_SIZE = {x=640, y=480}


function love.load(arg)
  love.window.setMode(IDEAL_SIZE['x'], IDEAL_SIZE['y'], {
    resizable=true, minwidth=130, minheight=100, highdpi=true
  })
  love.window.setTitle("Test")
  love.graphics.getBackgroundColor(200, 210, 230)

  camera = Camera()
end

function love.update(dt)
  camera.x, camera.y = objects.player.body:getPosition()
  vx, vy = objects.player.body:getLinearVelocity()
  objects.player.body:setLinearVelocity(vx, vy + 9.8)

  camera:update(dt)
end

function love.draw()

  camera:set()
    love.graphics.circle('fill', 0, 0, 50, 5)
  camera:unset()
end
