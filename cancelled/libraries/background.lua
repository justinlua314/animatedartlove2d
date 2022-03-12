back = {
	count = 3000,
	speed = 0.005,

	size = {
		min = 20,
		max = 100
	},

	squares = {},
	paused = true,
	timer = 0
}

function back.add()
	local n = love.math.random(back.size.min, back.size.max)
	table.insert(back.squares, 1, {
		x = love.math.random(global.screen.w + 200),
		y = love.math.random(-200, global.screen.h),
		w = n,
		h = n,
		color = global.color.random()
	})
end

function back.load()
	for i = 1,back.count do
		back.add()
	end

	back.timer = back.speed
end

function back.update(dt)
	if back.paused then return end

	back.timer = (back.timer - dt)

	if back.timer <= 0 then
		back.timer = (back.timer + back.speed)
		
		local marks = {}

		for k,square in pairs(back.squares) do
			square.x = (square.x - 1)
			square.y = (square.y + 1)

			if (square.x + square.w) < 0 or square.y > global.screen.h then
				table.insert(marks, k)
			end
		end

		local count = #marks
		
		if count > 0 then
			for i = count, 1, -1 do
				table.remove(back.squares, marks[i])
			end

			for i = 1,count do
				back.add()
			end
		end
	end
end

function back.draw()
	for _,square in pairs(back.squares) do
		love.graphics.setColor(square.color)
		love.graphics.rectangle("fill", square.x, square.y, square.w, square.h)

		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("line", square.x, square.y, square.w, square.h)
	end
end

function back.keypressed(key)
	if key == "space" then
		back.paused = not back.paused
	end
end
