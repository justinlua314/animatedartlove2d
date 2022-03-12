require("require")

function love.load()
	global.load()
	intro.load()
	poly.load()
	techs.load()
	love.graphics.setBackgroundColor(0.3, 0.3, 0.3)
end

function love.update(dt)
	intro.update(dt)
	poly.update(dt)
	adds.update(dt)
	techs.update(dt)
end

function love.draw()
	intro.draw()
	adds.draw()
	poly.draw()
	techs.draw()
end

function love.keypressed(key)
	intro.keypressed(key)
	adds.keypressed(key)
	poly.keypressed(key)
end
