local Rect = require 'rect'
local MapSensor = require 'mapsensor'

local BoundingBox = {}

function BoundingBox.bbInit(self, width, height)
  local sensorWidth = 5
  self._bbWidth = width
  self._bbHeight = height
  self._bbBottomSensor = MapSensor(self, Rect(
    0, height/2 - sensorWidth/2, 10, sensorWidth
  ))
  self._bbTopSensor = MapSensor(self, Rect(
    0, -height/2 + sensorWidth/2, 10, sensorWidth
  ))
  self._bbLeftSensor = MapSensor(self, Rect(
    -width/2 + sensorWidth/2, sensorWidth, 10
  ))
  self._bbRightSensor = MapSensor(self, Rect(
    width/2 - sensorWidth/2, sensorWidth, 10
  ))
end

function BoundingBox.bbGetRect(self)
  return Rect(self.x, self.y, self._bbWidth, self._bbHeight)
end

function BoundingBox.bbProcessCollision(self)
  local left = self._bbLeftSensor:processCollision(1, 0)
  local right = self._bbRightSensor:processCollision(-1, 0)
  local bottom = self._bbBottomSensor:processCollision(0, -1)
  local top = self._bbTopSensor:processCollision(0, 1)

  return top, bottom, left, right
end

return BoundingBox
