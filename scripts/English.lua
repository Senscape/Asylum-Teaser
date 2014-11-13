--[[

ASYLUM : Interactive Teaser

Script file: English strings

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

These are all the strings used in the Teaser. We stored them in Lua tables so they can be
accessed in different ways. It's OUR way, and you're free to do this however you want, but
keep in mind that tables are powerful and the cornerstone of Lua. It's always advisable to
make use of them.

So, we separated strings per room. Each has a 'Comments' sub-table. Comments have no key;
this means they're accessed with an index, which is precisely what we want. Empty comments
have a purpose: the string isn't displayed but the associated audio file still will be
played. Very useful for coughing and other nasty sounds the protagonist may produce.

Finally, that ID serves to organise and identify files.

--]]

-- Strings without voice for function key controls
Messages = {
	Camera1 = "SLOW camera speed",
	Camera2 = "NORMAL camera speed",
	Camera3 = "FAST camera speed",
	Camera4 = "FASTEST camera speed",				
	Gamma0 = "Gamma correction DISABLED",
	Gamma1 = "LOW gamma correction",
	Gamma2 = "MEDIUM gamma correction",
	Gamma3 = "HIGH gamma correction",
	Snapshot = "Snapshot saved in game folder..."
}

Feeds = {

	Cafeteria = {
		ID = 100,
		Comments = {
			"I remember how busy this place was back in the day. Loonies gobbling the stew or rubbing it on their faces. I can almost hear the sound of dishes clanking...",
			"I can hardly stand all this dust.",
			"So much decay around me, it's depressing... and dust. Lots of dust.",
			"",
			"I better leave the cafeteria quickly unless I want more dirt in my lungs.",
			"",
			""
		},
		Lead100001 = "Just ordinary tables.",
		Lead100002 = "Whatever happened to this table must have been nasty.",
		Lead100003 = "Disgusting.",
		Lead100004 = "I wonder what this button is for...",
		Lead100005 = "It's not working.",
		Lead100006 = "Well, this alarm is still working. In a sense that's comforting.",
		Lead100007 = "Something is blocking this door...",
		Lead100008 = "Impossible, I can't go this way.",
		Lead100009 = "There are a few speakers in the cafeteria. They were used to play soothing music during the meals.",
		Lead100010 = "I'm sure there's nothing of interest beneath that blanket. I wouldn't touch it anyway."

	},
	
	CorridorB = {
		ID = 101,
		Comments = {
			"I'm trying to remember the architectural style of this building...",
			"Kirkbride. That's it. A single linear construction housing all the required areas for the proper functioning of an insane asylum.",
			"It was believed that this style of architecture was conducive to the healing of patients, a notion that was completely disregarded by the twentieth century.",
			"There were plans to modernize the construction, but... I can't remember what happened."
		},
		Lead101001 = "This corridor leads... to the male patient wing.",
		Lead101002 = "Nothing worth noting on the corkboard.",
		Lead101003 = "Ah, there's the infirmary, just a few steps to my left. Of course, I could have read the sign over the door.",
		Lead101004 = "This asylum is huge...",
		Lead101005 = "These doors lead to the infirmary alright.",		
		Lead101006 = "A tree seems to have fallen and collapsed this section of the corridor.",
		Lead101007 = "No way I can go around this tree.",
		Lead101008 = "Something tells me this is an artificial obstacle created by the designers to prevent me from visiting the rest of the asylum. Those bastards...",
		Lead101009 = "Most windows in the building are protected in this manner. Still, some inmates would tear apart the grids and mash their heads on the glass."
	},
	
	Infirmary = {
		ID = 102,
		Comments = {
			"The malfunctioning light tubes are hurting my eyes.",
			"Even when it was clean and orderly a few years ago, the infirmary wasn't a cosy place.",
			"",
			"It's so very cold in here...",
			"",
			""
		},
		Lead102001 = "It looks like some kind of organ... I'll be damned if I know which one.",
		Lead102002 = "On second thought, that seems to be a lung.",
		Lead102003 = "The radiators aren't working, and it shows: the cold here is glacial.",
		Lead102004 = "Those radiators aren't working either. I've lost hope...",
		Lead102005 = "Several dated articles of no interest to me.",
		Lead102006 = "Just loads of useless junk.",
		Lead102007 = "Those are the male patient cells, but unfortunately, this gate is locked.",
		Lead102008 = "You could put the best mattress you could find on those iron beds, and they still wouldn't be comfortable."
	},
	
	Showers = {
		ID = 103,
		Lead103001 = "There doesn't seem to be any water. Or whatever unspeakable fluid runs through the pipes in this place.",
		Lead103002 = "I wonder how many diseases can be found in that toilet... probably all of them.",
		Lead103003 = "I guess somebody didn't like his teddy bear...",
		Lead103004 = "Am I going to find a single room with lights functioning properly in this asylum?",
		Lead103005 = "I better leave him alone. He seems upset."
	},
	
	CellsA = {
		ID = 104,
		Lead104001 = "Once was enough, thank you.",
		Lead104002 = "Apparently they've already transferred some inmates.",
		Lead104003 = "The condition of these patients... it breaks my heart.",
		Lead104004 = "This stairway leads to the basement and second floor.",
		Lead104005 = "Locked, but I wouldn't make it through with so many things in the way anyway."
	}
	
}

-- The Notes table is very similar to feeds. Thoughts instead of Comments and one extra
-- variable: 'state', which is used by the journal to determine the current line to play.

Notes = {

	Entries = {
		REMINDER = "Reminder",
		TUNNEL = "'Tunnel of the Damned'",
		INFIRMARY = "Infirmary",
		KEY_MALE = "Key to Cells",
		KEY_UNKNOWN = "Key ring"
	},
	
	Tunnel = {
		ID = 500,
		State = 0,
		Thoughts = {
			"I must go to the so-called 'Tunnel of the Damned', one of the most horrifying places in this asylum. Hopefully I'll find the answers I seek in there...",
			"So many awful stories were told about the Tunnel... it's where the highest risk patients were locked up.",
			"I swore I'd never return to that place, but I have no choice. I must go to the Tunnel.",
			"Now that I know my way, I'd better just go there and stop thinking about it before I change my mind."
		}
	},
		
	Infirmary = {
		ID = 501,	
		State = 0,
		Thoughts = {
			"If I remember well, the way towards the Tunnel is through the infirmary.",
			"There's got to be a map somewhere that will help me find the infirmary.",
			"I know where the infirmary is. It's right next to the cafeteria."
		}
	},
		
	KeyMale = {
		ID = 502,	
		State = 0,
		Thoughts = {
			"I might be able to find a key somewhere that opens the gate to the cells.",
			"I wonder what door this key opens...",
			"This is probably the key I was looking for.",
			"I've already used this key."
		}
	}
	
}
