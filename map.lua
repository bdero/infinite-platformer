require 'lib/middleclass'

map = {}
map = class('Map')

function map:initialize()
end

function map:sample(x, y)
  noise = love.math.noise(x)
end

return map
