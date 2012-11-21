--[[

Script file: Dagon tools

Copyright (c) 2012 Senscape s.r.l.
All rights reserved.

NOTICE: Senscape permits you to use, modify, and distribute this file as long all
copyright notices remain in place.

Contact us: info@senscape.net
URL: http://www.Senscape.net

--]]

--[[

These are general purpose tools that you may freely distribute with your project. Note
some of these functions require some polish and impose a very specific naming convention
of your files.

To use the asynchronous comments feature, you must provide a language file formatted
like this:

Feeds = {

	Room = {
		ID = 100,
		Comments = {
			"First comment.",
			"Second comment.",
			"Third comment.",
			"Etc."
		}
	}
}

--]]
	
require 'English'

------------------------------------------------------------------------------------------
-- Cycle between various camera speeds
------------------------------------------------------------------------------------------
cameraSpeed = 4
function adjustCamera()
	if cameraSpeed > 4 then
		cameraSpeed = 1
	end
	
	if cameraSpeed == 1 then
		camera.speed = 25	
		feed(Messages.Camera1)		
	elseif cameraSpeed == 2 then
		camera.speed = 50
		feed(Messages.Camera2)
	elseif cameraSpeed == 3 then
		camera.speed = 75
		feed(Messages.Camera3)
	elseif cameraSpeed == 4 then
		camera.speed = 99
		feed(Messages.Camera4)					
	end
	
	cameraSpeed = cameraSpeed + 1
end
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Asynchronous comments
------------------------------------------------------------------------------------------
commentsState = {}
commentsTimer = {}

function addComments(room, rate)
	key = room:name()
	
	commentsState[key] = 1
	commentsTimer[key] = room:startTimer(rate, true,
		function()
			-- Note you must comment out this readme check for the function to work
			if readme:isVisible() == false then
				key = currentRoom():name()
				line = commentsState[key]
				-- Generate the filename. Tweak all this to your liking!
				if line < 10 then
					queue(Feeds[key].Comments[line], 
						"lead_comment_" .. Feeds[key].ID .. "00" .. line .. ".ogg")			
				elseif line < 100 then
					queue(Feeds[key].Comments[line], 
						"lead_comment_" .. Feeds[key].ID .. "0" .. line .. ".ogg")
				else
					queue(Feeds[key].Comments[line], 
						"lead_comment_" .. Feeds[key].ID .. line .. ".ogg")			
				end
				
				line = line + 1
				
				-- No more comments? Then stop the timer.
				size = table.getn(Feeds[key].Comments)
				if line > size then
					stopTimer(commentsTimer[key])
				end
				
				-- Prepare the line for next update...
				commentsState[key] = line
			end
		end)
end
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Generic door function
------------------------------------------------------------------------------------------
function addDoor(from, to, direction, style, custom)
	-- This creates a spot with automatically generated video and audio files. The current
	-- node and name of target (either node or room) is used.
	local auxSpot = from:addSpot( Spot(direction, {64, 424}, {sync = true}) )
	auxSpot:attach(AUDIO, "door_" .. style .. "_open.ogg" )
	auxSpot:attach(VIDEO, 
		"door_" .. tostring(from) .. "_" .. string.lower(tostring(to)) .. ".ogv")
	auxSpot:stop()
	
	spot = from:addSpot( Spot(direction, {64, 424, 1984, 424, 1984, 2048, 64, 2048}) )
	spot:attach(FUNCTION, function()
		lookAt(direction)
		auxSpot:play()
		switch(to)
		auxSpot:stop()
		play("door_" .. style .. "_close.ogg")
		
		-- A custom function was specified? Good, execute it.
		if custom ~= nil then
			custom()
		end
	end)
	
	-- We return the spot in case we want to perform further operations with it
	return spot
end
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Cycle between various gamma levels
------------------------------------------------------------------------------------------
gammaLevel = 1
function adjustGamma()
	if gammaLevel > 3 then
		gammaLevel = 0
	end
	
	if gammaLevel == 0 then
		effects.brightness = 150
		feed(Messages.Gamma0)
	elseif gammaLevel == 1 then
		effects.brightness = 200		
		feed(Messages.Gamma1)		
	elseif gammaLevel == 2 then
		effects.brightness = 250
		feed(Messages.Gamma2)		
	elseif gammaLevel == 3 then	
		effects.brightness = 300
		feed(Messages.Gamma3)		
	end
	
	gammaLevel = gammaLevel + 1
end
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Take a snapshot
------------------------------------------------------------------------------------------
function takeSnapshot()
	-- Comment this line or make sure you have a file named like this to avoid an error
	play("snapshot.ogg")
	snap()
	feed(Messages.Snapshot)
end
------------------------------------------------------------------------------------------