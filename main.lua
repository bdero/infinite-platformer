IDEAL_SIZE = {x=640, y=480}
local camera = require('camera')

function love.load(arg)
  love.window.setMode(IDEAL_SIZE['x'], IDEAL_SIZE['y'], {
    resizable=true, minwidth=130, minheight=100, highdpi=true
  })
end

function love.update(dt)
  camera:update(dt)
end

function love.draw()

  camera:set()
    love.graphics.circle('fill', 0, 0, 50, 5)
  camera:unset()
end
