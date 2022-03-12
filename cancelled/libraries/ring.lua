ring = {
	thickness = 4,
	density = 300,
	speed = 0.25,
	breathSpeed = 4,
	colorSpeed = 0.008,
	size = {
		min = 200,
		max = 750
	},

	breathing = false,
	shifting = false,
	rotating = false,
	layers = {}
}

function ring.refresh()
	for _,layer in pairs(ring.layers) do
		for k,point in pairs(layer.lines) do
			local x, y = global.math.plotUnitCirclePoint(
				ring.cx, ring.cy, point.radius,
				(((math.pi * 2) * (k / ring.density)) + layer.rotation)
			)

			point.x = x
			point.y = y
		end
	end
end

function ring.load()
	ring.cx, ring.cy = global.screen.center()

	for i = 1,4 do
		table.insert(ring.layers, {
			x = 0, y = 0,
			rotation = 0,
			lines = {}
		})

		if i == 1 or i == 4 then
			ring.layers[i].colors = {
				global.color.random(),
				global.color.random()
			}

			ring.layers[i].targets = {
				global.color.random(),
				global.color.random()
			}
		end

		local toggle = true

		for point = 1,ring.density do
			local r = love.math.random(ring.size.min, ring.size.max)
			local c

			if i == 1 or i == 4 then
				if toggle then
					c = ring.layers[i].colors[1]
				else
					c = ring.layers[i].colors[2]
				end

				toggle = not toggle
			else
				c = global.color.random()
			end

			table.insert(ring.layers[i].lines, {
				radius = r,
				rtarget = love.math.random(ring.size.min, ring.size.max),
				color = c
			})
		end
	end

	for k,layer in pairs(ring.layers) do
		if k == 1 or k == 4 then
			layer.target = global.color.random()
		else
			for _,line in pairs(layer.lines) do
				line.target = global.color.random()
			end
		end
	end

	ring.layers[2].x = ring.cx
	ring.layers[3].y = ring.cy
	ring.layers[4].x = ring.cx
	ring.layers[4].y = ring.cy

	ring.refresh()
end

function ring.draw()
	love.graphics.setLineWidth(ring.thickness)
	for _,layer in pairs(ring.layers) do
		love.graphics.stencil(function()
			love.graphics.rectangle("fill", layer.x, layer.y, ring.cx, ring.cy)
		end, "replace", 1)

		love.graphics.setStencilTest("greater", 0)
			for _,line in pairs(layer.lines) do
				love.graphics.setColor(line.color)
				love.graphics.line(ring.cx, ring.cy, line.x, line.y)
			end
		love.graphics.setStencilTest()
	end
end

function ring.update(dt)
	if ring.rotating then
		for _,layer in pairs(ring.layers) do
			layer.rotation = (layer.rotation + (dt * ring.speed))
		end

		ring.refresh()
	end

	if ring.breathing then
		for _,layer in pairs(ring.layers) do
			for _,line in pairs(layer.lines) do
				line.radius, complete = global.math.pursue(line.radius, line.rtarget, ring.breathSpeed)
				
				if complete then
					line.rtarget = love.math.random(ring.size.min, ring.size.max)
				end
			end
		end

		if not love.keyboard.isDown("r") then
			ring.refresh()
		end
	end

	if ring.shifting then
		local complete

		for k,layer in pairs(ring.layers) do
			if k == 1 or k == 4 then
				layer.colors[1], complete = global.color.shift(
					layer.colors[1], layer.targets[1], ring.colorSpeed
				)

				if complete then layer.targets[1] = global.color.random() end

				layer.colors[2], complete = global.color.shift(
					layer.colors[2], layer.targets[2], ring.colorSpeed
				)

				if complete then layer.targets[2] = global.color.random() end
			else
				for _,line in pairs(layer.lines) do
					line.color, complete = global.color.shift(
						line.color, line.target, ring.colorSpeed
					)

					if complete then line.target = global.color.random() end
				end
			end
		end
	end
end

function ring.keypressed(key)
	if key == "c" then
		ring.shifting = not ring.shifting
	end

	if key == "b" then
		ring.breathing = not ring.breathing
	end

	if key == "r" then
		ring.rotating = not ring.rotating
	end
end
