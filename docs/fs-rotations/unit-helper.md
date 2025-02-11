# Unit Helper Library

The **Unit Helper** module provides a collection of utility functions for working with game units in Sylvanas. This module simplifies tasks such as checking unit states, retrieving unit information, and working with groups of units. Below, we'll explore its core functions and how to effectively utilize them.

## Including the Module[​](https://docs.project-sylvanas.net/docs/<#including-the-module> "Direct link to Including the Module")

As with all other LUA modules developed by us, you will need to **import** the unit helper module into your project. To do so, you can use the following lines:

```
---@type unit_helperlocal unit_helper =require("common/utility/unit_helper")
```

warning
To access the module's functions, you **must** use `:` instead of `.`
For example, this code is **not correct** :

```
---@type unit_helperlocal unit_helper =require("common/utility/unit_helper")localfunctionis_target_dummy(unit)return unit_helper.is_dummy(unit)end
```

And this would be the **corrected code** :

```
---@type unit_helperlocal unit_helper =require("common/utility/unit_helper")localfunctionis_target_dummy(unit)return unit_helper:is_dummy(unit)end
```

## Functions[​](https://docs.project-sylvanas.net/docs/<#functions> "Direct link to Functions")

### Unit Classification Functions 📋[​](https://docs.project-sylvanas.net/docs/<#unit-classification-functions-> "Direct link to unit-classification-functions-")

### `is_dummy(unit: game_object) -> boolean`[​](https://docs.project-sylvanas.net/docs/<#is_dummyunit-game_object---boolean> "Direct link to is_dummyunit-game_object---boolean")

Returns `true` if the given unit is a training dummy.

```
local is_training_dummy = unit_helper:is_dummy(unit)if is_training_dummy then  core.log("The unit is a training dummy.")end
```

### `is_boss(unit: game_object) -> boolean`[​](https://docs.project-sylvanas.net/docs/<#is_bossunit-game_object---boolean> "Direct link to is_bossunit-game_object---boolean")

Determines if the unit is a boss with certain exceptions.

### `is_valid_enemy(unit: game_object) -> boolean`[​](https://docs.project-sylvanas.net/docs/<#is_valid_enemyunit-game_object---boolean> "Direct link to is_valid_enemyunit-game_object---boolean")

Determines if the unit is a valid enemy with exceptions.

### `is_valid_ally(unit: game_object) -> boolean`[​](https://docs.project-sylvanas.net/docs/<#is_valid_allyunit-game_object---boolean> "Direct link to is_valid_allyunit-game_object---boolean")

Determines if the unit is a valid ally with exceptions.

### Combat State Functions 🛡️[​](https://docs.project-sylvanas.net/docs/<#combat-state-functions-️> "Direct link to combat-state-functions-️")

### `is_in_combat(unit: game_object) -> boolean`[​](https://docs.project-sylvanas.net/docs/<#is_in_combatunit-game_object---boolean> "Direct link to is_in_combatunit-game_object---boolean")

Determines if the unit is in combat with certain exceptions.

### Health and Resource Functions ❤️[​](https://docs.project-sylvanas.net/docs/<#health-and-resource-functions-️> "Direct link to health-and-resource-functions-️")

### `get_health_percentage(unit: game_object) -> number`[​](https://docs.project-sylvanas.net/docs/<#get_health_percentageunit-game_object---number> "Direct link to get_health_percentageunit-game_object---number")

Returns the health percentage of the unit in a format from `0.0` to `1.0`.

```
local health_pct = unit_helper:get_health_percentage(unit)core.log("Unit's health percentage: "..(health_pct *100).."%")
```

### `get_health_percentage_inc(unit: game_object, time_limit?: number) -> number, number, number, number`[​](https://docs.project-sylvanas.net/docs/<#get_health_percentage_incunit-game_object-time_limit-number---number-number-number-number> "Direct link to get_health_percentage_incunit-game_object-time_limit-number---number-number-number-number")

Calculates the health percentage of a unit considering incoming damage within a specified time frame. This function uses the [Health Prediction Module](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/health-prediction-user>)
note
This function returns 4 values: 1- Total -> The value that you will want usually. It's the future health percentage that you willhave according to the incoming damage. 2- Incoming -> The amount of incoming damage. 3- Percentage -> The current HP percentage. 4- Incoming Percentage -> The HP percentage taking into account just the incoming damage and not current health.

```
local total, incoming, percentage, incoming_percent = unit_helper:get_health_percentage_inc(unit,5)core.log("Health after incoming damage: "..(total *100).."%")
```

tip
Generally, you will use this function as follows:

```
if unit_helper:get_health_percentage_inc(ally_target)<0.45then    is_anyone_low =trueend
```

Just taking into account the first value.

### `get_resource_percentage(unit: game_object, power_type: number) -> number`[​](https://docs.project-sylvanas.net/docs/<#get_resource_percentageunit-game_object-power_type-number---number> "Direct link to get_resource_percentageunit-game_object-power_type-number---number")

Gets the power (resource) percentage of the unit. See for `power_type` values.

```
---@type enumslocal enums =require("common/enums")localget_local_player_energy_pct(local_player)local energy_percentage = unit_helper:get_resource_percentage(local_player, enums.power_type.ENERGY)  core.log("Unit's Energy percentage: "..(energy_percentage *100).."%")return energy_percentageend
```

### Role Determination Functions 🏹[​](https://docs.project-sylvanas.net/docs/<#role-determination-functions-> "Direct link to role-determination-functions-")

### `get_role_id(unit: game_object) -> number`[​](https://docs.project-sylvanas.net/docs/<#get_role_idunit-game_object---number> "Direct link to get_role_idunit-game_object---number")

Determines the role ID of the unit (Tank, DPS, Healer).

### `is_healer(unit: game_object) -> boolean`[​](https://docs.project-sylvanas.net/docs/<#is_healerunit-game_object---boolean> "Direct link to is_healerunit-game_object---boolean")

Determines if the unit is healer.
warning
Might not work in open world (if the target is not a party member).

### `is_player_in_arena() -> boolean`[​](https://docs.project-sylvanas.net/docs/<#is_player_in_arena---boolean> "Direct link to is_player_in_arena---boolean")

Determines if the local player is in arena.

### `is_player_in_bg() -> boolean`[​](https://docs.project-sylvanas.net/docs/<#is_player_in_bg---boolean> "Direct link to is_player_in_bg---boolean")

Determines if the local player is in BG.

### `is_tank(unit: game_object) -> boolean`[​](https://docs.project-sylvanas.net/docs/<#is_tankunit-game_object---boolean> "Direct link to is_tankunit-game_object---boolean")

warning
Might not work in open world (if the target is not a party member).
Determines if the unit is in the tank role.
tip
Below, an example on how to retrieve the tank from your party:

```
---@type unit_helperlocal unit_helper =require("common/utility/unit_helper")---@param local_player game_object---@returns game_object | nillocalget_tank_from_party(local_player)local allies_from_party = unit_helper:get_ally_list_around(local_player:get_position(),40.0,true,true)for k, ally inipairs(allies_from_party)dolocal is_current_ally_tank = unit_helper:is_tank(ally)if is_current_ally_tank thenreturn allyendendreturnnilend
```

[[target-selector-dev]]

- [Overview](https://docs.project-sylvanas.net/docs/<#overview>)
- [Including the Module](https://docs.project-sylvanas.net/docs/<#including-the-module>)
- [Functions](https://docs.project-sylvanas.net/docs/<#functions>)
  - [Unit Classification Functions 📋](https://docs.project-sylvanas.net/docs/<#unit-classification-functions->)
  - `is_dummy(unit: game_object) -> boolean`[](https://docs.project-sylvanas.net/docs/<#is_dummyunit-game_object---boolean>)
  - `is_blacklist(npc_id: number) -> boolean`[](https://docs.project-sylvanas.net/docs/<#is_blacklistnpc_id-number---boolean>)
  - `is_boss(unit: game_object) -> boolean`[](https://docs.project-sylvanas.net/docs/<#is_bossunit-game_object---boolean>)
  - `is_valid_enemy(unit: game_object) -> boolean`[](https://docs.project-sylvanas.net/docs/<#is_valid_enemyunit-game_object---boolean>)
  - `is_valid_ally(unit: game_object) -> boolean`[](https://docs.project-sylvanas.net/docs/<#is_valid_allyunit-game_object---boolean>)
  - [Combat State Functions 🛡️](https://docs.project-sylvanas.net/docs/<#combat-state-functions-️>)
  - `is_in_combat(unit: game_object) -> boolean`[](https://docs.project-sylvanas.net/docs/<#is_in_combatunit-game_object---boolean>)
  - [Health and Resource Functions ❤️](https://docs.project-sylvanas.net/docs/<#health-and-resource-functions-️>)
  - `get_health_percentage(unit: game_object) -> number`[](https://docs.project-sylvanas.net/docs/<#get_health_percentageunit-game_object---number>)
  - `get_health_percentage_inc(unit: game_object, time_limit?: number) -> number, number, number, number`[](https://docs.project-sylvanas.net/docs/<#get_health_percentage_incunit-game_object-time_limit-number---number-number-number-number>)
  - `get_resource_percentage(unit: game_object, power_type: number) -> number`[](https://docs.project-sylvanas.net/docs/<#get_resource_percentageunit-game_object-power_type-number---number>)
  - [Role Determination Functions 🏹](https://docs.project-sylvanas.net/docs/<#role-determination-functions->)
  - `get_role_id(unit: game_object) -> number`[](https://docs.project-sylvanas.net/docs/<#get_role_idunit-game_object---number>)
  - `is_healer(unit: game_object) -> boolean`[](https://docs.project-sylvanas.net/docs/<#is_healerunit-game_object---boolean>)
  - `is_player_in_arena() -> boolean`[](https://docs.project-sylvanas.net/docs/<#is_player_in_arena---boolean>)
  - `is_player_in_bg() -> boolean`[](https://docs.project-sylvanas.net/docs/<#is_player_in_bg---boolean>)
  - `is_tank(unit: game_object) -> boolean`[](https://docs.project-sylvanas.net/docs/<#is_tankunit-game_object---boolean>)
