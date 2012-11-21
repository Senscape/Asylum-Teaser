--[[

ASYLUM : Interactive Teaser

Script file: Showers room

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

I assume you have at least gone through Cafeteria.lua by now. This file has the most
complex operations with spots yet. It's like in the movies where a brief special effect
demands the most time. Suffice to say, if you haven't played the teaser this will spoil
the scare for you.

--]]

------------------------------------------------------------------------------------------
-- Basic settings
------------------------------------------------------------------------------------------
-- Required rooms
room 'CellsA'

-- Add layers of music
Showers:addAudio(musicLayer1)
Showers:addAudio(musicLayer2)

-- An electrical hum for the whole room
Showers:addAudio(Audio("showers.ogg", {loop = true, volume = 60}))

-- Footsteps
Showers:setDefaultFootstep("step_marble_m")

-- Creation of nodes
showers1 = Node("showers1", "Sinks")
showers2 = Node("showers2", "Toilets")

-- Node linking
showers1:link({ W = showers2 })
showers2:link({ SE = showers1 })
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Inmates chatter
------------------------------------------------------------------------------------------
-- The inmates chatter was created in the Cells room but we require that file, so it's
-- safe to reference these.

chatter = showers1:addSpot( Spot(SOUTH, {1024, 1024}, {volume = 66}) )
chatter:attach(AUDIO, inmatesChatter1)

chatter = showers1:addSpot( Spot(SOUTH, {1024, 1024}, {volume = 66}) )
chatter:attach(AUDIO, inmatesChatter2)

chatter = showers2:addSpot( Spot(EAST, {1024, 1024}, {volume = 33}) )
chatter:attach(AUDIO, inmatesChatter1)

chatter = showers2:addSpot( Spot(EAST, {1024, 1024}, {volume = 33}) )
chatter:attach(AUDIO, inmatesChatter2)
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Loose madman
------------------------------------------------------------------------------------------
-- The madman will appear in the showers after we look at the teddy bear

looseMadA = showers1:addSpot( Spot(NORTH, {1408, 1280}, {loop = true, volume = 60}) )
looseMadA:attach(AUDIO, "showers_mad.ogg")
looseMadA:attach(VIDEO, "showers1_mad.ogv")
looseMadA:attach(FEED, Feeds.Showers.Lead103005, "lead_feed_103005.ogg")
looseMadA:disable()

looseMadB = showers2:addSpot( Spot(EAST, {250, 1152}, {loop = true, volume = 60}) )
looseMadB:attach(AUDIO, "showers_mad.ogg")
looseMadB:attach(VIDEO, "showers2_mad.ogv")
looseMadB:stop()
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Patches to display when the door is closed
------------------------------------------------------------------------------------------
showersDoorA = showers1:addSpot( Spot(SOUTH, {526, 496}) )
showersDoorA:attach(IMAGE, "showers1s_door_closed.png")
showersDoorA:disable()

showersDoorB = showers1:addSpot( Spot(WEST, {0, 512}) )
showersDoorB:attach(IMAGE, "showers1w_door_closed.png")
showersDoorB:disable()

showersDoorC = showers1:addSpot( Spot(DOWN, {0, 1424}) )
showersDoorC:attach(IMAGE, "showers1d_door_closed.png")
showersDoorC:disable()

showersDoorD = showers2:addSpot( Spot(SOUTH, {0, 652}) )
showersDoorD:attach(IMAGE, "showers2s_door_closed.png")
showersDoorD:disable()

showersDoorE = showers2:addSpot( Spot(EAST, {1738, 684}) )
showersDoorE:attach(IMAGE, "showers2e_door_closed.png")
showersDoorE:disable()

showersDoorF = showers2:addSpot( Spot(DOWN, {1278, 1748}) )
showersDoorF:attach(IMAGE, "showers2d_door_closed.png")
showersDoorF:disable()
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Door to Cells 
------------------------------------------------------------------------------------------
-- We want the full effect here: when the madman enters the showers, he closes the door
-- behind him. This is a very demanding task for us because we have to rework the whole
-- state of the room: patches of images to draw the closed door, stop the inmates chatter
-- because it's no longer heard, and a few other operations.

isShowersDoorClosed = false
doorShowers = showers1:addSpot( Spot(SOUTH, {64, 424}, {sync = true}) )
doorShowers:attach(AUDIO, "door_creaky_open.ogg" )
doorShowers:attach(VIDEO, "door_showers1_cellsa.ogv")
doorShowers:attach(FUNCTION, 
	function()
		-- The protagonist will open the door and leave it opened. Note how we didn't use our
		-- addDoor() tool; we need full control over this spot.
		if isShowersDoorClosed == true then
			lookAt(SOUTH)	
			self:play()
			switch(CellsA)
			-- Disable all those patches
			showersDoorA:disable()
			showersDoorB:disable()
			showersDoorC:disable()
			showersDoorD:disable()
			showersDoorE:disable()
			showersDoorF:disable()			
			-- Play the inmates chatter again
			inmatesChatter1:play()
			inmatesChatter2:play()	
			self:setCursor(FORWARD)
			self:stop()

			isShowersDoorClosed = false
		else
			-- Otherwise, if the door is not closed, leave as always
			switch(CellsA)
		end
		
		-- Go back to the Cells throbbing style and intensity
		effects.throbStyle = 1
		effects.throb = 50
	end)
doorShowers:setCursor(FORWARD)
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- 'Sinks' node
------------------------------------------------------------------------------------------
lamp = showers1:addSpot( Spot(WEST, {1024, 320}, {auto = true, loop = true}) )
lamp:attach(VIDEO, "showers1_lamp.ogv")
lamp:attach(FEED, Feeds.Showers.Lead103004, "lead_feed_103004.ogg")

light = showers1:addSpot( Spot(EAST, {1280, 404}, {auto = true, loop = true}) )
light:attach(VIDEO, "showers1_light.ogv")

sink = showers1:addSpot( Spot(EAST, {460, 1460, 890, 1460, 890, 1750, 460, 1750}) )
sink:attach(FEED, Feeds.Showers.Lead103001, "lead_feed_103001.ogg")
sink:setCursor(USE)

sink = showers1:addSpot( Spot(EAST, {1260, 1460, 1750, 1460, 1750, 1750, 1260, 1750}) )
sink:attach(FEED, Feeds.Showers.Lead103001, "lead_feed_103001.ogg")
sink:setCursor(USE)
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Detail of teddy bear
------------------------------------------------------------------------------------------
-- Poor teddy bear... Boy, he looks familiar. We add a custom action when the player
-- returns from this slide, enabling the madman, the door patches, disabling the inmates
-- chatter, setting a few flags... All to scare players a little. Bah, next time we're
-- doing comedy.

madScare = false
teddyDetail = Slide("showers2_teddy_detail.jpg", "Detail of teddy bear")
teddyDetail:onReturn( 
	function()
		-- OK, here we go. If this is the first time the player leaves the slide, we setup
		-- all the stuff for the new state of the node. Sure, another solution is to use a
		-- completely different node but it's not as efficient.
		if madScare == false then
			play("showers_mad_scare.ogg")
			sleep(2)
			inmatesChatter1:stop()
			inmatesChatter2:stop()
			looseMadA:enable()
			looseMadA:play()	
			looseMadB:play()
			looseMadC:play()		
			showersDoorA:enable()
			showersDoorB:enable()
			showersDoorC:enable()
			showersDoorD:enable()
			showersDoorE:enable()
			showersDoorF:enable()			
			doorShowers:setCursor(USE)
			isShowersDoorClosed = true
			madScare = true
		end
	end)

water = teddyDetail:addSpot( Spot({730, 562}, {auto = true, loop = true}) )
water:attach(VIDEO, "showers2_teddy_detail.ogv")

teddy = teddyDetail:addSpot( Spot({530, 280, 970, 375, 1075, 755, 710, 760, 540, 640}) )
teddy:attach(FEED, Feeds.Showers.Lead103003, "lead_feed_103003.ogg")
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- 'Toilets' node
------------------------------------------------------------------------------------------
light = showers2:addSpot( Spot(EAST, {1268, 722}, {auto = true, loop = true}) )
light:attach(VIDEO, "showers2_light.ogv")

toilet = showers2:addSpot( 
	Spot(WEST, {100, 1920, 360, 1670, 570, 1670, 410, 2000, 100, 2000}) )
toilet:attach(FEED, Feeds.Showers.Lead103002, "lead_feed_103002.ogg")

madScare = false
toilet = showers2:addSpot( Spot(WEST, {1047, 1558}, {auto = true, loop = true}) )
toilet:attach(VIDEO, "showers2_toilet.ogv")
toilet:attach(SWITCH, teddyDetail)
------------------------------------------------------------------------------------------
