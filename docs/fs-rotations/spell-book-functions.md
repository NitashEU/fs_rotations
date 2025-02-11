# Spell Book - Raw Functions

The `spell_book` module provides a comprehensive set of methods to interact with spells in your scripts. You can use these functions to query spell cooldowns, retrieve spell names, check if a spell is equipped, etc. However, same like with the [Input module](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/input>), using the raw functions directly might not be the best idea in most cases. For example, to check if a spell is castable, you would need to first check if the spell is equipped, if the spell is on cooldown, then range... As you can see, this is going to become an annoying task in most of your scripts. To make your life easier and centralize code as much as possible so the amount of bugs is reduced, we developed the [Spell helper module](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/spell-helper-module>).
tip
Check the [Spell helper module](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/spell-helper-module>) after checking the raw functions, provided below.

## Functions[​](https://docs.project-sylvanas.net/docs/<#functions> "Direct link to Functions")

### General Functions 📃[​](https://docs.project-sylvanas.net/docs/<#general-functions-> "Direct link to General Functions 📃")

### `get_specialization_id()`[​](https://docs.project-sylvanas.net/docs/<#get_specialization_id> "Direct link to get_specialization_id")

Returns the specialization ID of the local player.
Returns: _number_ — The specialization ID.
note
This function is specially useful to decide whether to load or not your script. Here is an example to properly avoid loading scripts when they are not necessary (for example, your script is for rogues and the user is playing a monk).

```
--- this is the HEADER filelocal plugin_info =require("plugin_info")local plugin ={}plugin["name"]= plugin_info.plugin_load_nameplugin["version"]= plugin_info.plugin_versionplugin["author"]= plugin_info.author-- by default, we load the plugin alwaysplugin["load"]=true-- if there is no local player (eg. user injected before being in-game or is in loading screen) then-- we don't load the scriptlocal local_player = core.object_manager.get_local_player()ifnot local_player then  plugin["load"]=falsereturn pluginend-- we check if the class that is being played currently matches our script's intended classlocal enums =require("common/enums")local player_class = local_player:get_class()local is_valid_class = player_class == enums.class_id.ROGUEifnot is_valid_class then  plugin["load"]=falsereturn pluginend-- then, we check if the spec id that is being currently played matches our script's intended speclocal player_spec_id = core.spell_book.get_specialization_id()local is_valid_spec_id = player_spec_id ==3ifnot is_valid_spec_id then  plugin["load"]=falsereturn pluginendreturn plugin
```

### Cooldowns and Charges ⏳[​](https://docs.project-sylvanas.net/docs/<#cooldowns-and-charges-> "Direct link to Cooldowns and Charges ⏳")

### `get_global_cooldown()`[​](https://docs.project-sylvanas.net/docs/<#get_global_cooldown> "Direct link to get_global_cooldown")

Returns the duration of the global cooldown, which is the time between casting spells.
Returns: _number_ — The global cooldown duration in seconds.

### `get_spell_cooldown(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#get_spell_cooldownspell_id> "Direct link to get_spell_cooldownspell_id")

Returns the cooldown duration of the specified spell in seconds.
Parameters:

- **`spell_id`**(_integer_) — The ID of the spell.

Returns: _number_ — The cooldown duration in seconds.

### `get_spell_charge(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#get_spell_chargespell_id> "Direct link to get_spell_chargespell_id")

Returns the current number of charges available for the specified spell.
Parameters:

- **`spell_id`**(_integer_) — The ID of the spell.

Returns: _integer_ — The current number of charges.

### `get_spell_charge_max(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#get_spell_charge_maxspell_id> "Direct link to get_spell_charge_maxspell_id")

Returns the maximum number of charges available for the specified spell.
Parameters:

- **`spell_id`**(_integer_) — The ID of the spell.

Returns: _integer_ — The maximum number of charges.

### Spell Information ℹ️[​](https://docs.project-sylvanas.net/docs/<#spell-information-ℹ️> "Direct link to Spell Information ℹ️")

### `get_spell_name(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#get_spell_namespell_id> "Direct link to get_spell_namespell_id")

Returns the name of the specified spell.
Parameters:

- **`spell_id`**(_integer_) — The ID of the spell.

Returns: _string_ — The name of the spell.

### `get_spell_description(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#get_spell_descriptionspell_id> "Direct link to get_spell_descriptionspell_id")

Retrieves the tooltip text of the specified spell.
Parameters:

- **`spell_id`**(_integer_) — The ID of the spell.

Returns: _string_ — The tooltip text.

### `get_spells()`[​](https://docs.project-sylvanas.net/docs/<#get_spells> "Direct link to get_spells")

Returns a table containing all spells and their corresponding IDs.
Returns: table — A table mapping spell IDs to spell names.

### `has_spell(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#has_spellspell_id> "Direct link to has_spellspell_id")

Checks if the specified spell is equipped.
Parameters:

- **`spell_id`**(_integer_) — The ID of the spell.

Returns: _boolean_ — `true` if the spell is equipped; otherwise, `false`.

### `is_spell_learned(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#is_spell_learnedspell_id> "Direct link to is_spell_learnedspell_id")

Determines if the specified spell is learned.
Parameters:

- **`spell_id`**(_integer_) — The ID of the spell.

Returns: _boolean_ — `true` if the spell is learned; otherwise, `false`.
Note: _`is_spell_learned`is more reliable than`has_spell` for checking talents._

### Spell Costs 💰[​](https://docs.project-sylvanas.net/docs/<#spell-costs-> "Direct link to Spell Costs 💰")

### `get_spell_costs(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#get_spell_costsspell_id> "Direct link to get_spell_costsspell_id")

Returns a table containing the power cost details of the specified spell.
Parameters:

- **`spell_id`**(_integer_) — The ID of the spell.

Returns: _table_ — A table containing power cost details.
**`spell_cost`Properties:**

- `min_cost`: Minimum cost required to cast the spell.
- `cost`: Standard cost to cast the spell.
- `cost_per_sec`: Cost per second if the spell is channeled.
- `cost_type`: Type of resource used (e.g., mana, energy).
- `required_buff_id`: ID of any buff required to modify the cost.

warning
Do not use this function, as it returns a table that needs to be handled in a specific way. We still provide its functionality, but in general you wouldn't want to use it.

### Spell Range and Damage 🎯[​](https://docs.project-sylvanas.net/docs/<#spell-range-and-damage-> "Direct link to Spell Range and Damage 🎯")

### `get_spell_range_data(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#get_spell_range_dataspell_id> "Direct link to get_spell_range_dataspell_id")

Returns a table containing the minimum and maximum range of the specified spell.
Parameters:

- **`spell_id`**(_integer_) — The ID of the spell.

Returns: _table_ — A table with `min_range` and `max_range`.
**Range Data Properties:**

- `min_range`: Minimum distance required to cast the spell.
- `max_range`: Maximum distance within which the spell can be cast.

### `get_spell_min_range(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#get_spell_min_rangespell_id> "Direct link to get_spell_min_rangespell_id")

Returns the minimum range of the specified spell.
Parameters:

- **`spell_id`**(_integer_) — The ID of the spell.

Returns: _number_ — The minimum range.

### `get_spell_max_range(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#get_spell_max_rangespell_id> "Direct link to get_spell_max_rangespell_id")

Returns the maximum range of the specified spell.
Parameters:

- **`spell_id`**(_integer_) — The ID of the spell.

Returns: _number_ — The maximum range.

### `get_spell_damage(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#get_spell_damagespell_id> "Direct link to get_spell_damagespell_id")

Retrieves the damage value of the specified spell.
Parameters:

- **`spell_id`**(_integer_) — The ID of the spell.

Returns: _number_ — The damage value.

### Casting Types 🎭[​](https://docs.project-sylvanas.net/docs/<#casting-types-> "Direct link to Casting Types 🎭")

### `is_melee_spell(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#is_melee_spellspell_id> "Direct link to is_melee_spellspell_id")

Determines if the specified spell is of melee type.
Parameters:

- **`spell_id`**(_integer_) — The ID of the spell.

Returns: _boolean_ — `true` if the spell is melee type; otherwise, `false`.

### `is_spell_position_cast(spell_id)`[​](https://docs.project-sylvanas.net/docs/<#is_spell_position_castspell_id> "Direct link to is_spell_position_castspell_id")

Checks if the specified spell is a skillshot (position-cast spell).
Parameters:

- **`spell_id`**(_integer_) — The ID of the spell.

Returns: _boolean_ — `true` if the spell is a skillshot; otherwise, `false`.

### `cursor_has_spell()`[​](https://docs.project-sylvanas.net/docs/<#cursor_has_spell> "Direct link to cursor_has_spell")

Checks if the cursor is currently busy with a skillshot.
Returns: _boolean_ — `true` if the cursor is busy; otherwise, `false`.

### Talents 🌟[​](https://docs.project-sylvanas.net/docs/<#talents-> "Direct link to Talents 🌟")

### `get_talent_name(talent_id)`[​](https://docs.project-sylvanas.net/docs/<#get_talent_nametalent_id> "Direct link to get_talent_nametalent_id")

Returns the name of the specified talent.
Parameters:

- **`talent_id`**(_integer_) — The ID of the talent.

Returns: _string_ — The name of the talent.

### `get_talent_spell_id(talent_id)`[​](https://docs.project-sylvanas.net/docs/<#get_talent_spell_idtalent_id> "Direct link to get_talent_spell_idtalent_id")

Returns the spell ID associated with the specified talent.
Parameters:

- **`talent_id`**(_integer_) — The ID of the talent.

Returns: _number_ — The spell ID.
[[spell-helper-module]]

- [Overview](https://docs.project-sylvanas.net/docs/<#overview>)
- [Functions](https://docs.project-sylvanas.net/docs/<#functions>)
  - [General Functions 📃](https://docs.project-sylvanas.net/docs/<#general-functions->)
  - `get_specialization_id()`[](https://docs.project-sylvanas.net/docs/<#get_specialization_id>)
  - [Cooldowns and Charges ⏳](https://docs.project-sylvanas.net/docs/<#cooldowns-and-charges->)
  - `get_global_cooldown()`[](https://docs.project-sylvanas.net/docs/<#get_global_cooldown>)
  - `get_spell_cooldown(spell_id)`[](https://docs.project-sylvanas.net/docs/<#get_spell_cooldownspell_id>)
  - `get_spell_charge(spell_id)`[](https://docs.project-sylvanas.net/docs/<#get_spell_chargespell_id>)
  - `get_spell_charge_max(spell_id)`[](https://docs.project-sylvanas.net/docs/<#get_spell_charge_maxspell_id>)
  - [Spell Information ℹ️](https://docs.project-sylvanas.net/docs/<#spell-information-ℹ️>)
  - `get_spell_name(spell_id)`[](https://docs.project-sylvanas.net/docs/<#get_spell_namespell_id>)
  - `get_spell_description(spell_id)`[](https://docs.project-sylvanas.net/docs/<#get_spell_descriptionspell_id>)
  - `get_spells()`[](https://docs.project-sylvanas.net/docs/<#get_spells>)
  - `has_spell(spell_id)`[](https://docs.project-sylvanas.net/docs/<#has_spellspell_id>)
  - `is_spell_learned(spell_id)`[](https://docs.project-sylvanas.net/docs/<#is_spell_learnedspell_id>)
  - [Spell Costs 💰](https://docs.project-sylvanas.net/docs/<#spell-costs->)
  - `get_spell_costs(spell_id)`[](https://docs.project-sylvanas.net/docs/<#get_spell_costsspell_id>)
  - [Spell Range and Damage 🎯](https://docs.project-sylvanas.net/docs/<#spell-range-and-damage->)
  - `get_spell_range_data(spell_id)`[](https://docs.project-sylvanas.net/docs/<#get_spell_range_dataspell_id>)
  - `get_spell_min_range(spell_id)`[](https://docs.project-sylvanas.net/docs/<#get_spell_min_rangespell_id>)
  - `get_spell_max_range(spell_id)`[](https://docs.project-sylvanas.net/docs/<#get_spell_max_rangespell_id>)
  - `get_spell_damage(spell_id)`[](https://docs.project-sylvanas.net/docs/<#get_spell_damagespell_id>)
  - [Casting Types 🎭](https://docs.project-sylvanas.net/docs/<#casting-types->)
  - `is_melee_spell(spell_id)`[](https://docs.project-sylvanas.net/docs/<#is_melee_spellspell_id>)
  - `is_spell_position_cast(spell_id)`[](https://docs.project-sylvanas.net/docs/<#is_spell_position_castspell_id>)
  - `cursor_has_spell()`[](https://docs.project-sylvanas.net/docs/<#cursor_has_spell>)
  - [Talents 🌟](https://docs.project-sylvanas.net/docs/<#talents->)
  - `get_talent_name(talent_id)`[](https://docs.project-sylvanas.net/docs/<#get_talent_nametalent_id>)
  - `get_talent_spell_id(talent_id)`[](https://docs.project-sylvanas.net/docs/<#get_talent_spell_idtalent_id>)
