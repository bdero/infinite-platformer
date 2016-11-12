local Camera = require 'camera'
local Map = require 'map'
local Player = require 'player'

local canvas, volumetricShader, camera, map, player

local FIXED_UPDATE_RATE = 1/120
local _fixedUpdateTime = 0

function love.load(arg)
  local sizeX, sizeY = 640, 480

  love.window.setMode(1024, 768, {
    resizable=true, minwidth=130, minheight=100--, highdpi=true
  })
  love.window.setTitle("Test")
  love.graphics.setBackgroundColor(200, 210, 230)

  camera = Camera({idealX=sizeX, idealY=sizeY})
  camera:setActive()
  camera:setScale(1, 1)

  map = Map()
  map:setActive()

  player = Player()

  volumetricShader = love.graphics.newShader('shaders/volumetric.frag')
end

function love.update(dt)
  if love.fixedUpdate then
    _fixedUpdateTime = _fixedUpdateTime + dt
    while _fixedUpdateTime > FIXED_UPDATE_RATE do
      love.fixedUpdate()
      _fixedUpdateTime = _fixedUpdateTime - FIXED_UPDATE_RATE
    end
  end
  player:update(dt)
  Camera.update(dt)
end

function love.fixedUpdate()
  player:fixedUpdate()
end

function love.draw()
  if not canvas or canvas:getDimensions() ~= love.graphics.getDimensions() then
    canvas = love.graphics.newCanvas(love.graphics.getDimensions())
  end

  love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.setBlendMode('alpha')

    Camera.set()
      Map.draw()
      player:draw()
    Camera.unset()
  love.graphics.setCanvas()

  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.setShader(volumetricShader)
    volumetricShader:send('time', love.timer.getTime())
    volumetricShader:send('sun_pos', {love.graphics.getWidth()/2, love.graphics.getHeight()/2, -500})
    love.graphics.draw(canvas, 0, 0)
  love.graphics.setShader()
end
