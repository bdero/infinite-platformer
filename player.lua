local class = require 'lib/middleclass'
local BoundingBox = require 'mixins/boundingbox'
local utils = require 'utils'

local Player = class('Player')

Player.x = 0
Player.y = 0
Player.velX = 0
Player.velY = 0
Player.accX = 0
Player.accY = 9.8*200

Player:include(BoundingBox)

function Player:initialize()
  self:bbInit(16, 32)
end

function Player:update(dt)
  local leftPressed = love.keyboard.isDown('a', 'left')
  local rightPressed = love.keyboard.isDown('d', 'right')
  local jumpPressed = love.keyboard.isDown('space')

  self.accX = 0
  if leftPressed then
    self.accX = self.accX - 600
  end
  if rightPressed then
    self.accX = self.accX + 600
  end

  self.velX = utils.clamp(-300, 300, self.velX + self.accX*dt)
  self.velY = self.velY + self.accY*dt

  if not leftPressed and self.velX < 0 then
    self.velX = math.min(0, self.velX + 600*dt)
  end
  if not rightPressed and self.velX > 0 then
    self.velX = math.max(0, self.velX - 600*dt)
  end

  self.x = self.x + self.velX*dt
  self.y = self.y + self.velY*dt

  local top, bottom, left, right = self:bbProcessCollision()

  if top or bottom then
    self.velY = 0
  end
  if left or right then
    self.velX = 0
  end

  if jumpPressed and bottom then
    self.velY = -430
  end
end

function Player:draw()
  love.graphics.setColor(100, 100, 100)
  love.graphics.rectangle('fill', self:bbGetRect():getXYWH())
end

return Player
