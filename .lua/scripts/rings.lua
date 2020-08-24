-- Based on DThought's program
-- Found here: https://github.com/DThought/conky-rings/blob/master/rings.lua
-- Tutorial about Conky + Lua: https://stackoverflow.com/questions/45369475/how-to-implement-a-basic-lua-function-in-conky

conf = {
	bg_colour = 0xc85cd9,
	bg_alpha = 0.1,
	fg_colour = 0x96e1f3,
	fg_alpha = 0.8,
	line_colour = 0x8b119e,
	line_alpha = 0.85
}
elements = {
	-- some lines
	{
		x0 = 380,
		y0 = 90,
		x1 = 380,
		y1 = 100,
		width = 2
	},
	{
		x0 = 350,
		y0 = 90,
		x1 = 350,
		y1 = 100,
		width = 2
	},
	{
		x0 = 320,
		y0 = 90,
		x1 = 320,
		y1 = 100,
		width = 2
	},
	-- line next to CPU graph
	{
		x0 = 220,
		y0 = 122,
		x1 = 220,
		y1 = 163,
		width = 2
	},
	-- line next to mem graph
	{
		x0 = 220,
		y0 = 262,
		x1 = 220,
		y1 = 304,
		width = 2
	},
	{
		name = 'cpu',
		arg = 'cpu1',
		max = 100,
		x = 400,
		y = 90,
		r = 65,
		width = 15,
		graduation = 6,		-- deg
		start_angle = -90,	-- deg
		end_angle = 180,	-- deg
	},
	{
		name = 'cpu',
		arg = 'cpu2',
		max = 100,
		x = 400,
		y = 90,
		r = 50,
		width = 15,
		graduation = 6,
		start_angle = -90,
		end_angle = 180
	},
	{
		name = 'cpu',
		arg = 'cpu3',
		max = 100,
		x = 400,
		y = 90,
		r = 35,
		width = 15,
		graduation = 6,
		start_angle = -90,
		end_angle = 180
	},
	{
		name = 'cpu',
		arg = 'cpu4',
		max = 100,
		x = 400,
		y = 90,
		r = 20,
		width = 15,
		graduation = 6,
		start_angle = -90,
		end_angle = 180
	},
	{
		name = 'acpitemp',
		arg = '',
		max = 100,
		x = 400,
		y = 90,
		r = 80,
		width = 15,
		graduation = 6,
		start_angle = -90,
		end_angle = 180
	},
	{
		x0 = 0,
		y0 = 239,
		x1 = 337,
		y1 = 239,
		width = 2 
	},
	{
		name = 'memperc',
		arg = '',
		max = 100,
		x = 400,
		y = 240,
		r = 60,
		width = 10,
		graduation = 6,
		start_angle = -90,
		end_angle = 180
	},
	{
		name = 'swapperc',
		arg = '',
		max = 100,
		x = 400,
		y = 240,
		r = 45,
		width = 10,
		graduation = 6,
		start_angle = -90,
		end_angle = 180
	},
	{
		x0 = 0,
		y0 = 364,
		x1 = 345,
		y1 = 364,
		width = 2
	},
	{
		name = 'execi',
		arg = "60 df | grep ^/dev/sda1| awk '{ print substr($5, 1, length($5) - 1) }'",
		max = 100,
		x = 400,
		y = 365,
		r = 50,
		width = 10,
		graduation = 6,
		start_angle = -90,
		end_angle = 180
	},
	{
		name = 'execi',
		arg = "60 df | grep ^/dev/sda3| awk '{ print substr($5, 1, length($5) - 1) }'",
		max = 100,
		x = 400,
		y = 365,
		r = 35,
		width = 10,
		graduation = 6,
		start_angle = -90,
		end_angle = 180
	},
	{
		name = 'execi',
		arg = "600 curl -s https://api.coinbase.com/v2/prices/spot?currency=USD | jq '.data.amount' | sed -E 's/(,\"*)//' | tr -d '\"' ",
		min = 11000,
		max = 13000,
		x = 400,
		y = 365,
		r = 20,
		width = 15,
		graduation = 6,
		start_angle = -90,
		end_angle = 180
	},
	{
		x0 = 0,
		y0 = 464,
		x1 = 337,
		y1 = 464,
		width = 2
	},
	{
		x0 = 0,
		y0 = 535,
		x1 = 337,
		y1 = 535,
		width = 2
	}
}


-- function definitions
require 'cairo'
require 'math'

function rgba(colour, alpha)
	return colour / 0x10000 % 0x100 / 255.,
	colour / 0x100 % 0x100 / 255.,
	colour % 0x100 / 255.,
	alpha
end


function draw_line(cr, pt)
	cairo_move_to(cr, pt['x0'], pt['y0'])
	cairo_line_to(cr, pt['x1'], pt['y1'])
	cairo_set_source_rgba(cr, rgba(conf['line_colour'], conf['line_alpha']))
	cairo_set_line_width(cr, pt['width'])
	cairo_stroke(cr)
end


function draw_ring(cr, val, pt)
	local angle_0 = pt['start_angle'] * math.pi / 180 - math.pi / 2
	local angle_f = pt['end_angle'] * math.pi / 180 - math.pi / 2
	local angle_t = angle_0 + val / pt['max'] * (angle_f - angle_0)
	local r = pt['r']
	local width_tip = pt['graduation']

	-- draw the static (background) arc
	cairo_arc(cr, pt['x'], pt['y'], pt['r'], angle_0, angle_f)
	cairo_set_source_rgba(cr, rgba(conf['bg_colour'], conf['bg_alpha']))
	--cairo_set_line_width(cr, pt['width'])
	cairo_set_line_width(cr, 6)
	cairo_stroke(cr)

	-- draw the moving (usage) arc
	cairo_arc(cr, pt['x'], pt['y'], pt['r'], angle_0, angle_t)
	cairo_set_source_rgba(cr, rgba(conf['fg_colour'], conf['fg_alpha']))
	cairo_set_line_width(cr, pt['width'])
	cairo_stroke(cr)

	-- draw the tip
	if (width_tip > 0)	
	then
		angle_0_tip = angle_t - width_tip/2 * math.pi / 180
		angle_1_tip = angle_t +  width_tip/2 * math.pi / 180
		cairo_arc(cr, pt['x'], pt['y'], pt['r'], angle_0_tip, angle_1_tip )
		cairo_set_source_rgba(cr, rgba(conf['fg_colour'], conf['fg_alpha']))
		cairo_set_line_width(cr, pt['width'])
		cairo_stroke(cr)
	end
	
	-- draw the outline of the static arc
	--cairo_arc(cr, pt['x'], pt['y'], pt['r'] + pt['width']/2, angle_0, angle_f)
	--cairo_set_source_rgba(cr, rgba(conf['line_colour'], conf['line_alpha']))
	--cairo_set_line_width(cr, 1)
	--cairo_stroke(cr)

	--cairo_arc(cr, pt['x'], pt['y'], pt['r'] - pt['width']/2, angle_0, angle_f)
	--cairo_stroke(cr)
end


function setup_rings(cr, pt)
	if pt['name'] == nil then
		draw_line(cr, pt)
	else
		local val = conky_parse(string.format('${%s %s}', pt['name'],
		pt['arg'])):gsub('%%', '')
		val = tonumber(val)
		if val == nil then
			return
		end
		if pt['log'] then
			val = math.log(val + 1)
		end
		draw_ring(cr, val, pt)
	end
end


function conky_rings()
	if conky_window == nil then
		return
	end
	local cs = cairo_xlib_surface_create(
	conky_window.display, conky_window.drawable, conky_window.visual,
	conky_window.width, conky_window.height)
	local cr = cairo_create(cs)
	for i in pairs(elements) do
		setup_rings(cr, elements[i])
	end
end
