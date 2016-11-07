local Rect = require 'rect'
local MapSensor = require 'mapsensor'

local BoundingBox = {}

function BoundingBox.bbInit(self, width, height)
  self._bbWidth = width
  self._bbHeight = height
  self._bbBottomSensor = MapSensor(self, Rect(
    0, height/2 - 5/2, 10, 5
  ))
end

function BoundingBox.bbGetRect(self)
  return Rect(self.x, self.y, self._bbWidth, self._bbHeight)
end

function BoundingBox.bbProcessCollision(self)
  return self._bbBottomSensor:processCollision(0, -1)
end

return BoundingBox
