local class = require 'lib/middleclass'
local utils = require 'utils'
local Map = require 'map'
local Rect = require 'rect'

local MapSensor = class('MapSensor')

function MapSensor:initialize(parent, rect)
  self.parent = parent
  self.rect = rect
end

function MapSensor:getRect()
  return self.rect:addPosition(self.parent.x, self.parent.y)
end

function MapSensor:isOverlappingMap()
  local absoluteRect = self:getRect()
  local ax, ay, bx, by = Map.ACTIVE:getMinMaxAABB(absoluteRect:getAABB())

  for y = ay, by do
    for x = ax, bx do
      if Map.ACTIVE:sample(x, y) then
        local overlap = absoluteRect:isOverlapping(Rect(
          x*Map.TILE_SIZE, y*Map.TILE_SIZE,
          Map.TILE_SIZE, Map.TILE_SIZE
        ))
        if overlap then
          return true
        end
      end
    end
  end

  return false
end

function MapSensor:processCollision(axisName, axisSign)
  axisSign = axisSign
  local collision = false

  while self:isOverlappingMap() do
    collision = true
    self.parent[axisName] = self.parent[axisName] + axisSign
  end

  if collision then
    local operation = axisSign < 0 and math.ceil or math.floor
    self.parent[axisName] = operation(self.parent[axisName])
  end

  return collision
end

return MapSensor
