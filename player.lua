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
  if love.keyboard.isDown('a', 'left') then
    self.accX = -150
  elseif love.keyboard.isDown('d', 'right') then
    self.accX = 150
  end

  self.velX = self.velX + self.accX*dt
  self.velY = self.velY + self.accY*dt

  self.x = self.x + self.velX*dt
  self.y = self.y + self.velY*dt

  local yCol = self:bbProcessCollision()

  if yCol then
    self.velY = 0
  end
end

function Player:draw()
  love.graphics.setColor(100, 100, 100)
  love.graphics.rectangle('fill', self:bbGetRect():getXYWH())
end

return Player
