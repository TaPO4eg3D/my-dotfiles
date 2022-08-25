local mp = require 'mp'
local utils = require 'mp.utils'
local msg = require 'mp.msg'
local assdraw = require 'mp.assdraw'

LOG_LEVEL = 'info'
LOG_ERROR = 'error'

local opts = {
  toggle_menu_binding = 'ctrl+b',
  create_bookmark_binding = 's',

  up_binding = 'UP',
  down_binding = 'DOWN',
  select_binding = 'ENTER',

  main_color = '403609',
  sub_color = '736940',
  select_color = '414ED9',
  selected_color = '3545F2',

  backward_button_text = 'ᐊ',
  forward_button_text = 'N',

  file_path = '/home/tapo4eg3d/.mpv-bookmarks.json'
}

local tick_delay = 0.03

local state = {
  tick_timer = nil,
  tick_last_time = 0,
}

(require 'mp.options').read_options(opts, 'bookmarks')

local styles = {
  default_drawing = string.format('{\\p1\\c&H%s&\\3c&H%s&\\1a&H30&}', opts.main_color, opts.sub_color),
  invis_font = '{\\1a&0xFF&\\2a&H0xFF&\\3a&0xFF&}',
}
local bookmarks = {}

function file_exists(file_path)
  local file = io.open(file_path, 'r')

  if file ~= nil then
    file:close()

    return true
  else
    return false
  end
end

function write_to_file(file_path, write_table)
  local file = io.open(file_path, 'w')
  
  if file == nil then
    msg.log(LOG_ERROR, 'Error while creating: ' .. file_path)

    return false
  end

  local json, errors = utils.format_json(write_table)
  local is_success = file:write(json)

  if is_success == nil then
    msg.log(LOG_ERROR, 'Could not write to: ' .. file_path)

    return false
  end

  file:close()

  return true
end

function get_bookmarks_from_file()
  if file_exists(opts.file_path) then
    -- TODO: Add error handling
    local file = io.open(opts.file_path, 'r')
    file:seek('set')

    local file_content = file:read()
    local result = utils.parse_json(file_content)

    -- We have to if the table is empty because of https://github.com/mpv-player/mpv/issues/9655#issuecomment-1003122597
    if next(result) then
      bookmarks = result
    end

    file:close()
  else
    write_to_file(opts.file_path, nil)
  end
end

function create_new_bookmark(name)
  get_bookmarks_from_file()

  local now = os.date('%Y-%m-%d %H-%m-%S', os.time())
  local working_directory = mp.get_property('working-directory')

  local new_bookmark = {
    created_at = now,
    file_name = mp.get_property('filename'),
    timestamp = mp.get_property('time-pos'),
    name = 'test',
  }

  if bookmarks[working_directory] == nil then
    bookmarks[working_directory] = {}
  end

  table.insert(bookmarks[working_directory], new_bookmark)

  write_to_file(opts.file_path, bookmarks)
end

-- TODO: Find better solution!
mp.set_property('osd-margin-x', 0)
mp.set_property('osd-margin-y', 0)

local width, height = 0, 0
-- UTILITES

-- scale factor for translating between real and virtual ASS coordinates
function get_virt_scale_factor()
    local w, h = mp.get_osd_size()
    if w <= 0 or h <= 0 then
        return 0, 0
    end
    return width / w, height / h
end

-- return mouse position in virtual ASS coordinates (playresx/y)
function get_virt_mouse_pos()
    local sx, sy = get_virt_scale_factor()
    local x, y = mp.get_mouse_pos()
    return x * sx, y * sy
end

function mouse_hit_coords(b_x1, b_y1, b_x2, b_y2)
    local m_x, m_y = get_virt_mouse_pos()
    return (m_x >= b_x1 and m_x <= b_x2 and m_y >= b_y1 and m_y <= b_y2)
end

function create_overlay()
  -- Acts as a separate level of drawing
  local ov = mp.create_osd_overlay('ass-events')

  ov.res_x = mp.get_property('width')
  ov.res_y = mp.get_property('height')

  width, height = ov.res_x, ov.res_y
  
  return ov
end

function calculate_font_size(text, width, height)
  local ov = create_overlay()
  ov.data = '{\\fs100}' .. styles.invis_font .. text
  ov.compute_bounds = true

  local size = ov:update()
  ov:remove()

  local base_width = size.x1 - size.x0
  local base_height = size.y1 - size.y0

  local width_ratio = width / base_width
  local height_ratio = height / base_height

  local min_ratio = math.min(width_ratio, height_ratio)

  return min_ratio * 100
end

-- Abstract classes:
Drawable = {}

function Drawable:new()
  new_object = {
    state = {
      rendered = false,
    },
    styles = {},
    overlays = {},
  }
  self.__index = self
  
  return setmetatable(new_object, self)
end

-- Abstract methods:
function Drawable:draw()
  return false
end

function Drawable:onClick()
  return false
end

function Drawable:clean()
  if not self.overlays then
    return false
  end

  for i = 1, #self.overlays do
    self.overlays[i]:remove()
  end

  self.state.rendered = false
end


-- Implementations

-- BBOX
BBox = Drawable:new()
function BBox:draw()
  if self.state.rendered == true then
    return false
  end

  local ov = create_overlay()
  table.insert(self.overlays, ov)

  self.x1 = math.ceil(width / 8)
  self.y1 = math.ceil(height - height / 1.125)

  self.x2 = math.ceil(width - self.x1)
  self.y2 = math.ceil(height / 1.125)

  local ass_string = styles.default_drawing .. string.format(
    'm 0 0 m %u %u l %u %u l %u %u l %u %u',
    self.x1, self.y1, self.x1, self.y2, self.x2, self.y2, self.x2, self.y1
  )

  ov.data = ass_string
  ov:update()

  self.state.rendered = true
end

-- TABS
Tabs = Drawable:new()

function Tabs:draw_separtion_line()
  local ov = create_overlay()
  table.insert(self.overlays, ov)

  self.y_offset = (BBox.y2 - BBox.y1) / 10

  local ass_string = styles.default_drawing .. string.format(
    'm 0 0 m %u %u l %u %u',
    BBox.x1, BBox.y1 + self.y_offset, BBox.x2, BBox.y1 + self.y_offset
  )

  ov.data = ass_string
  ov:update()
end

function Tabs:draw_separtors()
  self.line_spacing = math.floor((BBox.x2 - BBox.x1) / #self.items)

  for i = 1, #self.items - 1 do
    local ov = create_overlay()
    table.insert(self.overlays, ov)

    local l_x1 = BBox.x1 + self.line_spacing * i
    ov.data = styles.default_drawing .. string.format(
      'm 0 0 m %u %u l %u %u', l_x1, BBox.y1, l_x1, BBox.y1 + self.y_offset
    )
    ov:update()
  end
end

function Tabs:calculate_font_size()
  self.font_size = math.huge

  for i = 1, #self.items do
    local item_width = self.line_spacing / 1.25
    local item_height = self.y_offset / 1.25

    self.font_size = math.min(self.font_size, calculate_font_size(
      self.items[i].name, item_width, item_height
    ))
  end
end

function Tabs:draw_tab_mouse_selection()
  if self.state.rendered == false then
    self.selection = {}

    for i = 1, #self.items do
      local ov = create_overlay()

      table.insert(self.overlays, ov)
      table.insert(self.selection, ov)

      self.items[i].x1 = BBox.x1 + self.line_spacing * (i - 1)
      self.items[i].y1 = BBox.y1

      self.items[i].x2 = BBox.x1 + self.line_spacing * i
      self.items[i].y2 = BBox.y1 + self.y_offset

      if i == 1 then
        self.items[i].selected = true
      else
        self.items[i].selected = false
      end
    end
  end

  for i = 1, #self.items do
    local render_string = ''
    local mouse_hits = mouse_hit_coords(
      self.items[i].x1,
      self.items[i].y1,
      self.items[i].x2,
      self.items[i].y2
    )

    if mouse_hits and self.items[i].selected == false then
      render_string = string.format(
        '{\\p1\\1c&H%s&\\bord0} m 0 0 m %u %u l %u %u l %u %u l %u %u',
        opts.select_color,
        self.items[i].x1,
        self.items[i].y1,
        self.items[i].x1,
        self.items[i].y2,
        self.items[i].x2,
        self.items[i].y2,
        self.items[i].x2,
        self.items[i].y1
      )
    end

    if self.items[i].selected == true then
      render_string = string.format(
        '{\\p1\\1c&H%s&\\bord0} m 0 0 m %u %u l %u %u l %u %u l %u %u',
        opts.selected_color,
        self.items[i].x1,
        self.items[i].y1,
        self.items[i].x1,
        self.items[i].y2,
        self.items[i].x2,
        self.items[i].y2,
        self.items[i].x2,
        self.items[i].y1
      )
    end

    self.selection[i].data = render_string
    self.selection[i]:update()
  end
end

function Tabs:draw_text()
  for i =1, #self.items do
    local ov = create_overlay()
    table.insert(self.overlays, ov)

    local t_x1 = (BBox.x1 + self.line_spacing * (i - 1))
    local t_y1 = BBox.y1

    local render_string = '{\\pos(%u, %u)\\fs%u\\a1}%s%s'

    -- Render invisbily first to calculate the final size and center it later
    ov.data = string.format(
      render_string,
      t_x1, t_y1, self.font_size, styles.invis_font, self.items[i].name
    )
    ov.compute_bounds = true

    local size = ov:update()

    local current_width = size.x1 - size.x0
    local current_height = size.y1 - size.y0
    
    local x1_offset = self.line_spacing / 2 - current_width / 2
    local y1_offset = self.y_offset / 2 + current_height / 2

    t_x1 = math.floor(t_x1 + x1_offset)
    t_y1 = math.floor(t_y1 + y1_offset)

    ov.data = string.format(
      render_string,
      t_x1, t_y1, self.font_size, '', self.items[i].name
    )
    ov.compute_bounds = false

    ov:update()
  end
end

function Tabs:draw()
  if self.state.rendered == false then
    self:draw_separtion_line()
    self:draw_separtors()
    self:calculate_font_size()
  end

  self:draw_tab_mouse_selection()

  if self.state.rendered == false then
    self:draw_text()
  end
  
  self.state.rendered = true
end

function Tabs:onClick()
  local mouse_in_tabs = mouse_hit_coords(
    BBox.x1, BBox.y1,
    BBox.x2, BBox.y1 + Tabs.y_offset
  )

  if mouse_in_tabs == false then
    return false
  end

  for i = 1, #self.items do
    local item = self.items[i]
    local mouse_hits = mouse_hit_coords(
      item.x1, item.y1,
      item.x2, item.y2
    )

    item.selected = mouse_hits
  end
end

-- CurrentBookmarks

CurrentBookmarks = Drawable:new()
CurrentBookmarks.chars_to_fit = 150
CurrentBookmarks.items_per_page = 6
CurrentBookmarks.items = {{
  created_at = '2021-01-01',
  file_name = 'fsdsfsddsf fsdfdsf fdsfds fdsfdsfsd fdsfdsd',
  timestamp = mp.get_property('time-pos'),
  name = 'test',
}, {
  created_at = '2021-01-01',
  file_name = mp.get_property('filename'),
  timestamp = mp.get_property('time-pos'),
  name = 'test',
}}

function CurrentBookmarks:calculate_item_size()
  self.item_width = BBox.x2 - BBox.x1
  self.item_height = (BBox.y2 - (BBox.y1 + Tabs.y_offset)) / self.items_per_page

  self.item_offset = self.item_height * 0.125
end

function CurrentBookmarks:draw_separation_lines()
  for i = 1, self.items_per_page - 1 do
    local ov = create_overlay()
    table.insert(self.overlays, ov)

    local y = (BBox.y1 + Tabs.y_offset) + self.item_height * i
    
    local render_string = string.format(
      styles.default_drawing .. 'm %u %u l %u %u',
      BBox.x1, y, BBox.x2, y
    )

    ov.data = render_string
    ov:update()
  end
end

function CurrentBookmarks:calculate_font_size()
  local test_string = string.rep('A', self.chars_to_fit)

  local available_width = self.item_width / 2 - (self.item_offset * 2)
  local available_height = self.item_height / 2 - (self.item_offset * 2)

  self.font_size = calculate_font_size(test_string, available_width, available_height)
end

function CurrentBookmarks:draw_items_text()
  for i = 1, #self.items - 1 do
    local ov = create_overlay()
    ov.compute_bounds = true
    table.insert(self.overlays, ov)

    local item = self.items[i]

    local x = BBox.x1
    local y = BBox.y1 + Tabs.y_offset - 2 + self.item_height * (i - 1)

    local render_string_tmp = '{\\pos(%u, %u)\\fs%u\\an7}%s%s'

    -- TODO: Make sure that the string will fit!
    local item_name = 'Name: ' .. (item.name or 'No name!')
    local item_file_name = 'File name: ' .. (item.file_name or 'No file name!')

    local render_string = ''
    render_string = string.format(
      render_string_tmp,
      x, y - 32 / 6, 32, '', 'NIGGER\\NNIGGER 2'
    )

    ov.data = render_string
    local size = ov:update()

    -- render_string = string.format(
    --   render_string_tmp,
    --   x, y, self.font_size, '', item_name
    -- )

    -- y = y + (size.y1 - size.y0) - self.item_offset + 2

    -- render_string = render_string .. '\n' .. string.format(
    --   render_string_tmp,
    --   x, y, self.font_size, '', item_file_name
    -- )
    
    -- ov.data = render_string
    -- ov:update()
  end
end

function CurrentBookmarks:draw_selection()
  if self.state.rendered == false then
    self.selection = {}

    for i = 1, #self.items do
      local ov = create_overlay()

      table.insert(self.overlays, ov)
      table.insert(self.selection, ov)
    end
  end

  for i = 1, #self.items do
    local x1 = BBox.x1
    local y1 = BBox.y1 + Tabs.y_offset + self.item_height * (i - 1)

    local x2 = BBox.x2
    local y2 = y1 + self.item_height


    local render_string = ''
    local mouse_hits = mouse_hit_coords(x1, y1, x2, y2)

    if mouse_hits then
      render_string = string.format(
        '{\\p1\\1c&H%s&\\bord0} m %u %u l %u %u l %u %u l %u %u',
        opts.select_color,
        x1, y1, x1, y2, x2, y2, x2, y1
      )
    end

    self.selection[i].data = render_string
    self.selection[i]:update()
  end
end

function CurrentBookmarks:draw()
  if self.state.rendered == false then
    self:calculate_item_size()
    self:calculate_font_size()
    self:draw_separation_lines()
  end

  self:draw_selection()

  if self.state.rendered == false then
    self:draw_items_text()
  end

  self.state.rendered = true
end

-- Back Button
BackButton = Drawable:new()

function BackButton:draw_bbox()
  local ov = create_overlay()
  table.insert(self.overlays, ov)

  local x_offset = Tabs.y_offset / 2
  local size = CurrentBookmarks.item_height

  local x1 = BBox.x1 - x_offset - size
  local y1 = BBox.y2 - size

  local x2 = x1 + size
  local y2 = y1 + size

  local render_string = string.format(
    styles.default_drawing .. 'm %u %u l %u %u l %u %u l %u %u',
    x1, y1, x1, y2, x2, y2, x2, y1
  )

  ov.data = render_string
  ov:update()
end

function BackButton:draw()
  if self.state.rendered == false then
    self:draw_bbox()
  end

  self.state.rendered = true
end

-- Forward button
ForwardButton = Drawable:new()

function ForwardButton:draw_bbox()
  local ov = create_overlay()
  table.insert(self.overlays, ov)

  local x_offset = Tabs.y_offset / 2
  local size = math.floor(CurrentBookmarks.item_height)

  self.x1 = BBox.x2 + x_offset
  self.y1 = BBox.y2 - size

  self.x2 = self.x1 + size
  self.y2 = self.y1 + size

  local render_string = string.format(
    styles.default_drawing .. 'm %u %u l %u %u l %u %u l %u %u',
    self.x1, self.y1, self.x1, self.y2, self.x2, self.y2, self.x2, self.y1
  )

  ov.data = render_string
  msg.log(LOG_LEVEL, render_string)
  ov:update()
end

function ForwardButton:draw_text()
  local ov = create_overlay()
  ov.compute_bounds = true
  table.insert(self.overlays, ov)

  local item_width = self.x2 - self.x1
  local item_height = self.y2 - self.y1
  
  local font_size = calculate_font_size(
    opts.forward_button_text, item_width, item_height
  )

  local render_string_tmp = '{\\pos(%u, %u)\\fs%u\\an7}%s%s'
  local render_string = string.format(
    render_string_tmp,
    self.x1, self.y1, font_size, styles.invis_font, opts.forward_button_text
  )

  ov.data = render_string
  local size = ov:update()

  local x_offset = size.x1 - size.x0
  local y_offset = size.y1 - size.y0

  msg.log(LOG_LEVEL, x_offset)
  msg.log(LOG_LEVEL, y_offset)

  render_string = string.format(
    render_string_tmp,
    self.x1, self.y1, font_size, '', opts.forward_button_text
  )

  ov.data = render_string
  msg.log(LOG_LEVEL, render_string)
  ov:update()
end

function ForwardButton:draw()
  if self.state.rendered == false then
    self:draw_bbox()
    self:draw_text()
  end

  self.state.rendered = true
end

Tabs.items = {
  {
    name='CURRENT BOOKMARKS',
    element=CurrentBookmarks,
  },
  {
    name='ALL BOOKMARKS',
    element=Drawable
  },
}

function tick()
  BBox:draw()
  Tabs:draw()
  
  for i = 1, #Tabs.items do
    local item = Tabs.items[i]

    if item.selected == true then
      item.element:draw()
    else
      item.element:clean()
    end
  end

  BackButton:draw()
  ForwardButton:draw()

  state.tick_last_time = mp.get_time()
  request_tick()
end

-- The tick is then either executed immediately, or rate-limited if it was
-- called a small time ago.
function request_tick()
    if state.tick_timer == nil then
        state.tick_timer = mp.add_timeout(0, tick)
    end

    if not state.tick_timer:is_enabled() then
        local now = mp.get_time()
        local timeout = tick_delay - (now - state.tick_last_time)
        if timeout < 0 then
            timeout = 0
        end
        state.tick_timer.timeout = timeout
        state.tick_timer:resume()
    end
end

function draw_menu()
  -- TODO: Add a global array of layers for the future cleanup
  mp.add_forced_key_binding('mbtn_left', process_mouse_click)
  request_tick()
end

function cleanup()
  ov.data = ''
  ov:update()
end

function process_mouse_click()
  msg.log(LOG_LEVEL, 'CLICK!')
  Tabs:onClick()
end

mp.add_forced_key_binding(opts.toggle_menu_binding, "bookmark-menu", draw_menu)
mp.add_forced_key_binding('ctrl+c', "clear-bookmark-menu", draw_menu)
