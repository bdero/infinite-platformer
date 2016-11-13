local Engine = require 'engine'
local Camera = require 'camera'
local Map = require 'map'
local Player = require 'player'

local engine, canvas, environmentShader, camera, map, player

local FIXED_UPDATE_RATE = 1/120
local _fixedUpdateTime = 0

function love.load(arg)
  local sizeX, sizeY = 640, 480

  love.window.setMode(1024, 768, {
    resizable=true, minwidth=130, minheight=100--, highdpi=true
  })
  love.window.setTitle("Test")

  camera = Camera({idealX=sizeX, idealY=sizeY})
  camera:setActive()
  camera:setScale(1, 1)

  map = Map()
  map:setActive()

  player = Player()

  engine = Engine()
  engine:add(camera)
  engine:add(map)
  engine:add(player)

  environmentShader = love.graphics.newShader('shaders/environment.frag')
end

function love.update(dt)
  if love.fixedUpdate then
    _fixedUpdateTime = _fixedUpdateTime + dt
    while _fixedUpdateTime > FIXED_UPDATE_RATE do
      love.fixedUpdate()
      _fixedUpdateTime = _fixedUpdateTime - FIXED_UPDATE_RATE
    end
  end
  engine:update(dt)
end

function love.fixedUpdate()
  engine:fixedUpdate()
end

function love.draw()
  if not canvas or canvas:getDimensions() ~= love.graphics.getDimensions() then
    canvas = love.graphics.newCanvas(love.graphics.getDimensions())
  end

  love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.setBlendMode('alpha')

    Camera.set()
      engine:draw()
    Camera.unset()
  love.graphics.setCanvas()

  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.setShader(environmentShader)
    environmentShader:send('time', love.timer.getTime())
    environmentShader:send('sun_pos', {love.graphics.getWidth()/2, love.graphics.getHeight()/2, -500})
    environmentShader:send('camera_pos', {camera.ACTIVE.currentX, camera.ACTIVE.currentY})
    environmentShader:send('viewport_scale', camera.ACTIVE:getViewportScale())
    environmentShader:send('screen_size', {love.graphics.getDimensions()})
    love.graphics.draw(canvas, 0, 0)
  love.graphics.setShader()
end
