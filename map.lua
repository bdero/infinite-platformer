class = require 'lib/middleclass'
Camera = require 'camera'


Map = class('Map')

Map.static.TILE_SIZE = 20

function Map:initialize()
end

function Map:sample(x, y)
  local noise = love.math.noise(x*0.117, y*0.117)
  return noise > 0.5
end

function Map:draw()
  local ax, ay, bx, by = Camera.ACTIVE:getViewport()

  local minx = math.floor(ax/Map.TILE_SIZE) - 1
  local miny = math.floor(ay/Map.TILE_SIZE) - 1
  local maxx = math.floor(ax/Map.TILE_SIZE) + 1
  local maxy = math.floor(ay/Map.TILE_SIZE) + 1

  for y = ay, by do
    for x = ax, bx do
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
