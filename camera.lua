local class = require 'lib/middleclass'
local utils = require 'utils'

local Camera = class('Camera')

Camera.x = 0
Camera.y = 0
Camera.currentX = 0
Camera.currentY = 0
Camera.lerpFactor = 0.2
Camera.idealX = 640
Camera.idealY = 480
Camera.scaleX = 1
Camera.scaleY = 1
Camera.rotation = 0
Camera.centered = true
Camera.shakeFrequency = 0.5
Camera.shakeMagnitude = 15

Camera.time = 0

Camera.static.ACTIVE = nil

Camera.static.set = function()
  if Camera.ACTIVE then
    Camera.ACTIVE:set()
  end
end

Camera.static.unset = function()
  if Camera.ACTIVE then
    Camera.ACTIVE:unset()
  end
end

Camera.static.update = function(dt)
  if Camera.ACTIVE then
    Camera.ACTIVE:update(dt)
  end
end

function Camera:initialize(settings)
  local settings = settings or {}
  for i, v in pairs(settings) do
    self[i] = v
  end

  if Camera.ACTIVE == nil then
    self:setActive()
  end
end

function Camera:setActive()
  Camera.ACTIVE = self
end

function Camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)

  local windowX, windowY = love.graphics.getDimensions()

  local scale = self:getViewportScale()
  love.graphics.scale(1/self.scaleX*scale, 1/self.scaleY*scale)

  local shakeX = love.math.noise(self.time*self.shakeFrequency)*self.shakeMagnitude
  local shakeY = love.math.noise(self.time*self.shakeFrequency + 900.327)*self.shakeMagnitude

  local x, y = self.currentX + shakeX, self.currentY + shakeY
  if self.centered then
    x = x - windowX*self.scaleX/scale/2
    y = y - windowY*self.scaleY/scale/2
  end
  love.graphics.translate(-x, -y)
end

function Camera:getViewportScale()
  local windowX, windowY = love.graphics.getDimensions()
  return (windowX/self.idealX + windowY/self.idealY)/2
end

function Camera:unset()
  love.graphics.pop()
end

function Camera:getViewport()
  local ww, wh = love.graphics.getDimensions()
  local scaleFactor = self:getViewportScale()
  local sw, sh = ww*self.scaleX/scaleFactor/2, wh*self.scaleY/scaleFactor/2
  return self.x - sw, self.y - sh, self.x + sw, self.y + sh
end

function Camera:move(dx, dy)
  self.currentX = self.currentX + (dx or 0)
  self.currentY = self.currentY + (dy or 0)
end

function Camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function Camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function Camera:setPosition(x, y)
  self.currentX = x or self.currentX
  self.currentY = y or self.currentY
end

function Camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

function Camera:update(dt)
  self.currentX = self.currentX + utils.asymptote(self.x - self.currentX, self.lerpFactor, dt)
  self.currentY = self.currentY + utils.asymptote(self.y - self.currentY, self.lerpFactor, dt)
  self.time = self.time + dt
end

return Camera
