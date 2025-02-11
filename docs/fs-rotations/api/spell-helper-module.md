# Spell helper

As explained in the previous page [Spell Book Functions](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/spell-book-functions#overview>), the spell helper module will provide you most of the possible and most used functionalities related to spells.
tip
Check the examples section, which is essentially the summary of all this module.

## Importing The Module[​](https://docs.project-sylvanas.net/docs/<#importing-the-module> "Direct link to Importing The Module")

warning
This is a Lua library stored inside the "common" folder. To use it, you will need to include the library. Use the `require` function and store it in a local variable.
Here is an example of how to do it:

```
---@type spell_helperlocal spell_helper =require("common/utility/spell_helper")
```

## Functions[​](https://docs.project-sylvanas.net/docs/<#functions> "Direct link to Functions")

### Spell Availability 📖[​](https://docs.project-sylvanas.net/docs/<#spell-availability-> "Direct link to Spell Availability 📖")

### `has_spell_equipped(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#has_spell_equippedspell_id> "Direct link to has_spell_equippedspell_id")

Checks if the spell is in the spellbook.
Parameters:

- **`spell_id`**(_number_) — The ID of the spell to check.

Returns: _boolean_ — `true` if the spell is equipped; otherwise, `false`.

### Spell Cooldown ⏳[​](https://docs.project-sylvanas.net/docs/<#spell-cooldown-> "Direct link to Spell Cooldown ⏳")

### `is_spell_on_cooldown(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#is_spell_on_cooldownspell_id> "Direct link to is_spell_on_cooldownspell_id")

Checks if the spell is currently on cooldown.
Parameters:

- **`spell_id`**(_number_) — The ID of the spell to check.

Returns: _boolean_ — `true` if the spell is on cooldown; otherwise, `false`.

### Range and Angle Checks 🎯[​](https://docs.project-sylvanas.net/docs/<#range-and-angle-checks-> "Direct link to Range and Angle Checks 🎯")

### `is_spell_in_range(spell_id, target, source, destination)`[​](https://docs.project-sylvanas.net/docs/<#is_spell_in_rangespell_id-target-source-destination> "Direct link to is_spell_in_rangespell_id-target-source-destination")

Checks if a spell is within castable range given a target.
Parameters:

- **`spell_id`**(_number_) — The ID of the spell.
- **`target`**(_game_object_) — The target game object.
- **`source`**(_vec3_) — The source position vector.
- **`destination`**(_vec3_) — The destination position vector.

Returns: _boolean_ — `true` if the spell is within range; otherwise, `false`.

### `is_spell_within_angle(spell_id, caster, target, caster_position, target_position)`[​](https://docs.project-sylvanas.net/docs/<#is_spell_within_anglespell_id-caster-target-caster_position-target_position> "Direct link to is_spell_within_anglespell_id-caster-target-caster_position-target_position")

Checks if the target is within a permissible angle for casting a spell.
Parameters:

- **`spell_id`**(_number_) — The ID of the spell.
- **`caster`**(_game_object_) — The caster game object.
- **`target`**(_game_object_) — The target game object.
- **`caster_position`**(_vec3_) — The position of the caster.
- **`target_position`**(_vec3_) — The position of the target.

Returns: _boolean_ — `true` if the target is within angle; otherwise, `false`.

### Line of Sight Checks 👁️[​](https://docs.project-sylvanas.net/docs/<#line-of-sight-checks-️> "Direct link to Line of Sight Checks 👁️")

### `is_spell_in_line_of_sight(spell_id, caster, target)`[​](https://docs.project-sylvanas.net/docs/<#is_spell_in_line_of_sightspell_id-caster-target> "Direct link to is_spell_in_line_of_sightspell_id-caster-target")

Checks if the caster has the target in line of sight for a spell.
Parameters:

- **`spell_id`**(_number_) — The ID of the spell.
- **`caster`**(_game_object_) — The caster game object.
- **`target`**(_game_object_) — The target game object.

Returns: _boolean_ — `true` if the target is in line of sight; otherwise, `false`.

### `is_spell_in_line_of_sight_position(spell_id, caster, cast_position)`[​](https://docs.project-sylvanas.net/docs/<#is_spell_in_line_of_sight_positionspell_id-caster-cast_position> "Direct link to is_spell_in_line_of_sight_positionspell_id-caster-cast_position")

Checks if the caster has the position in line of sight for a spell.
Parameters:

- **`spell_id`**(_number_) — The ID of the spell.
- **`caster`**(_game_object_) — The caster game object.
- **`cast_position`**(_vec3_) — The position to check.

Returns: _boolean_ — `true` if the position is in line of sight; otherwise, `false`.

### Resource and Cost Checks 💰[​](https://docs.project-sylvanas.net/docs/<#resource-and-cost-checks-> "Direct link to Resource and Cost Checks 💰")

### `get_spell_cost(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#get_spell_costspell_id> "Direct link to get_spell_costspell_id")

Retrieves the cost of a spell.
Parameters:

- **`spell_id`**(_number_) — The ID of the spell.

Returns: _table_ — A table containing the cost details of the spell.
**Cost Table Properties:**

- `cost_type`: The type of resource required (e.g., mana, energy).
- `cost`: The amount of resource required to cast the spell.
- `cost_percent`: The percentage of the resource pool required.
- Other cost-related fields as applicable.

warning
In most cases, you do not want to use this function, as it returns a table that needs to be specially handled, same like the raw function.

### `can_afford_spell(unit, spell_id, spell_costs)`[​](https://docs.project-sylvanas.net/docs/<#can_afford_spellunit-spell_id-spell_costs> "Direct link to can_afford_spellunit-spell_id-spell_costs")

Checks if a unit has enough resources to cast a spell.
Parameters:

- **`unit`**(_game_object_) — The unit attempting to cast the spell.
- **`spell_id`**(_number_) — The ID of the spell.
- **`spell_costs`**(_table_) — The cost table retrieved from `get_spell_cost`.

Returns: _boolean_ — `true` if the unit can afford the spell; otherwise, `false`.

### Casting Readiness ✅[​](https://docs.project-sylvanas.net/docs/<#casting-readiness-> "Direct link to Casting Readiness ✅")

### `is_spell_castable(spell_id, caster, target, skip_facing, skips_range)`[​](https://docs.project-sylvanas.net/docs/<#is_spell_castablespell_id-caster-target-skip_facing-skips_range> "Direct link to is_spell_castablespell_id-caster-target-skip_facing-skips_range")

Checks if the spell can be cast to target.
Parameters:

- **`spell_id`**(_number_) — The ID of the spell.
- **`caster`**(_game_object_) — The caster game object.
- **`target`**(_game_object_) — The target game object.
- **`skip_facing`**(_boolean_) — If `true`, skips the facing check.
- **`skips_range`**(_boolean_) — If `true`, skips the range check.

Returns: _boolean_ — `true` if the spell can be cast; otherwise, `false`.
note
This function handles everything for you (line of sight, cooldown, spell cost, etc), so, for most cases, this is the only function you will need to check if you can cast a spell or not.

## Examples[​](https://docs.project-sylvanas.net/docs/<#examples> "Direct link to Examples")

### How To - Check If You Can Cast A Spell 🎯[​](https://docs.project-sylvanas.net/docs/<#how-to---check-if-you-can-cast-a-spell-> "Direct link to How To - Check If You Can Cast A Spell 🎯")

tip
This is the recommended way to check if you can cast a spell. Just check the last two parameters (skip_facing and skip_range), since you might wanna set them to "true" in some cases (for example, for some self-cast spells).

```
---@type spell_helperlocal spell_helper =require("common/utility/spell_helper")localfunctioncan_cast(local_player, target)local is_logic_allowed = spell_helper:is_spell_castable(spell_data.id, local_player, target,false,false)return is_logic_allowedend
```

[[graphics-functions]]

- [Overview](https://docs.project-sylvanas.net/docs/<#overview>)
- [Importing The Module](https://docs.project-sylvanas.net/docs/<#importing-the-module>)
- [Functions](https://docs.project-sylvanas.net/docs/<#functions>)
  - [Spell Availability 📖](https://docs.project-sylvanas.net/docs/<#spell-availability->)
  - `has_spell_equipped(spell_id)`[](https://docs.project-sylvanas.net/docs/<#has_spell_equippedspell_id>)
  - [Spell Cooldown ⏳](https://docs.project-sylvanas.net/docs/<#spell-cooldown->)
  - `is_spell_on_cooldown(spell_id)`[](https://docs.project-sylvanas.net/docs/<#is_spell_on_cooldownspell_id>)
  - [Range and Angle Checks 🎯](https://docs.project-sylvanas.net/docs/<#range-and-angle-checks->)
  - `is_spell_in_range(spell_id, target, source, destination)`[](https://docs.project-sylvanas.net/docs/<#is_spell_in_rangespell_id-target-source-destination>)
  - `is_spell_within_angle(spell_id, caster, target, caster_position, target_position)`[](https://docs.project-sylvanas.net/docs/<#is_spell_within_anglespell_id-caster-target-caster_position-target_position>)
  - [Line of Sight Checks 👁️](https://docs.project-sylvanas.net/docs/<#line-of-sight-checks-️>)
  - `is_spell_in_line_of_sight(spell_id, caster, target)`[](https://docs.project-sylvanas.net/docs/<#is_spell_in_line_of_sightspell_id-caster-target>)
  - `is_spell_in_line_of_sight_position(spell_id, caster, cast_position)`[](https://docs.project-sylvanas.net/docs/<#is_spell_in_line_of_sight_positionspell_id-caster-cast_position>)
  - [Resource and Cost Checks 💰](https://docs.project-sylvanas.net/docs/<#resource-and-cost-checks->)
  - `get_spell_cost(spell_id)`[](https://docs.project-sylvanas.net/docs/<#get_spell_costspell_id>)
  - `can_afford_spell(unit, spell_id, spell_costs)`[](https://docs.project-sylvanas.net/docs/<#can_afford_spellunit-spell_id-spell_costs>)
  - [Casting Readiness ✅](https://docs.project-sylvanas.net/docs/<#casting-readiness->)
  - `is_spell_castable(spell_id, caster, target, skip_facing, skips_range)`[](https://docs.project-sylvanas.net/docs/<#is_spell_castablespell_id-caster-target-skip_facing-skips_range>)
- [Examples](https://docs.project-sylvanas.net/docs/<#examples>)
  - [How To - Check If You Can Cast A Spell 🎯](https://docs.project-sylvanas.net/docs/<#how-to---check-if-you-can-cast-a-spell->)
