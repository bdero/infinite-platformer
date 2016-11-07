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

camera.static.ACTIVE = nil

camera.static.set = function()
  if camera.static.ACTIVE then
    camera.static.ACTIVE:set()
  end
end

camera.static.unset = function()
  if camera.static.ACTIVE then
    camera.static.ACTIVE:unset()
  end
end

camera.static.update = function(dt)
  if camera.static.ACTIVE then
    camera.static.ACTIVE:update(dt)
  end
end

function camera:initialize(params)
  params = params or {}
  for i, v in ipairs(params) do
    self[i] = v
  end
end

function camera:setActive()
  camera.static.ACTIVE = self
end

function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)

  local windowX, windowY = love.graphics.getDimensions()

  local scale = self.getViewportScale()
  love.graphics.scale(1/self.scaleX*scale, 1/self.scaleY*scale)

  local shakeX = love.math.noise(self.time*self.shakeFrequency)*self.shakeMagnitude
  local shakeY = love.math.noise(self.time*self.shakeFrequency + 900.3)*self.shakeMagnitude

  local x, y = self.currentX + shakeX, self.currentY + shakeY
  if self.centered then
    x = x - windowX*self.scaleX/scale/2
    y = y - windowY*self.scaleY/scale/2
  end
  love.graphics.translate(-x, -y)
end

function camera:getViewportScale()
  local windowX, windowY = love.graphics.getDimensions()
  return (windowX/IDEAL_SIZE['x'] + windowY/IDEAL_SIZE['y'])/2
end

function camera:unset()
  love.graphics.pop()
end

function camera:getViewport()
  local ww, wh = love.graphics.getDimensions()
  local scaleFactor = self.getViewportScale()
  local sw, sh = ww*self.scaleX/scaleFactor/2, wh*self.scaleY/scaleFactor/2
  return self.x - sw, self.y - sh, self.x + sw, self.y + sh
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
