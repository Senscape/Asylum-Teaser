--[[

ASYLUM : Interactive Teaser

Script file: CellsA module

Copyright (c) 2012 Senscape s.r.l.
All rights reserved.

NOTICE: Senscape permits you to redistribute these files as long as they have not been
modified. All copyright notices must remain in place. Adapting this code for your
projects, provided the changes are significant, is fine. The exception is 'Tools.lua'
which consists of general purpose functions and may be reused as-is.

All the assets included in this project are the sole property of Senscape s.r.l. and you
are not allowed to reuse them in any way.

In short: BE NICE. This is a gift. We encourage you to share this Asylum Teaser as-is and
experiment with it all you want, but don't put modified versions out there.

Contact us: info@senscape.net
URL: http://www.Senscape.net

--]]

--[[

This room is fairly standard as long as you've read Cafeteria.lua and CorridorB.lua. Most
noteworthy aspect is how we end the teaser after the player reaches the end of the cells.

--]]

------------------------------------------------------------------------------------------
-- Basic settings
------------------------------------------------------------------------------------------
-- Prepare inmates chatter ambiance (required in Showers too)
inmatesChatter1 = Audio("cells1.ogg", {loop = true})
inmatesChatter2 = Audio("cells2.ogg", {loop = true})

-- Required rooms
room 'Showers'
room 'Infirmary'

-- Add layers of music
CellsA:addAudio(musicLayer1)
CellsA:addAudio(musicLayer2)
CellsA:addAudio(musicLayer3)

-- Some more electrical sound ambiance
CellsA:addAudio(Audio("cellsa.ogg", {loop = true, volume = 10}))

-- Footsteps
CellsA:setDefaultFootstep("step_concrete_h")

-- Creation of nodes
cellsa1 = Node("cellsa1", "Gate to infirmary")
cellsa2 = Node("cellsa2", "102A-103A")
cellsa3 = Node("cellsa3", "104A-105A")
cellsa4 = Node("cellsa4", "107A")
cellsa5 = Node("cellsa5", "110A-111A")
cellsa6 = Node("cellsa6", "Stairway to basement")

-- Node linking
cellsa1:link({ W = cellsa2 })
cellsa2:link({ W = cellsa3, E = cellsa1 })
cellsa3:link({ E = cellsa2 })
cellsa4:link({ W = cellsa5 })
cellsa5:link({ W = cellsa6, E = cellsa4 })
cellsa6:link({ E = cellsa5})
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Inmates chatter
------------------------------------------------------------------------------------------
-- These two files are positioned in opposite sides to create that groovy surround feel.
-- The sound is intensified as the player goes deeper into the cells corridor, thus
-- ensuring he or she soil their pants. 

-- First node
chatter = cellsa1:addSpot( Spot(WEST, {1024, 1024}, {auto = true, volume = 33}) )
chatter:attach(AUDIO, inmatesChatter1)

chatter = cellsa1:addSpot( Spot(WEST, {1024, 1024}, {auto = true, volume = 33}) )
chatter:attach(AUDIO, inmatesChatter2)

-- Second node
chatter = cellsa2:addSpot( Spot(EAST, {1024, 1024}, {volume = 66}) )
chatter:attach(AUDIO, inmatesChatter1)

chatter = cellsa2:addSpot( Spot(WEST, {1024, 1024}, {volume = 66}) )
chatter:attach(AUDIO, inmatesChatter2)

-- Third node
chatter = cellsa3:addSpot( Spot(EAST, {1024, 1024}, {volume = 100}) )
chatter:attach(AUDIO, inmatesChatter1)

chatter = cellsa3:addSpot( Spot(WEST, {1024, 1024}, {volume = 100}) )
chatter:attach(AUDIO, inmatesChatter2)

-- Fourth node
chatter = cellsa4:addSpot( Spot(EAST, {1024, 1024}, {volume = 100}) )
chatter:attach(AUDIO, inmatesChatter1)

chatter = cellsa4:addSpot( Spot(WEST, {1024, 1024}, {volume = 100}) )
chatter:attach(AUDIO, inmatesChatter2)

-- Fifth node
chatter = cellsa5:addSpot( Spot(EAST, {1024, 1024}, {volume = 66}) )
chatter:attach(AUDIO, inmatesChatter1)

chatter = cellsa5:addSpot( Spot(WEST, {1024, 1024}, {volume = 66}) )
chatter:attach(AUDIO, inmatesChatter2)

-- Sixth node
chatter = cellsa6:addSpot( Spot(EAST, {1024, 1024}, {volume = 33}) )
chatter:attach(AUDIO, inmatesChatter1)

chatter = cellsa6:addSpot( Spot(EAST, {1024, 1024}, {volume = 33}) )
chatter:attach(AUDIO, inmatesChatter2)
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- 'Gate to infirmary' node
------------------------------------------------------------------------------------------
addDoor(cellsa1, Infirmary, EAST, "metal",
	function()
		effects.throb = 60
	end)

stairwayFirstComment = true
stairway = cellsa1:addSpot( Spot(NORTH, {240, 815, 1100, 815, 1100, 2045, 240, 2045}) )
stairway:attach(FUNCTION, 
	function()
		if stairwayFirstComment == true then
			feed(Feeds.CellsA.Lead104004, "lead_feed_104004.ogg")
			self:setCursor(USE)
			stairwayFirstComment = false
		else
			play("door_metal_locked.ogg")
			startTimer(1, false,
				function()	
					feed(Feeds.CellsA.Lead104005, "lead_feed_104005.ogg")
				end)
		end
	end)
stairway:setCursor(LOOK)
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- '102A-103A' node
------------------------------------------------------------------------------------------
mad = cellsa2:addSpot( Spot(SOUTH, {947, 1047}, {auto = true, loop = true}) )
mad:attach(AUDIO, "cellsa2_mad.ogg")
mad:attach(VIDEO, "cellsa2_mad.ogv")
mad:attach(FEED, Feeds.CellsA.Lead104002, "lead_feed_104002.ogg")
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- '104A-105A' node
------------------------------------------------------------------------------------------
-- This door doesn't switch the room but simply two nodes in it

addDoor(cellsa3, cellsa4, WEST, "metal")
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- '107A' node
------------------------------------------------------------------------------------------
addDoor(cellsa4, cellsa3, EAST, "metal")

-- This spot is referenced by the Showers. The loose madman is visible here as well.
looseMadC = cellsa4:addSpot( Spot(NORTH, {1152, 1040}, {loop = true, volume = 20}) )
looseMadC:attach(AUDIO, "showers_mad.ogg")
looseMadC:attach(VIDEO, "cellsa4_mad.ogv")
looseMadC:stop()

-- Door to showers (always open)
toshowers = cellsa4:addSpot( Spot(NORTH, {682, 424, 1365, 424, 1365, 2048, 682, 2048}) )
toshowers:attach(FUNCTION, 
	function()
		-- We disable the throb because otherwise the crossfade between nodes can look funny
		effects.throb = 0
		
		switch(Showers)
		-- And we setup another throb style: an intermittent, bright flash
		effects.throbStyle = 2
		effects.throb = 90		
	end)
toshowers:setCursor(FORWARD)	
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- '110A-111A' node
------------------------------------------------------------------------------------------
mad = cellsa5:addSpot( Spot(NORTH, {1036, 1079}, {auto = true, loop = true}) )
mad:attach(AUDIO, "cellsa5_mad.ogg")
mad:attach(VIDEO, "cellsa5_mad.ogv")
mad:attach(FEED, Feeds.CellsA.Lead104003, "lead_feed_104003.ogg")
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- 'Stairway to basement' node
------------------------------------------------------------------------------------------
-- This is the guy that appears at the end of the teaser. He's friendly actually, he's
-- just saying goodbye.

seenMadInCell = false
mad = cellsa6:addSpot( Spot(NORTH, {406, 824}, {sync = true}) )
mad:attach(AUDIO, "cellsa6_mad.ogg")
mad:attach(VIDEO, "cellsa6_mad.ogv")
mad:attach(FUNCTION, 
	function()
		if seenMadInCell == false then
			self:play()
			seenMadInCell = true
		else
			feed(Feeds.CellsA.Lead104001, "lead_feed_104001.ogg")
		end
	end)
mad:stop()
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- End of teaser
------------------------------------------------------------------------------------------
-- We could have used overlays here just like in the readme class, but let's try something
-- else. The end screen is a single image (presented as a slide) and instead of buttons we
-- define spots for the interactive zones. That 'true' at the end tells Dagon that it
-- shouldn't create a return spot.

endSlide = Slide("end_screen.png", "Ending screen", true)

website = endSlide:addSpot( Spot({615, 650, 1300, 650, 1300, 900, 615, 900}) )
website:attach(FUNCTION,
	function()
		system.browse("http://www.Senscape.net")
	end)
website:setCursor(FORWARD)

quit = endSlide:addSpot( Spot({680, 1025, 1245, 1025, 1245, 1080, 680, 1080}) )
quit:attach(FUNCTION,
	function()
		-- Hard shutdown
		system.terminate()
	end)
quit:setCursor(USE)

function endTeaser()
	lookAt(WEST)
	finalGate:play()
	
	-- Disable all the effects and breathe so that the last screen remains clean and static
	camera.breathe = false
	config.effects = false
	switch(endSlide)
end

finalGate = cellsa6:addSpot( Spot(WEST, {64, 424}, {sync = true}) )
finalGate:attach(AUDIO, "door_metal_open.ogg")
finalGate:attach(VIDEO, "door_cellsa6_end.ogv")
finalGate:attach(FUNCTION, endTeaser)

handle = cellsa6:addSpot( Spot(WEST, {1200, 1590, 1335, 1590, 1340, 1785, 1200, 1785}) )
handle:attach(FUNCTION, endTeaser)
------------------------------------------------------------------------------------------
