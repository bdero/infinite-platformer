local Rect = require 'rect'

local BoundingBox = {}

function BoundingBox.bbInit(self, width, height)
  self._bbWidth = width
  self._bbHeight = height
end

function BoundingBox.bbGetRect(self)
  return Rect(self.x, self.y, self._bbWidth, self._bbHeight)
end

function BoundingBox.bbIsOverlapping(self, other)
  return other.isOverlapping(self:bbGetRect())
end

function BoundingBox.bbProcessCollision(self)

end

return BoundingBox
