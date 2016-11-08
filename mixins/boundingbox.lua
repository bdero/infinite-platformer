local Rect = require 'rect'
local MapSensor = require 'mapsensor'

local BoundingBox = {}

function BoundingBox.bbInit(self, width, height)
  local sensorWidth = 6
  self._bbWidth = width
  self._bbHeight = height
  self._bbBottomSensor = MapSensor(self, Rect(
    0, height/2 - sensorWidth/2, 10, sensorWidth
  ))
  self._bbTopSensor = MapSensor(self, Rect(
    0, -height/2 + sensorWidth/2, 10, sensorWidth
  ))
  self._bbLeftSensor = MapSensor(self, Rect(
    -width/2 + sensorWidth/2, 0, sensorWidth, 10
  ))
  self._bbRightSensor = MapSensor(self, Rect(
    width/2 - sensorWidth/2, 0, sensorWidth, 10
  ))
end

function BoundingBox.bbGetRect(self)
  return Rect(self.x, self.y, self._bbWidth, self._bbHeight)
end

function BoundingBox.bbProcessCollision(self)
  local left = self.velX <= 0 and self._bbLeftSensor:processCollision('x', 1) or false
  local right = self.velX >= 0 and self._bbRightSensor:processCollision('x', -1) or false
  local bottom = self.velY >= 0 and self._bbBottomSensor:processCollision('y', -1) or false
  local top = self.velY <= 0 and self._bbTopSensor:processCollision('y', 1) or false

  return top, bottom, left, right
end

return BoundingBox
