--[[

ASYLUM : Interactive Teaser

Script file: Corridor B room

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

------------------------------------------------------------------------------------------
-- Basic settings
------------------------------------------------------------------------------------------
-- Required rooms
room 'Cafeteria'
room 'Infirmary'

-- Add layers of music
CorridorB:addAudio(musicLayer1)

-- Footsteps
CorridorB:setDefaultFootstep("step_concrete_h")

-- Creation of nodes
corridorb2 = Node("corridorb2", "Door to Cafeteria") -- Becomes the first node
corridorb1 = Node("corridorb1", "Door to Infirmary")
corridorb3 = Node("corridorb3", "Map")

-- Node linking
corridorb1:link({ E = corridorb2 })
corridorb2:link({ W = corridorb1, E = corridorb3 })
corridorb3:link({ W = corridorb2 })
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Ambiance
------------------------------------------------------------------------------------------
-- Just a bit of ambiance here, same approach as the cafeteria alarm. The cafeteria file
-- was already too crowded with comments, so I'll take this opportunity to clarify our
-- naming convention:

-- 1) Rooms begin with a capital letter.
-- 2) Nodes are the name of the room in lowcase followed by a number.
-- 3) Spots that don't need to be referenced later are a single string. It's perfectly
-- 		fine to rewrite these objects; both Lua and Dagon are clever enough to avoid
--		garbage collecting objects that are still in use.
-- 4) Spots that require later referencing are two words (or more) named with camel case.
--		Like: distantSounds precisely.
--
-- Sometimes we will use prefixes for certain objects, especially when creating classes.

distantSounds1 = Audio("ambiance1.ogg", {loop = true})
distantSounds2 = Audio("ambiance2.ogg", {loop = true})

ambiance = corridorb2:addSpot( Spot(EAST, {1024, 1024}, {auto = true, volume = 20}) )
ambiance:attach(AUDIO, distantSounds1)

ambiance = corridorb2:addSpot( Spot(WEST, {1024, 1024}, {auto = true, volume = 20}) )
ambiance:attach(AUDIO, distantSounds2)

ambiance = corridorb1:addSpot( Spot(EAST, {1024, 1024}, {volume = 10}) )
ambiance:attach(AUDIO, distantSounds1)

ambiance = corridorb1:addSpot( Spot(WEST, {1024, 1024}, {volume = 10}) )
ambiance:attach(AUDIO, distantSounds2)

ambiance = corridorb3:addSpot( Spot(EAST, {1024, 1024}, {volume = 30}) )
ambiance:attach(AUDIO, distantSounds1)

ambiance = corridorb3:addSpot( Spot(WEST, {1024, 1024}, {volume = 30}) )
ambiance:attach(AUDIO, distantSounds2)
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- 'Door to Cafeteria' node
------------------------------------------------------------------------------------------
-- So this is another lame, boring node.

addDoor(corridorb2, Cafeteria, NORTH, "large",
	function()
		-- Activate the dust again. This can be an expensive feature: try 99 for many
		-- thousands of particles and a major slowdown on older systems. Tweaking the color
		-- and using settings like dustSpeed and dustSpread, rain and snow effects can be
		-- simulated.
		effects.dust = 30
	end)
	
window = corridorb2:addSpot( Spot(SOUTH, {0, 0, 695, 0, 725, 1520, 0, 1535}) )
window:attach(FEED, Feeds.CorridorB.Lead101009, "lead_feed_101009.ogg")

window = corridorb2:addSpot( Spot(SOUTH, {1370, 0, 2045, 0, 2045, 1530, 1375, 1525}) )
window:attach(FEED, Feeds.CorridorB.Lead101009, "lead_feed_101009.ogg")

window = corridorb2:addSpot( Spot(EAST, {1870, 215, 2045, 0, 2045, 1530, 1890, 1465}) )
window:attach(FEED, Feeds.CorridorB.Lead101009, "lead_feed_101009.ogg")

window = corridorb2:addSpot( Spot(WEST, {0, 40, 205, 220, 200, 1440, 0, 1530}) )
window:attach(FEED, Feeds.CorridorB.Lead101009, "lead_feed_101009.ogg")
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- 'Door to Infirmary' node
------------------------------------------------------------------------------------------
-- These flashes of light are here for a consistent look. When the player opens the door,
-- the infirmary has faulty light tubes.
flash = corridorb1:addSpot( Spot(WEST, {538,904}, {auto = true, loop = true}) )
flash:attach(VIDEO, "corridorb1_flash1.ogv")

flash = corridorb1:addSpot( Spot(WEST, {1324,904}, {auto = true, loop = true}) )
flash:attach(VIDEO, "corridorb1_flash2.ogv")

-- Note the video of this door opening will cover the flashes, so there's no need to
-- disable them. Spots are drawn by the engine in the same order they are added to the
-- node. Keeping this in mind can save you some work.
addDoor(corridorb1, Infirmary, WEST, "large",
	function()
		-- Set a throbbing style and intensity for the infirmary (just two styles for now)
		effects.throbStyle = 1
		effects.throb = 60
		
		-- This is the first example of our journal implementation. The protagonist is looking
		-- for the infirmary. Three things can happen:
		-- 
		-- 1) The player enters the infirmary directly.
		-- 2) Looks at the sign over the door which reads 'Infirmary'.
		-- 3) Looks at the map and learns about its location.
		-- 
		-- When we enter the infirmary, we ask this question. If it wasn't found, we mark the
		-- journal entry as complete.
		if foundInfirmary == false then
			journal:markEntry(Notes.Entries.INFIRMARY)
			foundInfirmary = true
		end
	end)

board = corridorb1:addSpot( Spot(NORTH, {560, 850, 1550, 765, 1600, 1325, 610, 1420}) )
board:attach(FEED, Feeds.CorridorB.Lead101002, "lead_feed_101002.ogg")

window = corridorb1:addSpot( Spot(SOUTH, {345, 0, 1335, 0, 1330, 1575, 345, 1560}) )
window:attach(FEED, Feeds.CorridorB.Lead101009, "lead_feed_101009.ogg")

-- As before, this sign can mean the infirmary is being found
sign = corridorb1:addSpot( Spot(WEST, {740, 220, 1385, 220, 1385, 425, 740, 425}) )
sign:attach(FUNCTION,
	function()
		feed(Feeds.CorridorB.Lead101005, "lead_feed_101005.ogg")
		if foundInfirmary == false then
			journal:markEntry(Notes.Entries.INFIRMARY)
			foundInfirmary = true
		end
	end)
	
-- Notice how we specifically set a cursor from time to time? Dagon will set certain
-- cursors by default: "use" when attaching a function, "look" when attaching a feed and
-- "forward" when attaching a node or room with the SWITCH tag (which means the engine
-- performs a switch when the spot is clicked). However, if the target with SWITCH is a
-- slide, the default icon is "look".
sign:setCursor(LOOK)
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Detail of map
------------------------------------------------------------------------------------------
-- Here comes the slides. The concept of this object is very similar to the nodes, except
-- these are supposed to be static images. You could create an entire adventure with 
-- slides (i.e.: slideshow style). Slides support spots (and therefore all their
-- functionality) just like nodes, however notice that you don't need to define a face.
--
-- Dagon will automatically add a "back" spot for you, that is, a region the player can
-- click to return to the previous node or slide. Yes, you can stack all the slides you
-- want and Dagon will respect the order. This makes it really easy to create multiple
-- closeups of items; sometimes one line of code is enough.

mapDetail = Slide("corridorb_map_detail.jpg", "Detail of map")

map = mapDetail:addSpot( Spot({75, 175, 1850, 180, 1850, 945, 90, 940}) )
map:attach(FEED, Feeds.CorridorB.Lead101004, "lead_feed_101004.ogg")

location = mapDetail:addSpot( Spot({475, 570, 775, 580, 730, 840, 450, 870}) )
location:attach(FUNCTION, 
	function()
		-- The last possibility to find about the infirmary. When the player clicks on the
		-- corresponding location on the map, that spot is disabled (so the generic one below
		-- with the comment "This asylum is huge" remains active) and the entry is marked
		-- as completed. 
		if foundInfirmary == true then
			feed(Feeds.CorridorB.Lead101004, "lead_feed_101004.ogg")
		else
			journal:markEntry(Notes.Entries.INFIRMARY)
			addComments(CorridorB, 15)
			
			feed(Feeds.CorridorB.Lead101003, "lead_feed_101003.ogg")
			foundInfirmary = true
		end
		self:disable()
end)
location:setCursor(LOOK)
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- 'Map' node
------------------------------------------------------------------------------------------
-- The last node here has a convenient obstacle to prevent players from visiting the rest
-- of the asylum. Hey, they're supposed to buy this game. We HAVE to make money somehow...
--
-- You can skip Infirmary and CellsA which exhibit the same features, but I suggest you
-- take a look at Showers.lua for a more complex example.

map = corridorb3:addSpot( Spot(NORTH, {630, 820, 1745, 825, 1745, 1400, 630, 1400}) )
map:attach(SWITCH, mapDetail)

window = corridorb3:addSpot( Spot(SOUTH, {610, 0, 1595, 0, 1585, 1570, 610, 1555}) )
window:attach(FEED, Feeds.CorridorB.Lead101009, "lead_feed_101009.ogg")

treeComment = 0
tree = corridorb3:addSpot( 
	Spot(EAST, {565, 710, 1015, 405, 1490, 710, 1490, 1900, 565, 1900}) )
tree:attach(FUNCTION, 
	function()
			if treeComment == 0 then
				feed(Feeds.CorridorB.Lead101006, "lead_feed_101006.ogg")
				treeComment = treeComment + 1
			elseif treeComment == 1 then
				feed(Feeds.CorridorB.Lead101007, "lead_feed_101007.ogg")
				treeComment = treeComment + 1
			elseif treeComment == 2 then
				feed(Feeds.CorridorB.Lead101008, "lead_feed_101008.ogg")
				treeComment = treeComment + 1	
			else
				feed(Feeds.CorridorB.Lead101007, "lead_feed_101007.ogg")
			end
	end)
tree:setCursor(FORWARD)
------------------------------------------------------------------------------------------
