local class = require 'lib/middleclass'
utils = require 'utils'

local camera = class('Camera')

camera.x = 0
camera.y = 0
camera.currentX = 0
camera.currentY = 0
camera.lerpFactor = 0.2
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0
camera.centered = true
camera.shakeFrequency = 0.5
camera.shakeMagnitude = 15

camera.time = 0

function camera:initialize(params)
  params = params or {}
  for i, v in ipairs(params) do
    self[i] = v
  end
end

function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)

  local windowX, windowY = love.graphics.getDimensions()

  local scale = (windowX/IDEAL_SIZE['x'] + windowY/IDEAL_SIZE['y'])/2
  love.graphics.scale(1/self.scaleX*scale, 1/self.scaleY*scale)

  local shakeX = love.math.noise(self.time*self.shakeFrequency)*self.shakeMagnitude
  local shakeY = love.math.noise(self.time*self.shakeFrequency + 900.3)*self.shakeMagnitude

  local x, y = self.currentX + shakeX, self.currentY + shakeY
  if self.centered then
    x = x - windowX/2/scale
    y = y - windowY/2/scale
  end
  love.graphics.translate(-x, -y)
end

function camera:unset()
  love.graphics.pop()
end

function camera:move(dx, dy)
  self.currentX = self.currentX + (dx or 0)
  self.currentY = self.currentY + (dy or 0)
end

function camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function camera:setPosition(x, y)
  self.currentX = x or self.currentX
  self.currentY = y or self.currentY
end

function camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

function camera:update(dt)
  self.currentX = self.currentX + utils.asymptote(self.x - self.currentX, self.lerpFactor, dt)
  self.currentY = self.currentY + utils.asymptote(self.y - self.currentY, self.lerpFactor, dt)
  self.time = self.time + dt
end

return camera
