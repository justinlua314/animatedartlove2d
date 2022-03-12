global = {
	devMode = true,
	screen = {
		w = 0,
		h = 0
	},

	math = {
		-- How close does a var need to be to it's pursue target to be set to the purse targets value
		pursueRoundValue = 0.1
	},

	string = {},
	table = {},

	mouse = {
		size = 5
	},

	color = {}
}

function global.load()
	local w, h = love.graphics.getDimensions()
	global.screen.w = w
	global.screen.h = h
end




-- Screen =============================================================================

function global.screen.center()
	return math.floor(global.screen.w / 2), math.floor(global.screen.h / 2)
end




-- Math ===============================================================================

function global.math.prime(n)
	for i = 2, (n^0.5) do
		if (n % i ) == 0 then return false end
	end

	return true
end

function global.math.clamp(var, lowerLimit, upperLimit)
	if var < lowerLimit then var = lowerLimit end
	if var > upperLimit then var = upperLimit end

	return var
end

function global.math.cossin(x, y, dx, dy)
	local angle = math.atan2((dy - y), (dx - x))
	return math.cos(angle), math.sin(angle)
end

function global.math.pursue(x, dx, change)
	local complete = false
	if x == dx then return x end
	if x > dx then
		x = (x - change)
		if (x - change) < dx then complete = true end
	else
		x = (x + change)
		if (x + change) > dx then complete = true end
	end

	if x > (dx - global.math.pursueRoundValue) and x < (dx + global.math.pursueRoundValue) then
		x = dx
		complete = true
	end

	return x, complete
end

function global.math.rectanglesOverlap(x, y, w, h, tx, ty, tw, th)
	local result = {
		x = false,
		y = false
	}

	if x < tx then
		result.x = ((x + w) >= tx)
	else
		result.x = ((tx + tw) >= x)
	end

	if y < ty then
		result.y = ((y + h) >= ty)
	else
		result.y = ((ty + th) >= y)
	end

	return (result.x and result.y)
end

function global.math.circlesOverlap(x, y, r, tx, ty, tr)
	return ((global.math.distance(x, y, tx, ty) - r) <= tr)
end

function global.math.distance(x, y, tx, ty)
	local dx = (x - tx)
	local dy = (y - ty)
	return math.floor(math.sqrt((dx * dx) + (dy * dy)))
end

function global.math.intersect(s1, e1, s2, e2)
	s1.x = s1.x or s1[1]
	s1.y = s1.y or s1[2]
	s2.x = s2.x or s2[1]
	s2.y = s2.y or s2[2]
	e1.x = e1.x or e1[1]
	e1.y = e1.y or e1[2]
	e2.x = e2.x or e2[1]
	e2.y = e2.y or e2[2]

	local x1,y1,x2,y2 = s1.x,s1.y,e1.x,e1.y
	local x3,y3,x4,y4 = s2.x,s2.y,e2.x,e2.y

	local t = (
		(((x1-x3)*(y3-y4)) - ((y1-y3)*(x3-x4))) /
		(((x1-x2)*(y3-y4)) - ((y1-y2)*(x3-x4)))
	)

	local u = (
		(((x2-x1)*(y1-y3)) - ((y2-y1)*(x1-x3))) /
		(((x1-x2)*(y3-y4)) - ((y1-y2)*(x3-x4)))
	)

	local answer = {}

	if 0 <= t and t <= 1 then
		answer.x = (x1 + (t * (x2 - x1)))
		answer.y = (y1 + (t * (y2 - y1)))
	elseif 0 <= u and u <= 1 then
		answer.x = (x3 + (t * (x4 - x3)))
		answer.y = (y3 + (t * (y4 - y3)))
	else
		answer = nil
	end

	return answer
end

function global.math.findNearest(point, tab, amount)
	point.x = math.ceil(point.x)
	point.y = math.ceil(point.y)
	local distances = {}
	for _,target in pairs(tab) do
		target.x = math.ceil(target.x)
		target.y = math.ceil(target.y)

		if not (target.x == point.x and target.y == point.y) then
			local distCheck
			local dist = global.math.distance(point.x, point.y, target.x, target.y)

			if #distances ~= 0 then
				for _,distance in pairs(distances) do
					if distance[1] == dist then
						distCheck = true
						break
					end
				end
			end

			if #distances == 0 or (#distances ~= 0 and distCheck ~= true) then
				local found

				for _,check in pairs(distances) do
					if check == dist then
						found = true; break
					end
				end

				if not found then
					table.insert(distances, {dist, target.x, target.y})
				end
			end
		end
	end

	local leaders = {}

	for i = 1,amount do
		local best = math.huge
		local exit

		for count,dist in pairs(distances) do
			if dist[1] < best then
				best = dist[1]
				exit = count
			end
		end

		if exit then
			table.insert(leaders, {x = distances[exit][2], y = distances[exit][3]})
			table.remove(distances, exit)
		end
	end

	if amount == 1 then
		return {x = leaders.x, y = leaders.y}
	else
		local t = {}

		for _,v in pairs(leaders) do
			table.insert(t, {x = v.x, y = v.y})
		end

		return t
	end
end

function global.math.equalPolygon(x, y, radius, count, rotation)
	rotation = rotation or 0
	local points = {}

	for i = 1,count do
		local tx, ty = global.math.plotUnitCirclePoint(
			x, y,
			radius,
			((((math.pi * 2) * (i / count)) + 0.52) + rotation)
		)
		table.insert(points, tx)
		table.insert(points, ty)
	end

	return points
end

-- Useful for plotting points around a center
function global.math.plotUnitCirclePoint(cx, cy, radius, angle)
	local x, y
	x = (radius * math.cos(angle) + cx)
	y = (radius * math.sin(angle) + cy)
	return x, y
end

function global.math.nearlyEqual(x, y, range)
	if (x >= y and (x - y) <= range) or (x < y and (y - x) <= range) then
		return true
	end

	return false
end



-- String =============================================================================

function global.string.explode(seperator, str)
	local t = {}

	for s in string.gmatch(str, "([^" .. seperator .. "]+)") do
		table.insert(t, s)
	end

	return t
end



-- Table ==============================================================================

function global.table.contains(tab, value)
	for _,v in pairs(tab) do
		if v == value then return true end

		if type(v) == "table" and type(value) == "table" then
			local identical = true

			for k,d in pairs(v) do
				if d ~= value[k] then identical = false end
			end

			if identical then return true end
		end
	end

	return false
end

function global.table.trim(tab)
	local t = {}

	for _,v in pairs(tab) do
		if not global.table.contains(t, v) then
			table.insert(t, v)
		end
	end

	return t
end

function global.table.deepCopy(orig, copies)
	copies = copies or {}
	local copy

	if type(orig) == "table" then
		if copies[orig] then
			copy = copies[orig]
		else
			copy = {}

			for key, value in next, orig do
				copy[global.table.deepCopy(key, copies)] = global.table.deepCopy(value, copies)
			end

			copies[orig] = copy
			setmetatable(copy, global.table.deepCopy(getmetatable(orig), copies))
		end
	else
		copy = orig
	end

	return copy
end



-- Mouse ==============================================================================

function global.mouse.draw()
	local mx, my = love.mouse.getPosition()
	love.graphics.setColor(0, 0, 0)
	love.graphics.line(mx, (my - global.mouse.size), mx, (my + global.mouse.size))
	love.graphics.line((mx - global.mouse.size), my, (mx + global.mouse.size), my)
end



-- Color ==============================================================================

function global.color.random(single, stream)
	if single then return (love.math.random(100) / 100) end

	if stream then
		return (love.math.random(100) / 100), (love.math.random(100) / 100), (love.math.random(100) / 100), 1
	else
		local col = {
			(love.math.random(100) / 100),
			(love.math.random(100) / 100),
			(love.math.random(100) / 100),
			1
		}

		return col
	end
end

function global.color.shift(col, target, speed)
	local finished = false
	speed = speed or 0.001

	if col.r then
		col[1] = col.r
		col[2] = col.g
		col[3] = col.b
	end

	if target.r then
		target[1] = target.r
		target[2] = target.g
		target[3] = target.b
	end

	col[1] = global.math.pursue(col[1], target[1], speed)
	col[2] = global.math.pursue(col[2], target[2], speed)
	col[3] = global.math.pursue(col[3], target[3], speed)

	if col.r then
		col.r = col[1]
		col.g = col[2]
		col.b = col[3]
	end

	if target.r then
		target.r = col[1]
		target.g = col[2]
		target.b = col[3]
	end

	if global.math.nearlyEqual(col[1], target[1], speed) and
	global.math.nearlyEqual(col[2], target[2], speed) and
	global.math.nearlyEqual(col[3], target[3], speed) then
		finished = true
	end

	return col, finished
end
