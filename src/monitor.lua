
Monitor = {}

local  t = 1
local ct = 2

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


if not hudtxt then
	function hudtxt(...)
		parse("hudtxt " .. table.concat({...}, " "))
	end
end


local images = {}

function Monitor.reset(id)
	if id then
		if images[33] then
			if images[33][1] then freeimage(images[id][1]) end
			if images[33][2] then freeimage(images[id][2]) end
			images[33] = nil
		end
		if images[id] then
			if images[id][1] then freeimage(images[id][1]) end
			if images[id][2] then freeimage(images[id][2]) end
			if images[id][3] then freeimage(images[id][3]) end
			images[id] = nil
			hudtxt(id)
		end
	else
		images = {}
	end
end

function Monitor.draw()

	if not images[33] then
		images[33] = {
			image("gfx/block.bmp<n>", 0, 0, 2),
			image("gfx/block.bmp<n>", 0, 0, 2),
		}
		imagecolor(images[33][1], 255, 0, 0)
		imagecolor(images[33][2], 0, 0, 255)
		
		imagescale(images[33][1], 1, 1.25)
		imagescale(images[33][2], 1, 1.25)
		
		imagepos(images[33][1], 250, 20, 0)
		imagepos(images[33][2], 390, 20, 0)
		
		hudtxt(48, string.format('"©255255255%3s"', game("score_t")),
			245, 10, 1)
		hudtxt(49, string.format('"©255255255%3s"', game("score_ct")),
			385, 10, 1)
	end

	local yoff = 0
	local count = (#player(0, "team1") * 20) / 2
	for p in players(t) do
		if not images[p] then
			images[p] = {
				image("gfx/block.bmp<n>", 0, 0, 2),
				image("gfx/block.bmp<n>", 0, 0, 2),
				image("gfx/block.bmp<n>", 0, 0, 2),
			}
			imagecolor(images[p][1], 100, 100, 100)
			imagescale(images[p][1], 5, 0.5)
			
			imagecolor(images[p][3], 0, 0, 0)
			imagescale(images[p][3], 1, 0.5)
			imagealpha(images[p][3], 0.85)
		end
		
		imagecolor(images[p][2], 255, 0, 0)
		
		local health = 5 * ((player(p, "health") or 0) /
			(player(p, "maxhealth") or 100))
		imagescale(images[p][2], health, 0.5)
		
		local ypos = 240 - count + yoff
		yoff = yoff + 20
		imagepos(images[p][1], 85, ypos, 0)
		imagepos(images[p][2], 5 + ((health * 32) / 2), ypos, 0)
		imagepos(images[p][3], 23, ypos, 0)
		
		hudtxt(p, string.format('"©255255255%-4s %-25s %s"',
			player(p, "health"),
			player(p, "name"),
			itemtype(player(p, "weapon"), "name")),
			12, ypos - 9, 0)
	end
	
	
	yoff = 0
	count = (#player(0, "team2") * 20) / 2
	for p in players(ct) do
		if not images[p] then
			images[p] = {
				image("gfx/block.bmp<n>", 0, 0, 2),
				image("gfx/block.bmp<n>", 0, 0, 2),
				image("gfx/block.bmp<n>", 0, 0, 2),
			}
			imagecolor(images[p][1], 100, 100, 100)
			imagescale(images[p][1], 5, 0.5)

			imagecolor(images[p][3], 0, 0, 0)
			imagescale(images[p][3], 1, 0.5)
			imagealpha(images[p][3], 0.75)
		end
		
		imagecolor(images[p][2], 0, 0, 255)
		
		local health = 5 * ((player(p, "health") or 0) /
			(player(p, "maxhealth") or 100))
		imagescale(images[p][2], health, 0.5)
		
		local ypos = 240 - count + yoff
		yoff = yoff + 20
		imagepos(images[p][1], 555, ypos, 0)
		imagepos(images[p][2], 635 - ((health * 32) / 2), ypos, 0)
		imagepos(images[p][3], 617, ypos, 0)

		hudtxt(p, string.format('"©255255255%s %25s %-4s"',
			itemtype(player(p, "weapon"), "name"),
			player(p, "name"),
			player(p, "health")),
			628, ypos - 9, 2)
	end

end


addhook('ms100', 'Monitor.draw')
addhook('spawn', 'Monitor.reset')
addhook('leave', 'Monitor.reset')
addhook('team',  'Monitor.reset')

