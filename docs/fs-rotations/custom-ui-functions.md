# Custom UI Functions 🪖

The Lua Menu Element Window module provides a range of functions for creating and managing custom GUI windows in Lua scripts. This module allows developers to design sophisticated interfaces with various visual elements and controls.

### Create New Window 📃[​](https://docs.project-sylvanas.net/docs/<#create-new-window-> "Direct link to Create New Window 📃")

`core.menu.window.new(id)`

- `id`: String - The unique identifier for the window.
- Returns: `window` - A new window instance.

> Creates a new window with the specified ID. Remember this should always be called outside of the render callback, since we are creating a new unique instance of a window.

### Set Initial Size 📃[​](https://docs.project-sylvanas.net/docs/<#set-initial-size-> "Direct link to Set Initial Size 📃")

`window:set_initial_size(size)`

- `size`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The initial size of the window.

note
This function just sets the initial size of the window. It can be overriden later, either by user input or by code by calling this function inside the render callback (this is not the recommended behaviour)

### Set Initial Position 📃[​](https://docs.project-sylvanas.net/docs/<#set-initial-position-> "Direct link to Set Initial Position 📃")

`window:set_initial_position(pos)`

- `pos`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The initial position of the window.

note
This function just sets the initial position of the window. It can be overriden later, either by user input or by code by calling the "force_next_begin_window_pos" function inside the render callback (this is not the recommended behaviour)

### Set Next Close Cross Position Offset 📃[​](https://docs.project-sylvanas.net/docs/<#set-next-close-cross-position-offset-> "Direct link to Set Next Close Cross Position Offset 📃")

`window:set_next_close_cross_pos_offset(pos_offset)`

- `pos_offset`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The position offset for the close cross.

note
This function will add an offset on the close cross position. By default, it is rendered at the top-right corner of the window.

### Add Menu Element Position Offset 📃[​](https://docs.project-sylvanas.net/docs/<#add-menu-element-position-offset-> "Direct link to Add Menu Element Position Offset 📃")

`window:add_menu_element_pos_offset(pos_offset)`

- `pos_offset`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The position offset for menu elements.

note
This function will add a position offset to the internal dynamic position variable. See "The Advanceds - Explaining Dynamic Drawing" for a more in-depth explanation on the matter.

### Get Window Size 📃[​](https://docs.project-sylvanas.net/docs/<#get-window-size-> "Direct link to Get Window Size 📃")

`window:get_size()`

- Returns: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The current size of the window.

### Get Window Position 📃[​](https://docs.project-sylvanas.net/docs/<#get-window-position-> "Direct link to Get Window Position 📃")

`window:get_position()`

- Returns: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The current position of the window.

### Get Mouse Position 📃[​](https://docs.project-sylvanas.net/docs/<#get-mouse-position-> "Direct link to Get Mouse Position 📃")

`window:get_mouse_pos()`

- Returns: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The current mouse position relative to the window.

### Get Current Context Dynamic Drawing Offset 📃[​](https://docs.project-sylvanas.net/docs/<#get-current-context-dynamic-drawing-offset-> "Direct link to Get Current Context Dynamic Drawing Offset 📃")

`window:get_current_context_dynamic_drawing_offset()`

- Returns: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The current context dynamic drawing offset.

note
Retrieves the internal dynamic position variable's current value. See "The Advanceds - Explaining Dynamic Drawing" for a more in-depth explanation on the matter.

### Get Text Size 📃[​](https://docs.project-sylvanas.net/docs/<#get-text-size-> "Direct link to Get Text Size 📃")

`window:get_text_size(str)`

- `str`: String - The text to measure.
- Returns: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The size of the text.

### Get Centered Text X Position 📃[​](https://docs.project-sylvanas.net/docs/<#get-centered-text-x-position-> "Direct link to Get Centered Text X Position 📃")

`window:get_text_centered_x_pos(text)`

- `text`: String - The text to center.
- Returns: Number - The X position offset for centered text.

note
After we get the centered text x position offset, we just need to add this value to the dynamic drawing offset by using "window:get_current_context_dynamic_drawing_offset()". Another option is to use the "Center Text" function directly (recommended)

### Center Text 📃[​](https://docs.project-sylvanas.net/docs/<#center-text-> "Direct link to Center Text 📃")

`window:center_text(text)`

- `text`: String - The text to center.

note
After calling this function, we just need to render the text using the "add_text_on_dynamic_pos" function. You will see that the text is centered in the middle of the window.

### Render Text 🖌️[​](https://docs.project-sylvanas.net/docs/<#render-text-️> "Direct link to Render Text 🖌️")

`window:render_text(font_id, pos_offset, color, text)`

- `font_id`: Integer - The ID of the font to use.
- `pos_offset`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The position offset for the text.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the text.
- `text`: String - The text to render.

note
Renders a text at the specified position with the given font and color. This function renders statically, so this text is not taken into account for the dynamic position offset.

### Render Rectangle 🖌️[​](https://docs.project-sylvanas.net/docs/<#render-rectangle-️> "Direct link to Render Rectangle 🖌️")

`window:render_rect(pos_min_offset, pos_max_offset, color, rounding, thickness [, flags])`

- `pos_min_offset`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The minimum position offset for the rectangle.
- `pos_max_offset`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The maximum position offset for the rectangle.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the rectangle.
- `rounding`: Number - The rounding radius for the rectangle corners.
- `thickness`: Number - The thickness of the rectangle border.
- `flags` (Optional): Integer - Flags for rectangle rendering. Default is `0`.

Available rounding flags: ( enums.window_enums.rect_borders_rounding_flags. ) NO_ROUNDING ROUND_TOP_LEFT_CORNERS ROUND_TOP_RIGHT_CORNERS ROUND_BOTTOM_LEFT_CORNER ROUND_BOTTOM_RIGHT_CORNER ROUND_TOP_CORNERS ROUND_BOTTOM_CORNERS ROUND_LEFT_CORNERS ROUND_RIGHT_CORNERS ROUND_ALL_CORNERS
note
Renders a rectangle at the specified position with the given properties. This function renders statically, so this rectangle is not taken into account for the dynamic position offset.

### Render Filled Rectangle 🖌️[​](https://docs.project-sylvanas.net/docs/<#render-filled-rectangle-️> "Direct link to Render Filled Rectangle 🖌️")

`window:render_rect_filled(pos_min_offset, pos_max_offset, color, rounding [, flags])`

- `pos_min_offset`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The minimum position offset for the filled rectangle.
- `pos_max_offset`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The maximum position offset for the filled rectangle.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The fill color of the rectangle.
- `rounding`: Number - The rounding radius for the rectangle corners.
- `flags` (Optional): Integer - Flags for rectangle rendering. Default is `0`.

Available rounding flags: ( enums.window_enums.rect_borders_rounding_flags. ) NO_ROUNDING ROUND_TOP_LEFT_CORNERS ROUND_TOP_RIGHT_CORNERS ROUND_BOTTOM_LEFT_CORNER ROUND_BOTTOM_RIGHT_CORNER ROUND_TOP_CORNERS ROUND_BOTTOM_CORNERS ROUND_LEFT_CORNERS ROUND_RIGHT_CORNERS ROUND_ALL_CORNERS
note
Renders a filled rectangle at the specified position with the given properties. This function renders statically, so this rectangle is not taken into account for the dynamic position offset.

### Render Filled Rectangle with Multiple Colors 🖌️[​](https://docs.project-sylvanas.net/docs/<#render-filled-rectangle-with-multiple-colors-️> "Direct link to Render Filled Rectangle with Multiple Colors 🖌️")

`window:render_rect_filled_multicolor(pos_min_offset, pos_max_offset, col_upr_left, col_upr_right, col_bot_right, col_bot_left, rounding [, flags])`

- `pos_min_offset`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The minimum position offset for the filled rectangle.
- `pos_max_offset`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The maximum position offset for the filled rectangle.
- `col_upr_left`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color for the upper-left corner.
- `col_upr_right`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color for the upper-right corner.
- `col_bot_right`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color for the bottom-right corner.
- `col_bot_left`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color for the bottom-left corner.
- `rounding`: Number - The rounding radius for the rectangle corners.
- `flags` (Optional): Integer - Flags for rectangle rendering. Default is `0`.

Available rounding flags: ( enums.window_enums.rect_borders_rounding_flags. ) NO_ROUNDING ROUND_TOP_LEFT_CORNERS ROUND_TOP_RIGHT_CORNERS ROUND_BOTTOM_LEFT_CORNER ROUND_BOTTOM_RIGHT_CORNER ROUND_TOP_CORNERS ROUND_BOTTOM_CORNERS ROUND_LEFT_CORNERS ROUND_RIGHT_CORNERS ROUND_ALL_CORNERS
note
Renders a filled rectangle at the specified position with the given properties. This function renders statically, so this rectangle is not taken into account for the dynamic position offset. The specified colors will be blended so we recommend testing to get used to this function. You can achieve cool-looking visuals with this function. An example is the height / width resizing rectangles that appear when the mouse is hovering the draggable regions of the window. (You can see that on the bottom of the main menu, for example.)

### Render Circle 🖌️[​](https://docs.project-sylvanas.net/docs/<#render-circle-️> "Direct link to Render Circle 🖌️")

`window:render_circle(center, radius, color [, num_segments [, thickness]])`

- `center`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The center position of the circle.
- `radius`: Number - The radius of the circle.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the circle.
- `num_segments` (Optional): Integer - The number of segments for the circle. Default is `0`.
- `thickness` (Optional): Number - The thickness of the circle outline. Default is `1.0`.

note
Renders a circunference (non-filled circle) at the specified position with the given properties. This function renders statically, so this circle is not taken into account for the dynamic position offset.

### Render Filled Circle 🖌️[​](https://docs.project-sylvanas.net/docs/<#render-filled-circle-️> "Direct link to Render Filled Circle 🖌️")

`window:render_circle_filled(center, radius, color [, num_segments])`

- `center`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The center position of the circle.
- `radius`: Number - The radius of the circle.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The fill color of the circle.
- `num_segments` (Optional): Integer - The number of segments for the circle. Default is `0`.

note
Renders a filled circle at the specified position with the given properties. This function renders statically, so this circle is not taken into account for the dynamic position offset.

### Render Quadratic Bezier Curve 🖌️[​](https://docs.project-sylvanas.net/docs/<#render-quadratic-bezier-curve-️> "Direct link to Render Quadratic Bezier Curve 🖌️")

`window:render_bezier_quadratic(p1, p2, p3, color, num_segments, thickness)`

- `p1`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The start point of the curve.
- `p2`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The control point of the curve.
- `p3`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The end point of the curve.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the curve.
- `num_segments`: Integer - The number of segments for the curve.
- `thickness`: Number - The thickness of the curve.

note
Renders a quadratic bezier curve at the specified position with the given properties. This function renders statically, so this curve is not taken into account for the dynamic position offset.

### Render Cubic Bezier Curve 🖌️[​](https://docs.project-sylvanas.net/docs/<#render-cubic-bezier-curve-️> "Direct link to Render Cubic Bezier Curve 🖌️")

`window:render_bezier_cubic(p1, p2, p3, p4, color, num_segments, thickness)`

- `p1`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The start point of the curve.
- `p2`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The first control point of the curve.
- `p3`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The second control point of the curve.
- `p4`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The end point of the curve.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the curve.
- `num_segments`: Integer - The number of segments for the curve.
- `thickness`: Number - The thickness of the curve.

note
Renders a cubic bezier curve at the specified position with the given properties. This function renders statically, so this curve is not taken into account for the dynamic position offset.

### Render Triangle 🖌️[​](https://docs.project-sylvanas.net/docs/<#render-triangle-️> "Direct link to Render Triangle 🖌️")

`window:render_triangle(p1, p2, p3, color, thickness)`

- `p1`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The first point of the triangle.
- `p2`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The second point of the triangle.
- `p3`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The third point of the triangle.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the triangle.
- `thickness`: Number - The thickness of the triangle outline.

note
Renders a triangle at the specified position with the given properties. This function renders statically, so this triangle is not taken into account for the dynamic position offset.

### Render Filled Triangle 🖌️[​](https://docs.project-sylvanas.net/docs/<#render-filled-triangle-️> "Direct link to Render Filled Triangle 🖌️")

`window:render_triangle_filled(p1, p2, p3, color)`

- `p1`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The first point of the triangle.
- `p2`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The second point of the triangle.
- `p3`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The third point of the triangle.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The fill color of the triangle.

note
Renders a filled triangle at the specified position with the given properties. This function renders statically, so this filled triangle is not taken into account for the dynamic position offset.

### Render Filled Triangle with Multiple Colors 🖌️[​](https://docs.project-sylvanas.net/docs/<#render-filled-triangle-with-multiple-colors-️> "Direct link to Render Filled Triangle with Multiple Colors 🖌️")

`window:render_triangle_filled_multi_color(p1, p2, p3, col_1, col_2, col_3)`

- `p1`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The first point of the triangle.
- `p2`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The second point of the triangle.
- `p3`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The third point of the triangle.
- `col_1`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color for the first point.
- `col_2`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color for the second point.
- `col_3`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color for the third point.

note
Renders a filled triangle at the specified position with the given properties. This function renders statically, so this triangle is not taken into account for the dynamic position offset. The specified colors will be blended so we recommend testing to get used to this function. You can achieve cool-looking visuals with this function. An example is the height and width resizing triangle that appear when the mouse is hovering the draggable regions of the window. (You can see that on the right-left of the console, for example.)

### Render Line 🖌️[​](https://docs.project-sylvanas.net/docs/<#render-line-️> "Direct link to Render Line 🖌️")

`window:render_line(p1, p2, color, thickness)`

- `p1`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The start point of the line.
- `p2`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The end point of the line.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the line.
- `thickness`: Number - The thickness of the line.

note
Renders a line from p1 to p2 with the given properties. This function renders statically, so this line is not taken into account for the dynamic position offset.

### Add Separator 🖌️[​](https://docs.project-sylvanas.net/docs/<#add-separator-️> "Direct link to Add Separator 🖌️")

`window:add_separator(right_sep_offset, left_sep_offset, y_offset, width_offset, custom_color)`

- `right_sep_offset`: Number - The right offset for the separator.
- `left_sep_offset`: Number - The left offset for the separator.
- `y_offset`: Number - The y-offset for the separator.
- `width_offset`: Number - The width offset for the separator.
- `custom_color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The custom color for the separator.
- `faded_line`: Boolean - Render the separator as a faded line.

note
Renders a separator from p1 to p2 with the given properties. This function renders statically, so the separator is not taken into account for the dynamic position offset.

### Is Mouse Hovering Rect 📃[​](https://docs.project-sylvanas.net/docs/<#is-mouse-hovering-rect-> "Direct link to Is Mouse Hovering Rect 📃")

`window:is_mouse_hovering_rect(rect_min, rect_max)`

- `rect_min`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The minimum position of the rectangle.
- `rect_max`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The maximum position of the rectangle.
- Returns: Boolean

note
Returns true if the mouse is hovering the specified bounds.

### Is Rect Clicked 📃[​](https://docs.project-sylvanas.net/docs/<#is-rect-clicked-> "Direct link to Is Rect Clicked 📃")

`window:is_rect_clicked(rect_min, rect_max)`

- `rect_min`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The minimum position of the rectangle.
- `rect_max`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The maximum position of the rectangle.
- Returns: Boolean

note
Returns true if the mouse left button was clicked while hovering the rect.

### Is Rect Double Clicked 📃[​](https://docs.project-sylvanas.net/docs/<#is-rect-double-clicked-> "Direct link to Is Rect Double Clicked 📃")

`window:is_rect_double_clicked(rect_min, rect_max)`

- `rect_min`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The minimum position of the rectangle.
- `rect_max`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The maximum position of the rectangle.
- Returns: Boolean

note
Returns true if the mouse left button was double-clicked while hovering the rect.

### Set Visibility 📃[​](https://docs.project-sylvanas.net/docs/<#set-visibility-> "Direct link to Set Visibility 📃")

`window:set_visibility(visibility)`

- `visibility`: Boolean - The visibility state of the window.

note
If visibility is false, the window will not be rendered. This is useful for window-popups, for example. See the examples in the guide.

### Is Being Shown 📃[​](https://docs.project-sylvanas.net/docs/<#is-being-shown-> "Direct link to Is Being Shown 📃")

`window:is_being_shown()`

- Returns: Boolean - The current visibility state of the window.

### Render 📃[​](https://docs.project-sylvanas.net/docs/<#render-> "Direct link to Render 📃")

`window:render(resizing_flag, is_adding_cross, bg_color, border_color, cross_style_flag, flag_1 (optional), flag_2 (optional), flag_3 (optional), callback)`

- `resizing_flag`: Integer - The resizing flag for the window.
- `is_adding_cross`: Boolean - Indicates if a cross is being added.
- `bg_color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The background color of the window. Use color.new(0,0,0,0) to use the Sylvana's theme default color.
- `border_color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The border color of the window.
- `cross_style_flag` (Optional): Integer - The style flag for the cross. Default is `0`.
- `flag_1` (Optional): Integer - Additional rendering flag. Default is `0`.
- `flag_2` (Optional): Integer - Additional rendering flag. Default is `0`.
- `flag_3` (Optional): Integer - Additional rendering flag. Default is `0`.
- `callback`: Function - The callback function to execute during rendering.

Available flags: ( enums.window_enums.window_behaviour_flags. ) NO_MOVE - Disables the option for the user to drag the window. ALWAYS_AUTO_RESIZE - Makes the window content automatically resize according to the space occupied by the widgets that affect the dynamic drawing variable. NO_SCROLLBAR - Disables scrollbars on the window.

- Returns: Boolean - True if the window is being rendered.

note
Renders the window with the specified properties and executes the callback function if the window is open. This is the main function, so all the code regarding visuals will always be inside a window:render block. The callback function must always be the last parameter of the window:render function.
A use example:

```
---@type colorlocal color =require("common/color")---@type vec2local vec2 =require("common/geometry/vector_2")---@type enumslocal enums =require("common/enums")local test_window = core.menu.window("Test window - ")local initial_size = vec2.new(200,200)test_window:set_initial_size(initial_size)local initial_position = vec2.new(500,300)test_window:set_initial_position(initial_position)local bg_color = color.new(16,16,20,180)local border_color = color.new(100,99,150,255)core.register_on_render_window_callback(function()  test_window:begin(enums.window_enums.window_resizing_flags.RESIZE_BOTH_AXIS,true, color.new(0,0,0,0),  border_color, enums.window_enums.window_cross_visuals.BLUE_THEME,function()-- render your stuff hereend)end)
```

### Begin Group 📃[​](https://docs.project-sylvanas.net/docs/<#begin-group-> "Direct link to Begin Group 📃")

`window:begin_group(callback)`

- `callback`: Function - The callback function to execute within the group.

note
Begins a new group and executes the callback function within the group context. This is useful when we want to draw multiple widgets at the same x offset, for example. By using this function, we avoid having to manually set the position for each widget. Instead, we can just set the position once and it will be applied for all widgets inside the callback.
For example, this is the code that we use for the main debug panel buttons:

```
-- popup triggers  window:add_menu_element_pos_offset(vec2.new(actual_offset,7.0))  window:begin_group(function()if menu_elements.unit_info_launch_popup:render("Show Unit Info")then      is_unit_info_popup_enabled =true      unit_info_window.set_visibility(true)endlocal auras_warning_msg ="Auras Table Is Empty\nFor Target: ".. target:get_name()if menu_elements.unit_auras_launch_popup:render("Show Auras Info")then      is_unit_auras_popup_enabled =true      auras_info_window.set_visibility(true)if#all_strings_to_show.auras_strings ==0then        core.graphics.add_notification(auras_warning_msg_id,"[Debug Panel - Warning]", auras_warning_msg,5.0, color.yellow(200))        is_unit_auras_popup_enabled =false        auras_info_window.set_visibility(false)endendlocal is_auras_popup_warning_clicked = core.graphics.is_notification_clicked(auras_warning_msg_id,0.0)if is_auras_popup_warning_clicked then      is_unit_auras_popup_enabled =true      auras_info_window.set_visibility(true)endlocal buffs_warning_msg ="Buffs Table Is Empty\nFor Target: ".. target:get_name()if menu_elements.unit_buffs_launch_popup:render("Show Buffs Info")then      is_unit_buffs_popup_enabled =true      buffs_info_window.set_visibility(true)if#all_strings_to_show.buffs_strings ==0then        core.graphics.add_notification(buffs_warning_msg_id,"[Debug Panel - Warning]", buffs_warning_msg,5.0, color.yellow(200))        is_unit_buffs_popup_enabled =false        buffs_info_window.set_visibility(false)endendlocal is_buffs_popup_warning_clicked = core.graphics.is_notification_clicked(buffs_warning_msg_id,0.0)if is_buffs_popup_warning_clicked then      is_unit_buffs_popup_enabled =true      buffs_info_window.set_visibility(true)endlocal debuffs_warning_msg ="Debuffs Table Is Empty\nFor Target: ".. target:get_name()if menu_elements.unit_debuffs_launch_popup:render("Show Debuffs Info")then      is_unit_debuffs_popup_enabled =true      debuffs_info_window.set_visibility(true)if#all_strings_to_show.debuffs_strings ==0then        core.graphics.add_notification(debuffs_warning_msg_id,"[Debug Panel - Warning]", debuffs_warning_msg,5.0, color.yellow(200))        is_unit_debuffs_popup_enabled =false        debuffs_info_window.set_visibility(false)endendlocal is_debuffs_popup_warning_clicked = core.graphics.is_notification_clicked(debuffs_warning_msg_id,0.0)if is_debuffs_popup_warning_clicked then      debuffs_info_window.set_visibility(true)      is_unit_debuffs_popup_enabled =trueendif menu_elements.more_info_launch_popup:render("Show Extra Info")then      is_extra_info_popup_enabled =true      extra_unit_info_window.set_visibility(true)endend)
```

It is a very extense example, however, you can focus on the following: We are adding the position offset just once, and as you can see in-game, all buttons are centered at the same X position. Note that the "begin_group" function ONLY works for dynamic offset drawings.

### Begin Popup 📃[​](https://docs.project-sylvanas.net/docs/<#begin-popup-> "Direct link to Begin Popup 📃")

`window:begin_popup(background_color, border_color, size, pos, is_close_on_release, is_triggering_from_button, callback)`

- `background_color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The background color of the popup.
- `border_color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The border color of the popup.
- `size`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The size of the popup.
- `pos`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The initial position of the popup. Note that this position is relative to the parent window's position (the window that spawned the popup)
- `is_close_on_release`: Boolean - Indicates if the popup should close on release, instead of on click.
- `is_triggering_from_button`: Boolean - Indicates if the popup is triggered from a core.menu button, since this requires a special handling.
- `callback`: Function - The callback function to execute within the popup.
- Returns: Boolean

note
Begins a new popup with the specified properties and executes the callback function if the popup is open. Essentially, a popup is just another window, with 2 main differences: 1 - We don't need to create a new object for it 2 - A popup will close automatically when the user clicks (or releases the mouse, if that's the specified behaviour) outside of its bounds. The begin popup will return false when the popup is not being rendered (in other words, when the user closed it.) We have to use this information to set a boolean declared outside of the main render loop that will dictaminate wheter the popup will be rendered again after the user closed it or not. For this, we usually have to use a button or something similar. This might sound confusing at first, but here is a quick example to show how this works:

```
-- use a custom rect as a button (you can also use core.menu buttons)if window:is_rect_clicked(open_popup_rect_v1, open_popup_rect_v2)then-- note: define this boolean is defined outside of the main render callback.    is_popup_active =trueendif is_popup_active thenif window:begin_popup(color.new(16,16,20,230), border_color, vec2.new(250,250), vec2.new(150,50),false,false,function()-- render your stuff hereend)end)then-- You can do whatever you want here. If the code here is read it means that the popup is currently being rendered.else-- This means that the user clicked outside of the popup bounds (or released the mouse), so it shouldn't be rendered anymore.      is_popup_active =falseendend
```

You can also check "The Intermediates - Popups" part on Barney's Guide for a more extense explanation and code examples.

### Draw Next Dynamic Widget on Same Line 📃[​](https://docs.project-sylvanas.net/docs/<#draw-next-dynamic-widget-on-same-line-> "Direct link to Draw Next Dynamic Widget on Same Line 📃")

`window:draw_next_dynamic_widget_on_same_line(offset_from_start_x [, spacing_w])`

- `offset_from_start_x`: Number - The offset from the start X position.
- `spacing_w` (Optional): Number - The spacing width. Default is `-1.0`.

note
Draws the next dynamic widget on the same line with the specified offset and spacing. This esentially prevents the internal handling system to automatically add a Y offset for the next dynamic widget that will be rendered.

### Draw Next Dynamic Widget on New Line 📃[​](https://docs.project-sylvanas.net/docs/<#draw-next-dynamic-widget-on-new-line-> "Direct link to Draw Next Dynamic Widget on New Line 📃")

`window:draw_next_dynamic_widget_on_new_line()`
note
Draws the next dynamic widget on a new line. This esentially forces the internal handling system to automatically add a Y offset for the next dynamic widget that will be rendered.

### Add Text on Dynamic Position 📃[​](https://docs.project-sylvanas.net/docs/<#add-text-on-dynamic-position-> "Direct link to Add Text on Dynamic Position 📃")

`window:add_text_on_dynamic_pos(color, text)`

- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the text.
- `text`: String - The text to add.

note
Adds text on the current dynamic position with the specified color.

### Push Font 📃[​](https://docs.project-sylvanas.net/docs/<#push-font-> "Direct link to Push Font 📃")

`window:push_font(font_id)`

- `font_id`: Integer - The ID of the font to push.

note
Pushes the specified font onto the internal font stack. Every text rendered after this call will be performed with the specified font, until a new push_font call is found. The currently available fonts are the following ones: Available Fonts: ( enums.window_enums.font_id. ) FONT_SMALL = 0 FONT_NORMAL = 1 FONT_SEMI_BIG = 2 FONT_BIG = 3 FONT_ICONS_SMALL = 4 FONT_ICONS_BIG = 5 FONT_ICONS_VERY_BIG = 6

### Animate Widget 📃[​](https://docs.project-sylvanas.net/docs/<#animate-widget-> "Direct link to Animate Widget 📃")

`window:animate_widget(animation_id, start_pos, end_pos, starting_alpha, max_alpha, alpha_speed, movement_speed, only_once)`

- `animation_id`: Integer - The ID of the animation.
- `start_pos`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The starting position of the animation.
- `end_pos`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The ending position of the animation.
- `starting_alpha`: Integer - The starting alpha value.
- `max_alpha`: Integer - The maximum alpha value.
- `alpha_speed`: Number - The speed of the alpha change.
- `movement_speed`: Number - The speed of the movement.
- `only_once`: Boolean - Indicates if the animation should run only once.
- Returns: Table - A table containing the animation result with keys `current_position` and `alpha`.

note
Animates a widget with the specified properties and returns the animation result. Check "The Advanceds - Animations" part on Barney's Guide for a more in-depth explanation and code examples.

### Set Next Window Items Spacing 📃[​](https://docs.project-sylvanas.net/docs/<#set-next-window-items-spacing-> "Direct link to Set Next Window Items Spacing 📃")

`window:set_next_window_items_spacing(spacing)`

- `spacing`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The spacing between window items.

note
Sets the spacing between items in the next window. This only applies to dynamic drawings. This function should be called before the window:render function.

### Set Next Window Items Inner Spacing 📃[​](https://docs.project-sylvanas.net/docs/<#set-next-window-items-inner-spacing-> "Direct link to Set Next Window Items Inner Spacing 📃")

`window:set_next_window_items_inner_spacing(inner_spacing)`

- `inner_spacing`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The inner spacing between window items.

note
Sets the inner spacing between items in the next window. This only applies to dynamic drawings. This function should be called before the window:render function.

### Set Next Window Padding 📃[​](https://docs.project-sylvanas.net/docs/<#set-next-window-padding-> "Direct link to Set Next Window Padding 📃")

`window:set_next_window_padding(padding)`

- `padding`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The padding of the next window.

note
Sets the padding for the next window. This only applies to dynamic drawings. This function should be called before the window:render function.

### Set Background Multicolored 📃[​](https://docs.project-sylvanas.net/docs/<#set-background-multicolored-> "Direct link to Set Background Multicolored 📃")

`window:set_background_multicolored(top_left_color: color, top_right_color: color, bot_right_color: color, bot_left_color: color))`
This function enables multi-color support for the given window's background.
warning
This function MUST be called before the window:begin function.
tip
You could use a colorpicker for each color, giving infinite color customization options to the user. An example is the [PvP UI module](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/pvp-ui-module>).

### Manually Set End Called State 📃[​](https://docs.project-sylvanas.net/docs/<#manually-set-end-called-state-> "Direct link to Manually Set End Called State 📃")

`window:set_end_called_state()`
This function is to manually set the end_called flag that's used within the core to check if a begin function was called for the given window. The implementation is a bit complex, just keep in mind that this function exists for when you use the functions to set the next window padding/spacing and it gives a Lua Error on the console. This means that we just found an unhandled exception. To fix this, just call this function at the end of your :begin function.

### Force Next Begin Window Position 📃[​](https://docs.project-sylvanas.net/docs/<#force-next-begin-window-position-> "Direct link to Force Next Begin Window Position 📃")

`window:force_next_begin_window_pos(pos)`

- `pos`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The position to force the next window to begin at.

note
Forces the next window to be rendered at the specified position. This function's use is not recommended in most cases. This function should be called before the window:render function.

### Stop Forcing Next Begin Window Position 📃[​](https://docs.project-sylvanas.net/docs/<#stop-forcing-next-begin-window-position-> "Direct link to Stop Forcing Next Begin Window Position 📃")

`window:stop_forcing_position()`
note
Stops the next window to be rendered at the specified position. This function's use is not recommended in most cases. This function should be called before the window:render function.
tip
An example where force_next_begin_window_pos / stop_forcing_position might be useful is when you have to enable attachment / deattachment of one window to another window. ([See PvP UI Module](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/pvp-ui-module>)). This would be the simple code example:

```
ifnot menu.menu_elements.deattach_check:get_state()then    settings_window:force_next_begin_window_pos(vec2.new(current_window_pos.x + window_size_elements.x:get(), current_window_pos.y))else    settings_window:stop_forcing_position()end
```

The previous code is extracted directly from the PvP UI Module. The settings window is the one that attaches to current window, which would be the main window (the one with the buttons).

### Set Next Window Minimum Size 📃[​](https://docs.project-sylvanas.net/docs/<#set-next-window-minimum-size-> "Direct link to Set Next Window Minimum Size 📃")

`window:set_next_window_min_size(min_size)`

- `min_size`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The minimum size of the next window.

note
Sets the minimum size of the next window, so the user cannot reduce its size to less than the specified value. This function should be called before the window:render function.

### Is Animation Finished 📃[​](https://docs.project-sylvanas.net/docs/<#is-animation-finished-> "Direct link to Is Animation Finished 📃")

`window:is_animation_finished(id)`

- `id`: Integer - The ID of the animation.
- Returns: Boolean

note
Returns true if the animation with the given ID has already finished.

### Set Window Cross Round 📃[​](https://docs.project-sylvanas.net/docs/<#set-window-cross-round-> "Direct link to Set Window Cross Round 📃")

`window:set_next_window_cross_round()`
note
Sets the next window cross to be a circumference, instead of a rectangle. This function should be called before the window:render function.

### Make Loading Circle Animation 📃[​](https://docs.project-sylvanas.net/docs/<#make-loading-circle-animation-> "Direct link to Make Loading Circle Animation 📃")

`window:make_loading_circle_animation(animation_id, origin, radius, color, thickness, animation_type)`

- `animation_id`: Integer - The ID of the animation.
- `origin`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The origin of the animation.
- `radius`: Number - The radius of the circle.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the circle.
- `thickness`: Number - The thickness of the circle.
- `animation_type`: Integer - The type of the animation.

note
Creates a loading circle animation with the specified properties. These are the animations used by the loader, for example.

### Get Window Type 📃[​](https://docs.project-sylvanas.net/docs/<#get-window-type-> "Direct link to Get Window Type 📃")

`window:get_type()`

- Returns: Integer - The type of the window.

[[custom-ui-guide]]

- [Overview](https://docs.project-sylvanas.net/docs/<#overview>)
  - [Create New Window 📃](https://docs.project-sylvanas.net/docs/<#create-new-window->)
  - [Set Initial Size 📃](https://docs.project-sylvanas.net/docs/<#set-initial-size->)
  - [Set Initial Position 📃](https://docs.project-sylvanas.net/docs/<#set-initial-position->)
  - [Set Next Close Cross Position Offset 📃](https://docs.project-sylvanas.net/docs/<#set-next-close-cross-position-offset->)
  - [Add Menu Element Position Offset 📃](https://docs.project-sylvanas.net/docs/<#add-menu-element-position-offset->)
  - [Get Window Size 📃](https://docs.project-sylvanas.net/docs/<#get-window-size->)
  - [Get Window Position 📃](https://docs.project-sylvanas.net/docs/<#get-window-position->)
  - [Get Mouse Position 📃](https://docs.project-sylvanas.net/docs/<#get-mouse-position->)
  - [Get Current Context Dynamic Drawing Offset 📃](https://docs.project-sylvanas.net/docs/<#get-current-context-dynamic-drawing-offset->)
  - [Get Text Size 📃](https://docs.project-sylvanas.net/docs/<#get-text-size->)
  - [Get Centered Text X Position 📃](https://docs.project-sylvanas.net/docs/<#get-centered-text-x-position->)
  - [Center Text 📃](https://docs.project-sylvanas.net/docs/<#center-text->)
  - [Render Text 🖌️](https://docs.project-sylvanas.net/docs/<#render-text-️>)
  - [Render Rectangle 🖌️](https://docs.project-sylvanas.net/docs/<#render-rectangle-️>)
  - [Render Filled Rectangle 🖌️](https://docs.project-sylvanas.net/docs/<#render-filled-rectangle-️>)
  - [Render Filled Rectangle with Multiple Colors 🖌️](https://docs.project-sylvanas.net/docs/<#render-filled-rectangle-with-multiple-colors-️>)
  - [Render Circle 🖌️](https://docs.project-sylvanas.net/docs/<#render-circle-️>)
  - [Render Filled Circle 🖌️](https://docs.project-sylvanas.net/docs/<#render-filled-circle-️>)
  - [Render Quadratic Bezier Curve 🖌️](https://docs.project-sylvanas.net/docs/<#render-quadratic-bezier-curve-️>)
  - [Render Cubic Bezier Curve 🖌️](https://docs.project-sylvanas.net/docs/<#render-cubic-bezier-curve-️>)
  - [Render Triangle 🖌️](https://docs.project-sylvanas.net/docs/<#render-triangle-️>)
  - [Render Filled Triangle 🖌️](https://docs.project-sylvanas.net/docs/<#render-filled-triangle-️>)
  - [Render Filled Triangle with Multiple Colors 🖌️](https://docs.project-sylvanas.net/docs/<#render-filled-triangle-with-multiple-colors-️>)
  - [Render Line 🖌️](https://docs.project-sylvanas.net/docs/<#render-line-️>)
  - [Add Separator 🖌️](https://docs.project-sylvanas.net/docs/<#add-separator-️>)
  - [Is Mouse Hovering Rect 📃](https://docs.project-sylvanas.net/docs/<#is-mouse-hovering-rect->)
  - [Is Rect Clicked 📃](https://docs.project-sylvanas.net/docs/<#is-rect-clicked->)
  - [Is Rect Double Clicked 📃](https://docs.project-sylvanas.net/docs/<#is-rect-double-clicked->)
  - [Set Visibility 📃](https://docs.project-sylvanas.net/docs/<#set-visibility->)
  - [Is Being Shown 📃](https://docs.project-sylvanas.net/docs/<#is-being-shown->)
  - [Render 📃](https://docs.project-sylvanas.net/docs/<#render->)
  - [Begin Group 📃](https://docs.project-sylvanas.net/docs/<#begin-group->)
  - [Begin Popup 📃](https://docs.project-sylvanas.net/docs/<#begin-popup->)
  - [Draw Next Dynamic Widget on Same Line 📃](https://docs.project-sylvanas.net/docs/<#draw-next-dynamic-widget-on-same-line->)
  - [Draw Next Dynamic Widget on New Line 📃](https://docs.project-sylvanas.net/docs/<#draw-next-dynamic-widget-on-new-line->)
  - [Add Text on Dynamic Position 📃](https://docs.project-sylvanas.net/docs/<#add-text-on-dynamic-position->)
  - [Push Font 📃](https://docs.project-sylvanas.net/docs/<#push-font->)
  - [Animate Widget 📃](https://docs.project-sylvanas.net/docs/<#animate-widget->)
  - [Set Next Window Items Spacing 📃](https://docs.project-sylvanas.net/docs/<#set-next-window-items-spacing->)
  - [Set Next Window Items Inner Spacing 📃](https://docs.project-sylvanas.net/docs/<#set-next-window-items-inner-spacing->)
  - [Set Next Window Padding 📃](https://docs.project-sylvanas.net/docs/<#set-next-window-padding->)
  - [Set Background Multicolored 📃](https://docs.project-sylvanas.net/docs/<#set-background-multicolored->)
  - [Manually Set End Called State 📃](https://docs.project-sylvanas.net/docs/<#manually-set-end-called-state->)
  - [Force Next Begin Window Position 📃](https://docs.project-sylvanas.net/docs/<#force-next-begin-window-position->)
  - [Stop Forcing Next Begin Window Position 📃](https://docs.project-sylvanas.net/docs/<#stop-forcing-next-begin-window-position->)
  - [Set Next Window Minimum Size 📃](https://docs.project-sylvanas.net/docs/<#set-next-window-minimum-size->)
  - [Is Animation Finished 📃](https://docs.project-sylvanas.net/docs/<#is-animation-finished->)
  - [Set Window Cross Round 📃](https://docs.project-sylvanas.net/docs/<#set-window-cross-round->)
  - [Make Loading Circle Animation 📃](https://docs.project-sylvanas.net/docs/<#make-loading-circle-animation->)
  - [Get Window Type 📃](https://docs.project-sylvanas.net/docs/<#get-window-type->)
