-- DAGON Configuration File

-- Possible control modes: Drag (0), Fixed (1), Free (2)
-- Drag requires the left button to be pressed to rotate the camera. Fixed keeps the mouse
-- centered and allows direct control of the camera. In this case, the right button
-- toggles between controlling the camera or the cursor (NOTE: This one is still rather
-- finicky). Finally, Free is the default one and rotates the camera as the mouse nears
-- the border of the screen.
controlMode = 2

-- Debug mode. Enable to turn on the debug console and other useful info.
debugMode = false

-- Screen resolution
displayWidth = 1280
displayHeight = 800

-- Visual effects. Can be disabled if the game is performing too slowly.
effects = true

-- Windows only: Disregard the screen best resolution and force the specified one.
forcedFullscreen = false

-- Switch to fullscreen mode by default
fullscreen = true

-- Logging. Enable if something goes wrong.
log = false

-- Script to load. Don't change this!
script = "Asylum.lua"

-- Set fo false if you want to remove the Dagon splash and stop being a cool person
showSplash = true

-- Silent feeds. This silences the main character but keeps the text of feedback.
silentFeeds = false

-- Subtitles. If set to false, no feedback text is displayed.
subtitles = true

-- Vertical sync. As with 'effects', disable if the game is performing slowly.
verticalSync = true
