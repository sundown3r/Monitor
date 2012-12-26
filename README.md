Monitor
=======

A Lua script for CS2D which shows player information on screen.

A server-side solution based solely on uprate6's client-side plugin (it's a 
**plugin**, not a hack!) for those who are scared of DLL injections.

It currently lacks basic features such as access control (at the moment it is 
visible for every player) and is filled with 'bugs' for which the inflexibility 
of CS2D does not allow an easy fix: unaligned text due to a limited amount of 
hudtxt ID's (use a monospace font to fix that), images are drawn *under* the 
HUD instead of over and the remaining time is not visible (is anyone aware of a 
parameter that can fetch the remaining time? I couldn't find it).

No additional resources should be needed, the script only uses the image 
*gfx/block.bmp* which is included in the ZIP archive download by default.

Installation
------------

Simply drop *src/Monitor.lua* in the directory *sys/lua/autorun/* and start a 
server.

