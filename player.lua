local class = require 'lib/middleclass'
local BoundingBox = require 'mixins/boundingbox'

local Player = class('Player')

Player.x = 0
Player.y = 0
Player.velX = 0
Player.velY = 0
Player.accX = 0
Player.accY = 9.8*20

Player:include(BoundingBox)

function Player:initialize()
  self:bbInit(16, 32)
end

function Player:update(dt)
  self.velX = self.velX + self.accX*dt
  self.velY = self.velY + self.accY*dt

  self.x = self.x + self.velX*dt
  self.y = self.y + self.velY*dt

  self:bbProcessCollision()
end

function Player:draw()
  local color = {255, 100, 100}
  if self:bbIsColliding() then
    color = {100, 255, 100}
  end

  love.graphics.setColor(unpack(color))
  love.graphics.rectangle('fill', self:bbGetRect():getXYWH())
end

return Player
