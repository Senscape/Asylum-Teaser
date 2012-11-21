--[[

ASYLUM : Interactive Teaser

Script file: Journal class

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

This file is HARDCORE. It's quite messy too and should be separated in two different
classes, but hey, It Works (tm). Because this is an implementation very specific to
Asylum, I won't comment much. It's a very complex example of the kind of interface you can
create combining the power of Lua with the flexibility of Dagon. The features of only two
engine objects were used: Overlays and Buttons. That's it.

Please, don't copy this journal implementation. I encourage you to come up with your own
ideas and style. Yes, you can create a typical adventure inventory, or something new that
breaks the paradigm. The tools are here!

Later versions of the engine will support manipulation of actual 3D objects, so this is
only scratching the surface of endless possibilities...

--]]

------------------------------------------------------------------------------------------
-- Journal - Class definition
------------------------------------------------------------------------------------------
Journal = {}
Journal.__index = Journal

function Journal.create()
	local self = {
		-- Readonly journal states
		OPENING = 101,
		CLOSING = 102,
		OPENED = 103,
		CLOSED = 104,
		
		-- Readonly icon animation states
		IDLE = 201,
  	EXPAND = 202,
  	CONTRACT = 203,
  	
  	-- Readonly font settings
		FONT_WIDTH = 13,
		FONT_HEIGHT = 40,
		
		-- Other readonly settings
		ICON_ANIM_SIZE = 20,
		ICON_MAX_SIZE = 180,
		ICON_MIN_SIZE = 64,
		OPENED_SIZE_X = 450,
		OPENED_SIZE_Y = 675,
		OPENED_DISPLACE_X = 30, -- To fully cover the icon
		OPENING_SPEED = 10,
				
		-- Dagon objects
		ovrClosed,
		ovrOpened,
		btnBackground,		
		btnIcon,
	
		-- State of the journal
		currentState,
		
		-- Array to hold the entries
		rows = {},
		
		-- For the marked animation: row currently updated and size of the mark
		rowUpdating = 0,
		markStretch = 0,
	
		-- For the icon animation, current loop and phase of the animation
		iconAnimLoop = 0,
		iconAnimState,

		-- Current size and position of the icon
		closedX = 0,
		closedY = 0,
		closedSize = 180,
		closedCurrSize = 180,
		closedOffset = 0,
		
		-- Current position of the opened journal
		openedX = 0,
		openedY = 0,
		openedOffset = 500,
		
		previousWidth = config.displayWidth,
		previousHeight = config.displayHeight,
		
		ready = false
  }
  
	setmetatable(self, Journal)
	
	self.currentState = self.CLOSED
	self.iconAnimState = self.IDLE
	
	local _toggle = function()
		self:toggle()
	end
	
	self.ovrClosed = Overlay("Journal Closed")
	self.ovrOpened = Overlay("Journal Opened")
	
	-- Icon for the closed journal
	self.btnIcon = Button(self.closedX, self.closedY, self.closedSize, self.closedSize)
	self.btnIcon:setAction(FUNCTION, _toggle)
	self.btnIcon:setCursor(CUSTOM)
	self.btnIcon:setImage("journal_icon.tga")
	
	self:resize()

	self.ovrClosed:addButton(self.btnIcon)
	self.ovrClosed:enable()

	-- Graphic for the opened journal
	self.btnBackground = Button(self.openedX, self.openedY,
		self.OPENED_SIZE_X, self.OPENED_SIZE_Y)
	self.btnBackground:setAction(FUNCTION, _toggle)
	self.btnBackground:setCursor(BACKWARD)			   
	self.btnBackground:setImage("journal_bg.tga")
	
	self.ovrOpened:addButton(self.btnBackground)
	self.ovrOpened:enable()
	self.ovrOpened:move(0, self.openedOffset) -- Hide the journal
		
	return self
end
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Journal - Entry management methods
------------------------------------------------------------------------------------------
function Journal:addEntry(e, f)
	local i = table.getn(self.rows) -- Get length of table
	i = i + 1
	x, y = self.ovrOpened:position()
	self.rows[i] = Button(self.openedX + 50, y + self.openedY + 60 + (i * self.FONT_HEIGHT),
		string.len(e) * self.FONT_WIDTH, self.FONT_HEIGHT)
	self.rows[i]:setAction(FUNCTION, f)	
	self.rows[i]:setCursor(CUSTOM)
	self.rows[i]:setFadeSpeed(FASTEST)
	self.rows[i]:setFont("quikhand.ttf", 24)
	self.rows[i]:setTextColor(0xbb000000)
	self.rows[i]:setText(e)
	self.rows[i]:fadeIn()
	self.ovrOpened:addButton(self.rows[i])
	
	if self.ready then
		self.iconAnimLoop = 2
		play("journal_write.ogg")
	end
end

function Journal:markEntry(e)
	for i,v in pairs(self.rows) do
  	if v:text() == e then
    		self.rows[i]:setImage("journal_mark.tga")
    		
				if self.rowUpdating ~= 0 then
					x, y = self.rows[self.rowUpdating]:size()
					x = string.len(self.rows[self.rowUpdating]:text()) * self.FONT_WIDTH
					self.rows[self.rowUpdating]:setSize(x, y)
					self.markStretch = 0
				end
				
				self.rows[i]:setSize(0, self.FONT_HEIGHT)
    		self.rowUpdating = i
    		
    		if self.ready then
    			self.iconAnimLoop = 2
    			play("journal_erase.ogg")
    		end
    	return
  	end
	end
end

function Journal:tagEntry(e)
	for i,v in pairs(self.rows) do
  	if v:text() == (e) then
  		x, y = self.ovrOpened:position()
    	tag = Image("journal_tag.tga")
			tag:setPosition(self.openedX + 20,
				y + self.openedY + 60 + (i * 40))
			self.ovrOpened:addImage(tag)
			if self.ready then
				self.iconAnimLoop = 2
				play("journal_tag.ogg")
			end
    	return
  	end
	end
end
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Journal - State manipulation methods
------------------------------------------------------------------------------------------
function Journal:disable()
	self.btnIcon:disable()
end	

function Journal:enable()
	self.btnIcon:fadeIn()
end	

function Journal:init()
	self.ready = true
end

function Journal:resize()
		-- Icon
		size = (config.displayWidth * self.ICON_MAX_SIZE) / 1920
		if size > self.ICON_MAX_SIZE then
			size = self.ICON_MAX_SIZE
		elseif size < self.ICON_MIN_SIZE then
			size = self.ICON_MIN_SIZE
		end
		
		self.closedSize = size
		self.closedCurrSize = size
		
		posX = config.displayWidth - size
		posY = config.displayHeight - size
		
		self.btnIcon:setSize(size, size)
		self.btnIcon:setPosition(posX, posY)
	
		-- Opened overlay
		offsetX = config.displayWidth - self.previousWidth
		offsetY = config.displayHeight - self.previousHeight
						
		self.ovrOpened:move(offsetX, offsetY)
						
		self.closedOffset = self.closedOffset + offsetY
		self.openedOffset = self.openedOffset + offsetY
		
		self.closedX = config.displayWidth - self.closedSize
		self.closedY = config.displayHeight - self.closedSize
		self.openedX = config.displayWidth - self.OPENED_SIZE_X +
			self.OPENED_DISPLACE_X
		self.openedY = config.displayHeight - self.openedOffset		
						
		self.previousWidth = config.displayWidth
		self.previousHeight = config.displayHeight
end

function Journal:toggle()
		if self.currentState == self.CLOSED then
			self.ovrOpened:enable()
			play("journal_open.ogg")
			self.currentState = self.OPENING
		elseif self.currentState == self.OPENED then
			play("journal_close.ogg")
			self.currentState = self.CLOSING		
		end
end

function Journal:toggleIcon()
	self.btnIcon:toggle()
end

function Journal:update()
	-- Check if we must update the icon
	if self.iconAnimState == self.IDLE then
		self.iconAnimState = self.EXPAND
	elseif self.iconAnimState == self.EXPAND then
		if self.closedSize < (self.closedCurrSize + self.ICON_ANIM_SIZE) then
			self.closedSize = self.closedSize + 1
			self.closedX = self.closedX - 1
			self.closedY = self.closedY - 1
		else
			self.iconAnimState = self.CONTRACT
		end
		
		self.btnIcon:setPosition(self.closedX, self.closedY)		
		self.btnIcon:setSize(self.closedSize, self.closedSize)
	elseif self.iconAnimState == self.CONTRACT then
		if self.closedSize > self.closedCurrSize then
			self.closedSize = self.closedSize - 1
			self.closedX = self.closedX + 1
			self.closedY = self.closedY + 1
		else
			self.iconAnimState = self.EXPAND
			self.iconAnimLoop = self.iconAnimLoop - 1
		end
		
		self.btnIcon:setPosition(self.closedX, self.closedY)		
		self.btnIcon:setSize(self.closedSize, self.closedSize)	
	end
	
	if self.iconAnimLoop == 0 then
		self.iconAnimState = self.IDLE
	end
	
	-- Update positions of the journal
	if  self.rowUpdating ~= 0 then
		x, y = self.rows[self.rowUpdating]:size()
		x = string.len(self.rows[self.rowUpdating]:text()) * self.markStretch
		self.rows[self.rowUpdating]:setSize(x, y)
		self.markStretch = self.markStretch + 1
		
		if self.markStretch == self.FONT_WIDTH then
			self.markStretch = 0
			self.rowUpdating = 0
		end
	end

	if self.currentState == self.OPENING then
		x, y = self.ovrOpened:position()
		if y < self.closedOffset then
			self.currentState = self.OPENED
		else
			self.ovrOpened:move(0, -self.OPENING_SPEED)
		end
	elseif self.currentState == self.CLOSING then
		x, y = self.ovrOpened:position()
		if y > self.openedOffset then
			self.ovrOpened:disable()		
			self.currentState = self.CLOSED
		else
			self.ovrOpened:move(0, self.OPENING_SPEED)
		end
	end		
end
------------------------------------------------------------------------------------------
