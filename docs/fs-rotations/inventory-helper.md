# Inventory Helper

The **Inventory Helper** module provides a comprehensive set of utility functions that aims to make your life easier when working with items. Below, we'll explore its functionality.

## Including the Module[​](https://docs.project-sylvanas.net/docs/<#including-the-module> "Direct link to Including the Module")

As with all other LUA modules developed by us, you will need to **import** the Inventory Helper module into your project. To do so, you can use the following lines:

```
---@type inventory_helperlocal inventory_helper =require("common/utility/inventory_helper")
```

warning
To access the module's functions, you **must** use `:` instead of `.`
For example, this code is **not correct** :

```
---@type inventory_helperlocal inventory_helper =require("common/utility/pvp_helper")localfunctioncheck_if_player(unit)return inventory_helper.get_bank_slots(unit)end
```

And this would be the **corrected code** :

```
---@type inventory_helperlocal inventory_helper =require("common/utility/pvp_helper")localfunctioncheck_if_player(unit)return inventory_helper:get_bank_slots(unit)end
```

## Functions[​](https://docs.project-sylvanas.net/docs/<#functions> "Direct link to Functions")

### `get_all_slots() -> table<slot_data>`[​](https://docs.project-sylvanas.net/docs/<#get_all_slots---tableslot_data> "Direct link to get_all_slots---tableslot_data")

Retrieves all item slots available to the player, including both character bags and bank slots.

- **Returns** :
  - `slots` (`table<slot_data>`): A table containing slot data for all items.

### `get_character_bag_slots() -> table<slot_data>`[​](https://docs.project-sylvanas.net/docs/<#get_character_bag_slots---tableslot_data> "Direct link to get_character_bag_slots---tableslot_data")

Retrieves all item slots from the character's bags, excluding bank slots.

- **Returns** :
  - `slots` (`table<slot_data>`): A table containing slot data for items in character bags.

### `get_bank_slots() -> table<slot_data>`[​](https://docs.project-sylvanas.net/docs/<#get_bank_slots---tableslot_data> "Direct link to get_bank_slots---tableslot_data")

Retrieves all item slots from the bank.

- **Returns** :
  - `slots` (`table<slot_data>`): A table containing slot data for items in the bank.

### `get_current_consumables_list() -> table<consumable_data>`[​](https://docs.project-sylvanas.net/docs/<#get_current_consumables_list---tableconsumable_data> "Direct link to get_current_consumables_list---tableconsumable_data")

Retrieves a list of consumables currently in the player's inventory.

- **Returns** :
  - `consumables` (`table<consumable_data>`): A table containing data for each consumable item.

### `update_consumables_list()`[​](https://docs.project-sylvanas.net/docs/<#update_consumables_list> "Direct link to update_consumables_list")

Updates the internal list of consumables. Call this function whenever the inventory changes to refresh the consumables list.
**Example** :

```
---@type inventory_helperlocal inventory_helper =require("common/utility/pvp_helper")-- After picking up new consumablesinventory_helper:update_consumables_list()
```

### `debug_print_consumables()`[​](https://docs.project-sylvanas.net/docs/<#debug_print_consumables> "Direct link to debug_print_consumables")

Prints the current consumables list to the debug log for debugging purposes.

## Data Structures[​](https://docs.project-sylvanas.net/docs/<#data-structures> "Direct link to Data Structures")

### Slot Data Structure 🎒[​](https://docs.project-sylvanas.net/docs/<#slot-data-structure-> "Direct link to slot-data-structure-")

The `slot_data` class represents an item slot in the inventory or bank.

#### Fields:[​](https://docs.project-sylvanas.net/docs/<#fields> "Direct link to Fields:")

- `item` (`game_object`): The item object in this slot.
- `global_slot` (`number`): Global slot identifier.
- `bag_id` (`integer`): ID of the bag containing the item.
- `bag_slot` (`integer`): Slot number within the bag.
- `stack_count` (`integer`): Stack count of the item in this slot.

**Example** :

```
local slot = all_slots[1]core.log("Item: ".. slot.item:get_name())core.log("Stack Count: "..tostring(slot.stack_count))
```

### Consumable Data Structure 🧪[​](https://docs.project-sylvanas.net/docs/<#consumable-data-structure-> "Direct link to consumable-data-structure-")

The `consumable_data` class represents a consumable item in the inventory.

#### Fields:[​](https://docs.project-sylvanas.net/docs/<#fields-1> "Direct link to Fields:")

- `is_mana_potion` (`boolean`): Whether the item is a mana potion.
- `is_health_potion` (`boolean`): Whether the item is a health potion.
- `is_damage_bonus_potion` (`boolean`): Whether the item is a damage bonus potion.
- `item` (`game_object`): The item object for the consumable.
- `bag_id` (`integer`): ID of the bag containing the item.
- `bag_slot` (`integer`): Slot number within the bag.
- `stack_count` (`integer`): Stack count of the item in this slot.

## Examples[​](https://docs.project-sylvanas.net/docs/<#examples> "Direct link to Examples")

### Iterating Over All Inventory Slots[​](https://docs.project-sylvanas.net/docs/<#iterating-over-all-inventory-slots> "Direct link to Iterating Over All Inventory Slots")

```
---@type inventory_helperlocal inventory =require("common/utility/inventory_helper")localfunctionprint_all_items()local all_slots = inventory:get_all_slots()for _, slot inipairs(all_slots)do    core.log("Item: ".. slot.item:get_name().." in slot: "..tostring(slot.global_slot))endendprint_all_items()
```

[[dungeons-helper]]

- [Overview](https://docs.project-sylvanas.net/docs/<#overview>)
- [Including the Module](https://docs.project-sylvanas.net/docs/<#including-the-module>)
- [Functions](https://docs.project-sylvanas.net/docs/<#functions>)
  - `get_all_slots() -> table<slot_data>`[](https://docs.project-sylvanas.net/docs/<#get_all_slots---tableslot_data>)
  - `get_character_bag_slots() -> table<slot_data>`[](https://docs.project-sylvanas.net/docs/<#get_character_bag_slots---tableslot_data>)
  - `get_bank_slots() -> table<slot_data>`[](https://docs.project-sylvanas.net/docs/<#get_bank_slots---tableslot_data>)
  - `get_current_consumables_list() -> table<consumable_data>`[](https://docs.project-sylvanas.net/docs/<#get_current_consumables_list---tableconsumable_data>)
  - `update_consumables_list()`[](https://docs.project-sylvanas.net/docs/<#update_consumables_list>)
  - `debug_print_consumables()`[](https://docs.project-sylvanas.net/docs/<#debug_print_consumables>)
- [Data Structures](https://docs.project-sylvanas.net/docs/<#data-structures>)
  - [Slot Data Structure 🎒](https://docs.project-sylvanas.net/docs/<#slot-data-structure->)
  - [Consumable Data Structure 🧪](https://docs.project-sylvanas.net/docs/<#consumable-data-structure->)
- [Examples](https://docs.project-sylvanas.net/docs/<#examples>)
  - [Iterating Over All Inventory Slots](https://docs.project-sylvanas.net/docs/<#iterating-over-all-inventory-slots>)
