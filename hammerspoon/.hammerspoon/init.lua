hs.hotkey.bind({ "ctrl" }, "v", function()
	hs.eventtap.keyStroke({ "cmd" }, "v", true) -- Simulate Cmd+V once

	-- Use a timer to simulate the second Cmd+V after a short delay
	hs.timer.doAfter(0.1, function()
		hs.eventtap.keyStroke({ "cmd" }, "v", true) -- Simulate Cmd+V again
	end)
end)
