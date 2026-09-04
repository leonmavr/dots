-- Conky config with hexagon gauge aesthetic
-- Generated with the help of ChatGPT 5.6

require 'cairo'

local cold_color = { r = 0x4a / 255, g = 0xef / 255, b = 0xd6 / 255 }
local hot_color = { r = 0xf0 / 255, g = 0x00 / 255, b = 0x50 / 255 }
local hexagon_color = { r = 0xb6 / 255, g = 0xf2 / 255, b = 0xf0 / 255 }
local scale_cpu = 1.2
local scale_ram = 0.85
local scale_filesystem = 0.7
local scale = scale_cpu
local xpos_cpu = 0.82
local ypos_cpu = 0.22
local xpos_ram = 0.88
local ypos_ram = 0.5
local xpos_filesystem = 0.6
local ypos_filesystem = 0.5
local transparency = 0.1
local outline_thickness = 0.3
local outline_coverage = 0.5
local box_transparency = 0.35
local rectangle_scale = 0
local ring_gradient = true
local text_box_enabled = true
local text_box_width_cpu = 140
local text_box_width_ram = 280
local text_box_gap = 12
local text_box_font = 'Hack'
local quote_box_enabled = true
local quote_box_width = 500
local quote_box_height = 66
local quote_box_gap = 12
local quote_speed = 20
local xpos_quote = 0.74
local ypos_quote = 0.68
local cached_cpu_count
local cached_memory_totals
local temperature_sources
local cached_quote_day
local cached_quote
local quote_scroll_offset = 0
local quote_scroll_day

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

local function number_from_conky(expression)
    local value = conky_parse('${' .. expression .. '}') or ''
    return tonumber(value:match('[+-]?%d+%.?%d*')) or 0
end

local function processor_count()
    if cached_cpu_count ~= nil then
        return cached_cpu_count
    end

    local cpuinfo = io.open('/proc/cpuinfo', 'r')
    if cpuinfo == nil then
        return 1
    end

    local count = 0
    for line in cpuinfo:lines() do
        if line:match('^processor%s*:') then
            count = count + 1
        end
    end
    cpuinfo:close()
    cached_cpu_count = math.max(1, count)
    return cached_cpu_count
end

local function initialize_temperature_sources()
    temperature_sources = {}
    local patterns = {
        '/sys/class/thermal/thermal_zone*/temp',
        '/sys/class/hwmon/hwmon*/temp*_input',
    }
    local paths = io.popen('printf "%s\\n" ' .. table.concat(patterns, ' '))
    if paths == nil then
        return
    end

    for path in paths:lines() do
        local source = io.open(path, 'r')
        if source ~= nil then
            table.insert(temperature_sources, source)
        end
    end
    paths:close()
end

local function temperature_value()
    local conky_temperature = number_from_conky('acpitemp')
    if conky_temperature > 0 then
        return conky_temperature
    end

    if temperature_sources == nil then
        initialize_temperature_sources()
    end
    for index = #temperature_sources, 1, -1 do
        local source = temperature_sources[index]
        source:seek('set', 0)
        local value = tonumber(source:read('*l'))
        if value ~= nil then
            if value > 1000 then
                value = value / 1000
            end
            return value
        else
            source:close()
            table.remove(temperature_sources, index)
        end
    end
    return 20
end

local function color_for(value)
    local amount = math.max(0, math.min(1, value / 100))
    return cold_color.r + (hot_color.r - cold_color.r) * amount,
        cold_color.g + (hot_color.g - cold_color.g) * amount,
        cold_color.b + (hot_color.b - cold_color.b) * amount
end

local function point(center_x, center_y, radius, index)
    local angle = math.rad(index * 60)
    return center_x + math.cos(angle) * radius,
        center_y + math.sin(angle) * radius
end

local function draw_segment_band(display, center_x, center_y, outer_radius, inner_radius,
    first_vertex, last_vertex, amount)
    local outer_start_x, outer_start_y = point(center_x, center_y, outer_radius, first_vertex)
    local inner_start_x, inner_start_y = point(center_x, center_y, inner_radius, first_vertex)
    cairo_move_to(display, outer_start_x, outer_start_y)
    if amount >= 1 then
        local outer_end_x, outer_end_y = point(center_x, center_y, outer_radius, last_vertex)
        local inner_end_x, inner_end_y = point(center_x, center_y, inner_radius, last_vertex)
        cairo_line_to(display, outer_end_x, outer_end_y)
        cairo_line_to(display, inner_end_x, inner_end_y)
    elseif amount > 0 then
        local outer_end_x, outer_end_y = point(center_x, center_y, outer_radius, last_vertex)
        local inner_end_x, inner_end_y = point(center_x, center_y, inner_radius, last_vertex)
        cairo_line_to(display, outer_start_x + (outer_end_x - outer_start_x) * amount,
            outer_start_y + (outer_end_y - outer_start_y) * amount)
        cairo_line_to(display, inner_start_x + (inner_end_x - inner_start_x) * amount,
            inner_start_y + (inner_end_y - inner_start_y) * amount)
    end
    cairo_line_to(display, inner_start_x, inner_start_y)
    cairo_close_path(display)
end

local function draw_info_box(display, center_x, center_y, outer_radius)
    if rectangle_scale < 0 then
        return
    end

    local opacity = 1 - box_transparency
    local background_radius = outer_radius * (1 + rectangle_scale)
    cairo_set_source_rgba(display, 0, 0, 0, opacity)
    cairo_move_to(display, point(center_x, center_y, background_radius, 0))
    for vertex = 1, 6 do
        cairo_line_to(display, point(center_x, center_y, background_radius, vertex))
    end
    cairo_close_path(display)
    cairo_fill(display)
end

local function draw_partial_rectangle_outline(display, left, top, width, height)
    if outline_thickness == 0 or outline_coverage == 0 then
        return
    end

    local corners = {
        { x = left, y = top },
        { x = left + width, y = top },
        { x = left + width, y = top + height },
        { x = left, y = top + height },
    }
    cairo_set_source_rgba(display, hexagon_color.r, hexagon_color.g, hexagon_color.b,
        1 - transparency)
    cairo_set_line_width(display, outline_thickness * 7 * scale)
    for index = 1, 4 do
        local next_index = index % 4 + 1
        local start = corners[index]
        local finish = corners[next_index]
        local midpoint_x = (start.x + finish.x) * 0.5
        local midpoint_y = (start.y + finish.y) * 0.5
        cairo_move_to(display, start.x, start.y)
        cairo_line_to(display,
            start.x + (midpoint_x - start.x) * outline_coverage,
            start.y + (midpoint_y - start.y) * outline_coverage)
        cairo_move_to(display, finish.x, finish.y)
        cairo_line_to(display,
            finish.x + (midpoint_x - finish.x) * outline_coverage,
            finish.y + (midpoint_y - finish.y) * outline_coverage)
    end
    cairo_stroke(display)
end

local function truncate_text(text, available_width, font_size)
    local character_limit = math.floor(available_width / (font_size * 0.6))
    if #text <= character_limit then
        return text
    end
    if character_limit <= 3 then
        return text:sub(1, math.max(0, character_limit))
    end
    return text:sub(1, character_limit - 3) .. '...'
end

local function draw_text_box(display, center_x, center_y, outer_radius, configured_width, lines,
    configured_height)
    if not text_box_enabled then
        return
    end

    local width = configured_width * scale / 1.2
    local height = configured_height or outer_radius * 2 * 0.8660254
    local left = center_x - outer_radius - text_box_gap * scale - width
    local top = center_y - height * 0.5
    cairo_set_source_rgba(display, 0, 0, 0, 1 - box_transparency)
    cairo_rectangle(display, left, top, width, height)
    cairo_fill(display)
    draw_partial_rectangle_outline(display, left, top, width, height)

    if lines == nil then
        return
    end
    local line_count = #lines
    local fit_size = height / (line_count * 1.35 + 1.75)
    local font_size = math.max(7 * scale, math.min(12 * scale, fit_size))
    local line_height = font_size * 1.35
    local text_left = left + 10 * scale / 1.2
    local available_width = width - 20 * scale / 1.2
    local text_top = top + font_size * 1.4
    cairo_set_source_rgba(display, 0.72, 0.96, 0.94, 1 - transparency)
    cairo_select_font_face(display, text_box_font, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD)
    cairo_set_font_size(display, font_size)
    for index, line in ipairs(lines) do
        local y = text_top + (index - 1) * line_height
        if y <= top + height - font_size * 0.35 then
            cairo_move_to(display, text_left, y)
            cairo_show_text(display, truncate_text(line, available_width, font_size))
        end
    end
end

local function wrap_text(text, available_width, font_size)
    local character_limit = math.max(1, math.floor(available_width / (font_size * 0.6)))
    local lines = {}
    while #text > character_limit do
        local split_at = text:sub(1, character_limit):match('^.*()%s+')
        split_at = split_at or character_limit
        table.insert(lines, text:sub(1, split_at):gsub('%s+$', ''))
        text = text:sub(split_at + 1)
    end
    if #text > 0 then
        table.insert(lines, text)
    end
    return lines
end

local function draw_segment_zero_separators(display, center_x, center_y, radius, inner_radius)
    if outline_thickness == 0 then
        return
    end

    cairo_set_source_rgba(display, hexagon_color.r, hexagon_color.g, hexagon_color.b, 1 - transparency)
    cairo_set_line_width(display, outline_thickness * 7 * scale * 0.5)
    for _, vertex in ipairs({ 1, 2 }) do
        cairo_move_to(display, point(center_x, center_y, radius, vertex))
        cairo_line_to(display, point(center_x, center_y, inner_radius, vertex))
    end
    cairo_stroke(display)
end

local function create_ring_gradient(display, center_x, center_y, radius, opacity)
    local start_x, start_y = point(center_x, center_y, radius, 2)
    local end_x, end_y = point(center_x, center_y, radius, 7)
    local gradient = cairo_pattern_create_linear(start_x, start_y, end_x, end_y)
    cairo_pattern_add_color_stop_rgba(gradient, 0,
        cold_color.r, cold_color.g, cold_color.b, opacity)
    cairo_pattern_add_color_stop_rgba(gradient, 1,
        hot_color.r, hot_color.g, hot_color.b, opacity)
    return gradient
end

local function draw_partial_outline(display, center_x, center_y, radius)
    if outline_thickness == 0 or outline_coverage == 0 then
        return
    end

    cairo_set_source_rgba(display, hexagon_color.r, hexagon_color.g, hexagon_color.b, 1 - transparency)
    cairo_set_line_width(display, outline_thickness * 7 * scale)
    for vertex = 0, 5 do
        local next_vertex = vertex + 1
        local start_x, start_y = point(center_x, center_y, radius, vertex)
        local end_x, end_y = point(center_x, center_y, radius, next_vertex)
        local midpoint_x = (start_x + end_x) * 0.5
        local midpoint_y = (start_y + end_y) * 0.5
        cairo_move_to(display, start_x, start_y)
        cairo_line_to(display,
            start_x + (midpoint_x - start_x) * outline_coverage,
            start_y + (midpoint_y - start_y) * outline_coverage)
        cairo_move_to(display, end_x, end_y)
        cairo_line_to(display,
            end_x + (midpoint_x - end_x) * outline_coverage,
            end_y + (midpoint_y - end_y) * outline_coverage)
    end
    cairo_stroke(display)
end

local function draw_hexagon(display, center_x, center_y, radius, inner_radius, label, value)
    local red, green, blue = color_for(value)
    local filled_segments = math.max(0, math.min(5, value / 100 * 5))
    local opacity = 1 - transparency
    local gradient
    if ring_gradient then
        gradient = create_ring_gradient(display, center_x, center_y, radius, opacity)
    end

    local fill_edges = { { 2, 3 }, { 3, 4 }, { 4, 5 }, { 5, 6 }, { 6, 7 } }
    for segment = 0, 4 do
        local edge = fill_edges[segment + 1]
        local amount = math.max(0, math.min(1, filled_segments - segment))
        if amount > 0 then
            if gradient then
                cairo_set_source(display, gradient)
            else
                cairo_set_source_rgba(display, red, green, blue, opacity)
            end
            draw_segment_band(display, center_x, center_y, radius, inner_radius,
                edge[1], edge[2], amount)
            cairo_fill(display)
        end
    end
    if gradient then
        cairo_pattern_destroy(gradient)
    end

    draw_partial_outline(display, center_x, center_y, radius)

    cairo_set_source_rgba(display, 0.72, 0.96, 0.94, opacity)
    cairo_select_font_face(display, 'DejaVu Sans Mono', CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD)
    local font_size = math.max(7 * scale,
        math.min(12 * scale, (radius - inner_radius) * 0.38))
    cairo_set_font_size(display, font_size)
    local label_x = center_x - #label * font_size * 0.30
    local label_y = center_y + (radius + inner_radius) * 0.4330127 + font_size * 0.35
    cairo_move_to(display, label_x, label_y)
    cairo_show_text(display, label)

    draw_segment_zero_separators(display, center_x, center_y, radius, inner_radius)
end

local function draw_two_ring_stack(display, center_x, center_y, radius_step,
    outer_label, outer_value, inner_label, inner_value)
    local outer_radius = radius_step * 2
    draw_info_box(display, center_x, center_y, outer_radius)

    draw_hexagon(display, center_x, center_y, outer_radius, radius_step, outer_label, outer_value)
    draw_hexagon(display, center_x, center_y, radius_step, 0, inner_label, inner_value)
end

local function draw_filesystem_stack(display, center_x, center_y, radius_step)
    local radius = radius_step * 1.6
    local inner_radius = radius_step

    draw_info_box(display, center_x, center_y, radius)
    draw_hexagon(display, center_x, center_y, radius, inner_radius, '/home',
        number_from_conky('fs_used_perc /home'))
    draw_hexagon(display, center_x, center_y, inner_radius, 0, '/',
        number_from_conky('fs_used_perc /'))
end

local function cpu_text_lines(cpu_count)
    local lines = {}
    for cpu = 0, cpu_count - 1 do
        table.insert(lines, string.format('CPU%d: %d%%', cpu,
            math.floor(number_from_conky('cpu cpu' .. cpu) + 0.5)))
    end
    table.insert(lines, string.format('TEMP: %d C',
        math.floor(math.max(20, math.min(100, temperature_value())) + 0.5)))
    return lines
end

local function memory_text_lines()
    if cached_memory_totals == nil then
        cached_memory_totals = {
            ram = tostring(conky_parse('${memmax}')),
            swap = tostring(conky_parse('${swapmax}')),
        }
    end
    return {
        'RAM: ' .. tostring(conky_parse('${mem}')) .. '/' .. cached_memory_totals.ram,
        'SWAP: ' .. tostring(conky_parse('${swap}')) .. '/' .. cached_memory_totals.swap,
    }
end

local function memory_process_lines()
    local lines = memory_text_lines()
    for process = 1, 5 do
        table.insert(lines, tostring(conky_parse('${top_mem name ' .. process .. '}')) .. ': '
            .. tostring(conky_parse('${top_mem mem ' .. process .. '}')) .. '%')
    end
    return lines
end

local function daily_quote()
    local today = os.date('%Y-%j')
    if cached_quote_day == today then
        return cached_quote
    end

    local file = io.open(os.getenv('HOME') .. '/.config/conky/quotes.json', 'r')
    if file == nil then
        return nil
    end
    local content = file:read('*a')
    file:close()

    local quotes = {}
    for first_name, last_name, message in content:gmatch(
        '{%s*"firstName"%s*:%s*"(.-)"%s*,%s*"lastName"%s*:%s*"(.-)"%s*,%s*"message"%s*:%s*"(.-)"%s*}') do
        local author = first_name
        if last_name ~= '' then
            author = author == '' and last_name or author .. ' ' .. last_name
        end
        table.insert(quotes, { message = message, author = author })
    end

    if #quotes == 0 then
        return nil
    end
    local day_number = tonumber(os.date('%j')) or 1
    cached_quote = quotes[(day_number - 1) % #quotes + 1]
    cached_quote_day = today
    return cached_quote
end

local function quote_text_lines()
    local quote = daily_quote()
    if quote == nil then
        return { 'No quote available' }
    end

    local today = os.date('%Y-%j')
    if quote_scroll_day ~= today then
        quote_scroll_day = today
        quote_scroll_offset = 0
    end
    local character_limit = math.max(1, math.floor((quote_box_width - 20) / (10 * 0.6)))
    local message = quote.message
    local separator = '     '
    local cycle_length = #message + #separator
    local repeated_message = (message .. separator):rep(
        math.ceil((character_limit + #message) / cycle_length) + 1)
    local start = quote_scroll_offset % cycle_length + 1
    message = repeated_message:sub(start, start + character_limit - 1)
    quote_scroll_offset = quote_scroll_offset + quote_speed
    return { message, '-- ' .. quote.author }
end

local function draw_quote_box(display, box_center_x, box_center_y, outer_radius)
    if not quote_box_enabled then
        return
    end
    local width = quote_box_width * scale / 1.2
    local height = quote_box_height * scale / 1.2
    local anchor_x = box_center_x + width * 0.5 + outer_radius + text_box_gap * scale
    draw_text_box(display, anchor_x, box_center_y, outer_radius,
        quote_box_width, quote_text_lines(), height)
end

function conky_main()
    if conky_window == nil then
        return
    end

    local surface = cairo_xlib_surface_create(conky_window.display,
        conky_window.drawable, conky_window.visual,
        conky_window.width, conky_window.height)
    local display = cairo_create(surface)
    local cpu_count = processor_count()
    local normalized_scale_cpu = clamp(scale_cpu, 0, 2)
    local normalized_scale_ram = clamp(scale_ram, 0, 2)
    local normalized_scale_filesystem = clamp(scale_filesystem, 0, 2)
    local normalized_x_cpu = clamp(xpos_cpu, 0, 1)
    local normalized_y_cpu = clamp(ypos_cpu, 0, 1)
    local normalized_x_ram = clamp(xpos_ram, 0, 1)
    local normalized_y_ram = clamp(ypos_ram, 0, 1)
    local normalized_x_filesystem = clamp(xpos_filesystem, 0, 1)
    local normalized_y_filesystem = clamp(ypos_filesystem, 0, 1)
    local normalized_x_quote = clamp(xpos_quote, 0, 1)
    local normalized_y_quote = clamp(ypos_quote, 0, 1)
    transparency = clamp(transparency, 0, 1)
    outline_thickness = clamp(outline_thickness, 0, 1)
    outline_coverage = clamp(outline_coverage, 0, 1)
    box_transparency = clamp(box_transparency, 0, 1)
    quote_box_width = math.max(1, quote_box_width)
    quote_box_height = math.max(1, quote_box_height)
    quote_box_gap = math.max(0, quote_box_gap)
    quote_speed = math.max(0, math.floor(quote_speed))
    text_box_width_cpu = math.max(1, text_box_width_cpu)
    text_box_width_ram = math.max(1, text_box_width_ram)
    text_box_gap = math.max(0, text_box_gap)
    scale = normalized_scale_cpu
    local center_x = conky_window.width * normalized_x_cpu
    local center_y = conky_window.height * normalized_y_cpu
    local memory_center_x = conky_window.width * normalized_x_ram
    local memory_center_y = conky_window.height * normalized_y_ram
    local filesystem_center_x = conky_window.width * normalized_x_filesystem
    local filesystem_center_y = conky_window.height * normalized_y_filesystem
    local base_outer_radius = math.min(140, 48 + cpu_count * 18) / 1.2
    local outer_radius = base_outer_radius * normalized_scale_cpu
    local radius_step = outer_radius / (cpu_count + 1)

    if normalized_scale_cpu > 0 then
        draw_text_box(display, center_x, center_y, outer_radius, text_box_width_cpu,
            cpu_text_lines(cpu_count))
    end

    scale = normalized_scale_ram
    if normalized_scale_ram > 0 then
        local memory_outer_radius = base_outer_radius * scale
        local memory_radius_step = memory_outer_radius / 2
        draw_text_box(display, memory_center_x, memory_center_y, memory_outer_radius, text_box_width_ram,
            memory_process_lines())
        draw_two_ring_stack(display, memory_center_x, memory_center_y, memory_radius_step,
            'RAM', number_from_conky('memperc'), 'SWAP', number_from_conky('swapperc'))
    end

    scale = normalized_scale_filesystem
    if normalized_scale_filesystem > 0 then
        local filesystem_radius_step = base_outer_radius * scale / 1.6
        draw_filesystem_stack(display, filesystem_center_x, filesystem_center_y, filesystem_radius_step)
    end

    scale = normalized_scale_cpu
    draw_quote_box(display, conky_window.width * normalized_x_quote,
        conky_window.height * normalized_y_quote, radius_step)

    scale = normalized_scale_cpu
    if normalized_scale_cpu > 0 then
        draw_info_box(display, center_x, center_y, outer_radius)

        local temperature = math.max(20, math.min(100, temperature_value()))
        draw_hexagon(display, center_x, center_y, outer_radius, outer_radius - radius_step, 'TEMP',
            (temperature - 20) / 80 * 100)

        for cpu = cpu_count - 1, 0, -1 do
            local radius = radius_step * (cpu + 1)
            draw_hexagon(display, center_x, center_y, radius, radius - radius_step, tostring(cpu),
                number_from_conky('cpu cpu' .. cpu))
        end
    end

    cairo_destroy(display)
    cairo_surface_destroy(surface)
end
