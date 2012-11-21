--[[

ASYLUM : Interactive Teaser

Script file: Main module

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

INTRODUCTION:

This code is fairly tidy and makes use of the whole feature set currently being offered by
Dagon. There's much to do and improve, but as you can see it's already possible to
do something that feels like a game. Still, this is a stable alpha which is not ready for
full commercial releases.

I tried to comment this code as much as I could, however I'm assuming you have some
knowledge of Lua: a few portions of the code are very complex and use advanced
functionality of this language. If anything, this is an in-depth look into what Dagon has
to offer; it's not even simple enough to be taken as a tutorial. There is no proper
documentation either... Sorry! More error messages are badly needed, so I advice you go
one step at a time to understand everything that's happening in your script. Also, I urge
you to visit our forums and participate in an already active community of developers that
are hard at work on a Wiki, tutorials and more examples:

http://www.Senscape.net/forum

Syntax, names of functions, and configuration parameters MAY CHANGE. We're still ironing
out the script language, so portions of what you do at this point might be incompatible
with future versions of Dagon (although nothing that couldn't be quickly resolved).

Something else to consider: Dagon is very flexible and will adapt to *your* needs.
However, we came up with this workflow and organisation of files which is intuitive and
scales nicely for large projects. Keep an eye for specific comments that will tell you how
you may load your own assets. Please excuse any spelleing errrors too.

Hope you enjoy the reading and like the engine! Looking forward to seeing your own
creations soon!

	Agustín Cordes

--]]

-- This file consists mostly of setup and some general definitions. You should continue
-- the tour in the Cafeteria.lua file, the first room in the Teaser and the most commented 
-- one.

-- First we load all the required modules (note the script is configured to automatically
-- search in the Modules folder
require 'English'
require 'Notes'
require 'Intro'
require 'Readme'
require 'Tools'

-- Uncomment to mute all sounds, helpful for testing
--config.mute = true

-- Uncomment to show all the interactive spots. This has nothing to do with the indicators
-- the user can toggle on and off: it's the actual polygons that comprise the spots.
--config.showSpots = true

-- Enable the supported camera effects: breathing of the protagonist and a simulated
-- walking when traversing nodes.
camera.breathe = true
camera.walk = true

-- Setup all the visual effects. These will be completely disabled if config.effects is
-- set to false or if the users' video card does not support shaders or rendering to a
-- framebuffer.
effects.dust = 30
effects.dustColor = 0x8880eeee
effects.motionBlur = 700
effects.sharpen = 50
effects.brightness = 150
effects.contrast = 120
effects.saturation = 90 -- Try 0 for a gritty, black and white asylum!
effects.noise = 10

-- Uncomment to try a significantly different look
--effects.sepia = 100

-- This is a useful sentence that hooks a script line to a function key. The first three
-- register functions from Tools.lua. The last one toggles the journal GUI icon on and
-- off.
hotkey(F1, "takeSnapshot()")

hotkey(F2, "adjustGamma()")

hotkey(F3, "adjustCamera()")

hotkey(F4, "journal:toggleIcon()")

-- Default font for feedback
setFont(FEED, "dislexiae.ttf", 20)

-- Let's load all our default cursors. It's worth mentioning that config, effects and
-- cursor are *libraries*, so we use the dot (.) to access their properties or methods.
-- It's different with objects that require colons (:) to access stuff.
cursor.load(NORMAL, "normal.tga")
cursor.load(DRAGGING, "dragging.tga")
cursor.load(LEFT, "left.tga")
cursor.load(RIGHT, "right.tga")
cursor.load(UP, "up.tga")
cursor.load(DOWN, "down.tga")
cursor.load(UP_LEFT, "upleft.tga")
cursor.load(UP_RIGHT, "upright.tga")
cursor.load(DOWN_LEFT, "downleft.tga")
cursor.load(DOWN_RIGHT, "downright.tga")
cursor.load(FORWARD, "forward.tga")
cursor.load(BACKWARD, "backward.tga")
cursor.load(USE, "use.tga")
cursor.load(LOOK, "look.tga")
cursor.load(TALK, "talk.tga")
cursor.load(CUSTOM, "custom.tga") -- We support one custom cursor for now, more soon

-- Now we create references to the music files, which are three layers of increasing
-- tension. To Dagon these are regular audio objects with a difference: we indicate that
-- two layers should be "matched" to the main one. This means that whenever layers are
-- played, the engine makes sure they are all in sync. Note we also set the fade speed
-- to the slowest possible one for smooth transitions.
musicLayer1 = Audio("music_layer1.ogg", {volume = 75, loop = true})
musicLayer1:setFadeSpeed(SLOWEST)

musicLayer2 = Audio("music_layer2.ogg", {volume = 75, loop = true})
musicLayer2:setFadeSpeed(SLOWEST)
musicLayer2:match(musicLayer1)

musicLayer3 = Audio("music_layer3.ogg", {volume = 75, loop = true})
musicLayer3:setFadeSpeed(SLOWEST)
musicLayer3:match(musicLayer1)

-- Creation of the intro which is a Lua class that manages all sorts of layers on screen,
-- in addition to slowly fading the scene. It's rather complex so you might want to ignore
-- it for now.
intro = Intro.create()

-- Similar to intro, this is a Lua class that will display a floating readme with
-- interactive buttons.
readme = Readme.create()

-- Register event hooks. This means Dagon will invoke these functions when the indicated
-- events occur. POST_RENDER will update the state of the intro and perform operations
-- with the journal.
register(POST_RENDER, 
	function()
		intro:update()
		journal:update()					
	end)
	
-- This one is called whenever the window is resized (includes switching to and from
-- fullscreen). The engine does its best to resize elements, but anything that comprises
-- "interface" (overlays, buttons and images) is our responsibility. You don't have to
-- worry about resized spots for example or coordinates in slides.
register(RESIZE, 
	function()
		intro:resize()
		journal:resize()	
		readme:resize()
	end)
	
-- Register our own function for the right mouse click event. Note the Fixed control mode
-- will override this hook. Speaking of which, you can force your own configuration
-- parameters and ignore those provided by the user. i.e.: type config.controlMode = FREE
-- to ensure the control mode always remains the default one.
register(MOUSE_RIGHT_BUTTON,
	function()
		journal:toggle()
	end)	

-- The 'room' is a convenience sentence to load a room. This will add all the nodes
-- created within that file to the indicated room. Also, it makes sure that no file
-- is loaded twice. Please note the room is still an object and any operations performed
-- with it require the object:method() syntax.
room 'Cafeteria'

-- And now... the "switch". The single most complex function in the entire engine, and
-- yet so simple to explain: this basically tells Dagon to set the Cafeteria as the
-- current room. You can also indicate nodes or slides as long as they belong to a room.
switch(Cafeteria)

-- Finally, we start the intro that requires an active room, which is why we do this after
-- making a switch. This can be commented to bypass the whole intro and immediately show
-- the first node.
intro:start()
