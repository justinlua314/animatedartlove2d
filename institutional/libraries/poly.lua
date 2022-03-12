poly = {
	count = 2500,
	pointCap = 12,
	lineWidth = 3,

	stencilCount = 250,
	stencilSizeCap = {
		min = 50,
		max = 200
	},
	stencilSpeed = 100,

	shiftPhaseSpeed = 0.25,

	background = nil,
	list = {},
	stencils = {},
	backgroundAlpha = 0,
	stencilAlpha = 0,
}

function poly.getCanvas()
	local canvas = love.graphics.newCanvas()
	local polys = {}

	for i = 1,poly.count do
		table.insert(polys, {
			x = love.math.random(global.screen.w),
			y = love.math.random(global.screen.h),
			color = global.color.random(),
			targetColor = global.color.random(),
		})
	end

	for _,shape in pairs(polys) do
		shape.points = global.math.equalPolygon(
			shape.x, shape.y,
			love.math.random(10, 50),
			love.math.random(3, poly.pointCap),
			love.math.random(0, (math.pi * 2))
		)
	end

	love.graphics.setCanvas(canvas)
		for _,shape in pairs(polys) do
			love.graphics.setColor(shape.color)
			love.graphics.polygon("fill", shape.points)
			love.graphics.setColor(0, 0, 0)
			love.graphics.polygon("line", shape.points)
		end
	love.graphics.setCanvas()

	return canvas
end

function poly.load()
	love.graphics.setLineWidth(poly.lineWidth)
	poly.background = poly.getCanvas()

	for i = 1,poly.stencilCount do
		table.insert(poly.stencils, {
			pos = {
				x = love.math.random(-250, (global.screen.w + 250)),
				y = love.math.random(-250, (global.screen.h + 250))
			},

			target = {
				x = love.math.random(-250, (global.screen.w + 250)),
				y = love.math.random(-250, (global.screen.h + 250))
			},

			w = love.math.random(poly.stencilSizeCap.min, poly.stencilSizeCap.max),
			h = love.math.random(poly.stencilSizeCap.min, poly.stencilSizeCap.max),

			render = poly.getCanvas()
		})
	end
end

function poly.update(dt)
	for _,stencil in pairs(poly.stencils) do
		stencil.pos.x, xClamped = global.math.pursue(
			stencil.pos.x, stencil.target.x,
			(poly.stencilSpeed * dt)
		)

		stencil.pos.y, yClamped = global.math.pursue(
			stencil.pos.y, stencil.target.y,
			(poly.stencilSpeed * dt)
		)

		if xClamped then
			stencil.target.x = love.math.random(-250, (global.screen.w + 250))
		end

		if yClamped then
			stencil.target.y = love.math.random(-250, (global.screen.h + 250))
		end
	end

	if love.keyboard.isDown("up") then
		if love.keyboard.isDown("lshift") then
			if poly.backgroundAlpha < 1 then
				poly.backgroundAlpha = (poly.backgroundAlpha + (poly.shiftPhaseSpeed * dt))
			end
		else
			if poly.stencilAlpha < 1 then
				poly.stencilAlpha = (poly.stencilAlpha + (poly.shiftPhaseSpeed * dt))
			end
		end
	end

	if love.keyboard.isDown("down") then
		if love.keyboard.isDown("lshift") then
			if poly.backgroundAlpha > 0 then
				poly.backgroundAlpha = (poly.backgroundAlpha - (poly.shiftPhaseSpeed * dt))
			end
		else
			if poly.stencilAlpha > 0 then
				poly.stencilAlpha = (poly.stencilAlpha - (poly.shiftPhaseSpeed * dt))
			end
		end
	end
end

function poly.draw()
	love.graphics.setColor(1, 1, 1, poly.backgroundAlpha)
	love.graphics.draw(poly.background)
	love.graphics.setColor(1, 1, 1, poly.stencilAlpha)

	for _,stencil in pairs(poly.stencils) do
		love.graphics.stencil(
			function()
				love.graphics.rectangle(
					"fill", stencil.pos.x, stencil.pos.y,
					stencil.w, stencil.h
				)
			end, "replace", 1
		)

		love.graphics.setStencilTest("greater", 0)
			love.graphics.draw(stencil.render)
		love.graphics.setStencilTest()
	end
end

function poly.keypressed(key)
	if key == "g" then
		for _,stencil in pairs(poly.stencils) do
			stencil.pos.x = love.math.random(-250, (global.screen.w + 250))
			stencil.pos.y = love.math.random(-250, (global.screen.h + 250))
		end
	end
end
