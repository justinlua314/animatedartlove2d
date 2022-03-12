techs = {
	count = 20,
	speed = 150,
	colorSpeed = 1,

	list = {}
}

function techs.load()
	for i = 1,techs.count do
		table.insert(techs.list, {
			x = love.math.random(global.screen.w),
			y = love.math.random(global.screen.h),

			tx = love.math.random(global.screen.w),
			ty = love.math.random(global.screen.h),

			color = global.color.random(),
			target = global.color.random()
		})
	end
end

function techs.update(dt)
	for tech = 1,#techs.list do
		local clamp = {x = nil, y = nil}

		techs.list[tech].x, clamp.x = global.math.pursue(
			techs.list[tech].x, techs.list[tech].tx, (techs.speed * dt)
		)

		techs.list[tech].y, clamp.y = global.math.pursue(
			techs.list[tech].y, techs.list[tech].ty, (techs.speed * dt)
		)

		if clamp.x then
			techs.list[tech].tx = love.math.random(global.screen.w)
		end

		if clamp.y then
			techs.list[tech].ty = love.math.random(global.screen.h)
		end

		local finished
		techs.list[tech].color, finished = global.color.shift(
			techs.list[tech].color, techs.list[tech].target,
			(techs.colorSpeed * dt)
		)

		if finished then
			techs.list[tech].target = global.color.random()
		end
	end
end

function techs.draw()
	local a = (poly.backgroundAlpha - poly.stencilAlpha)
	a = global.math.clamp(a, 0, 1)

	for _,tech in pairs(techs.list) do
		love.graphics.setColor({
			tech.color[1],
			tech.color[2],
			tech.color[3],
			a
		})
		love.graphics.line(tech.x, tech.y, tech.x, 0)
		love.graphics.line(tech.x, tech.y, tech.x, global.screen.h)
		love.graphics.line(tech.x, tech.y, 0, tech.y)
		love.graphics.line(tech.x, tech.y, global.screen.w, tech.y)
	end
end
