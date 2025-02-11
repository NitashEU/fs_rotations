# Vector 2

The `vec2` module provides functions for working with 2D vectors in Lua scripts. These functions include vector creation, arithmetic operations, normalization, length calculation, dot product calculation, interpolation, randomization, rotation, and more.
tip
If you are new and don't know what a vec2 is and want a deep understanding of this class, and specially, the [vec3](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-3>) data structure, you might want to study some . This information is basic and it will be usefull for any game-related project that you might work on in the future.

## Importing the Module[​](https://docs.project-sylvanas.net/docs/<#importing-the-module> "Direct link to Importing the Module")

warning
This is a Lua library stored inside the "common" folder. To use it, you will need to include the library. Use the `require` function and store it in a local variable.
Here is an example of how to do it:

```
---@type vec2local vec2 =require("common/geometry/vector_2")
```

## Functions[​](https://docs.project-sylvanas.net/docs/<#functions> "Direct link to Functions")

### Vector Creation and Cloning ✨[​](https://docs.project-sylvanas.net/docs/<#vector-creation-and-cloning-> "Direct link to Vector Creation and Cloning ✨")

### `new(x, y)`[​](https://docs.project-sylvanas.net/docs/<#newx-y> "Direct link to newx-y")

Creates a new 2D vector with the specified x and y components.
Parameters:

- **`x`**(_number_) — The x component of the vector.
- **`y`**(_number_) — The y component of the vector.

Returns: _vec2_ — A new vector instance.

### `clone()`[​](https://docs.project-sylvanas.net/docs/<#clone> "Direct link to clone")

Clones the current vector.
Returns: _vec2_ — A new vector instance that is a copy of the original.

### Arithmetic Operations ➕[​](https://docs.project-sylvanas.net/docs/<#arithmetic-operations-> "Direct link to Arithmetic Operations ➕")

### `__add(other)`[​](https://docs.project-sylvanas.net/docs/<#__addother> "Direct link to __addother")

Overloads the addition operator (`+`) for vector addition.
Parameters:

- **`other`**(_vec2_) — The vector to add.

Returns: _vec2_ — The result of the addition.
warning
Do not use this function directly. Instead, just use the operator `+`. For example:

```
---@type vec2local vec2 =require("common/geometry/vector_2")local v1 = vec2.new(1,1)local v2 = vec2.new(2,2)--- Bad code:-- local v3 = v1:__add(v2)--- Correct code:local v3 = v1 + v2
```

### `__sub(other)`[​](https://docs.project-sylvanas.net/docs/<#__subother> "Direct link to __subother")

Overloads the subtraction operator (`-`) for vector subtraction.
Parameters:

- **`other`**(_vec2_) — The vector to subtract.

Returns: _vec2_ — The result of the subtraction.
warning
Do not use this function directly. Instead, just use the operator `-`. For example:

```
---@type vec2local vec2 =require("common/geometry/vector_2")local v1 = vec2.new(1,1)local v2 = vec2.new(2,2)--- Bad code:-- local v3 = v1:__sub(v2)--- Correct code:local v3 = v1 - v2
```

### `__mul(value)`[​](https://docs.project-sylvanas.net/docs/<#__mulvalue> "Direct link to __mulvalue")

Overloads the multiplication operator (`*`) for scalar multiplication or element-wise multiplication.
Parameters:

- **`value`**(_number_ or _vec2_) — The scalar or vector to multiply with.

Returns: _vec2_ — The result of the multiplication.
warning
Do not use this function directly. Instead, just use the operator `*`. For example:

```
---@type vec2local vec2 =require("common/geometry/vector_2")local v1 = vec2.new(1,1)local v2 = vec2.new(2,2)--- Bad code:-- local v3 = v1:__mul(v2)--- Correct code:local v3 = v1 * v2
```

### `__div(value)`[​](https://docs.project-sylvanas.net/docs/<#__divvalue> "Direct link to __divvalue")

Overloads the division operator (`/`) for scalar division or element-wise division.
Parameters:

- **`value`**(_number_ or _vec2_) — The scalar or vector to divide by.

Returns: _vec2_ — The result of the division.
warning
Do not use this function directly. Instead, just use the operator `/`. For example:

```
---@type vec2local vec2 =require("common/geometry/vector_2")local v1 = vec2.new(1,1)local v2 = vec2.new(2,2)--- Bad code:-- local v3 = v1:__div(v2)--- Correct code:local v3 = v1 / v2
```

### Vector Properties and Methods 🧮[​](https://docs.project-sylvanas.net/docs/<#vector-properties-and-methods-> "Direct link to Vector Properties and Methods 🧮")

### `normalize()`[​](https://docs.project-sylvanas.net/docs/<#normalize> "Direct link to normalize")

Returns the normalized vector (unit vector) of the current vector.
Returns: _vec2_ — The normalized vector.

### `length()`[​](https://docs.project-sylvanas.net/docs/<#length> "Direct link to length")

Returns the length (magnitude) of the vector.
Returns: _number_ — The length of the vector.

### `dot(other)`[​](https://docs.project-sylvanas.net/docs/<#dotother> "Direct link to dotother")

Calculates the dot product of two vectors.
Parameters:

- **`other`**(_vec2_) — The other vector.

Returns: _number_ — The dot product.

### `lerp(target, t)`[​](https://docs.project-sylvanas.net/docs/<#lerptarget-t> "Direct link to lerptarget-t")

Performs linear interpolation between two vectors.
Parameters:

- **`target`**(_vec2_) — The target vector.
- **`t`**(_number_) — The interpolation factor (between 0.0 and 1.0).

Returns: _vec2_ — The interpolated vector.

### Advanced Operations ⚙️[​](https://docs.project-sylvanas.net/docs/<#advanced-operations-️> "Direct link to Advanced Operations ⚙️")

### `randomize_xy(margin)`[​](https://docs.project-sylvanas.net/docs/<#randomize_xymargin> "Direct link to randomize_xymargin")

Randomizes the x and y components of the vector within a specified margin.
Parameters:

- **`margin`**(_number_) — The maximum value to add or subtract from each component.

Returns: _vec2_ — The randomized vector.

### `rotate_around(origin, angle_degrees)`[​](https://docs.project-sylvanas.net/docs/<#rotate_aroundorigin-angle_degrees> "Direct link to rotate_aroundorigin-angle_degrees")

Rotates the vector around a specified origin point by a given angle in degrees.
Parameters:

- **`origin`**(_vec2_) — The origin point to rotate around.
- **`angle_degrees`**(_number_) — The angle in degrees.

Returns: _vec2_ — The rotated vector.

### `dist_to(other)`[​](https://docs.project-sylvanas.net/docs/<#dist_toother> "Direct link to dist_toother")

Calculates the distance to another vector.
Parameters:

- **`other`**(_vec2_) — The other vector.

Returns: _number_ — The distance between the vectors.

### `get_angle(origin)`[​](https://docs.project-sylvanas.net/docs/<#get_angleorigin> "Direct link to get_angleorigin")

Calculates the angle between the vector and the x-axis, relative to a specified origin point.
Parameters:

- **`origin`**(_vec2_) — The origin point.

Returns: _number_ — The angle in degrees.

### `intersects(p1, p2)`[​](https://docs.project-sylvanas.net/docs/<#intersectsp1-p2> "Direct link to intersectsp1-p2")

Checks if the vector (as a point) intersects with a line segment defined by two vectors.
Parameters:

- **`p1`**(_vec2_) — The first point of the line segment.
- **`p2`**(_vec2_) — The second point of the line segment.

Returns: _boolean_ — `true` if the point intersects the line segment; otherwise, `false`.

### `get_perp_left(origin)`[​](https://docs.project-sylvanas.net/docs/<#get_perp_leftorigin> "Direct link to get_perp_leftorigin")

Returns the left perpendicular vector of the current vector relative to a specified origin point.
Parameters:

- **`origin`**(_vec2_) — The origin point.

Returns: _vec2_ — The left perpendicular vector.

### `get_perp_left_factor(origin, factor)`[​](https://docs.project-sylvanas.net/docs/<#get_perp_left_factororigin-factor> "Direct link to get_perp_left_factororigin-factor")

Returns the left perpendicular vector of the vec2 instance with a factor applied.
Parameters:

- **`origin`**(_vec2_) — The origin point.
- **`factor`**(_number_) — The factor to apply.

Returns: _vec2_ — The left perpendicular vector.

### `get_perp_right(origin)`[​](https://docs.project-sylvanas.net/docs/<#get_perp_rightorigin> "Direct link to get_perp_rightorigin")

Returns the right perpendicular vector of the current vector relative to a specified origin point.
Parameters:

- **`origin`**(_vec2_) — The origin point.

Returns: _vec2_ — The right perpendicular vector.

### `get_perp_right_factor(origin, factor)`[​](https://docs.project-sylvanas.net/docs/<#get_perp_right_factororigin-factor> "Direct link to get_perp_right_factororigin-factor")

Returns the right perpendicular vector of the vec2 instance with a factor applied.
Parameters:

- **`origin`**(_vec2_) — The origin point.
- **`factor`**(_number_) — The factor to apply.

Returns: _vec2_ — The right perpendicular vector.

### Additional Functions 🛠️[​](https://docs.project-sylvanas.net/docs/<#additional-functions-️> "Direct link to Additional Functions 🛠�️")

### `dot_product(other)`[​](https://docs.project-sylvanas.net/docs/<#dot_productother> "Direct link to dot_productother")

An alternative method to calculate the dot product of two vectors.
Parameters:

- **`other`**(_vec2_) — The other vector.

Returns: _number_ — The dot product.

### `is_nan()`[​](https://docs.project-sylvanas.net/docs/<#is_nan> "Direct link to is_nan")

Checks if the vector is not a number.
Returns: _boolean_ — True if the vector_2 is not a number, false otherwise.

### `is_zero()`[​](https://docs.project-sylvanas.net/docs/<#is_zero> "Direct link to is_zero")

Checks if the vector is zero.
Returns: _boolean_ — True if the vector_2 is the vector(0,0), false otherwise.
tip
Saying that a vector is_zero is the same as saying that the said vector equals the vec2.new(0,0)

## Code Examples[​](https://docs.project-sylvanas.net/docs/<#code-examples> "Direct link to Code Examples")

### Example 1: Vector Addition[​](https://docs.project-sylvanas.net/docs/<#example-1-vector-addition> "Direct link to Example 1: Vector Addition")

```
---@type vec2local vec2 =require("common/geometry/vector_2")core.register_on_render_callback(function()local local_player = core.object_manager.get_local_player()ifnot local_player thenreturnend-- example vectorslocal v1 = vec2.new(500.0,350.0)local v2 = vec2.new(100.0,100.0)local v3 = v1 + v2 -- (this is the result of adding v2 to v1)-- this is the blue line in the picture (a line from v1 to v3)  core.graphics.line_2d(v1, v3, color.cyan(255))-- red circle at v1 position  core.graphics.circle_2d(v1,20.0, color.red(255))-- we adjust the text position by substracting a new vectorlocal v1_text_position = v1 - vec2.new(10.0,15.0)-- and finally draw the "v1" text at the position that we just calculated  core.graphics.text_2d("v1", v1_text_position,20, color.red(255))-- green circle at v3 position  core.graphics.circle_2d(v3,20.0, color.green_pale(255))-- we adjust the text position by substracting a new vectorlocal v3_text_position = v3 - vec2.new(10.0,10.0)-- and finally draw the "v3" text at the position that we just calculated  core.graphics.text_2d("v3", v3_text_position,20, color.green(255))end)
```

This should be the result after running that piece of code:
![](https://downloads.project-sylvanas.net/1727780263019-vector_add.png)

### Example 2: Vector Dot Product[​](https://docs.project-sylvanas.net/docs/<#example-2-vector-dot-product> "Direct link to Example 2: Vector Dot Product")

```
---@type vec2local vec2 =require("common/geometry/vector_2")-- Create two vectorslocal v1 = vec2.new(3,5)local v2 = vec2.new(2,8)-- Calculate the dot productlocal dot_product = v1:dot(v2)-- Print the dot productcore.log("Dot product of the vectors: ".. dot_product)
```

### Example 3: Vector Normalization[​](https://docs.project-sylvanas.net/docs/<#example-3-vector-normalization> "Direct link to Example 3: Vector Normalization")

```
---@type vec2local vec2 =require("common/geometry/vector_2")-- Create a vectorlocal v = vec2.new(3,4)-- Normalize the vectorlocal normalized = v:normalize()-- Print the normalized vectorcore.log("Normalized vector: (".. normalized.x ..", ".. normalized.y ..")")
```

### Example 4: Vector Rotation[​](https://docs.project-sylvanas.net/docs/<#example-4-vector-rotation> "Direct link to Example 4: Vector Rotation")

```
---@type vec2local vec2 =require("common/geometry/vector_2")core.register_on_render_callback(function()local local_player = core.object_manager.get_local_player()ifnot local_player thenreturnend-- example vectorslocal v1 = vec2.new(500.0,350.0)-- local v2 = vec2.new(100.0, 100.0)-- rotate the vector 90 degrees around the originlocal v2 = v1:rotate_around(vec2.new(0,0),90)-- extend the starting position to the rotated position by 100local v3 = v1:get_extended(v2,100.0)-- this is the blue line in the picture (a line from v1 to v3)  core.graphics.line_2d(v1, v3, color.cyan(255))-- red circle at v1 position  core.graphics.circle_2d(v1,20.0, color.red(255))-- we adjust the text position by substracting a new vectorlocal v1_text_position = v1 - vec2.new(10.0,15.0)-- and finally draw the "v1" text at the position that we just calculated  core.graphics.text_2d("v1", v1_text_position,20, color.red(255))-- green circle at v3 position  core.graphics.circle_2d(v3,20.0, color.green_pale(255))-- we adjust the text position by substracting a new vectorlocal v3_text_position = v3 - vec2.new(10.0,10.0)-- and finally draw the "v3" text at the position that we just calculated  core.graphics.text_2d("v3", v3_text_position,20, color.green(255))end)
```

This is the expected result after running that code:
![](https://downloads.project-sylvanas.net/1727781068572-v2_rotation_1.png)
If we rotate it by -90 degrees instead of 90, this is what we should be seeing now:
![](https://downloads.project-sylvanas.net/1727781072508-v2_rotation_2.png)
[[vector-3]]

- [Overview](https://docs.project-sylvanas.net/docs/<#overview>)
- [Importing the Module](https://docs.project-sylvanas.net/docs/<#importing-the-module>)
- [Functions](https://docs.project-sylvanas.net/docs/<#functions>)
  - [Vector Creation and Cloning ✨](https://docs.project-sylvanas.net/docs/<#vector-creation-and-cloning->)
  - `new(x, y)`[](https://docs.project-sylvanas.net/docs/<#newx-y>)
  - `clone()`[](https://docs.project-sylvanas.net/docs/<#clone>)
  - [Arithmetic Operations ➕](https://docs.project-sylvanas.net/docs/<#arithmetic-operations->)
  - `__add(other)`[](https://docs.project-sylvanas.net/docs/<#__addother>)
  - `__sub(other)`[](https://docs.project-sylvanas.net/docs/<#__subother>)
  - `__mul(value)`[](https://docs.project-sylvanas.net/docs/<#__mulvalue>)
  - `__div(value)`[](https://docs.project-sylvanas.net/docs/<#__divvalue>)
  - [Vector Properties and Methods 🧮](https://docs.project-sylvanas.net/docs/<#vector-properties-and-methods->)
  - `normalize()`[](https://docs.project-sylvanas.net/docs/<#normalize>)
  - `length()`[](https://docs.project-sylvanas.net/docs/<#length>)
  - `dot(other)`[](https://docs.project-sylvanas.net/docs/<#dotother>)
  - `lerp(target, t)`[](https://docs.project-sylvanas.net/docs/<#lerptarget-t>)
  - [Advanced Operations ⚙️](https://docs.project-sylvanas.net/docs/<#advanced-operations-️>)
  - `randomize_xy(margin)`[](https://docs.project-sylvanas.net/docs/<#randomize_xymargin>)
  - `rotate_around(origin, angle_degrees)`[](https://docs.project-sylvanas.net/docs/<#rotate_aroundorigin-angle_degrees>)
  - `dist_to(other)`[](https://docs.project-sylvanas.net/docs/<#dist_toother>)
  - `get_angle(origin)`[](https://docs.project-sylvanas.net/docs/<#get_angleorigin>)
  - `intersects(p1, p2)`[](https://docs.project-sylvanas.net/docs/<#intersectsp1-p2>)
  - `get_perp_left(origin)`[](https://docs.project-sylvanas.net/docs/<#get_perp_leftorigin>)
  - `get_perp_left_factor(origin, factor)`[](https://docs.project-sylvanas.net/docs/<#get_perp_left_factororigin-factor>)
  - `get_perp_right(origin)`[](https://docs.project-sylvanas.net/docs/<#get_perp_rightorigin>)
  - `get_perp_right_factor(origin, factor)`[](https://docs.project-sylvanas.net/docs/<#get_perp_right_factororigin-factor>)
  - [Additional Functions 🛠️](https://docs.project-sylvanas.net/docs/<#additional-functions-️>)
  - `dot_product(other)`[](https://docs.project-sylvanas.net/docs/<#dot_productother>)
  - `is_nan()`[](https://docs.project-sylvanas.net/docs/<#is_nan>)
  - `is_zero()`[](https://docs.project-sylvanas.net/docs/<#is_zero>)
- [Code Examples](https://docs.project-sylvanas.net/docs/<#code-examples>)
  - [Example 1: Vector Addition](https://docs.project-sylvanas.net/docs/<#example-1-vector-addition>)
  - [Example 2: Vector Dot Product](https://docs.project-sylvanas.net/docs/<#example-2-vector-dot-product>)
  - [Example 3: Vector Normalization](https://docs.project-sylvanas.net/docs/<#example-3-vector-normalization>)
  - [Example 4: Vector Rotation](https://docs.project-sylvanas.net/docs/<#example-4-vector-rotation>)
