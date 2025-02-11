# Geometry

The `geometry` module provides a set of classes to create and interact with geometric shapes such as circles, rectangles, and cones. These classes offer various methods to manipulate the shapes, check points within them, retrieve units inside them, and visualize them by drawing.
tip
These classes are helpful for area-of-effect calculations, targeting systems, and visual debugging.
warning
This is a Lua library stored inside the "common" folder. To use it, you will need to include the library. Use the `require` function and store it in a local variable.
Here is an example of how to do it:

```
-- Recommended "circle" name for consistencylocal circle =require("common/geometry/circle")local cursor_position = core.get_cursor_position()local my_circle = circle:create(cursor_position,5.0)
```

## Classes[​](https://docs.project-sylvanas.net/docs/<#classes> "Direct link to Classes")

### Circle[​](https://docs.project-sylvanas.net/docs/<#circle> "Direct link to Circle")

The `circle` class represents a circle with a center point and a radius.

#### Properties[​](https://docs.project-sylvanas.net/docs/<#properties> "Direct link to Properties")

- `center`: _vec3_ — The center position of the circle.
- `radius`: _number_ — The radius of the circle.

#### Methods[​](https://docs.project-sylvanas.net/docs/<#methods> "Direct link to Methods")

### `create(center, radius)`[​](https://docs.project-sylvanas.net/docs/<#createcenter-radius> "Direct link to createcenter-radius")

Creates a circle given a center and radius.
Parameters:

- **`center`**(_vec3_) — The center position of the circle.
- **`radius`**(_number_) — The radius of the circle.

Returns: _circle_ — A new `circle` instance.

### `is_inside(point, hitbox)`[​](https://docs.project-sylvanas.net/docs/<#is_insidepoint-hitbox> "Direct link to is_insidepoint-hitbox")

Checks if a point is inside the circle.
Parameters:

- **`point`**(_vec3_) — The point to check.
- **`hitbox`**(_number_) — The hitbox radius to consider.

Returns: _boolean_ — `true` if the point is inside; otherwise, `false`.

### `get_units_inside(units_list)`[​](https://docs.project-sylvanas.net/docs/<#get_units_insideunits_list> "Direct link to get_units_insideunits_list")

Retrieves units within the circle.
Parameters:

- **`units_list`**(_table <game_object>_, optional) — List of units to check. If not provided, retrieves all units around the circle's center.

Returns: _table <game_object>_ — A table of units inside the circle.

### `get_allies_inside(units_list_override)`[​](https://docs.project-sylvanas.net/docs/<#get_allies_insideunits_list_override> "Direct link to get_allies_insideunits_list_override")

Retrieves allies within the circle.
Parameters:

- **`units_list_override`**(_table <game_object>_, optional) — List of units to check. If not provided, retrieves all units around the circle's center.

Returns: _table <game_object>_ — A table of allies inside the circle.

### `get_enemies_inside(units_list_override)`[​](https://docs.project-sylvanas.net/docs/<#get_enemies_insideunits_list_override> "Direct link to get_enemies_insideunits_list_override")

Retrieves enemies within the circle.
Parameters:

- **`units_list_override`**(_table <game_object>_, optional) — List of units to check. If not provided, retrieves all units around the circle's center.

Returns: _table <game_object>_ — A table of enemies inside the circle.

### `draw(custom_height)`[​](https://docs.project-sylvanas.net/docs/<#drawcustom_height> "Direct link to drawcustom_height")

Draws the circle.
Parameters:

- **`custom_height`**(_number_ , optional) — Custom height to draw the circle.

Returns: _nil_

### `draw_with_counter(count)`[​](https://docs.project-sylvanas.net/docs/<#draw_with_countercount> "Direct link to draw_with_countercount")

Draws the circle and the number of units hit.
Parameters:

- **`count`**(_number_ , optional) — Number of units hit. If not provided, calculates the number of units inside the circle.

Returns: _nil_

### Rectangle[​](https://docs.project-sylvanas.net/docs/<#rectangle> "Direct link to Rectangle")

The `rectangle` class represents a rectangle with four corners, a width, and a length.

#### Properties[​](https://docs.project-sylvanas.net/docs/<#properties-1> "Direct link to Properties")

- `corner1`: _vec3_ — The first corner of the rectangle.
- `corner2`: _vec3_ — The second corner of the rectangle.
- `corner3`: _vec3_ — The third corner of the rectangle.
- `corner4`: _vec3_ — The fourth corner of the rectangle.
- `width`: _number_ — The width of the rectangle.
- `length`: _number_ — The length of the rectangle.
- `origin`: _vec3_ — The origin position of the rectangle.

#### Methods[​](https://docs.project-sylvanas.net/docs/<#methods-1> "Direct link to Methods")

### `create(origin, destination, width, length)`[​](https://docs.project-sylvanas.net/docs/<#createorigin-destination-width-length> "Direct link to createorigin-destination-width-length")

Creates a rectangle given an origin, destination, width, and length.
Parameters:

- **`origin`**(_vec3_) — The origin position.
- **`destination`**(_vec3_) — The destination position.
- **`width`**(_number_) — The width of the rectangle.
- **`length`**(_number_ , optional) — The length of the rectangle. If not provided, it is calculated from the origin and destination.

Returns: _rectangle_ — A new `rectangle` instance.

### `create_direction(position, direction, width, length)`[​](https://docs.project-sylvanas.net/docs/<#create_directionposition-direction-width-length> "Direct link to create_directionposition-direction-width-length")

Creates a rectangle given a position, direction, width, and length.
Parameters:

- **`position`**(_vec3_) — The starting position.
- **`direction`**(_vec3_) — The direction vector.
- **`width`**(_number_) — The width of the rectangle.
- **`length`**(_number_) — The length of the rectangle.

Returns: _rectangle_ — A new `rectangle` instance.

### `is_inside(point, hitbox)`[​](https://docs.project-sylvanas.net/docs/<#is_insidepoint-hitbox-1> "Direct link to is_insidepoint-hitbox-1")

Checks if a point is inside the rectangle.
Parameters:

- **`point`**(_vec3_) — The point to check.
- **`hitbox`**(_number_) — The hitbox radius to consider.

Returns: _boolean_ — `true` if the point is inside; otherwise, `false`.

### `get_units_inside(units_list)`[​](https://docs.project-sylvanas.net/docs/<#get_units_insideunits_list-1> "Direct link to get_units_insideunits_list-1")

Retrieves units within the rectangle.
Parameters:

- **`units_list`**(_table <game_object>_, optional) — List of units to check. If not provided, retrieves all units around the rectangle's origin.

Returns: _table <game_object>_ — A table of units inside the rectangle.

### `get_allies_inside(units_list_override)`[​](https://docs.project-sylvanas.net/docs/<#get_allies_insideunits_list_override-1> "Direct link to get_allies_insideunits_list_override-1")

Retrieves allies within the rectangle.
Parameters:

- **`units_list_override`**(_table <game_object>_, optional) — List of units to check. If not provided, retrieves all units around the rectangle's origin.

Returns: _table <game_object>_ — A table of allies inside the rectangle.

### `get_enemies_inside(units_list_override)`[​](https://docs.project-sylvanas.net/docs/<#get_enemies_insideunits_list_override-1> "Direct link to get_enemies_insideunits_list_override-1")

Retrieves enemies within the rectangle.
Parameters:

- **`units_list_override`**(_table <game_object>_, optional) — List of units to check. If not provided, retrieves all units around the rectangle's origin.

Returns: _table <game_object>_ — A table of enemies inside the rectangle.

### `draw(custom_height)`[​](https://docs.project-sylvanas.net/docs/<#drawcustom_height-1> "Direct link to drawcustom_height-1")

Draws the rectangle.
Parameters:

- **`custom_height`**(_number_ , optional) — Custom height to draw the rectangle.

Returns: _nil_

### `draw_with_counter(count)`[​](https://docs.project-sylvanas.net/docs/<#draw_with_countercount-1> "Direct link to draw_with_countercount-1")

Draws the rectangle and the number of units hit.
Parameters:

- **`count`**(_number_ , optional) — Number of units hit. If not provided, calculates the number of units inside the rectangle.

Returns: _nil_

### Cone[​](https://docs.project-sylvanas.net/docs/<#cone> "Direct link to Cone")

The `cone` class represents a cone with a center point, radius, angle, and direction.

#### Properties[​](https://docs.project-sylvanas.net/docs/<#properties-2> "Direct link to Properties")

- `center`: _vec3_ — The center position of the cone.
- `radius`: _number_ — The radius of the cone.
- `angle`: _number_ — The angle of the cone in degrees.
- `direction`: _vec3_ — The direction vector of the cone.

#### Methods[​](https://docs.project-sylvanas.net/docs/<#methods-2> "Direct link to Methods")

### `create(center, radius, angle, direction)`[​](https://docs.project-sylvanas.net/docs/<#createcenter-radius-angle-direction> "Direct link to createcenter-radius-angle-direction")

Creates a cone given a center position, radius, angle, and direction.
Parameters:

- **`center`**(_vec3_) — The center position of the cone.
- **`radius`**(_number_) — The radius of the cone.
- **`angle`**(_number_) — The angle of the cone in degrees.
- **`direction`**(_vec3_) — The direction vector the cone is facing.

Returns: _cone_ — A new `cone` instance.

### `is_inside(point_position, hitbox)`[​](https://docs.project-sylvanas.net/docs/<#is_insidepoint_position-hitbox> "Direct link to is_insidepoint_position-hitbox")

Checks if a point is inside the cone.
Parameters:

- **`point_position`**(_vec3_) — The position of the point to check.
- **`hitbox`**(_number_) — The hitbox radius to consider.

Returns: _boolean_ — `true` if the point is inside; otherwise, `false`.

### `get_units_inside(units_list)`[​](https://docs.project-sylvanas.net/docs/<#get_units_insideunits_list-2> "Direct link to get_units_insideunits_list-2")

Retrieves units within the cone.
Parameters:

- **`units_list`**(_table <game_object>_, optional) — List of units to check. If not provided, retrieves all units around the cone's center.

Returns: _table <game_object>_ — A table of units inside the cone.

### `get_allies_inside(units_list_override)`[​](https://docs.project-sylvanas.net/docs/<#get_allies_insideunits_list_override-2> "Direct link to get_allies_insideunits_list_override-2")

Retrieves allies within the cone.
Parameters:

- **`units_list_override`**(_table <game_object>_, optional) — List of units to check. If not provided, retrieves all units around the cone's center.

Returns: _table <game_object>_ — A table of allies inside the cone.

### `get_enemies_inside(units_list_override)`[​](https://docs.project-sylvanas.net/docs/<#get_enemies_insideunits_list_override-2> "Direct link to get_enemies_insideunits_list_override-2")

Retrieves enemies within the cone.
Parameters:

- **`units_list_override`**(_table <game_object>_, optional) — List of units to check. If not provided, retrieves all units around the cone's center.

Returns: _table <game_object>_ — A table of enemies inside the cone.

### `draw(custom_height)`[​](https://docs.project-sylvanas.net/docs/<#drawcustom_height-2> "Direct link to drawcustom_height-2")

Draws the cone.
Parameters:

- **`custom_height`**(_number_ , optional) — Custom height to draw the cone.

Returns: _nil_

### `draw_with_counter(count)`[​](https://docs.project-sylvanas.net/docs/<#draw_with_countercount-2> "Direct link to draw_with_countercount-2")

Draws the cone and the number of units hit.
Parameters:

- **`count`**(_number_ , optional) — Number of units hit. If not provided, calculates the number of units inside the cone.

Returns: _nil_

## Examples[​](https://docs.project-sylvanas.net/docs/<#examples> "Direct link to Examples")

### Creating and Using a Circle[​](https://docs.project-sylvanas.net/docs/<#creating-and-using-a-circle> "Direct link to Creating and Using a Circle")

```
-- load the circle class---@type circlelocal circle =require("common/geometry/circle")localfunctiongenerate_and_draw_circle_with_hit_count()local local_player = core.object_manager.get_local_player()ifnot local_player thenreturnend-- get the player's positionlocal player_position = core.object_manager.get_local_player():get_position()-- create a circle with a radius of 10 units, for examplelocal my_circle = circle:create(player_position,10.0)-- get enemies inside the circlelocal enemies = my_circle:get_enemies_inside()-- draw the circle and the number of enemies inside  my_circle:draw_with_counter(#enemies)endcore.register_on_render_callback(function()generate_and_draw_circle_with_hit_count()end)
```

This is what you should be seeing after running that code:
![](https://downloads.project-sylvanas.net/1727625243154-circle_geometry.png)

### Creating and Using a Rectangle[​](https://docs.project-sylvanas.net/docs/<#creating-and-using-a-rectangle> "Direct link to Creating and Using a Rectangle")

```
-- load the rectangle class---@type rectanglelocal rectangle =require("common/geometry/rectangle")---@type vec3local vec3 =require("common/geometry/vector_3")localfunctiongenerate_and_draw_rect_with_ally_hit_count()local local_player = core.object_manager.get_local_player()ifnot local_player thenreturnend-- define origin and destination positionslocal origin = local_player:get_position()local destination = origin + vec3.new(20,0,0)-- create a rectangle of width 5 unitslocal my_rectangle = rectangle:create(origin, destination,5.0)-- get allies inside the rectanglelocal allies = my_rectangle:get_allies_inside()-- Draw the rectangle  my_rectangle:draw_with_counter(#allies)endcore.register_on_render_callback(function()generate_and_draw_rect_with_ally_hit_count()end)
```

This is what you should be seeing after running that code:
![](https://downloads.project-sylvanas.net/1727625678545-rect_hit.png)

### Creating and Using a Cone[​](https://docs.project-sylvanas.net/docs/<#creating-and-using-a-cone> "Direct link to Creating and Using a Cone")

```
-- load the cone class---@type conelocal cone =require("common/geometry/cone")-- load the vec3 class---@type vec3local vec3 =require("common/geometry/vector_3")localfunctiongenerate_and_draw_cone_with_unit_hit_count()local local_player = core.object_manager.get_local_player()ifnot local_player thenreturnend-- get the player's position and facing directionlocal position = local_player:get_position()local origin = local_player:get_position()local destination = origin + vec3.new(20,0,0)-- create a cone with a radius of 10 yds and an angle of 45 degreeslocal my_cone = cone:create(position, destination,10.0,45)-- draw the cone  my_cone:draw_with_counter()  my_cone:draw()endcore.register_on_render_callback(function()generate_and_draw_cone_with_unit_hit_count()end)
```

This is what you should be seeing after running that code:
![](https://downloads.project-sylvanas.net/1727626038090-cone_example.png)
note
The shaders for the cones are still under development. It will be added in the future, that's why they look worse than the other geometries. Stay tuned for the shaders update!

## Notes[​](https://docs.project-sylvanas.net/docs/<#notes> "Direct link to Notes")

- The **`vec3`**type represents a 3D vector with`x` , `y`, and `z` coordinates. See [Vectors (vec3)](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-3>) for more details.
- The **`game_object`**type refers to any entity within the game world, such as players, NPCs, or items. See[Game Object - Functions](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/game-object-functions>) for more details.

[[control-panel]]

- [Overview](https://docs.project-sylvanas.net/docs/<#overview>)
- [Classes](https://docs.project-sylvanas.net/docs/<#classes>)
  - [Circle](https://docs.project-sylvanas.net/docs/<#circle>)
  - `create(center, radius)`[](https://docs.project-sylvanas.net/docs/<#createcenter-radius>)
  - `is_inside(point, hitbox)`[](https://docs.project-sylvanas.net/docs/<#is_insidepoint-hitbox>)
  - `get_units_inside(units_list)`[](https://docs.project-sylvanas.net/docs/<#get_units_insideunits_list>)
  - `get_allies_inside(units_list_override)`[](https://docs.project-sylvanas.net/docs/<#get_allies_insideunits_list_override>)
  - `get_enemies_inside(units_list_override)`[](https://docs.project-sylvanas.net/docs/<#get_enemies_insideunits_list_override>)
  - `draw(custom_height)`[](https://docs.project-sylvanas.net/docs/<#drawcustom_height>)
  - `draw_with_counter(count)`[](https://docs.project-sylvanas.net/docs/<#draw_with_countercount>)
  - [Rectangle](https://docs.project-sylvanas.net/docs/<#rectangle>)
  - `create(origin, destination, width, length)`[](https://docs.project-sylvanas.net/docs/<#createorigin-destination-width-length>)
  - `create_direction(position, direction, width, length)`[](https://docs.project-sylvanas.net/docs/<#create_directionposition-direction-width-length>)
  - `is_inside(point, hitbox)`[](https://docs.project-sylvanas.net/docs/<#is_insidepoint-hitbox-1>)
  - `get_units_inside(units_list)`[](https://docs.project-sylvanas.net/docs/<#get_units_insideunits_list-1>)
  - `get_allies_inside(units_list_override)`[](https://docs.project-sylvanas.net/docs/<#get_allies_insideunits_list_override-1>)
  - `get_enemies_inside(units_list_override)`[](https://docs.project-sylvanas.net/docs/<#get_enemies_insideunits_list_override-1>)
  - `draw(custom_height)`[](https://docs.project-sylvanas.net/docs/<#drawcustom_height-1>)
  - `draw_with_counter(count)`[](https://docs.project-sylvanas.net/docs/<#draw_with_countercount-1>)
  - [Cone](https://docs.project-sylvanas.net/docs/<#cone>)
  - `create(center, radius, angle, direction)`[](https://docs.project-sylvanas.net/docs/<#createcenter-radius-angle-direction>)
  - `is_inside(point_position, hitbox)`[](https://docs.project-sylvanas.net/docs/<#is_insidepoint_position-hitbox>)
  - `get_units_inside(units_list)`[](https://docs.project-sylvanas.net/docs/<#get_units_insideunits_list-2>)
  - `get_allies_inside(units_list_override)`[](https://docs.project-sylvanas.net/docs/<#get_allies_insideunits_list_override-2>)
  - `get_enemies_inside(units_list_override)`[](https://docs.project-sylvanas.net/docs/<#get_enemies_insideunits_list_override-2>)
  - `draw(custom_height)`[](https://docs.project-sylvanas.net/docs/<#drawcustom_height-2>)
  - `draw_with_counter(count)`[](https://docs.project-sylvanas.net/docs/<#draw_with_countercount-2>)
- [Examples](https://docs.project-sylvanas.net/docs/<#examples>)
  - [Creating and Using a Circle](https://docs.project-sylvanas.net/docs/<#creating-and-using-a-circle>)
  - [Creating and Using a Rectangle](https://docs.project-sylvanas.net/docs/<#creating-and-using-a-rectangle>)
  - [Creating and Using a Cone](https://docs.project-sylvanas.net/docs/<#creating-and-using-a-cone>)
- [Notes](https://docs.project-sylvanas.net/docs/<#notes>)
