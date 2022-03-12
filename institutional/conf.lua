local big = 1

function love.conf(t)
	t.identity = "poly"
	t.window.title = "New Love Project"
	t.console = true

	if big == 0 then
		t.window.width = 1024
		t.window.height = 576
	elseif big == 1 then
		t.window.width = 1000
		t.window.height = 1000
	else
		t.window.width = 1920
		t.window.height = 1080
		t.window.borderless = true
	end

	t.window.vsync = 1

	t.modules.joystick = false
	t.modules.physics = false
	t.modules.timer = true
end
