require("require")

function love.load()
	global.load()
	ring.load()
	worms.load()
	back.load()
	love.graphics.setBackgroundColor(0.3, 0.3, 0.3)
end

function love.update(dt)
	back.update(dt)
	ring.update(dt)
	worms.update(dt)
end

function love.draw()
	back.draw()
	ring.draw()
	worms.draw()
end

function love.keypressed(key)
	back.keypressed(key)
	ring.keypressed(key)
end

function love.keyreleased(key)
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
end

