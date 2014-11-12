--[[

ASYLUM : Interactive Teaser

Script file: Readme class

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

You should check out Intro.lua before going through this file. They are essentially the
same, the exception being that Readme features buttons. Therefore, this one isn't as
commented as Intro.

--]]

------------------------------------------------------------------------------------------
-- Readme - Class definition
------------------------------------------------------------------------------------------
Readme = {}
Readme.__index = Readme

function Readme.create()
	local self = {
		-- Read only definitions
		WIDTH = 1024,
		HEIGHT = 768,
		
		-- We use two overlays to organize the content since we have two readme pages. You'll
		-- notice how fading in and out entire overlays will be very useful here.
		ovrPage1,
		ovrPage2,

		imgPage1Content,
		imgPage2Content,
		
		btnClose,
		btnNext,
		btnPrevious,
		btnFacebook,		
		btnTwitter,
				
		visible = false
  }
  
	setmetatable(self, Readme)
	
	self.imgPage1Content = Image("readme1.png")
	-- We change the default fade speed of the content for quicker crossfades, otherwise
	-- flipping the page feels too sluggish. 
	self.imgPage1Content:setFadeSpeed(FASTEST)
	
	self.imgPage2Content = Image("readme2.png")
	self.imgPage2Content:setFadeSpeed(FASTEST)
	
	-- These would be the equivalent to private methods in Lua. Each is a different action
	-- performed by a button.
	local _close = function()
		play("use_readme_button.ogg")
		-- Note that 'self' here is the pointer to the Readme class and not a Dagon object.
		-- Of course, hide() is a Readme method as well.
		self:hide()
	end
	
	local _next = function()
		play("use_readme_button.ogg")
		-- Yes, just like this: fade out one page, fade in another one.
		self.ovrPage1:fadeOut()
		self.ovrPage2:fadeIn()
	end
	
	local _previous = function()
		play("use_readme_button.ogg")		
		self.ovrPage1:fadeIn()
		self.ovrPage2:fadeOut()
	end
	
	local _facebook = function()
		play("use_social_button.ogg")	
		-- This function from the system library goes to the specified URL with the default
		-- browser. It automatically minimizes the game if fullscreen is enabled, so it's not
		-- suitable for background operations (we'll support that as well in due time).
		system.browse("https://www.facebook.com/Senscape")
	end	
	
	local _twitter = function()
		play("use_social_button.ogg")		
		system.browse("https://twitter.com/Senscape")
	end
	
	self.btnClose1 = Button(self.WIDTH - 90, self.HEIGHT - 90, 90, 90)
	self.btnClose1:setAction(FUNCTION, _close)
	self.btnClose1:setCursor(USE)			   
	self.btnClose1:setImage("close.png")
	self.btnClose1:setFadeSpeed(FASTEST)
	
	self.btnClose2 = Button(self.WIDTH - 90, self.HEIGHT - 90, 90, 90)
	self.btnClose2:setAction(FUNCTION, _close)
	self.btnClose2:setCursor(USE)			   
	self.btnClose2:setImage("close.png")
	self.btnClose2:setFadeSpeed(FASTEST)	
	
	self.btnNext = Button(self.WIDTH - 210, self.HEIGHT - 90, 120, 90)
	self.btnNext:setAction(FUNCTION, _next)
	self.btnNext:setCursor(USE)			   
	self.btnNext:setImage("next.png")
	self.btnNext:setFadeSpeed(FASTEST)	
	
	self.btnPrevious = Button(self.WIDTH - 210, self.HEIGHT - 90, 120, 90)
	self.btnPrevious:setAction(FUNCTION, _previous)
	self.btnPrevious:setCursor(USE)			   
	self.btnPrevious:setImage("previous.png")
	self.btnPrevious:setFadeSpeed(FASTEST)	
	
	self.btnTwitter = Button(280, 650, 229, 64)
	self.btnTwitter:setAction(FUNCTION, _twitter)
	self.btnTwitter:setCursor(USE)			   
	self.btnTwitter:setImage("twitter.png")
	self.btnTwitter:setFadeSpeed(FASTEST)		
	
	self.btnFacebook = Button(525, 650, 229, 64)
	self.btnFacebook:setAction(FUNCTION, _facebook)
	self.btnFacebook:setCursor(USE)			   
	self.btnFacebook:setImage("facebook.png")
	self.btnFacebook:setFadeSpeed(FASTEST)			
	
	self.ovrPage1 = Overlay("Readme") 
	self.ovrPage1:addImage(self.imgPage1Content)
	self.ovrPage1:addButton(self.btnNext)
	self.ovrPage1:addButton(self.btnClose1)
	self.ovrPage1:addButton(self.btnTwitter)
	self.ovrPage1:addButton(self.btnFacebook)
	
	self.ovrPage2 = Overlay("Readme") 
	self.ovrPage2:addImage(self.imgPage2Content)
	self.ovrPage2:addButton(self.btnPrevious)
	self.ovrPage2:addButton(self.btnClose2)		
	
	self:resize()
		
	return self
end
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Readme - Class methods
------------------------------------------------------------------------------------------
function Readme:hide()
	self.ovrPage1:fadeOut()
	self.ovrPage2:fadeOut()	
	self.visible = false
end

function Readme:isVisible()
	return self.visible
end

function Readme:resize()
	-- Resizing is different in Readme. We know the size of the content, which always
	-- remains the same, so we keep it centered.
	self.ovrPage1:setPosition((config.displayWidth / 2) - (self.WIDTH / 2), 
		(config.displayHeight / 2) - (self.HEIGHT / 2))	
		
	self.ovrPage2:setPosition((config.displayWidth / 2) - (self.WIDTH / 2), 
		(config.displayHeight / 2) - (self.HEIGHT / 2))			
end

function Readme:show()
	self.ovrPage1:fadeIn()
		
	self.visible = true
end
------------------------------------------------------------------------------------------