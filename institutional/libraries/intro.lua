intro = {
	count = 25,
	strobeSpeed = 200,
	colorSpeed = 2,
	chance = 800,

	spawns = {},
	circles = {},
	paused = true
}

function intro.add(x, y, r, color, target)
	table.insert(intro.circles, {
		x = x, y = y,
		color = color,
		target = target,
		r = r
	})
end

function intro.load()
	for i = 1,intro.count do
		intro.add(
			love.math.random(global.screen.w),
			love.math.random(global.screen.h),
			love.math.random(10, 30),
			global.color.random(),
			global.color.random()
		)
	end
end

function intro.update(dt)
	if intro.paused then return end
	local marks = {}

	for k,circle in pairs(intro.circles) do
		circle.r = (circle.r + (intro.strobeSpeed * dt))

		if circle.r > (global.screen.w * 1.5) then
			table.insert(marks, k)
		end

		if love.math.random(intro.chance) == 1 then
			intro.add(circle.x, circle.y, 0, circle.color, circle.target)
		end

		local finished
		circle.color, finished = global.color.shift(
			circle.color, circle.target, (intro.colorSpeed * dt)
		)

		if finished then
			circle.target = global.color.random()
		end
	end

	if love.math.random(math.ceil(intro.chance / 2)) == 1 then
		intro.add(
			love.math.random(global.screen.w),
			love.math.random(global.screen.h),
			love.math.random(10, 30),
			global.color.random(),
			global.color.random()
		)
	end

	if #marks > 0 then
		for i = #marks, 1, -1 do
			table.remove(intro.circles, marks[i])
		end
	end
end

function intro.draw()
	for _,circle in pairs(intro.circles) do
		love.graphics.setColor(love.graphics.getBackgroundColor())
		love.graphics.circle("fill", circle.x, circle.y, circle.r)
		love.graphics.setColor(circle.color)
		love.graphics.circle("line", circle.x, circle.y, circle.r)
	end
end

function intro.keypressed(key)
	if key == "space" then
		intro.paused = not intro.paused
	end
end
