worms = {
	count = 40,
	segments = 4,
	thickness = 10,
	speed = 0.001,
	border = 20,

	textureThickness = 5,

	list = {},
	timer = 0,
	paused = false,
	alpha = 0
}

function worms.texture()
	local texture = love.graphics.newCanvas()

	love.graphics.setCanvas(texture)
		local colors = {
			global.color.random(),
			global.color.random()
		}
		
		love.graphics.setLineWidth(worms.textureThickness)
		local r = 10
		local toggle = true

		while r < global.screen.h do
			if toggle then
				love.graphics.setColor(colors[1])
			else
				love.graphics.setColor(colors[2])
			end

			love.graphics.circle("line", ring.cx, ring.cy, r)
			r = (r + worms.textureThickness)
			toggle = not toggle
		end
	love.graphics.setCanvas()
	return texture
end

function worms.point(right)
	local x, y
	
	if right then
		x = love.math.random(ring.cx, (global.screen.w - worms.border))
	else
		x = love.math.random(worms.border, ring.cx)
	end

	y = love.math.random(worms.border, (global.screen.h - worms.border))

	return x,y
end

function worms.load()
	local right = true

	for i = 1,worms.count do
		table.insert(worms.list, {
			right = right,
			texture = worms.texture(),
			segments = {}
		})

		for s = 1,worms.segments do
			local tx, ty = worms.point(right)
			table.insert(worms.list[i].segments, {
				x = love.math.random(worms.border, (global.screen.w - worms.border)),
				y = love.math.random(worms.border, (global.screen.h - worms.border)),

				tx = tx,
				ty = ty
			})
		end

		right = not right
	end

	worms.timer = worms.speed
end

function worms.update(dt)
	if love.keyboard.isDown("up") then
		worms.alpha = (worms.alpha + dt)
	end

	if love.keyboard.isDown("down") then
		worms.alpha = (worms.alpha - dt)
	end

	worms.alpha = global.math.clamp(worms.alpha, 0, 1)

	if worms.paused then return end

	worms.timer = (worms.timer - dt)

	if worms.timer <= 0 then
		local cx, cy = global.screen.center()
		worms.timer = (worms.timer + worms.speed)

		local right = true
		for _,worm in pairs(worms.list) do
			local points = {cx, cy}
			for _,segment in pairs(worm.segments) do
				segment.x, complete = global.math.pursue(segment.x, segment.tx, 1)
				local tx, ty = worms.point(right)

				if complete then
					segment.tx = tx
				end

				segment.y, complete = global.math.pursue(segment.y, segment.ty, 1)

				if complete then
					segment.ty = ty
				end

				table.insert(points, segment.x)
				table.insert(points, segment.y)
			end

			local bezier = love.math.newBezierCurve(points)
			worm.render = bezier:render()
			right = not right
		end
	end
end

function worms.draw()
	if not worms.list[1].render then return end
	love.graphics.setLineWidth(worms.thickness)
	for _,worm in pairs(worms.list) do
		love.graphics.stencil(function()
			love.graphics.line(worm.render)
		end, "replace", 1)

		love.graphics.setStencilTest("greater", 0)
			love.graphics.setColor(1, 1, 1, worms.alpha)
			love.graphics.draw(worm.texture)
		love.graphics.setStencilTest()
	end
end
