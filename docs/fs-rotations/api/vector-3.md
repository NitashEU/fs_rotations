# Vector 3

The `vec3` module provides functions for working with 3D vectors in Lua scripts. These functions include vector creation, arithmetic operations, normalization, length calculation, dot and cross product calculation, interpolation, randomization, rotation, distance calculation, angle calculation, intersection checking, and more.
tip
If you are new and don't know what a `vec3` is and want a deep understanding of this class, or the [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) data structure, you might want to study some . This information is basic and it will be useful for any game-related project that you might work on in the future. Since vec3 has 1 more coordinate in the space, working with vec3 is a little bit more complex. Therefore, if you are new, we recommend you to study [vec2](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/vector-2>) first.

## Importing the Module[​](https://docs.project-sylvanas.net/docs/<#importing-the-module> "Direct link to Importing the Module")

warning
This is a Lua library stored inside the "common" folder. To use it, you will need to include the library. Use the `require` function and store it in a local variable.
Here is an example of how to do it:

```
---@type vec3local vec3 =require("common/geometry/vector_3")
```

## Functions[​](https://docs.project-sylvanas.net/docs/<#functions> "Direct link to Functions")

### Vector Creation and Cloning[​](https://docs.project-sylvanas.net/docs/<#vector-creation-and-cloning> "Direct link to Vector Creation and Cloning")

### `new(x, y, z)`[​](https://docs.project-sylvanas.net/docs/<#newx-y-z> "Direct link to newx-y-z")

Creates a new 3D vector with the specified x, y, and z components.
Parameters:

- **`x`**(_number_) — The x component of the vector.
- **`y`**(_number_) — The y component of the vector.
- **`z`**(_number_) — The z component of the vector.

Returns: _vec3_ — A new vector instance.
note
If no number is passed as parameter (you construct the vector by using vec3.new()) then, a vector_3 is constructed with the values (0,0,0). So, :is_zero will be true.

### `clone()`[​](https://docs.project-sylvanas.net/docs/<#clone> "Direct link to clone")

Clones the current vector.
Returns: _vec3_ — A new vector instance that is a copy of the original.

### Arithmetic Operations ➕➖✖️➗[​](https://docs.project-sylvanas.net/docs/<#arithmetic-operations-️> "Direct link to Arithmetic Operations ➕➖✖️➗")

### `__add(other)`[​](https://docs.project-sylvanas.net/docs/<#__addother> "Direct link to __addother")

Overloads the addition operator (`+`) for vector addition.
Parameters:

- **`other`**(_vec3_) — The vector to add.

Returns: _vec3_ — The result of the addition.
warning
Do not use this function directly. Instead, just use the operator `+`. For example:

```
---@type vec3local vec3 =require("common/geometry/vector_3")local v1 = vec3.new(1,1,0)local v2 = vec3.new(2,2,2)--- Bad code:-- local v3 = v1:__add(v2)--- Correct code:local v3 = v1 + v2
```

### `__sub(other)`[​](https://docs.project-sylvanas.net/docs/<#__subother> "Direct link to __subother")

Overloads the subtraction operator (`-`) for vector subtraction.
Parameters:

- **`other`**(_vec3_) — The vector to subtract.

Returns: _vec3_ — The result of the subtraction.
warning
Do not use this function directly. Instead, just use the operator `-`. For example:

```
---@type vec3local vec3 =require("common/geometry/vector_3")local v1 = vec3.new(1,1,0)local v2 = vec3.new(2,2,2)--- Bad code:-- local v3 = v1:__sub(v2)--- Correct code:local v3 = v1 - v2
```

### `__mul(value)`[​](https://docs.project-sylvanas.net/docs/<#__mulvalue> "Direct link to __mulvalue")

Overloads the multiplication operator (`*`) for scalar multiplication or element-wise multiplication.
Parameters:

- **`value`**(_number_ or _vec3_) — The scalar or vector to multiply with.

Returns: _vec3_ — The result of the multiplication.
warning
Do not use this function directly. Instead, just use the operator `*`. For example:

```
---@type vec3local vec3 =require("common/geometry/vector_3")local v1 = vec3.new(1,1,0)local v2 = vec3.new(2,2,2)--- Bad code:-- local v3 = v1:__mul(v2)--- Correct code:local v3 = v1 * v2
```

### `__div(value)`[​](https://docs.project-sylvanas.net/docs/<#__divvalue> "Direct link to __divvalue")

Overloads the division operator (`/`) for scalar division or element-wise division.
Parameters:

- **`value`**(_number_ or _vec3_) — The scalar or vector to divide by.

Returns: _vec3_ — The result of the division.
warning
Do not use this function directly. Instead, just use the operator `/`. For example:

```
---@type vec3local vec3 =require("common/geometry/vector_3")local v1 = vec3.new(1,1,0)local v2 = vec3.new(2,2,2)--- Bad code:-- local v3 = v1:__div(v2)--- Correct code:local v3 = v1 / v2
```

### `__eq(value)`[​](https://docs.project-sylvanas.net/docs/<#__eqvalue> "Direct link to __eqvalue")

Overloads the equals operator (`==`).
Parameters:

- **`value`**(_vec3_) — The vector 3 to check if it's equal.

Returns: _boolean_ — True if both vectors are equal, false otherwise.
warning
Do not use this function directly. Instead, just use the operator `==`. For example:

```
---@type vec3local vec3 =require("common/geometry/vector_3")local v1 = vec3.new(1,1,0)local v2 = vec3.new(2,2,2)--- Bad code:-- local are_v1_and_v2_the_same = v1:__eq(v2)--- Correct code:local are_v1_and_v2_the_same = v1 ==(v2)
```

### Vector Properties and Methods 🧮[​](https://docs.project-sylvanas.net/docs/<#vector-properties-and-methods-> "Direct link to Vector Properties and Methods 🧮")

### `normalize()`[​](https://docs.project-sylvanas.net/docs/<#normalize> "Direct link to normalize")

Returns the normalized vector (unit vector) of the current vector.
Returns: _vec3_ — The normalized vector.

### `length()`[​](https://docs.project-sylvanas.net/docs/<#length> "Direct link to length")

Returns the length (magnitude) of the vector.
Returns: _number_ — The length of the vector.

### `dot(other)`[​](https://docs.project-sylvanas.net/docs/<#dotother> "Direct link to dotother")

Calculates the dot product of two vectors.
Parameters:

- **`other`**(_vec3_) — The other vector.

Returns: _number_ — The dot product.

### `cross(other)`[​](https://docs.project-sylvanas.net/docs/<#crossother> "Direct link to crossother")

Calculates the cross product of two vectors.
Parameters:

- **`other`**(_vec3_) — The other vector.

Returns: _vec3_ — The cross product vector.

### `lerp(target, t)`[​](https://docs.project-sylvanas.net/docs/<#lerptarget-t> "Direct link to lerptarget-t")

Performs linear interpolation between two vectors.
Parameters:

- **`target`**(_vec3_) — The target vector.
- **`t`**(_number_) — The interpolation factor (between 0.0 and 1.0).

Returns: _vec3_ — The interpolated vector.

### Advanced Operations ⚙️[​](https://docs.project-sylvanas.net/docs/<#advanced-operations-️> "Direct link to Advanced Operations ⚙️")

### `rotate_around(origin, angle_degrees)`[​](https://docs.project-sylvanas.net/docs/<#rotate_aroundorigin-angle_degrees> "Direct link to rotate_aroundorigin-angle_degrees")

Rotates the vector around a specified origin point by a given angle in degrees.
Parameters:

- **`origin`**(_vec3_) — The origin point to rotate around.
- **`angle_degrees`**(_number_) — The angle in degrees.

Returns: _vec3_ — The rotated vector.

### `dist_to(other)`[​](https://docs.project-sylvanas.net/docs/<#dist_toother> "Direct link to dist_toother")

Calculates the Euclidean distance to another vector.
Parameters:

- **`other`**(_vec3_) — The other vector.

Returns: _number_ — The distance between the vectors.
tip
Usually, you would want to use dist_to_ignore_z, since for most cases you don't really care about the Z component of the vector (height differences). We recommend using squared_dist_to_ignore_z, instead of dist_to_ignore_z or squared_dist_to instead of dist_to. If you check the mathematical formula to calculate a distance between 2 vectors, you will see there is a square root operation there. This is computationally expensive, so, for performance reasons, we advise you to just use the square function and then compare it to the value you want to compare it, but squared. For example:

```
-- check if the distance between v1 and v2 is > 10.0---@type vec3local vec3 =require("common/geometry/vector_3")local v1 = vec3.new(5.0,5.0,5.0)local v2 = vec3.new(10.0,10.0,10.0)local distance_check =10.0local distance_check_squared = distance_check * distance_check-- method 1: BADlocal distance = v1:dist_to(v2)local is_dist_superior_to_10_method1 = distance > distance_checkcore.log("Method 1 result: "..tostring(is_dist_superior_to_10_method1))-- method 2: GOODlocal distance_squared = v1:squared_dist_to(v2)local is_dist_superior_to_10_method2 = distance_squared > distance_check_squaredcore.log("Method 2 result: "..tostring(is_dist_superior_to_10_method2))
```

If you run the previous code, you will notice that the result from the first method is the same as the result from the second method. However, the second one is much more efficient. This will make no difference in a low scale, but if you have multiple distance checks in your code it will end up being very noticeable in the user's FPS counter.

### `squared_dist_to(other)`[​](https://docs.project-sylvanas.net/docs/<#squared_dist_toother> "Direct link to squared_dist_toother")

Calculates the Euclidean squared distance to another vector.
Parameters:

- **`other`**(_vec3_) — The other vector.

Returns: _number_ — The squared distance between the vectors.
note
This function is recommended over dist_to(other), for the reasons previously explained.

### `squared_dist_to_ignore_z(other)`[​](https://docs.project-sylvanas.net/docs/<#squared_dist_to_ignore_zother> "Direct link to squared_dist_to_ignore_zother")

Calculates the Euclidean squared distance to another vector, ignoring the Z component of the vectors.
Parameters:

- **`other`**(_vec3_) — The other vector.

Returns: _number_ — The squared distance between the vectors, without taking into account the Z component of the vectors.
note
This function is recommended over dist_to_ignore_z(other), for the reasons previously explained.

### `dist_to_line_segment(line_segment_start, line_segment_end)`[​](https://docs.project-sylvanas.net/docs/<#dist_to_line_segmentline_segment_start-line_segment_end> "Direct link to dist_to_line_segmentline_segment_start-line_segment_end")

Calculates the distance from self to a given line segment.
Parameters:

- **`other`**(_vec3_) — The other vector.

Returns: _number_ — The distance between self and a line segment.

### `squared_dist_to_line_segment(line_segment_start, line_segment_end)`[​](https://docs.project-sylvanas.net/docs/<#squared_dist_to_line_segmentline_segment_start-line_segment_end> "Direct link to squared_dist_to_line_segmentline_segment_start-line_segment_end")

Calculates the distance from self to a given line segment.
Parameters:

- **`other`**(_vec3_) — The other vector.

Returns: _number_ — The squared distance between self and a line segment.
note
This function is recommended over dist_to_line_segment(), for the reasons previously explained.

### `squared_dist_to_ignore_z_line_segment(line_segment_start, line_segment_end)`[​](https://docs.project-sylvanas.net/docs/<#squared_dist_to_ignore_z_line_segmentline_segment_start-line_segment_end> "Direct link to squared_dist_to_ignore_z_line_segmentline_segment_start-line_segment_end")

Calculates the distance from self to a given line segment, ignoring the Z component of the vector.
Parameters:

- **`other`**(_vec3_) — The other vector.

Returns: _number_ — The squared distance between self and a line segment, ignoring the Z component of the vector.

### `get_angle(origin)`[​](https://docs.project-sylvanas.net/docs/<#get_angleorigin> "Direct link to get_angleorigin")

Calculates the angle between the vector and a target vector, relative to a specified origin point.
Parameters:

- **`origin`**(_vec3_) — The origin point.

Returns: _number_ — The angle in degrees.

### `intersects(p1, p2)`[​](https://docs.project-sylvanas.net/docs/<#intersectsp1-p2> "Direct link to intersectsp1-p2")

Checks if the vector (as a point) intersects with a line segment defined by two points.
Parameters:

- **`p1`**(_vec3_) — The first point of the line segment.
- **`p2`**(_vec3_) — The second point of the line segment.

Returns: _boolean_ — `true` if the point intersects the line segment; otherwise, `false`.

### `get_perp_left(origin)`[​](https://docs.project-sylvanas.net/docs/<#get_perp_leftorigin> "Direct link to get_perp_leftorigin")

Returns the left perpendicular vector of the current vector relative to a specified origin point.
Parameters:

- **`origin`**(_vec3_) — The origin point.

Returns: _vec3_ — The left perpendicular vector.

### `get_perp_right(origin)`[​](https://docs.project-sylvanas.net/docs/<#get_perp_rightorigin> "Direct link to get_perp_rightorigin")

Returns the right perpendicular vector of the current vector relative to a specified origin point.
Parameters:

- **`origin`**(_vec3_) — The origin point.

Returns: _vec3_ — The right perpendicular vector.

### Additional Functions 🛠️[​](https://docs.project-sylvanas.net/docs/<#additional-functions-️> "Direct link to Additional Functions 🛠️")

### `dot_product(other)`[​](https://docs.project-sylvanas.net/docs/<#dot_productother> "Direct link to dot_productother")

An alternative method to calculate the dot product of two vectors.
Parameters:

- **`other`**(_vec3_) — The other vector.

Returns: _number_ — The dot product.

### `is_nan()`[​](https://docs.project-sylvanas.net/docs/<#is_nan> "Direct link to is_nan")

Checks if the vector is not a number.
Returns: _boolean_ — True if the vector_3 is not a number, false otherwise.

### `is_zero()`[​](https://docs.project-sylvanas.net/docs/<#is_zero> "Direct link to is_zero")

Checks if the vector is zero.
Returns: _boolean_ — True if the vector_3 is the vector(0,0,0), false otherwise.
tip
Saying that a vector is_zero is the same as saying that the said vector equals the vec3.new(0,0,0)

## Code Examples[​](https://docs.project-sylvanas.net/docs/<#code-examples> "Direct link to Code Examples")

```
---@type vec3local vec3 =require("common/geometry/vector_3")local v1 = vec3.new(1,2,3)local v2 = vec3.new(4,5,6)local v3 = v1:clone()-- Clone v1-- Adding vectorslocal v_add = v1 + v2core.log("Vector addition result: ".. v_add.x ..", ".. v_add.y ..", ".. v_add.z)-- Subtracting vectorslocal v_sub = v1 - v2core.log("Vector subtraction result: ".. v_sub.x ..", ".. v_sub.y ..", ".. v_sub.z)-- Normalizing a vectorlocal v_norm = v1:normalize()core.log("Normalized vector: ".. v_norm.x ..", ".. v_norm.y ..", ".. v_norm.z)-- Finding the distance between two vectors, ignoring zlocal dist_ignore_z = v1:dist_to_ignore_z(v2)core.log("Distance ignoring Z: ".. dist_ignore_z)-- Finding the squared length for efficiencylocal dist_squared = v1:length_squared()core.log("Squared length: ".. dist_squared)
```

[[spell-prediction]]

- [Overview](https://docs.project-sylvanas.net/docs/<#overview>)
- [Importing the Module](https://docs.project-sylvanas.net/docs/<#importing-the-module>)
- [Functions](https://docs.project-sylvanas.net/docs/<#functions>)
  - [Vector Creation and Cloning](https://docs.project-sylvanas.net/docs/<#vector-creation-and-cloning>)
  - `new(x, y, z)`[](https://docs.project-sylvanas.net/docs/<#newx-y-z>)
  - `clone()`[](https://docs.project-sylvanas.net/docs/<#clone>)
  - [Arithmetic Operations ➕➖✖️➗](https://docs.project-sylvanas.net/docs/<#arithmetic-operations-️>)
  - `__add(other)`[](https://docs.project-sylvanas.net/docs/<#__addother>)
  - `__sub(other)`[](https://docs.project-sylvanas.net/docs/<#__subother>)
  - `__mul(value)`[](https://docs.project-sylvanas.net/docs/<#__mulvalue>)
  - `__div(value)`[](https://docs.project-sylvanas.net/docs/<#__divvalue>)
  - `__eq(value)`[](https://docs.project-sylvanas.net/docs/<#__eqvalue>)
  - [Vector Properties and Methods 🧮](https://docs.project-sylvanas.net/docs/<#vector-properties-and-methods->)
  - `normalize()`[](https://docs.project-sylvanas.net/docs/<#normalize>)
  - `length()`[](https://docs.project-sylvanas.net/docs/<#length>)
  - `dot(other)`[](https://docs.project-sylvanas.net/docs/<#dotother>)
  - `cross(other)`[](https://docs.project-sylvanas.net/docs/<#crossother>)
  - `lerp(target, t)`[](https://docs.project-sylvanas.net/docs/<#lerptarget-t>)
  - [Advanced Operations ⚙️](https://docs.project-sylvanas.net/docs/<#advanced-operations-️>)
  - `rotate_around(origin, angle_degrees)`[](https://docs.project-sylvanas.net/docs/<#rotate_aroundorigin-angle_degrees>)
  - `dist_to(other)`[](https://docs.project-sylvanas.net/docs/<#dist_toother>)
  - `squared_dist_to(other)`[](https://docs.project-sylvanas.net/docs/<#squared_dist_toother>)
  - `squared_dist_to_ignore_z(other)`[](https://docs.project-sylvanas.net/docs/<#squared_dist_to_ignore_zother>)
  - `dist_to_line_segment(line_segment_start, line_segment_end)`[](https://docs.project-sylvanas.net/docs/<#dist_to_line_segmentline_segment_start-line_segment_end>)
  - `squared_dist_to_line_segment(line_segment_start, line_segment_end)`[](https://docs.project-sylvanas.net/docs/<#squared_dist_to_line_segmentline_segment_start-line_segment_end>)
  - `squared_dist_to_ignore_z_line_segment(line_segment_start, line_segment_end)`[](https://docs.project-sylvanas.net/docs/<#squared_dist_to_ignore_z_line_segmentline_segment_start-line_segment_end>)
  - `get_angle(origin)`[](https://docs.project-sylvanas.net/docs/<#get_angleorigin>)
  - `intersects(p1, p2)`[](https://docs.project-sylvanas.net/docs/<#intersectsp1-p2>)
  - `get_perp_left(origin)`[](https://docs.project-sylvanas.net/docs/<#get_perp_leftorigin>)
  - `get_perp_right(origin)`[](https://docs.project-sylvanas.net/docs/<#get_perp_rightorigin>)
  - [Additional Functions 🛠️](https://docs.project-sylvanas.net/docs/<#additional-functions-️>)
  - `dot_product(other)`[](https://docs.project-sylvanas.net/docs/<#dot_productother>)
  - `is_nan()`[](https://docs.project-sylvanas.net/docs/<#is_nan>)
  - `is_zero()`[](https://docs.project-sylvanas.net/docs/<#is_zero>)
- [Code Examples](https://docs.project-sylvanas.net/docs/<#code-examples>)
