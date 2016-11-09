local Camera = require 'camera'
local Map = require 'map'
local Player = require 'player'

local camera, map, player

local FIXED_UPDATE_RATE = 1/120
local _fixedUpdateTime = 0

function love.run()
  -- Overridden to add a fixed update method.
  -- Taken and modified from 0.10.1 version on https://love2d.org/wiki/love.run
	if love.math then
		love.math.setRandomSeed(os.time())
	end

	if love.load then love.load(arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end

    if love.fixedUpdate then
      _fixedUpdateTime = _fixedUpdateTime + dt
      while _fixedUpdateTime > FIXED_UPDATE_RATE do
        love.fixedUpdate()
        _fixedUpdateTime = _fixedUpdateTime - FIXED_UPDATE_RATE
      end
    end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()
			if love.draw then love.draw() end
			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end

end

function love.load(arg)
  local sizeX, sizeY = 640, 480

  love.window.setMode(sizeX, sizeY, {
    resizable=true, minwidth=130, minheight=100, highdpi=true
  })
  love.window.setTitle("Test")
  love.graphics.setBackgroundColor(200, 210, 230)

  camera = Camera({idealX=sizeX, idealY=sizeY})
  camera:setActive()
  camera:setScale(1, 1)

  map = Map()
  map:setActive()

  player = Player()
end

function love.update(dt)
  player:update(dt)
  Camera.ACTIVE:setPosition(player.x, player.y)
  Camera.update(dt)
end

function love.fixedUpdate()
  player:fixedUpdate()
end

function love.draw()
  Camera.set()
    Map.draw()
    player:draw()
  Camera.unset()
end
