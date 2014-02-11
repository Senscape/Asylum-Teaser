--[[

ASYLUM : Interactive Teaser

Script file: Cafeteria room

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

ANOTHER INTRODUCTION
Or: How I Learned to Stop Worrying and Load my Own Files in Dagon

First, a super-brief overview of the Dagon basics, so brief in fact it's in the form of a
Haiku poem:

a room is a container for many nodes
a node has six faces, each a canvas for spots
a spot can be anything you want: an image, an audio, a video, or all

How quaint. Anyway, you have three ways to load textures in a node:

1) From a bundle
2) Allowing the engine to automatically generate the filenames, without bundles
3) Manually creating the spots yourself

Bundle means the textures are compressed and stored in a Dagon custom format (.TEX). Each
bundle may store an unlimited number of textures, but the usual is six. This is the
default and preferred method by the engine. The converter tool is not provided here, but
you may get it from the Senscape forums. With this method, the node name becomes the
expected bundle. So if your node is called "cafeteria1", the engine expects the
cafeteria1.tex file to get its textures.

Something to keep in mind: in bundles, the textures are always compressed for super-fast
loading, which may introduce artifacts in scenes with soft gradients (i.e.: a desert).

No bundles means the engine will expect six filenames when you create a node with the form
NAMEXXX.EXT where NAME is the name of the node, XXX the number of texture and EXT the
extension. In the case of the Cafeteria, those files would be: cafeteria1001.jpg, 
cafeteria1002.jpg, etc. The order of the node faces is: North, East, South, West, Up,
Down.

To do it this way, you must disable bundles and set the extension of your textures. For
example:

config.bundleEnabled = false
config.texExtension = "jpg"

And if you want to disable texture compression:

config.texCompression = false

Finally, to avoid any automatisation, use any name you want and create the spots yourself,
provided bundles are disabled:

cafeteria1 = Node("My lovely cafeteria", "This is the description of the cafeteria.")
spot = cafeteria1:addSpot( Spot(NORTH, {0, 0}) )
spot:attach(IMAGE, "cafeteria1001.jpg")
spot = cafeteria1:addSpot( Spot(EAST, {0, 0}) )
spot:attach(IMAGE, "cafeteria1002.jpg")

And so on... Which is exactly what the engine does by default: automatically create six
spots for you. EVERYTHING you see in Dagon is a spot, which are very powerful objects.

One last thing: if you don't care about the default Dagon structure of folders and don't
want to be forced to put files into subfolders such as Nodes and Images, then you must
disable the feature like this:

config.autopaths = false

Whew... Let's go the fun part now, shall we.

--]]

------------------------------------------------------------------------------------------
-- Basic settings
------------------------------------------------------------------------------------------
-- Required rooms
room 'CorridorB'

-- Add layers of music
Cafeteria:addAudio(musicLayer1)

-- Sound of footsteps. When the extension is not added, Dagon will randomise the file
-- name. Currently it generates a number between 001 and 006 (more flexibility later).
Cafeteria:setDefaultFootstep("step_concrete_l")

-- This makes our character occasionally tell comments about his surroundings or anything
-- that comes to mind. To achieve this, we stored those strings in a huge Lua table. See
-- English.lua and Tools.lua
addComments(Cafeteria, 30)

-- Timed event to play the sound of distant dishes
Cafeteria:startTimer(50, false,
		function()
			play("dishes.ogg")
		end)

-- Creation of nodes
cafeteria1 = Node("cafeteria1", "Door to Corridor B")
cafeteria2 = Node("cafeteria2", "Middle section")
cafeteria3 = Node("cafeteria3", "Door to Corridor C")

-- A very convenient way to link all your nodes. You pass a table indicating the node that
-- corresponds to each cardinal direction. We even support NE, SE, etc. While this is
-- ideal for basic movements and prototyping, you have to resort to manual spots when
-- there is a door or something else in the way.
cafeteria1:link({ N = cafeteria2 })
cafeteria2:link({ N = cafeteria3, S = cafeteria1 })
cafeteria3:link({ S = cafeteria2 })
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Alarms
------------------------------------------------------------------------------------------
-- A first example of how to solve a typical problem with non-linear adventures: there are
-- two alarm buttons, one in service, the other broken. The player can press them in any
-- order. So...

-- This is a shared audio object. We will assign it to several spots within the room. A
-- cool feature of Dagon: it automatically positions this audio (if it's mono) according
-- to the position of the node. Then, when the camera turns, it's repositioned to simulate
-- a surround effect.
alarmSound = Audio("alarm.ogg", {loop = true})

-- Shared function between two buttons. We must know if it's the first time the alarm is
-- triggered, to tell a comment, or if it's the first time that particular button is
-- pressed.
alarmFirstTime = true
buttonFirstTime = true
function pressAlarm()
	if buttonFirstTime == true then
		-- The character wonders what this button might do
		feed(Feeds.Cafeteria.Lead100004, "lead_feed_100004.ogg")
		-- Both of them are usable now
		alarmButton1:setCursor(USE)
		alarmButton2:setCursor(USE)			
		buttonFirstTime = false
	else
		-- Is this the working alarm button?
		if self == alarmButton1 then
			-- Yay!
			buttonFirstTime = false
			if alarmFirstTime == true then
				-- If it's the first time the player pressed it, set a comment after the next two
				-- seconds
				startTimer(2, false,
					function()
						feed(Feeds.Cafeteria.Lead100006, "lead_feed_100006.ogg")
					end)
				alarmFirstTime = false
			end
			
			-- Since the button toggles the alarm on and off, we ask this question and play or
			-- stop accordingly
			play("use_button.ogg")
			if self:isPlaying() == false then 
				startTimer(1, false,
					function()
						alarmButton1:play()
					end)
			else
				self:stop()
			end		
		else
			-- Nay...
			play("use_button.ogg")
			-- Another timed comment, to make it feel more natural. The character expects
			-- something to happen, without success.
			startTimer(1, false,
				function()
					feed(Feeds.Cafeteria.Lead100005, "lead_feed_100005.ogg")
				end)
		end
	end
end

-- The actual alarm spots, each in opposite corners of the cafeteria
alarmButton1 = cafeteria3:addSpot( 
	Spot(WEST, {1536, 1164, 1625, 1164, 1625, 1290, 1536, 1290}) )
alarmButton1:attach(AUDIO, alarmSound)
alarmButton1:attach(FUNCTION, pressAlarm)
alarmButton1:setCursor(LOOK)

alarmButton2 = cafeteria1:addSpot( 
	Spot(EAST, {1870, 1140, 2000, 1150, 2000, 1300, 1880, 1275}) )
alarmButton2:attach(FUNCTION, pressAlarm)
alarmButton2:setCursor(LOOK)

-- Two more non-interactive spots to hold the alarm sound. Note we can set the volume, so
-- that when the player walks away from the alarm its volume is decreased.
alarm = cafeteria1:addSpot( Spot(NORTH, {1024, 1024}, {volume = 20}) )
alarm:attach(AUDIO, alarmSound)

alarm = cafeteria2:addSpot( Spot(NORTH, {0, 1024}, {volume = 40}) )
alarm:attach(AUDIO, alarmSound)
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- 'Door to Corridor B' node
------------------------------------------------------------------------------------------
-- The first node without anything noteworthy. We have a few spots that trigger comments,
-- a distant video, and a door.

speaker = cafeteria1:addSpot( 
	Spot(EAST, {1415, 500, 1475, 420, 1590, 420, 1585, 530, 1510, 610, 1440, 595}) )
speaker:attach(FEED, Feeds.Cafeteria.Lead100009, "lead_feed_100009.ogg")	

speaker = cafeteria1:addSpot( Spot(
	WEST, {470, 435, 575, 440, 635, 520, 620, 610, 550, 615, 470, 550}) )
speaker:attach(FEED, Feeds.Cafeteria.Lead100009, "lead_feed_100009.ogg")	

blanket = cafeteria1:addSpot( 
	Spot(WEST, {890, 1365, 1035, 1335, 1290, 1075, 1445, 1110, 
	2045, 1780, 2045, 2045, 790, 2045}) )
blanket:attach(FEED, Feeds.Cafeteria.Lead100010, "lead_feed_100010.ogg")

-- Right, before I forget: if you declare one vertex for the spot (just x, y), when you
-- attach a video it will automatically resize itself. If, however, you declare a polygon,
-- the engine will attempt to play the video with this shape. The same applies to images.
-- For obvious reasons, when you must force a size (i.e.: you want to stretch the image or
-- video) you should stick to four vertices.
tube = cafeteria1:addSpot( Spot(NORTH, {1160, 758}, {auto = true, loop = true}) )
tube:attach(VIDEO, "cafeteria1_tube.ogv")

tables = cafeteria1:addSpot( 
	Spot(EAST, {745, 1215, 940, 1215, 680, 1800, 0, 1800}) )
tables:attach(FEED, Feeds.Cafeteria.Lead100001, "lead_feed_100001.ogg")

-- Door to Corridor B. The first time the players leave, a new comment is scheduled.
-- Please refer to Tools.lua for comments about the actual addDoor() function.
corridorFeed = false
addDoor(cafeteria1, CorridorB, SOUTH, "large",
	function()
		effects.dust = 0
		if corridorFeed == false then
			hallwayTimer = startTimer(2,
				function()
					feed(Feeds.CorridorB.Lead101001, "lead_feed_101001.ogg")
				end)
			corridorFeed = true
		end
	end)
------------------------------------------------------------------------------------------	

------------------------------------------------------------------------------------------
-- 'Middle section' node
------------------------------------------------------------------------------------------
-- Same as before, a transitory node

speaker = cafeteria2:addSpot( Spot(EAST, {730, 705, 825, 705, 830, 775, 735, 770}) )
speaker:attach(FEED, Feeds.Cafeteria.Lead100009, "lead_feed_100009.ogg")

speaker = cafeteria2:addSpot( Spot(EAST, {1190, 705, 1275, 705, 1275, 775, 1190, 770}) )
speaker:attach(FEED, Feeds.Cafeteria.Lead100009, "lead_feed_100009.ogg")

tube = cafeteria2:addSpot( Spot(NORTH, {1472, 242}, {auto = true, loop = true}) )
tube:attach(VIDEO, "cafeteria2_tube.ogv")

tables = cafeteria2:addSpot( Spot(EAST, {950, 1205, 1135, 1205, 1425, 1680, 770, 1680}) )
tables:attach(FEED, Feeds.Cafeteria.Lead100001, "lead_feed_100001.ogg")

-- The first example of a spot with three properties: it has a video, an audio, and a feed
-- associated with it. In future versions, we will support video files with embedded
-- audios, but for now this is the only means to sync video and audio streams.
flies = cafeteria2:addSpot( Spot(WEST, {964, 1404}, 
																			{auto = true, loop = true, volume = 25}) )
flies:attach(AUDIO, "cafeteria2_flies.ogg")
flies:attach(VIDEO, "cafeteria2_flies.ogv")
flies:attach(FEED, Feeds.Cafeteria.Lead100003, "lead_feed_100003.ogg")
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Locked door
------------------------------------------------------------------------------------------
-- The door at the end is stuck. The protagonist tells two different comments when the
-- player attempts to open it.

doorFirstTry = true
door = cafeteria3:addSpot( Spot(NORTH, {64, 424}, {sync = true}) )
door:attach(AUDIO, "door_cafeteria_locked.ogg" )
door:attach(VIDEO, "door_cafeteria_locked.ogv")
door:attach(FUNCTION, 
	function()
		lookAt(NORTH)
		self:play()
		
		if doorFirstTry == true then
			feed(Feeds.Cafeteria.Lead100007, "lead_feed_100007.ogg")
			doorFirstTry = false
		else
			feed(Feeds.Cafeteria.Lead100008, "lead_feed_100008.ogg")
		end
	end)
------------------------------------------------------------------------------------------	

------------------------------------------------------------------------------------------
-- 'Door to Corridor C' node
------------------------------------------------------------------------------------------
-- And... more spots, a particularly nasty table and that's it. Next stop: Corridor B.

speaker = cafeteria3:addSpot( Spot(UP, {880, 1685, 1210, 1675, 1285, 2030, 845, 2030}) )
speaker:attach(FEED, Feeds.Cafeteria.Lead100009, "lead_feed_100009.ogg")	
 
tube = cafeteria3:addSpot( Spot(SOUTH, {176, 452}, {auto = true, loop = true}) )
tube:attach(AUDIO, "cafeteria_tube.ogg")
tube:attach(VIDEO, "cafeteria3_tube.ogv")

tables = cafeteria3:addSpot( 
	Spot(EAST, {1085, 1245, 1280, 1245, 1790, 1870, 1085, 1870}) )
tables:attach(FEED, Feeds.Cafeteria.Lead100001, "lead_feed_100001.ogg")

tables = cafeteria3:addSpot( Spot(WEST, {780, 1260, 980, 1260, 855, 2045, 0, 2045}) )
tables:attach(FEED, Feeds.Cafeteria.Lead100001, "lead_feed_100001.ogg")

nasty = cafeteria3:addSpot( 
	Spot(EAST, {1655, 1240, 1845, 1240, 2040, 1325, 2040, 1465}) )
nasty:attach(FEED, Feeds.Cafeteria.Lead100002, "lead_feed_100002.ogg")

nasty = cafeteria3:addSpot( Spot(SOUTH, {0, 1325, 690, 1375, 585, 1500, 0, 1465}) )
nasty:attach(FEED, Feeds.Cafeteria.Lead100002, "lead_feed_100002.ogg")
------------------------------------------------------------------------------------------
