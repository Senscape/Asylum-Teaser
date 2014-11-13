--[[

ASYLUM : Interactive Teaser

Script file: Introduction class

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

This and Readme.lua are slightly more complicated files than the rooms. They feature Lua's
implementation of classes. I found this to be the best way to represent these kind of
objects. The idea is to show overlays of images or buttons on top of the current node or
slide. The camera always ignores these overlays, which makes them ideal for GUI elements.

It's like this:

	1) Overlays are containers that hold images or buttons. They can be disabled and
	enabled. Mostly importantly, they can be repositioned which happens to modify the
	coordinates of all the objects contained (we use this in Journal.lua). Finally, overlays
	can be faded in or out, effectively applying the fade to all the objects in them.

	2) Images are that: images. They ignore mouse events and are used to show stuff only.
	
	3) Buttons are like meaty images. They do accept mouse events. In fact, they have the
	same interactivity as spots. The 'setAction' method is like the 'attach' for spots,
	except it only accepts FEED, FUNCTION and SWITCH tags. Also useful: they can show text.
	Of course, you can set images for buttons, so these are extremely powerful objects.
	
	4) Both images and buttons can be repositioned, resized and toggled within their overlay
	containers as you wish. It's loads of fun for family and friends!
	
	One last important thing: overlays are always disabled by default, so they have to be
	specifically enabled to work. Fading in will automatically enable them, as fading out
	will leave them disabled then they're no longer visible (a behaviour that in fact
	applies to all the objects in Dagon).

--]]

------------------------------------------------------------------------------------------
-- Intro - Class definition
------------------------------------------------------------------------------------------
Intro = {}
Intro.__index = Intro

function Intro.create()
	local self = {
		-- Main overlay
		ovrIntro,
		
		-- Various images contained in the overlay
		imgLogo,
		imgCredit1,
		imgCredit2,
		imgCredit3,
		imgCredit4,
		
		-- This is a timer we use to update the graphics when the intro is running. The loop
		-- determines the next step in the sequence.
		timerID,
		timerLoop = 1,
		
		-- Blah
		running = false
  }
  
  -- Lua stuff. Don't ask, I'm not sure myself...
	setmetatable(self, Intro)
	 
	-- This is the logo. Same as the rest, except it's smoothly scaled for a cool effect.
	self.imgLogo = Image("intro_logo.png")
	self.imgLogo:scale(0.5)

	-- Credits images
	self.imgCredit1 = Image("intro_credit1.png")
	self.imgCredit1:disable()
	
	self.imgCredit2 = Image("intro_credit2.png")
	self.imgCredit2:disable()

	self.imgCredit3 = Image("intro_credit3.png")
	self.imgCredit3:disable()

	self.imgCredit4 = Image("intro_credit4.png")
	self.imgCredit4:disable()
	
	-- Now we add all the stuff to the overlay
	self.ovrIntro = Overlay("Intro") 
	self.ovrIntro:addImage(self.imgLogo)
	self.ovrIntro:addImage(self.imgCredit1)
	self.ovrIntro:addImage(self.imgCredit2)
	self.ovrIntro:addImage(self.imgCredit3)
	self.ovrIntro:addImage(self.imgCredit4)
	
	-- Manually invoke the resize method to relocate all the elements with the current
	-- resolution of the user
	self:resize()
		
	return self
end
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Intro - Class methods
------------------------------------------------------------------------------------------
function Intro:start()
	-- This is the function that starts the intro sequence. First we disable the current
	-- node. Yes, nodes can be disabled/enabled and faded even. It's only useful to perform
	-- transitions like this. No, you can't have two (or more) nodes loaded at the same
	-- time. Perhaps in future versions...
	node = currentNode()
	node:disable()
	
	-- Stop the music because we want to make sure it starts in a later step
	musicLayer1:stop()
	
	-- Guess what... This command disables the cursor!
	cursor.disable()
	
	-- Disable the journal icon so that it's later faded in along with the cursor. As you
	-- can see this class depends on many other files, so this is by no means an effective
	-- design. It should be improved.
	journal:disable()
	
	-- Note how we specifically enable the overlay here
	self.ovrIntro:enable()
	play("thump.ogg")

	-- And now we create the timer with the function that will be called each 4 seconds.
	-- With that time in mind, we define arbitrary steps to operate the elements, mostly
	-- cross-fading the credits.
	self.timerID = startTimer(4, true,
		function()
			if (self.timerLoop == 1) then
				self.imgLogo:fadeOut()
				
				-- With the logo gone, we fade in the scene and start the music. Sooo smooth!
				node:fadeIn()
				musicLayer1:play()
			elseif (self.timerLoop == 2) then	
				self.imgCredit1:fadeIn()
				-- Now fade in the cursor and enable the journal (performs a fade in as well)
				cursor.fadeIn()
				journal:enable()
			elseif (self.timerLoop == 4) then	
				self.imgCredit1:fadeOut()
				self.imgCredit2:fadeIn()
			elseif (self.timerLoop == 6) then	
				self.imgCredit2:fadeOut()
				self.imgCredit3:fadeIn()
			elseif (self.timerLoop == 8) then	
				self.imgCredit3:fadeOut()
				self.imgCredit4:fadeIn()			
			elseif (self.timerLoop == 10) then
				self.imgCredit4:fadeOut()
			elseif (self.timerLoop == 11) then
				-- We no longer need this timer, so we throw it away. Useless, bad timer, we don't
				-- love you anymore.
				stopTimer(self.timerID)
			end
			
			self.timerLoop = self.timerLoop + 1
		end)
		
		self.running = true
end

-- This is a function that's never used but is here just in case. It completely cancels
-- the intro sequence and leaves the game in a "normal" state.
function Intro:cancel()
	if self.running == true then
		self.ovrIntro:fadeOut()
		if self.timerLoop == 1 then
			node = currentNode()
			node:fadeIn()
			cursor.fadeIn()
			journal:enable()
			musicLayer1:play()
		end
		stopTimer(self.timerID)
		self.running = false
	end
end

-- We do this often to support any resolution and live resizing in case of a window.
-- Remember: it's our responsibility to relocate these elements on screen. The engine
-- won't care about them.
function Intro:resize()
	local w, h = 0
	
	-- We used the size() method here, but another option would be to acquire the current
	-- position and do a different math. Your choice.

	-- The logo is always centered.
	w, h = self.imgLogo:size()
	self.imgLogo:setPosition((config.displayWidth / 2) - (w / 2), 
			(config.displayHeight / 2) - (h / 2))
	
	-- And the credits are alternatively glued to left and right sides of the screen.
	w, h = self.imgCredit1:size()
	self.imgCredit1:setPosition(50, (config.displayHeight / 2) - (h / 2))
		
	w, h = self.imgCredit2:size()
	self.imgCredit2:setPosition(config.displayWidth - w - 50, 
		(config.displayHeight / 2) - (h / 2))
	
	w, h = self.imgCredit3:size()
	self.imgCredit3:setPosition(50, (config.displayHeight / 2) - (h / 2))
	
	-- Last one goes centered for that cinematic feel. Grab the popcorn!
	w, h = self.imgCredit4:size()
	self.imgCredit4:setPosition((config.displayWidth / 2) - (w / 2), 
		(config.displayHeight / 2) - (h / 2))
end

-- Finally, this function is called during the POST_RENDER event to smoothly scale the
-- logo
function Intro:update()
	if self.running == true then
		local w, h = 0
	
		self.imgLogo:scale(1.0015)
		w, h = self.imgLogo:size()
		self.imgLogo:setPosition((config.displayWidth / 2) - (w / 2), 
				(config.displayHeight / 2) - (h / 2))
	end
end
------------------------------------------------------------------------------------------