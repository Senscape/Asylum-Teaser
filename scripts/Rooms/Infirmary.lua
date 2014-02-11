--[[

ASYLUM : Interactive Teaser

Script file: Infirmary room

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

If you've been through Cafeteria and Corridor B, there's not much else to say here. We
have a similar situation to the alarms, more slides, dozens of spots, and one
particularly interesting example: an item can be grabbed by the player and used.

--]]

------------------------------------------------------------------------------------------
-- Basic settings
------------------------------------------------------------------------------------------
-- Required rooms
room 'CellsA'
room 'CorridorB'

-- Add layers of music
Infirmary:addAudio(musicLayer1)
Infirmary:addAudio(musicLayer2)

-- Some ambiance of faulty tubes
Infirmary:addAudio(Audio("infirmary.ogg", {loop = true, volume = 25}))

-- Footsteps
Infirmary:setDefaultFootstep("step_marble_m")

-- Asynchronous comments
addComments(Infirmary, 20)

-- Creation of nodes
infirmary1 = Node("infirmary1", "Door to Corridor B")
infirmary2 = Node("infirmary2", "Middle section")
infirmary3 = Node("infirmary3", "Door to Cells")

-- Node linking
infirmary1:link({ W = infirmary2 })
infirmary2:link({ W = infirmary3, E = infirmary1 })
infirmary3:link({ E = infirmary2 })
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Detail of corkboard
------------------------------------------------------------------------------------------
-- Plenty of things to see in this corkboard. Note how we must pay attention to the state
-- of the lifted paper. The player is not required to put it down to go back, so we do it
-- ourselves when we set custom actions in the onReturn function. 

boardDetail = Slide("infirmary1_board_detail.jpg", "Detail of board")
photoDetail = Slide("infirmary1_photo_detail.jpg", "Detail of photo")
news1Detail = Slide("infirmary1_news1_detail.jpg", "Detail of first newspaper")
news2Detail = Slide("infirmary1_news2_detail.jpg", "Detail of second newspaper")

articles = boardDetail:addSpot( Spot({180, 110, 1780, 180, 1730, 980, 200, 1020}) )
articles:attach(FEED, Feeds.Infirmary.Lead102005, "lead_feed_102005.ogg")

drawing = boardDetail:addSpot( Spot({600, 115}) )
drawing:attach(IMAGE, "infirmary1_board_drawing.jpg")
drawing:disable()

isPaperLifted = false
function putDownPaper()
	if isPaperLifted == true then
		play("drop_paper.ogg")
		drawing:disable()
		isPaperLifted = false
	end
end

function togglePaper()
	if isPaperLifted == true then
		putDownPaper()
	else
		play("grab_paper.ogg")
		drawing:enable()
		isPaperLifted = true
	end
end

paper = boardDetail:addSpot( Spot({810, 190, 1100, 190, 1110, 675, 825, 690}) )
paper:attach(FUNCTION, togglePaper)
boardDetail:onReturn(putDownPaper)

seenPhoto = false
photo = boardDetail:addSpot( Spot({465, 245, 815, 320, 780, 560, 410, 500}) )
photo:attach(FUNCTION, 
	function()
		putDownPaper()		
		switch(photoDetail)
		
		if seenPhoto == false then
			seenPhoto = true
			play("piano.ogg")
		end
	end)
photo:setCursor(LOOK)

news1 = boardDetail:addSpot( Spot({1165, 130, 1460, 205, 1400, 420, 1115, 340}) )
news1:attach(FUNCTION, 
	function()
		putDownPaper()		
		switch(news1Detail)
	end)
news1:setCursor(LOOK)

news2 = boardDetail:addSpot( Spot({680, 800, 1120, 765, 1115, 1035, 695, 1165}) )
news2:attach(FUNCTION, 
	function()
		putDownPaper()		
		switch(news2Detail)
	end)
news2:setCursor(LOOK)
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- 'Door to Corridor B' node
------------------------------------------------------------------------------------------
addDoor(infirmary1, CorridorB, EAST, "large",
	function()
		-- Turn off the throbbing effects when we return to the Corridor B
		effects.throb = 0
	end)
	
board = infirmary1:addSpot( Spot(SOUTH, {1180, 895, 2045, 895, 2045, 1375, 1180, 1375}) )
board:attach(SWITCH, boardDetail)

tube = infirmary1:addSpot( Spot(WEST, {788, 368}, {auto = true, loop = true}) )
tube:attach(VIDEO, "infirmary1_tubea.ogv")
	
tube = infirmary1:addSpot( Spot(WEST, {894, 698}, {auto = true, loop = true}) )
tube:attach(VIDEO, "infirmary1_tubeb.ogv")
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- 'Middle section' node
------------------------------------------------------------------------------------------
bed = infirmary2:addSpot( Spot(NORTH, {110, 2045, 720, 1530, 735, 1400, 1030, 1430, 1030, 1580, 790, 2045}) )
bed:attach(FEED, Feeds.Infirmary.Lead102008, "lead_feed_102008.ogg")

bed = infirmary2:addSpot( Spot(SOUTH, {0, 1690, 950, 1450, 950, 1800, 400, 2045, 0, 2045}) )
bed:attach(FEED, Feeds.Infirmary.Lead102008, "lead_feed_102008.ogg")

bed = infirmary2:addSpot( Spot(SOUTH, {1655, 1390, 1920, 1420, 2045, 1525, 2045, 1740, 1810, 1670}) )
bed:attach(FEED, Feeds.Infirmary.Lead102008, "lead_feed_102008.ogg")

bed = infirmary2:addSpot( Spot(DOWN, {150, 0, 790, 0, 610, 570, 20, 360}) )
bed:attach(FEED, Feeds.Infirmary.Lead102008, "lead_feed_102008.ogg")

junk = infirmary2:addSpot( Spot(NORTH, {0, 1285, 600, 1025, 710, 1365, 180, 1670, 0, 1590}) )
junk:attach(FEED, Feeds.Infirmary.Lead102006, "lead_feed_102006.ogg")

junk = infirmary2:addSpot( Spot(NORTH, {1300, 1070, 1710, 1015, 1825, 1420, 1360, 1410}) )
junk:attach(FEED, Feeds.Infirmary.Lead102006, "lead_feed_102006.ogg")

junk = infirmary2:addSpot( Spot(SOUTH, {1265, 1340, 1495, 1375, 1630, 1490, 1750, 1750, 1380, 1525}) )
junk:attach(FEED, Feeds.Infirmary.Lead102006, "lead_feed_102006.ogg")

tube = infirmary2:addSpot( Spot(EAST, {1118, 306}, {auto = true, loop = true}) )
tube:attach(VIDEO, "infirmary2_tube.ogv")

-- Two different comments when looking at the flasks
flasksFirstLook = true
flasks = infirmary2:addSpot( Spot(WEST, {1540, 1410, 1870, 1450, 1870, 1630, 1550, 1575}) )
flasks:attach(FUNCTION,
	function()
		if flasksFirstLook == true then
			feed(Feeds.Infirmary.Lead102001, "lead_feed_102001.ogg")
			flasksFirstLook = false
		else
			feed(Feeds.Infirmary.Lead102002, "lead_feed_102002.ogg")
		end
	end)
flasks:setCursor(LOOK)

-- Here's an item the player can grab. Our inventory system is very particular: entries in
-- the journal become items. The difference is a small tag to indicate this. So grabbing
-- is just like adding an entry to the journal, or tagging an already existing one. By
-- combining Slides, Overlays, Images and Buttons (see Intro.lua or Readme.lua) you can
-- create any system you want.
key = infirmary2:addSpot( Spot(DOWN, {500, 272}) )
key:attach(IMAGE, "infirmary2_keys.png")
key:attach(FUNCTION, 
	function()
		if needKeyMale == false then
			journal:addEntry(Notes.Entries.KEY_UNKNOWN, keyMaleThoughts)
			journal:tagEntry(Notes.Entries.KEY_UNKNOWN)
		else
			journal:tagEntry(Notes.Entries.KEY_MALE)
		end		
		foundKeyMale = true
		play("grab_key.ogg")
		-- As if it wasn't obvious, 'self' is the object that triggered the function. Dagon
		-- makes sure to set this variable for you. You can't rely on 'self' always however
		-- if, for example, you need to enable/disable an object from another function (that
		-- is why we use camelCase to reference the objects sometimes).
		--
		-- It is possible to have many objects share a single function. Using 'self', you can
		-- perform actions on the object that triggered the call without knowing its name,
		-- which can reduce tons of boilerplate code.
		self:disable()
	end)
------------------------------------------------------------------------------------------
	
------------------------------------------------------------------------------------------
-- Radiators
------------------------------------------------------------------------------------------
-- As I said before, this is similar to the alarms case. The comment is different
-- depending on which radiator is seen first.

seenNorthRadiator = false
radiator = infirmary2:addSpot( Spot(NORTH, {810, 1205, 1115, 1205, 1115, 1350, 810, 1350}) )
radiator:attach(FUNCTION,
	function()
		if seenSouthRadiator == true then
			feed(Feeds.Infirmary.Lead102004, "lead_feed_102004.ogg")
		else
			feed(Feeds.Infirmary.Lead102003, "lead_feed_102003.ogg")
			seenNorthRadiator = true
		end
	end)
radiator:setCursor(LOOK)

seenSouthRadiator = false
radiator = infirmary2:addSpot( Spot(SOUTH, {945, 1200, 1625, 1210, 1625, 1350, 945, 1350}) )
radiator:attach(FUNCTION,
	function()
		if seenNorthRadiator == true then
			feed(Feeds.Infirmary.Lead102004, "lead_feed_102004.ogg")
		else
			feed(Feeds.Infirmary.Lead102003, "lead_feed_102003.ogg")
			seenSouthRadiator = true
		end
	end)
radiator:setCursor(LOOK)
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Easter egg
------------------------------------------------------------------------------------------
-- Just a silly easter egg here. In future versions, we will allow you to define if a spot
-- can show an indicator when the spacebar is pressed or not, or disable this feature
-- altogether.

cabinetDetail = Slide("infirmary3_cabinet_detail.jpg", "Detail of cabinet")
hiddenPhotoDetail = Slide("infirmary3_photo_detail.jpg", "Detail of hidden photo")
hiddenPhotoDetail:onReturn(
	function()
			play("drop_paper.ogg")
	end)

photo = cabinetDetail:addSpot( Spot({955, 500, 1060, 485, 1130, 580, 1020, 600}) )
photo:attach(FUNCTION,
	function()
		play("grab_paper.ogg")
		switch(hiddenPhotoDetail)
	end)
photo:setCursor(USE)

easter = infirmary3:addSpot( Spot(SOUTH, {1150, 1440, 1190, 1440, 1190, 1485, 1150, 1485}) )
easter:attach(SWITCH, cabinetDetail)
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- 'Door to Cells' node
------------------------------------------------------------------------------------------
-- And now, the possibility to use the key. The player has two options: just click on the
-- door and the key is automatically used (because there's only one and our protagonist is
-- clever enough to figure this out for himself), or manually click the journal entry.
-- That particular action is handled in Notes.lua.

-- Default, unlocked door. This is disabled at first.
cellsDoor = addDoor(infirmary3, CellsA, WEST, "metal",
	function()
		-- Less throb intensity while we're in the Cells
		effects.throb = 40
	end)
cellsDoor:disable()

-- This function is called from a spot and the corresponding journal entry
function unlockCellsDoor()
		-- You'll notice we have to consider two different entries here. The protagonist can
		-- grab the key without knowing what it's for, or knowing in advance it could be the
		-- key to the cells. Details, details...
		if needKeyMale == true then
			journal:markEntry(Notes.Entries.KEY_MALE)
		else
			journal:markEntry(Notes.Entries.KEY_UNKNOWN)
		end
		-- The locked door spot is disabled, the unlocked one is enabled, we play a sound, set
		-- a flag for later use, and everybody's happy.
		cellsDoorLocked:disable()
		cellsDoor:enable()
		play("use_key.ogg")
		usedKeyMale = true
end

-- Locked instance of the door
cellsDoorLocked = infirmary3:addSpot( Spot(WEST, {64, 424, 1984, 424, 1984, 2048, 64, 2048}, {auto = true, loop = true}) )
cellsDoorLocked:attach(FUNCTION, function()
		if foundKeyMale == false then
			play("door_metal_locked.ogg")
			startTimer(1, false,
				function()	
					feed(Feeds.Infirmary.Lead102007, "lead_feed_102007.ogg")
				end)
			if needKeyMale == false and foundKeyMale == false then
				journal:addEntry(Notes.Entries.KEY_MALE, keyMaleThoughts)
			end
			needKeyMale = true
		else
			unlockCellsDoor()
		end 
	end)

-- Alarm button. Yes, another one! But this time we're lazy and just tell the
-- "not working" comment, regardless if another button was already tried or not.
button = infirmary3:addSpot( Spot(SOUTH, {1630, 1150, 1780, 1160, 1770, 1395, 1630, 1330}) )
button:attach(FUNCTION,
	function()
		play("use_button.ogg")
		startTimer(1, false,
			function()
				feed(Feeds.Cafeteria.Lead100005, "lead_feed_100005.ogg")
			end)
	end)
button:setCursor(USE)

tube = infirmary3:addSpot( Spot(EAST, {1030, 534}, {auto = true, loop = true}) )
tube:attach(VIDEO, "infirmary3_tubea.ogv")

tube = infirmary3:addSpot( Spot(EAST, {1050, 802}, {auto = true, loop = true}) )
tube:attach(VIDEO, "infirmary3_tubeb.ogv")
------------------------------------------------------------------------------------------
