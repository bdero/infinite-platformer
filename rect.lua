local class = require 'lib/middleclass'

local Rect = class('Rect')

function Rect:initialize(x, y, w, h, centered)
  self.x = x or 0
  self.y = y or 0
  self.width = w or 0
  self.height = h or 0
  self.centered = centered or true
end

function Rect:getXYWH()
  local x, y, w, h = self.x, self.y, self.width, self.height
  if self.centered then
    x, y = x - w/2, y - h/2
  end

  return x, y, w, h
end

function Rect:getAABB()
  local x, y, w, h = self:getXYWH()
  return x, y, x + w, y + h
end

function Rect:isOverlapping(other)
  --[[
           cy
      +-----------+
      |           |cx2
    cx|           |
      |           |   oy
      |        *--+-------*
      +--------+--+       |
        cy2    |          |
               |          |ox2
             ox|          |
               +----------+
                    oy2
  ]]
  local cy, cx, cy2, cx2 = self:getAABB()
  local ox, oy, ox2, oy2 = other:getAABB()

  return not(cx > ox2 or cx2 < ox or cy > oy2 or cy2 < oy)
end

return Rect
