# Lua Graphics Module Documentation

The Lua Graphics Module provides a range of functions for rendering various graphical elements in Lua scripts. This module empowers developers to create visually engaging user interfaces and enhance in-game visuals.

### Register Graphics Callback[​](https://docs.project-sylvanas.net/docs/<#register-graphics-callback> "Direct link to Register Graphics Callback")

warning
This callback should only be used for graphics, as explained in [Core - Overview](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/core#overview>)
`core.menu.register_on_render_callback(callback: function)`

- This function registers the menu for interaction. Same like with other callbacks, you can also pass an anonymous function. This is how you would call the callback:

```
core.menu.register_on_render_callback(function()-- your rendering code hereend)
```

Or:

```
localfunctionmy_render_function()-- your rendering code hereendcore.menu.register_on_render_callback(my_render_function)
```

## Functions 🛠️[​](https://docs.project-sylvanas.net/docs/<#functions-️> "Direct link to Functions 🛠️")

### Line Of Sight 👁️[​](https://docs.project-sylvanas.net/docs/<#line-of-sight-️> "Direct link to Line Of Sight 👁️")

warning
In most cases, you should NOT use this function, since it's very expensive. Instead, you should instead use the spell_helper:is_spell_in_line_of_sight() function. See [Spell Helper - LOS](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/spell-helper-module#is_spell_in_line_of_sightspell_id-caster-target>)
Syntax

```
core.graphics.is_line_of_sight(caster, target)
```

Parameters

- `caster`: [game_object](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/game-object-functions>) - The caster object.
- `target`: [game_object](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/game-object-functions>) - The target object.

Returns

- `boolean`: `true` if the `target` is in line of sight from the `caster`, `false` otherwise.

Description
Determines if the `target` is within the line of sight of the `caster`.
💡
You can use this function to check visibility between two game objects.

### Cursor World Position 👁️[​](https://docs.project-sylvanas.net/docs/<#cursor-world-position-️> "Direct link to Cursor World Position 👁️")

Syntax

```
core.graphics.get_cursor_world_position()
```

Returns

- [vec3](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-3>) : The current cursor position's coordinates transformed to 3D dimensions.

Description
Retrieves the current cursor position screen coordinates (2D) and returns it after transforming them to 3D.

### Trace Line 🧭[​](https://docs.project-sylvanas.net/docs/<#trace-line-> "Direct link to Trace Line 🧭")

Syntax

```
core.graphics.trace_line(pos1, pos2, flags)
```

Parameters

- `pos1`: [vec3](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-3>) - Starting position.
- `pos2`: [vec3](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-3>) - Ending position.
- `flags`: Collision flags that determine which objects to consider during tracing.

Returns

- `boolean`: `true` if there is a valid trace line between `pos1` and `pos2`, `false` otherwise.

Description
Indicates if there is a valid trace line between `pos1` and `pos2` following the collision flags you provide.
**Collision Flags**

```
None,DoodadCollision   =0x00000001,DoodadRender    =0x00000002,WmoCollision    =0x00000010,WmoRender      =0x00000020,WmoNoCamCollision  =0x00000040,Terrain       =0x00000100,IgnoreWmoDoodad   =0x00002000,LiquidWaterWalkable =0x00010000,LiquidAll      =0x00020000,Cull        =0x00080000,EntityCollision   =0x00100000,EntityRender    =0x00200000,Collision      = DoodadCollision | WmoCollision | Terrain | EntityCollision,LineOfSight     = WmoCollision | EntityCollision
```

warning
The collision flags are located in `enums.collision_flags`. You should import the enums module:

```
---@type enumslocal enums =require("common/enums")
```

Avoid using their values directly, as this is **not recommended** since these values might change in the future. By importing the enums module, any updates will automatically be reflected in your code.
You can use this function to see which enemies are not in line of sight. You can adjust the flags according to your requirements.

## Example:

Here's an example function to gather all units that are not in line of sight within a search distance:

```
---@type unit_helperlocal unit_helper =require("common/utility/unit_helper")---@type enumslocal enums =require("common/enums")---@param search_distance number---@return table<game_object> | nillocalfunctionget_enemies_that_are_not_in_los(search_distance)local local_player = core.object_manager.get_local_player()ifnot local_player thenreturnnilendlocal local_player_position = local_player:get_position()local enemies = unit_helper:get_enemy_list_around(local_player_position, search_distance,true)local not_in_los_enemies ={}for _, enemy inipairs(enemies)dolocal enemy_pos = enemy:get_position()-- trace_line will return true if the enemy is in line of sight, as long as we pass the enums.collision_flags.LineOfSight flaglocal is_in_los = core.graphics.trace_line(local_player_position, enemy_pos, enums.collision_flags.LineOfSight)ifnot is_in_los then      table.insert(not_in_los_enemies, enemy)endendreturn not_in_los_enemiesend
```

note
For this example, to check if something is in **LOS** (line of sight), you could also use the `core.graphics.is_line_of_sight` function, defined earlier.

### World to Screen 🌐➡️🖥️[​](https://docs.project-sylvanas.net/docs/<#world-to-screen-️️> "Direct link to World to Screen 🌐➡️🖥️")

Syntax

```
core.graphics.w2s(position)
```

Parameters

- `position`: [vec3](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-3>) - The 3D world position to convert.

Returns

- [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>): The 2D screen position corresponding to the 3D world position.

Description
Converts a 3D world position to a 2D screen position, facilitating the rendering of objects in screen space.
warning
Before using the return value, you should make sure it's not `nil`, since a `vec3` out of the screen won't be converted and will return `nil`.

## Example:

Drawing text at the 2D position of a given unit

```
---@type colorlocal color =require("common/color")---@param unit game_object---@param text stringlocalfunctiondraw_text_at_unit_screen_position(unit, text)ifnot unit thenreturnendlocal unit_position = unit:get_position()local unit_screen_position = core.graphics.w2s(unit_position)ifnot unit_screen_position thenreturnend  core.graphics.text_2d(text, unit_screen_position,16, color.cyan(230))end
```

### Is Menu Open 📋🔍[​](https://docs.project-sylvanas.net/docs/<#is-menu-open-> "Direct link to Is Menu Open 📋🔍")

Syntax

```
core.graphics.is_menu_open()
```

Returns

- `boolean`: `true` if the main menu is visible, `false` otherwise.

Description
Checks if the main menu is currently open.

### Get Screen Size 🖥️📏[​](https://docs.project-sylvanas.net/docs/<#get-screen-size-️> "Direct link to Get Screen Size 🖥️📏")

Syntax

```
core.graphics.get_screen_size()
```

Returns

- [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>): The width and height of the screen.

Description
Retrieves the current screen size in pixels.

### Render 2D Text 📝[​](https://docs.project-sylvanas.net/docs/<#render-2d-text-> "Direct link to Render 2D Text 📝")

Syntax

```
core.graphics.text_2d(text, position, font_size, color, centered, font_id)
```

Parameters

- `text`: `string` - The text to render.
- `position`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The position where the text will be rendered.
- `font_size`: `number` - The font size of the text.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the text.
- `centered` (Optional): `boolean` - Indicates whether the text should be centered at the specified position. Default is `false`.
- `font_id` (Optional): `integer` - The font ID. Default is `0`.

Description
Renders 2D text on the screen at the specified position with the given font size and color.

### Render 3D Text 📝🌐[​](https://docs.project-sylvanas.net/docs/<#render-3d-text-> "Direct link to Render 3D Text 📝🌐")

Syntax

```
core.graphics.text_3d(text, position, font_size, color, centered, font_id)
```

Parameters

- `text`: `string` - The text to render.
- `position`: [vec3](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-3>) - The position in 3D space where the text will be rendered.
- `font_size`: `number` - The font size of the text.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the text.
- `centered` (Optional): `boolean` - Indicates whether the text should be centered at the specified position. Default is `false`.
- `font_id` (Optional): `integer` - The font ID. Default is `0`.

Description
Renders 3D text in the world at the specified position with the given font size and color.

### Get Text Width 📐[​](https://docs.project-sylvanas.net/docs/<#get-text-width-> "Direct link to Get Text Width 📐")

Syntax

```
core.graphics.get_text_width(text, font_size, font_id)
```

Parameters

- `text`: `string` - The text to measure.
- `font_size`: `number` - The font size of the text.
- `font_id` (Optional): `integer` - The font ID. Default is `0`.

Returns

- `number`: The width of the text.

Description
Calculates and returns the width of the specified text, useful for aligning text elements.

### Draw 2D Line ✏️[​](https://docs.project-sylvanas.net/docs/<#draw-2d-line-️> "Direct link to Draw 2D Line ✏️")

Syntax

```
core.graphics.line_2d(start_point, end_point, color, thickness)
```

Parameters

- `start_point`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The start point of the line.
- `end_point`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The end point of the line.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the line.
- `thickness` (Optional): `number` - The thickness of the line. Default is `1`.

Description
Draws a 2D line between two points with the specified color and optional thickness.

### Draw 3D Line ✏️🌐[​](https://docs.project-sylvanas.net/docs/<#draw-3d-line-️> "Direct link to Draw 3D Line ✏️🌐")

Syntax

```
core.graphics.line_3d(start_point, end_point, color, thickness)
```

Parameters

- `start_point`: [vec3](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-3>) - The start point of the line in 3D space.
- `end_point`: [vec3](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-3>) - The end point of the line in 3D space.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the line.
- `thickness` (Optional): `number` - The thickness of the line. Default is `1`.

Description
Draws a 3D line between two points with the specified color and optional thickness.

## Example:

Drawing A Line From Local Player To a Unit

```
---@type colorlocal color =require("common/color")---@param unit game_objectlocalfunctiondraw_line_to_unit(unit)ifnot unit thenreturnendlocal local_player = core.object_manager.get_local_player()ifnot local_player thenreturnnilendlocal local_player_position = local_player:get_position()local unit_position = unit:get_position()  core.graphics.line_3d(local_player_position, unit_position, color.cyan(220),5.0)end
```

### Draw 2D Rectangle Outline 🖼️[​](https://docs.project-sylvanas.net/docs/<#draw-2d-rectangle-outline-️> "Direct link to Draw 2D Rectangle Outline 🖼️")

Syntax

```
core.graphics.rect_2d(top_left_point, width, height, color, thickness, rounding)
```

Parameters

- `top_left_point`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The top-left corner point of the rectangle.
- `width`: `number` - The width of the rectangle.
- `height`: `number` - The height of the rectangle.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the rectangle outline.
- `thickness` (Optional): `number` - The thickness of the outline. Default is `1`.
- `rounding` (Optional): `number` - The rounding of corners. Default is `0`.

Description
Draws an outlined 2D rectangle with the specified dimensions, color, and optional thickness and rounding.

### Draw 2D Filled Rectangle 🖼️🖌️[​](https://docs.project-sylvanas.net/docs/<#draw-2d-filled-rectangle-️️> "Direct link to Draw 2D Filled Rectangle 🖼️🖌️")

Syntax

```
core.graphics.rect_2d_filled(top_left_point, width, height, color, rounding)
```

Parameters

- `top_left_point`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The top-left corner point of the rectangle.
- `width`: `number` - The width of the rectangle.
- `height`: `number` - The height of the rectangle.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The fill color of the rectangle.
- `rounding` (Optional): `number` - The rounding of corners. Default is `0`.

Description
Draws a filled 2D rectangle with the specified dimensions, color, and optional rounding.

## Example:

Drawing a 2d filled rect at cursor screen position

```
---@type colorlocal color =require("common/color")localfunctionrender_rect_2d_at_cursor_screen_pos()local local_player = core.object_manager.get_local_player()ifnot local_player thenreturnnilendlocal cursor_pos_2d = core.get_cursor_position()  core.graphics.rect_2d_filled(cursor_pos_2d,200,50, color.cyan_pale(200))end
```

![](https://downloads.project-sylvanas.net/1727348652550-rect_2d_filled_mousepos.png)

### Draw 3D Rectangle Outline 🖼️🌐[​](https://docs.project-sylvanas.net/docs/<#draw-3d-rectangle-outline-️> "Direct link to Draw 3D Rectangle Outline 🖼️🌐")

Syntax

```
core.graphics.rect_3d(p1, p2, p3, p4, color, thickness)
```

Parameters

- `p1`, `p2`, `p3`, `p4`: [vec3](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-3>) - Four points defining the corners of the rectangle in 3D space.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the rectangle outline.
- `thickness` (Optional): `number` - The thickness of the outline. Default is `1`.

Description
Draws an outlined 3D rectangle with the specified corner points, color, and optional thickness.

## Example:

How to Render a 3D Rectangle From Local Player to Mouse Position

```
---@type colorlocal color =require("common/color")localfunctionrender_rect_3d_to_mouse()local local_player = core.object_manager.get_local_player()ifnot local_player thenreturnnilendlocal local_player_position = local_player:get_position()local cursor_position_3d = core.graphics.get_cursor_world_position()  core.graphics.rect_3d(local_player_position, cursor_position_3d,5.0, color.cyan_pale(200),30.0,1.5)end
```

![](https://downloads.project-sylvanas.net/1727347302615-rect_showcase.png)

### Draw 3D Filled Rectangle 🖼️🖌️🌐[​](https://docs.project-sylvanas.net/docs/<#draw-3d-filled-rectangle-️️> "Direct link to Draw 3D Filled Rectangle 🖼️🖌️🌐")

Syntax

```
core.graphics.rect_3d_filled(p1, p2, p3, p4, color)
```

Parameters

- `p1`, `p2`, `p3`, `p4`: [vec3](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-3>) - Four points defining the corners of the rectangle in 3D space.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The fill color of the rectangle.

Description
Draws a filled 3D rectangle with the specified corner points and color.

### Draw 2D Circle Outline 🎯[​](https://docs.project-sylvanas.net/docs/<#draw-2d-circle-outline-> "Direct link to Draw 2D Circle Outline 🎯")

Syntax

```
core.graphics.circle_2d(center, radius, color, thickness)
```

Parameters

- `center`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The center point of the circle.
- `radius`: `number` - The radius of the circle.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the circle outline.
- `thickness` (Optional): `number` - The thickness of the outline. Default is `1`.

Description
Draws an outlined 2D circle with the specified center, radius, color, and optional thickness.

### Draw 2D Filled Circle 🎯🖌️[​](https://docs.project-sylvanas.net/docs/<#draw-2d-filled-circle-️> "Direct link to Draw 2D Filled Circle 🎯🖌️")

Syntax

```
core.graphics.circle_2d_filled(center, radius, color)
```

Parameters

- `center`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - The center point of the circle.
- `radius`: `number` - The radius of the circle.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The fill color of the circle.

Description
Draws a filled 2D circle with the specified center, radius, and color.

### Draw 3D Circle Outline 🎯🌐[​](https://docs.project-sylvanas.net/docs/<#draw-3d-circle-outline-> "Direct link to Draw 3D Circle Outline 🎯🌐")

Syntax

```
core.graphics.circle_3d(center, radius, color, thickness)
```

Parameters

- `center`: [vec3](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-3>) - The center point of the circle in 3D space.
- `radius`: `number` - The radius of the circle.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the circle.
- `thickness` (Optional): `number` - The thickness of the lines forming the circle.

Description
Draws an outlined 3D circle with the specified center, radius, color, and optional thickness.

## Example:

How to Render a 3D Circle at Unit's Position

```
---@type colorlocal color =require("common/color")localfunctionrender_rect_3d_at_unit_position(unit)ifnot unit thenreturnend-- you can avoid this check if you checked it earlier in your code. -- It's just to make sure nothing is rendered while on loading screen.local local_player = core.object_manager.get_local_player()ifnot local_player thenreturnnilendlocal unit_position = unit:get_position()  core.graphics.circle_3d(unit_position,5.0, color.cyan(230),40,1.5)end
```

![](https://downloads.project-sylvanas.net/1727349247525-circle_3d_showcase.png)

### Draw 3D Circle Outline Percentage 🎯🌐📊[​](https://docs.project-sylvanas.net/docs/<#draw-3d-circle-outline-percentage-> "Direct link to Draw 3D Circle Outline Percentage 🎯🌐📊")

Syntax

```
core.graphics.circle_3d_percentage(center, radius, color, percentage, thickness)
```

Parameters

- `center`: [vec3](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-3>) - The center point of the circle in 3D space.
- `radius`: `number` - The radius of the circle.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The color of the circle outline.
- `percentage`: `number` - The percentage of the circle to render.
- `thickness` (Optional): `number` - The thickness of the outline. Default is `1`.

Description
Draws an outlined 3D circle with the specified center, radius, color, and percentage of the circle to render. Optionally, the thickness can be specified.
tip
This function might be useful to track casts, since you can render the circle up to a unit's current cast completion percentage, for example.

### Draw 3D Filled Circle 🎯🖌️🌐[​](https://docs.project-sylvanas.net/docs/<#draw-3d-filled-circle-️> "Direct link to Draw 3D Filled Circle 🎯🖌️🌐")

Syntax

```
core.graphics.circle_3d_filled(center, radius, color)
```

Parameters

- `center`: [vec3](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-3>) - The center point of the circle in 3D space.
- `radius`: `number` - The radius of the circle.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The fill color of the circle.

Description
Draws a filled 3D circle with the specified center, radius, and color.

### Draw 2D Filled Triangle 🔺🖌️[​](https://docs.project-sylvanas.net/docs/<#draw-2d-filled-triangle-️> "Direct link to Draw 2D Filled Triangle 🔺🖌️")

Syntax

```
core.graphics.triangle_2d_filled(p1, p2, p3, color)
```

Parameters

- `p1`, `p2`, `p3`: [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) - Three points defining the corners of the triangle in 2D space.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The fill color of the triangle.

Description
Draws a filled 2D triangle with the specified corner points and color.

### Draw 3D Filled Triangle 🔺🖌️🌐[​](https://docs.project-sylvanas.net/docs/<#draw-3d-filled-triangle-️> "Direct link to Draw 3D Filled Triangle 🔺🖌️🌐")

Syntax

```
core.graphics.triangle_3d_filled(p1, p2, p3, color)
```

Parameters

- `p1`, `p2`, `p3`: [vec3](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-3>) - Three points defining the corners of the triangle in 3D space.
- `color`: [color](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/color>) - The fill color of the triangle.

Description
Draws a filled 3D triangle with the specified corner points and color.
[[graphics-notifications]]

- [Overview](https://docs.project-sylvanas.net/docs/<#overview>)
  - [Register Graphics Callback](https://docs.project-sylvanas.net/docs/<#register-graphics-callback>)
- [Functions 🛠️](https://docs.project-sylvanas.net/docs/<#functions-️>)
  - [Line Of Sight 👁️](https://docs.project-sylvanas.net/docs/<#line-of-sight-️>)
  - [Cursor World Position 👁️](https://docs.project-sylvanas.net/docs/<#cursor-world-position-️>)
  - [Trace Line 🧭](https://docs.project-sylvanas.net/docs/<#trace-line->)
  - [World to Screen 🌐➡️🖥️](https://docs.project-sylvanas.net/docs/<#world-to-screen-️️>)
  - [Is Menu Open 📋🔍](https://docs.project-sylvanas.net/docs/<#is-menu-open->)
  - [Get Screen Size 🖥️📏](https://docs.project-sylvanas.net/docs/<#get-screen-size-️>)
  - [Render 2D Text 📝](https://docs.project-sylvanas.net/docs/<#render-2d-text->)
  - [Render 3D Text 📝🌐](https://docs.project-sylvanas.net/docs/<#render-3d-text->)
  - [Get Text Width 📐](https://docs.project-sylvanas.net/docs/<#get-text-width->)
  - [Draw 2D Line ✏️](https://docs.project-sylvanas.net/docs/<#draw-2d-line-️>)
  - [Draw 3D Line ✏️🌐](https://docs.project-sylvanas.net/docs/<#draw-3d-line-️>)
  - [Draw 2D Rectangle Outline 🖼️](https://docs.project-sylvanas.net/docs/<#draw-2d-rectangle-outline-️>)
  - [Draw 2D Filled Rectangle 🖼️🖌️](https://docs.project-sylvanas.net/docs/<#draw-2d-filled-rectangle-️️>)
  - [Draw 3D Rectangle Outline 🖼️🌐](https://docs.project-sylvanas.net/docs/<#draw-3d-rectangle-outline-️>)
  - [Draw 3D Filled Rectangle 🖼️🖌️🌐](https://docs.project-sylvanas.net/docs/<#draw-3d-filled-rectangle-️️>)
  - [Draw 2D Circle Outline 🎯](https://docs.project-sylvanas.net/docs/<#draw-2d-circle-outline->)
  - [Draw 2D Filled Circle 🎯🖌️](https://docs.project-sylvanas.net/docs/<#draw-2d-filled-circle-️>)
  - [Draw 3D Circle Outline 🎯🌐](https://docs.project-sylvanas.net/docs/<#draw-3d-circle-outline->)
  - [Draw 3D Circle Outline Percentage 🎯🌐📊](https://docs.project-sylvanas.net/docs/<#draw-3d-circle-outline-percentage->)
  - [Draw 3D Filled Circle 🎯🖌️🌐](https://docs.project-sylvanas.net/docs/<#draw-3d-filled-circle-️>)
  - [Draw 2D Filled Triangle 🔺🖌️](https://docs.project-sylvanas.net/docs/<#draw-2d-filled-triangle-️>)
  - [Draw 3D Filled Triangle 🔺🖌️🌐](https://docs.project-sylvanas.net/docs/<#draw-3d-filled-triangle-️>)
