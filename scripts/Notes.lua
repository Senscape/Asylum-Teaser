--[[

ASYLUM : Interactive Teaser

Script file: Journal notes

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

This file makes use of our journal implementation, so check out Journal.lua for the nitty
gritty.

--]]

require 'English'
require 'Journal'

-- Create the journal
journal = Journal.create()

------------------------------------------------------------------------------------------
-- Reminder entry
------------------------------------------------------------------------------------------
seenReminder = false

function showReminder()
	if seenReminder == false then
		journal:markEntry(Notes.Entries.REMINDER)
		seenReminder = true
	end
	
	if readme:isVisible() == false then
		intro:cancel()
		journal:toggle()
		readme:show()
	else
		readme:hide()
	end
end
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Thoughts about the 'Tunnel of the Damned'
------------------------------------------------------------------------------------------
function tunnelThoughts()
	size = table.getn(Notes.Tunnel.Thoughts)
	if Notes.Tunnel.State < size then
		if Notes.Tunnel.State == (size - 1) then
			if foundInfirmary == true then
				Notes.Tunnel.State = Notes.Tunnel.State + 1
			end
		else Notes.Tunnel.State = Notes.Tunnel.State + 1
		end
	end
	feed(Notes.Tunnel.Thoughts[Notes.Tunnel.State], 
		"lead_note_" .. Notes.Tunnel.ID .. "00" .. Notes.Tunnel.State .. ".ogg")
end
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Thoughts about the Infirmary
------------------------------------------------------------------------------------------
foundInfirmary = false

function infirmaryThoughts()
	size = table.getn(Notes.Infirmary.Thoughts)
	if foundInfirmary == true then
		Notes.Infirmary.State = size
	else
		if Notes.Infirmary.State < (size - 1) then
			Notes.Infirmary.State = Notes.Infirmary.State + 1
		end
	end
	feed(Notes.Infirmary.Thoughts[Notes.Infirmary.State], 
		"lead_note_" .. Notes.Infirmary.ID .. "00" .. Notes.Infirmary.State .. ".ogg")
end
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Notes for the key to Cells
------------------------------------------------------------------------------------------
foundKeyMale = false
needKeyMale = false
usedKeyMale = false

function keyMaleThoughts()
	if usedKeyMale == true then
		Notes.KeyMale.State = 4
	else
		if foundKeyMale == true and 
			currentNode() == infirmary3 then
			unlockCellsDoor()
			return
		end
	
		if needKeyMale == true then
			if foundKeyMale == true then				
				Notes.KeyMale.State = 3
			else
				Notes.KeyMale.State = 1
			end
		else
			Notes.KeyMale.State = 2
		end
	end

	feed(Notes.KeyMale.Thoughts[Notes.KeyMale.State],
		"lead_note_" .. Notes.KeyMale.ID .. "00" .. Notes.KeyMale.State .. ".ogg")
end
------------------------------------------------------------------------------------------

-- Add default entries
journal:addEntry(Notes.Entries.REMINDER, showReminder)
journal:addEntry(Notes.Entries.TUNNEL, tunnelThoughts)
journal:addEntry(Notes.Entries.INFIRMARY, infirmaryThoughts)

-- Initialise the journal
journal:init()