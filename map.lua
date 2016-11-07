class = require 'lib/middleclass'
Camera = require 'camera'


Map = class('Map')

Map.static.TILE_SIZE = 20
Map.static.ACTIVE = nil

Map.static.draw = function()
  if Map.ACTIVE then
    Map.ACTIVE:draw()
  end
end

function Map:initialize()
end

function Map:setActive()
  Map.ACTIVE = self
end

function Map:sample(x, y)
  local noise = love.math.noise(x*0.117/3, y*0.117)
  return noise < 0.56
end

function Map:draw()
  local ax, ay, bx, by = Camera.ACTIVE:getViewport()

  local minx = math.floor(ax/Map.TILE_SIZE)
  local miny = math.floor(ay/Map.TILE_SIZE)
  local maxx = math.ceil(bx/Map.TILE_SIZE) + 1
  local maxy = math.ceil(by/Map.TILE_SIZE) + 1

  love.graphics.setColor(0, 0, 0)
  for y = miny, maxy do
    for x = minx, maxx do
      if self:sample(x, y) then
        love.graphics.rectangle(
          'fill',
          x*Map.TILE_SIZE - Map.TILE_SIZE/2,
          y*Map.TILE_SIZE - Map.TILE_SIZE/2,
          Map.TILE_SIZE,
          Map.TILE_SIZE
        )
      end
    end
  end
end

return Map
