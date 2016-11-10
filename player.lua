local class = require 'lib/middleclass'
local utils = require 'utils'
local BoundingBox = require 'mixins/boundingbox'
local Camera = require 'camera'

local Player = class('Player')

Player.x = 0
Player.y = 0
Player.velX = 0
Player.velY = 0
Player.accX = 0
Player.accY = 0.098*1.5
Player.jumpTicks = 0

Player.static.MAX_JUMP_TICKS = 20

Player:include(BoundingBox)

function Player:initialize()
  self:bbInit(16, 32)
end

function Player:fixedUpdate()
  local leftPressed = love.keyboard.isDown('a', 'left')
  local rightPressed = love.keyboard.isDown('d', 'right')
  local jumpPressed = love.keyboard.isDown('space')

  self.accX = 0
  if leftPressed then
    self.accX = self.accX - 0.1
  end
  if rightPressed then
    self.accX = self.accX + 0.1
  end

  self.velX = utils.clamp(-5, 5, self.velX + self.accX)
  self.velY = self.velY + self.accY

  if (not leftPressed or rightPressed) and self.velX < 0 then
    self.velX = math.min(0, self.velX + 0.1)
  end
  if (not rightPressed or leftPressed) and self.velX > 0 then
    self.velX = math.max(0, self.velX - 0.1)
  end

  local top, bottom, left, right = false, false, false, false
  for i = 1, 4 do
    self.x = self.x + self.velX/4
    self.y = self.y + self.velY/4

    local t, b, l, r = self:bbProcessCollision()
    top = top or t
    bottom = bottom or b
    left = left or l
    right = right or r
  end

  if top or bottom then
    self.velY = 0
  end
  if left or right then
    self.velX = 0
  end

  if not jumpPressed then
    self.jumpTicks = Player.MAX_JUMP_TICKS
  else
    if bottom then
      self.jumpTicks = 0
    end
    if self.jumpTicks < Player.MAX_JUMP_TICKS then
      self.velY = -3.5 - math.abs(self.velX/10)
    end
    self.jumpTicks = self.jumpTicks + 1
  end
end

function Player:update(dt)
  Camera.ACTIVE:setPosition(self.x + self.velX*70, self.y + self.velY*60)
end

function Player:draw()
  love.graphics.setColor(100, 100, 100)
  love.graphics.rectangle('fill', self:bbGetRect():getXYWH())
end

return Player
