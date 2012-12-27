--------------------------
-- Monitor, a Lua script for CS2D which shows player information on screen.
-- Author: sundown3r
-- https://sundown3r.wordpress.com/2012/12/26/monitor-cs2d/
-- Last update: 27/12/2012
--------------------------

-- The standard comma-seperated USGN list.
-- Leave empty to allow for every spectator.
local ACCESSCONTROL = { 7134 }


Monitor = {}

local  t = 1
local ct = 2

-- A shorthand to pairs(player(0, team)):
--  for player in players(t) do ... end
local function players(team)
	if team == t or team == ct then
		team = "team" .. team
	else
		team = "table"
	end
	local k, v
	return function(t)
		k, v = next(t, k)
		return v
	end, player(0, team), nil
end

-- An iterator for all players with Monitor enabled
local speclist = {}
local function playersEnabled()
	local k, v
	return function(t)
		repeat
			k, v = next(t, k)
		until k == nil or v == true and player(k, "team") == 0
		return k
	end, speclist, nil
end

-- Provide functions hudtxt and hudtxt2 only if wrapper.lua is disabled
local hudtxt = hudtxt
if not hudtxt then
	function hudtxt(...)
		parse("hudtxt " .. table.concat({...}, " "))
	end
end

local hudtxt2 = hudtxt2
if not hudtxt2 then
	function hudtxt2(...)
		parse("hudtxt2 " .. table.concat({...}, " "))
	end
end


function Monitor.reset(id)
	if id then
		for spec in playersEnabled() do
			if images[spec][33] then
				if images[spec][33][1] then freeimage(images[spec][33][1]) end
				if images[spec][33][2] then freeimage(images[spec][33][2]) end
				images[spec][33] = nil
			end
			if images[spec][id] then
				if images[spec][id][1] then freeimage(images[spec][id][1]) end
				if images[spec][id][2] then freeimage(images[spec][id][2]) end
				if images[spec][id][3] then freeimage(images[spec][id][3]) end
				images[spec][id] = nil
			end
			hudtxt(id)
			hudtxt(48)
			hudtxt(49)
		end
	else
		images = {}
		for i = 0, 49 do hudtxt(i) end
	end
end


function Monitor.leave(id)
	if images[id] then
		for i = 1, 33 do
			if images[id][i] then
				if images[id][i][1] then freeimage(images[id][i][1]) end
				if images[id][i][2] then freeimage(images[id][i][2]) end
				if images[id][i][3] then freeimage(images[id][i][3]) end
			end
		end
	end
	for i = 0, 49 do hudtxt(i) end
	Monitor.reset(id)
	speclist[id] = nil
	images[id] = nil
end

function ACCESSCONTROL:contains(e)
	for k, v in pairs(self) do
		if v == e then return k end
	end
end

function Monitor.toggle(id, key)
	if key == 1 then
		if #ACCESSCONTROL == 0 or ACCESSCONTROL:contains(player(id, "usgn")) then
			speclist[id] = not speclist[id]
		end
	end
end


local images = {}
function Monitor.draw()
	for spec in playersEnabled() do
		if not images[spec] then images[spec] = {} end
		if not images[spec][33] then
			images[spec][33] = {
				image("gfx/block.bmp<n>", 0, 0, 2, spec),
				image("gfx/block.bmp<n>", 0, 0, 2, spec),
			}
			imagecolor(images[spec][33][1], 255, 0, 0)
			imagecolor(images[spec][33][2], 0, 0, 255)
			
			imagescale(images[spec][33][1], 1, 1.25)
			imagescale(images[spec][33][2], 1, 1.25)
			
			imagepos(images[spec][33][1], 250, 20, 0)
			imagepos(images[spec][33][2], 390, 20, 0)
			
			hudtxt2(spec, 48, string.format('"©255255255%3s"',
				game("score_t")), 245, 10, 1)
			hudtxt2(spec, 49, string.format('"©255255255%3s"',
				game("score_ct")), 385, 10, 1)
		end
	
		local yoff = 0
		local count = (#player(0, "team1") * 20) / 2
		local split = (#player(0, "team1") + #player(0, "team2")) <= 20
		for p in players(t) do
			if not images[spec][p] then
				images[spec][p] = {
					image("gfx/block.bmp<n>", 0, 0, 2, spec),
					image("gfx/block.bmp<n>", 0, 0, 2, spec),
					image("gfx/block.bmp<n>", 0, 0, 2, spec),
				}
				imagecolor(images[spec][p][1], 100, 100, 100)
				imagescale(images[spec][p][1], 5, 0.5)
				
				imagecolor(images[spec][p][3], 0, 0, 0)
				imagescale(images[spec][p][3], 1, 0.5)
				imagealpha(images[spec][p][3], 0.85)
			end
			
			imagecolor(images[spec][p][2], 255, 0, 0)
			
			local health = 5 * ((player(p, "health") or 0) /
				(player(p, "maxhealth") or 100))
			imagescale(images[spec][p][2], health, 0.5)
			
			local ypos = 240 - count + yoff
			yoff = yoff + 20
			imagepos(images[spec][p][1], 85, ypos, 0)
			imagepos(images[spec][p][2], 5 + ((health * 32) / 2), ypos, 0)
			imagepos(images[spec][p][3], 23, ypos, 0)
			
			if split then
				hudtxt2(spec, p, string.format('"©255255255%-4s %s"',
					player(p, "health"),
					player(p, "name")),
					12, ypos - 9, 0)
				hudtxt2(spec, p+20, string.format('"©255255255%s"',
					itemtype(player(p, "weapon"), "name")),
					168, ypos - 9, 0)
			else
				hudtxt2(spec, p, string.format('"©255255255%-4s %-25s %s"',
					player(p, "health"),
					player(p, "name"),
					itemtype(player(p, "weapon"), "name")),
					12, ypos - 9, 0)
			end
		end
		
		
		yoff = 0
		count = (#player(0, "team2") * 20) / 2
		for p in players(ct) do
			if not images[spec][p] then
				images[spec][p] = {
					image("gfx/block.bmp<n>", 0, 0, 2, spec),
					image("gfx/block.bmp<n>", 0, 0, 2, spec),
					image("gfx/block.bmp<n>", 0, 0, 2, spec),
				}
				imagecolor(images[spec][p][1], 100, 100, 100)
				imagescale(images[spec][p][1], 5, 0.5)
	
				imagecolor(images[spec][p][3], 0, 0, 0)
				imagescale(images[spec][p][3], 1, 0.5)
				imagealpha(images[spec][p][3], 0.75)
			end
			
			imagecolor(images[spec][p][2], 0, 0, 255)
			
			local health = 5 * ((player(p, "health") or 0) /
				(player(p, "maxhealth") or 100))
			imagescale(images[spec][p][2], health, 0.5)
			
			local ypos = 240 - count + yoff
			yoff = yoff + 20
			imagepos(images[spec][p][1], 555, ypos, 0)
			imagepos(images[spec][p][2], 635 - ((health * 32) / 2), ypos, 0)
			imagepos(images[spec][p][3], 617, ypos, 0)
	
			if split then
				hudtxt2(spec, p, string.format('"©255255255%s %4s"',
					player(p, "name"),
					player(p, "health")),
					628, ypos - 9, 2)
				hudtxt2(spec, p+20, string.format('"©255255255%s"',
					itemtype(player(p, "weapon"), "name")),
					472, ypos - 9, 2)
			else
				hudtxt2(spec, p, string.format('"©255255255%s %25s %4s"',
					itemtype(player(p, "weapon"), "name"),
					player(p, "name"),
					player(p, "health")),
					628, ypos - 9, 2)
			end
		end
	end
end


addhook('ms100', 'Monitor.draw')
addhook('spawn', 'Monitor.reset')
addhook('leave', 'Monitor.leave')
addhook('team',  'Monitor.leave')
addhook('serveraction', 'Monitor.toggle')
