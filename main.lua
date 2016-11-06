local Camera = require 'camera'

IDEAL_SIZE = {x=640, y=480}


function love.load(arg)
  love.window.setMode(IDEAL_SIZE['x'], IDEAL_SIZE['y'], {
    resizable=true, minwidth=130, minheight=100, highdpi=true
  })
  love.window.setTitle("Test")
  love.graphics.getBackgroundColor(200, 210, 230)

  love.physics.setMeter(64)
  world = love.physics.newWorld(0, 9.81*64, true)

  camera = Camera()

  objects = {}

  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, 0, -50/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
  objects.ground.shape = love.physics.newRectangleShape(250, 50) --make a rectangle with a width of 650 and a height of 50
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape) --attach shape to body

  objects.player = {}
  objects.player.body = love.physics.newBody(world, 0, 0, "kinematic")
  objects.player.body:setFixedRotation(true)
  objects.player.shape = love.physics.newRectangleShape(32, 64)
  objects.player.fixture = love.physics.newFixture(objects.player.body, objects.player.shape, 1)
end

function love.update(dt)
  world:update(dt)

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
