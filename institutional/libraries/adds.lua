adds = {
	speed = 500,

	list = {}
}

function adds.add()
	local nx,ny = love.math.random(global.screen.w), love.math.random(global.screen.h)
	table.insert(adds.list, {x = nx, y = ny, r = 1})

	adds.list[#adds.list].render = global.math.equalPolygon(nx, ny, 1, 3)
end

function adds.update(dt)
	for k,add in pairs(adds.list) do
		if add.r < global.screen.w then
			add.r = (add.r + (adds.speed * dt))
			add.render = global.math.equalPolygon(add.x, add.y, add.r, 3)
		end
	end
end

function adds.draw()
	love.graphics.setColor(0, 0, 0)

	for _,add in pairs(adds.list) do
		love.graphics.polygon("line", add.render)
	end
end

function adds.keypressed(key)
	if key == "a" or key == "r" then
		adds.add()
	end
end
