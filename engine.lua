local class = require('lib/middleclass')

local Engine = class('Engine')

Engine.entities = {}

function Engine:add(entity)
  table.insert(self.entities, entity)
end

function Engine:remove(entity)
  for k, v in pairs(self.entities) do
    if v == entity then
      return table.remove(self.entities, k)
    end
  end
  return nil
end

function Engine:update(dt)
  for k, v in pairs(self.entities) do
    if v.update then
      v:update(dt)
    end
  end
end

function Engine:fixedUpdate()
  for k, v in pairs(self.entities) do
    if v.fixedUpdate then
      v:fixedUpdate()
    end
  end
end

function Engine:draw()
  for k, v in pairs(self.entities) do
    if v.draw then
      v:draw()
    end
  end
end

return Engine
