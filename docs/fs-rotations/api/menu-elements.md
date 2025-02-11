# Menu Elements

This module is one of the most important ones, since it is the one that will allow you to add customization options to your plugins. You could always design your own menu for your scripts using our [Custom UI](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/custom-ui-guide>), in a way that makes your plugins very unique and different from the rest. However, **this would add a level of complexity that might not be necessary** in most cases. So, for most devs, we offer the option to add your own menu to the main menu directly. (You can still use the menu elements in your custom menu, if desired, as stated in the [Custom UI](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/custom-ui-guide>) guide).

## Menu Elements Basics

There are a two things that you have to keep in mind when working with menu elements. The first one is that you can only render them in 2 specific callbacks. The other information that you should know is menu elements are, and therefore, must be treated as, objects. This implies that you must not declare the menu elements inside the render callback, since you would be generating a new different menu element with each iteration. This will cause issues, specially if done with tree nodes.
tip
There is one exception to the previous rule, and that is, headers. You can render a header (a plain text in the menu) as follows:

```
  core.menu.header():render("Header Test", color.green(200))
```

And it would be valid, since headers are a very light-weight object and don't need of an unique ID, unlike the other menu elements.
An example of an invalid code:

```
-- The state of the checkbox is not saved into the variable "bad_code_example", since core.menu.checkbox doesn't return a boolean, but rather the checkbox object.-- A new checkbox is being generated every frame, generating performance issues.core.register_on_render_menu_callback(function()local bad_code_example = core.menu.checkbox(true,"testing_1"):render("AA")end)
```

An example of code following best practices:

```
-- first, we generate a table containing all the menu elements that we are going to use OUTSIDE the callback---@type colorlocal color =require("common/color")local menu_elements ={  my_test_node = core.menu.tree_node(),  my_checkbox_1 = core.menu.checkbox(true,"my_checkbox_test"),  my_test_keybind = core.menu.keybind(7,false,"my_test_keybind")}core.register_on_render_menu_callback(function()  menu_elements.my_test_node:render("Hi From Lua - Testing Menu Elements!",function()    menu_elements.my_checkbox_1:render("Testing The Checkbox!","This is a tooltip!")    core.menu.header():render("Testing The Headers!", color.green(200))    menu_elements.my_test_keybind:render("Testing The Keybind!")end)end)
```

This is the result of the previous code:
![](https://downloads.project-sylvanas.net/1727206014677-menu_test1.png)

### Register Menu Callback[​](https://docs.project-sylvanas.net/docs/<#register-menu-callback> "Direct link to Register Menu Callback")

warning
Menu elements can only be rendered inside the register_on_render_menu_callback OR register_on_render_window_callback callbacks. The first one is reserved for menu elements that will be rendered within the main menu, and the second one for menu elements that will be rendered within one of your custom-made windows. See [Custom UI Guide](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/custom-ui-guide>)
`core.menu.register_on_render_menu_callback(callback: function)`

- This function registers the menu for interaction. Same like with other callbacks, you can also pass an anonymous function. This is how you would call the callback:

```
core.menu.register_on_render_menu_callback(function()-- your pre-defined menu elements render function code hereend)
```

Or:

```
localfunctionmy_render_menu_function()-- your pre-defined menu elements render function code hereendcore.menu.register_on_render_menu_callback(my_render_menu_function)
```

## Available Menu Elements[​](https://docs.project-sylvanas.net/docs/<#available-menu-elements> "Direct link to available-menu-elements")

## Tree Node 🌳[​](https://docs.project-sylvanas.net/docs/<#tree-node-> "Direct link to Tree Node 🌳")

### Constructor[​](https://docs.project-sylvanas.net/docs/<#constructor> "Direct link to Constructor")

### `tree_node()`[​](https://docs.project-sylvanas.net/docs/<#tree_node> "Direct link to tree_node")

Creates a new tree node instance.
Returns: _tree_node_ — A new `tree_node` object.

### `render(header, callback)`[​](https://docs.project-sylvanas.net/docs/<#renderheader-callback> "Direct link to renderheader-callback")

Renders the tree node with content.
Parameters:

- **`header`**(_string_) — The header text of the tree node.
- **`callback`**(_function_) — The content to render inside the node.

#### Example[​](https://docs.project-sylvanas.net/docs/<#example> "Direct link to Example")

```
-- Anonymous function approachmain_node:render("Debug Plugin",function()-- content inside the nodeend)-- Alternativelocalfunctiondebug_plugin_node()-- content inside the node-- note: declare outside menu callbackend-- Inside menu callbackmain_node:render("Debug Plugin", debug_plugin_node)
```

### `is_open()`[​](https://docs.project-sylvanas.net/docs/<#is_open> "Direct link to is_open")

Checks if the tree node is open.
Returns: _boolean_ — `true` if the tree node is open; otherwise, `false`.

## Checkbox ☑️[​](https://docs.project-sylvanas.net/docs/<#checkbox-️> "Direct link to Checkbox ☑️")

### Constructor[​](https://docs.project-sylvanas.net/docs/<#constructor-1> "Direct link to Constructor")

### `checkbox(default_state, id)`[​](https://docs.project-sylvanas.net/docs/<#checkboxdefault_state-id> "Direct link to checkboxdefault_state-id")

Creates a new checkbox instance.
Parameters:

- **`default_state`**(_boolean_) — The default state of the checkbox.
- **`id`**(_string_) — The unique identifier for the checkbox.

Returns: _checkbox_ — A new `checkbox` object.

### `render(label, tooltip(optional))`[​](https://docs.project-sylvanas.net/docs/<#renderlabel-tooltipoptional> "Direct link to renderlabel-tooltipoptional")

Renders the checkbox with the specified label and optional tooltip.
Parameters:

- **`label`**(_string_) — The label text of the checkbox.
- **`tooltip`**(_string_ , optional) — The tooltip text for the checkbox.

tip
Checkbox `render` supports `\n` to write multiple lines.

### `get_state()`[​](https://docs.project-sylvanas.net/docs/<#get_state> "Direct link to get_state")

Retrieves the current state of the checkbox.
Returns: _boolean_ — `true` if checked; otherwise, `false`.

### `set(new_state)`[​](https://docs.project-sylvanas.net/docs/<#setnew_state> "Direct link to setnew_state")

Sets a new state for the checkbox.
Parameters:

- **`new_state`**(_boolean_) — The new state to set.

Returns: _nil_

## Slider Int 🎚️[​](https://docs.project-sylvanas.net/docs/<#slider-int-️> "Direct link to Slider Int 🎚️")

### Constructor[​](https://docs.project-sylvanas.net/docs/<#constructor-2> "Direct link to Constructor")

### `slider_int(min_value, max_value, default_value, id)`[​](https://docs.project-sylvanas.net/docs/<#slider_intmin_value-max_value-default_value-id> "Direct link to slider_intmin_value-max_value-default_value-id")

Creates a new slider with integer values.
Parameters:

- **`min_value`**(_number_) — The minimum value of the slider.
- **`max_value`**(_number_) — The maximum value of the slider.
- **`default_value`**(_number_) — The default value of the slider.
- **`id`**(_string_) — The unique identifier for the slider.

Returns: _slider_int_ — A new `slider_int` object.

### `render(label, tooltip(optional))`[​](https://docs.project-sylvanas.net/docs/<#renderlabel-tooltipoptional-1> "Direct link to renderlabel-tooltipoptional-1")

Renders the slider with the specified label and optional tooltip.
Parameters:

- **`label`**(_string_) — The label text of the slider.
- **`tooltip`**(_string_ , optional) — The tooltip text for the slider.

tip
Slider `render` supports `\n` to write multiple lines.

### `get()`[​](https://docs.project-sylvanas.net/docs/<#get> "Direct link to get")

Retrieves the current value of the slider.
Returns: _number_ — The current value.

### `set(new_value)`[​](https://docs.project-sylvanas.net/docs/<#setnew_value> "Direct link to setnew_value")

Sets a new value for the slider.
Parameters:

- **`new_value`**(_number_) — The new value to set.

Returns: _nil_

## Slider Float 🎛️[​](https://docs.project-sylvanas.net/docs/<#slider-float-️> "Direct link to Slider Float 🎛️")

### Constructor[​](https://docs.project-sylvanas.net/docs/<#constructor-3> "Direct link to Constructor")

### `slider_float(min_value, max_value, default_value, id)`[​](https://docs.project-sylvanas.net/docs/<#slider_floatmin_value-max_value-default_value-id> "Direct link to slider_floatmin_value-max_value-default_value-id")

Creates a new slider with floating-point values.
Parameters:

- **`min_value`**(_number_) — The minimum value of the slider.
- **`max_value`**(_number_) — The maximum value of the slider.
- **`default_value`**(_number_) — The default value of the slider.
- **`id`**(_string_) — The unique identifier for the slider.

Returns: _slider_float_ — A new `slider_float` object.

### `render(label, tooltip (optional))`[​](https://docs.project-sylvanas.net/docs/<#renderlabel-tooltip-optional> "Direct link to renderlabel-tooltip-optional")

Renders the slider with the specified label and optional tooltip.
Parameters:

- **`label`**(_string_) — The label text of the slider.
- **`tooltip`**(_string_ , optional) — The tooltip text for the slider.

tip
Slider `render` supports `\n` to write multiple lines.

### `get()`[​](https://docs.project-sylvanas.net/docs/<#get-1> "Direct link to get-1")

Retrieves the current value of the slider.
Returns: _number_ — The current value.

### `set(new_value)`[​](https://docs.project-sylvanas.net/docs/<#setnew_value-1> "Direct link to setnew_value-1")

Sets a new value for the slider.
Parameters:

- **`new_value`**(_number_) — The new value to set.

Returns: _nil_

## Combobox 🔽[​](https://docs.project-sylvanas.net/docs/<#combobox-> "Direct link to Combobox 🔽")

### Constructor[​](https://docs.project-sylvanas.net/docs/<#constructor-4> "Direct link to Constructor")

### `combobox(default_index, id)`[​](https://docs.project-sylvanas.net/docs/<#comboboxdefault_index-id> "Direct link to comboboxdefault_index-id")

Creates a new combobox.
Parameters:

- **`default_index`**(_number_) — The default index of the combobox options (1-based).
- **`id`**(_string_) — The unique identifier for the combobox.

Returns: _combobox_ — A new `combobox` object.

### `render(label, options, tooltip (optional))`[​](https://docs.project-sylvanas.net/docs/<#renderlabel-options-tooltip-optional> "Direct link to renderlabel-options-tooltip-optional")

Renders the combobox with the specified label, options, and optional tooltip.
Parameters:

- **`label`**(_string_) — The label text of the combobox.
- **`options`**(_table_) — A table of strings containing the options for the combobox.
- **`tooltip`**(_string_ , optional) — The tooltip text for the combobox.

tip
Combobox `render` supports `\n` to write multiple lines.

### `get()`[​](https://docs.project-sylvanas.net/docs/<#get-2> "Direct link to get-2")

Retrieves the index of the currently selected option (1-based).
Returns: _number_ — The index of the selected option.

### `set(new_value)`[​](https://docs.project-sylvanas.net/docs/<#setnew_value-2> "Direct link to setnew_value-2")

Sets a new selected index for the combobox.
Parameters:

- **`new_value`**(_number_) — The new index to select.

Returns: _nil_
tip
You could use a combo box to let the user decide script behaviours in a more graphical way. Below, an example using 3 possible modes:

```
local combat_mode_enum ={  AUTO  =1,  AOE   =2,  SINGLE =3,}local combat_mode_options ={"Auto","AoE","Single"}local main_tree = core.menu.tree_node()local combat_mode = core.menu.combobox(combat_mode_enum.AUTO,"combat_mode_auto_aoe_single")core.register_on_render_menu_callback(function()  main_tree:render("Combo - Test",function()    combat_mode:render("Testing Combo Boxes - Combat Modes", combat_mode_options)end)end)core.register_on_update_callback(function()local current_combat_mode = combat_mode:get()local current_combat_mode_str = combat_mode_options[current_combat_mode]local is_current_combat_mode_auto = current_combat_mode == combat_mode_enum.AUTOlocal is_current_combat_mode_aoe = current_combat_mode == combat_mode_enum.AOElocal is_current_combat_mode_single = current_combat_mode == combat_mode_enum.SINGLE  core.log("Current Combat Mode Is: ".. current_combat_mode_str)  core.log("Is Current Combat Mode Auto: "..tostring(is_current_combat_mode_auto))  core.log("Is Current Combat Mode AOE: "..tostring(is_current_combat_mode_aoe))  core.log("Is Current Combat Mode Single: "..tostring(is_current_combat_mode_single))end)
```

This should be the result of running that code:
![](https://downloads.project-sylvanas.net/1727699662195-combobox_test.png)

## Keybind ⌨️[​](https://docs.project-sylvanas.net/docs/<#keybind-️> "Direct link to Keybind ⌨️")

### Constructor[​](https://docs.project-sylvanas.net/docs/<#constructor-5> "Direct link to Constructor")

### `keybind(default_value, initial_toggle_state, id)`[​](https://docs.project-sylvanas.net/docs/<#keybinddefault_value-initial_toggle_state-id> "Direct link to keybinddefault_value-initial_toggle_state-id")

Creates a new keybind.
Parameters:

- **`default_value`**(_number_) — The default key code for the keybind.
- **`initial_toggle_state`**(_boolean_) — The initial toggle state.
- **`id`**(_string_) — The unique identifier for the keybind.

Returns: _keybind_ — A new `keybind` object.

### `render(label, tooltip (optional), add_separator(optional))`[​](https://docs.project-sylvanas.net/docs/<#renderlabel-tooltip-optional-add_separatoroptional> "Direct link to renderlabel-tooltip-optional-add_separatoroptional")

Renders the keybind with the specified label and optional tooltip.
Parameters:

- **`label`**(_string_) — The label text of the keybind.
- **`tooltip`**(_string_ , optional) — The tooltip text for the keybind.
- **`add_separator`**(_boolean_ , optional) — A flag to add a separator below the keybind. True by default.

### `get_state()`[​](https://docs.project-sylvanas.net/docs/<#get_state-1> "Direct link to get_state-1")

Retrieves the state of the keybind.
Returns: _boolean_ — The state of the keybind.

### `get_toggle_state()`[​](https://docs.project-sylvanas.net/docs/<#get_toggle_state> "Direct link to get_toggle_state")

Retrieves the toggle state of the keybind.
Returns: _boolean_ — The toggle state.

### `get_key_code()`[​](https://docs.project-sylvanas.net/docs/<#get_key_code> "Direct link to get_key_code")

Retrieves the key code assigned to the keybind.
Returns: _integer_ — The key code.

### `set_toggle_state(new_state)`[​](https://docs.project-sylvanas.net/docs/<#set_toggle_statenew_state> "Direct link to set_toggle_statenew_state")

Sets a new toggle state for the keybind.
Parameters:

- **`new_state`**(_boolean_) — The new toggle state.

Returns: _nil_

### `set_key_code(new_key_code)`[​](https://docs.project-sylvanas.net/docs/<#set_key_codenew_key_code> "Direct link to set_key_codenew_key_code")

Sets a new key code for the keybind.
Parameters:

- **`new_key_code`**(_integer_) — The new key code.

Returns: _nil_

## Button 🖱️[​](https://docs.project-sylvanas.net/docs/<#button-️> "Direct link to Button 🖱️")

### Constructor[​](https://docs.project-sylvanas.net/docs/<#constructor-6> "Direct link to Constructor")

### `button()`[​](https://docs.project-sylvanas.net/docs/<#button> "Direct link to button")

Creates a new button.
Returns: _button_ — A new `button` object.

### `render(label, tooltip (optional))`[​](https://docs.project-sylvanas.net/docs/<#renderlabel-tooltip-optional-1> "Direct link to renderlabel-tooltip-optional-1")

Renders the button with the specified label and optional tooltip.
Parameters:

- **`label`**(_string_) — The label text of the button.
- **`tooltip`**(_string_ , optional) — The tooltip text for the button.

Returns: _boolean_ — `true` if the button was clicked; otherwise, `false`.

## Color Picker 🎨[​](https://docs.project-sylvanas.net/docs/<#color-picker-> "Direct link to Color Picker 🎨")

### Constructor[​](https://docs.project-sylvanas.net/docs/<#constructor-7> "Direct link to Constructor")

### `color_picker(default_color, id)`[​](https://docs.project-sylvanas.net/docs/<#color_pickerdefault_color-id> "Direct link to color_pickerdefault_color-id")

Creates a new color picker.
Parameters:

- **`default_color`**(_number_) — The default color value.
- **`id`**(_string_) — The unique identifier for the color picker.

Returns: _color_picker_ — A new `color_picker` object.

### `render(label, tooltip (optional))`[​](https://docs.project-sylvanas.net/docs/<#renderlabel-tooltip-optional-2> "Direct link to renderlabel-tooltip-optional-2")

Renders the color picker with the specified label and optional tooltip.
Parameters:

- **`label`**(_string_) — The label text of the color picker.
- **`tooltip`**(_string_ , optional) — The tooltip text for the color picker.

### `get()`[​](https://docs.project-sylvanas.net/docs/<#get-3> "Direct link to get-3")

Retrieves the selected color value.
Returns: _number_ — The selected color value.

## Key Checkbox 🖱️[​](https://docs.project-sylvanas.net/docs/<#key-checkbox-️> "Direct link to Key Checkbox 🖱️")

note
This is a special menu element that allows the user full customization over a keybind . Using this menu element might be overkill in most cases, but there are circumstances where you would want to add full costumization to a certain keybind, so all kinds of users are happy with the customization options. This is what it would look like:
![](https://downloads.project-sylvanas.net/1730289461618-key_checkbox.png)
Explanation of the menu element: 1 -> First, we have a checkbox. If this checkbox is disabled, the logic should be disabled completely. 2 -> Secondly, we have a keyboard icon. Upon pressing this icon, a new popup will appear. 3 -> > This popup contains 3 elements: 3.1 -> Mode: This is the behaviour that the keybind has. 3.1.1 -> Available modes: 3.1.1.1 -- (0) Hold 3.1.1.2 -- (1) Toggle 3.1.1.3 -- (2) Always 3.1.2 -> Modes explanation: 3.1.2.1 -- Hold means that the keybind state will only return true when the user is pressing it. False otherwise. 3.1.2.2 -- Toggle means that the keybind wil behave as a toggle. 3.1.2.3 -- Always means that the keybind will always return true (acts as a checkbox, essentially)

### Constructor[​](https://docs.project-sylvanas.net/docs/<#constructor-8> "Direct link to Constructor")

### `key_checkbox(default_key, initial_toggle_state, default_state, show_in_binds, default_mode_state, id)`[​](https://docs.project-sylvanas.net/docs/<#key_checkboxdefault_key-initial_toggle_state-default_state-show_in_binds--default_mode_state-id> "Direct link to key_checkboxdefault_key-initial_toggle_state-default_state-show_in_binds--default_mode_state-id")

```
--- Creates a new checkbox instance.---@param default_key integer The default state of the checkbox.---@param initial_toggle_state boolean The initial toggle state of the keybind---@param default_state boolean The default state of the checkbox---@param show_in_binds boolean The default show in binds state of the checkbox---@param default_mode_state integer The default show in binds state of the checkbox -> 0 is hold, 1 is toggle, 2 is always---@param id string The unique identifier for the checkbox.---@return key_checkbox
```

### `render(label, tooltip (optional))`[​](https://docs.project-sylvanas.net/docs/<#renderlabel-tooltip-optional-3> "Direct link to renderlabel-tooltip-optional-3")

Renders the key checkbox with the specified label and optional tooltip.
Parameters:

- **`label`**(_string_) — The label text of the button.
- **`tooltip`**(_string_ , optional) — The tooltip text for the button.

Returns: _boolean_ — `true` if the button was clicked; otherwise, `false`.

## Code Examples 🧰[​](https://docs.project-sylvanas.net/docs/<#code-examples-> "Direct link to Code Examples 🧰")

```
-- Define a unique developer ID to prevent ID collisions with other pluginslocal dev_id ="unique_developer_id_here"-- Create a table to store all menu elementslocal menu_elements ={}-- Create the main node for the menumenu_elements.main_node = core.menu.tree_node()-- Create checkboxes with unique IDsmenu_elements.checkbox_one = core.menu.checkbox(true, dev_id .."checkbox_example_one")menu_elements.checkbox_two = core.menu.checkbox(false, dev_id .."checkbox_example_two")-- Create slider int and float with unique IDsmenu_elements.slider_int = core.menu.slider_int(0,100,50, dev_id .."slider_int")menu_elements.slider_float = core.menu.slider_float(0,100,50, dev_id .."slider_float")-- Create the sub menu node inside the main nodemenu_elements.sub_menu_node = core.menu.tree_node()-- Create combobox, keybind, button, and color picker with unique IDsmenu_elements.combobox = core.menu.combobox(1, dev_id .."combobox")menu_elements.keybind = core.menu.keybind(46,false, dev_id .."keybind")menu_elements.button = core.menu.button()menu_elements.colorpicker = core.menu.color_picker(-65536, dev_id .."colorpicker")-- Register the menu rendering callbackcore.menu.register_on_render_menu_callback(function()-- Render the main node  menu_elements.main_node:render("Menu Example",function()-- Render checkboxes    menu_elements.checkbox_one:render("Checkbox Example One","")    menu_elements.checkbox_two:render("Checkbox Example Two","")-- Render slider int and float    menu_elements.slider_int:render("Slider Int","")    menu_elements.slider_float:render("Slider Float","")-- Render the sub menu node    menu_elements.sub_menu_node:render("More Elements",function()-- Render combobox      menu_elements.combobox:render("ComboBox",{"Option A","Option B","Option C"},"")-- Render keybind      menu_elements.keybind:render("Keybind","")-- Render buttonif menu_elements.button:render("Button","")then        core.log("Button was clicked!")end-- Render color picker      menu_elements.colorpicker:render("ColorPicker","")end)end)end)
```

## Notes 📝[​](https://docs.project-sylvanas.net/docs/<#notes-> "Direct link to Notes 📝")

- Always declare your menu elements **outside** of the render callback to prevent creating new instances each frame.
- Use unique IDs for your menu elements to avoid conflicts with other menu elements within your plugin.
- Menu elements can only be rendered inside the `register_on_render_menu_callback` or `register_on_render_window_callback` callbacks.

[[input]]

- [Overview 📃](https://docs.project-sylvanas.net/docs/<#overview->)
- [Register Menu Callback](https://docs.project-sylvanas.net/docs/<#register-menu-callback>)
- [Available Menu Elements](https://docs.project-sylvanas.net/docs/<#available-menu-elements>)
- [Tree Node 🌳](https://docs.project-sylvanas.net/docs/<#tree-node->)
  - [Constructor](https://docs.project-sylvanas.net/docs/<#constructor>)
  - `tree_node()`[](https://docs.project-sylvanas.net/docs/<#tree_node>)
  - `render(header, callback)`[](https://docs.project-sylvanas.net/docs/<#renderheader-callback>)
  - `is_open()`[](https://docs.project-sylvanas.net/docs/<#is_open>)
- [Checkbox ☑️](https://docs.project-sylvanas.net/docs/<#checkbox-️>)
  - [Constructor](https://docs.project-sylvanas.net/docs/<#constructor-1>)
  - `checkbox(default_state, id)`[](https://docs.project-sylvanas.net/docs/<#checkboxdefault_state-id>)
  - `render(label, tooltip(optional))`[](https://docs.project-sylvanas.net/docs/<#renderlabel-tooltipoptional>)
  - `get_state()`[](https://docs.project-sylvanas.net/docs/<#get_state>)
  - `set(new_state)`[](https://docs.project-sylvanas.net/docs/<#setnew_state>)
- [Slider Int 🎚️](https://docs.project-sylvanas.net/docs/<#slider-int-️>)
  - [Constructor](https://docs.project-sylvanas.net/docs/<#constructor-2>)
  - `slider_int(min_value, max_value, default_value, id)`[](https://docs.project-sylvanas.net/docs/<#slider_intmin_value-max_value-default_value-id>)
  - `render(label, tooltip(optional))`[](https://docs.project-sylvanas.net/docs/<#renderlabel-tooltipoptional-1>)
  - `get()`[](https://docs.project-sylvanas.net/docs/<#get>)
  - `set(new_value)`[](https://docs.project-sylvanas.net/docs/<#setnew_value>)
- [Slider Float 🎛️](https://docs.project-sylvanas.net/docs/<#slider-float-️>)
  - [Constructor](https://docs.project-sylvanas.net/docs/<#constructor-3>)
  - `slider_float(min_value, max_value, default_value, id)`[](https://docs.project-sylvanas.net/docs/<#slider_floatmin_value-max_value-default_value-id>)
  - `render(label, tooltip (optional))`[](https://docs.project-sylvanas.net/docs/<#renderlabel-tooltip-optional>)
  - `get()`[](https://docs.project-sylvanas.net/docs/<#get-1>)
  - `set(new_value)`[](https://docs.project-sylvanas.net/docs/<#setnew_value-1>)
- [Combobox 🔽](https://docs.project-sylvanas.net/docs/<#combobox->)
  - [Constructor](https://docs.project-sylvanas.net/docs/<#constructor-4>)
  - `combobox(default_index, id)`[](https://docs.project-sylvanas.net/docs/<#comboboxdefault_index-id>)
  - `render(label, options, tooltip (optional))`[](https://docs.project-sylvanas.net/docs/<#renderlabel-options-tooltip-optional>)
  - `get()`[](https://docs.project-sylvanas.net/docs/<#get-2>)
  - `set(new_value)`[](https://docs.project-sylvanas.net/docs/<#setnew_value-2>)
- [Keybind ⌨️](https://docs.project-sylvanas.net/docs/<#keybind-️>)
  - [Constructor](https://docs.project-sylvanas.net/docs/<#constructor-5>)
  - `keybind(default_value, initial_toggle_state, id)`[](https://docs.project-sylvanas.net/docs/<#keybinddefault_value-initial_toggle_state-id>)
  - `render(label, tooltip (optional), add_separator(optional))`[](https://docs.project-sylvanas.net/docs/<#renderlabel-tooltip-optional-add_separatoroptional>)
  - `get_state()`[](https://docs.project-sylvanas.net/docs/<#get_state-1>)
  - `get_toggle_state()`[](https://docs.project-sylvanas.net/docs/<#get_toggle_state>)
  - `get_key_code()`[](https://docs.project-sylvanas.net/docs/<#get_key_code>)
  - `set_toggle_state(new_state)`[](https://docs.project-sylvanas.net/docs/<#set_toggle_statenew_state>)
  - `set_key_code(new_key_code)`[](https://docs.project-sylvanas.net/docs/<#set_key_codenew_key_code>)
- [Button 🖱️](https://docs.project-sylvanas.net/docs/<#button-️>)
  - [Constructor](https://docs.project-sylvanas.net/docs/<#constructor-6>)
  - `button()`[](https://docs.project-sylvanas.net/docs/<#button>)
  - `render(label, tooltip (optional))`[](https://docs.project-sylvanas.net/docs/<#renderlabel-tooltip-optional-1>)
- [Color Picker 🎨](https://docs.project-sylvanas.net/docs/<#color-picker->)
  - [Constructor](https://docs.project-sylvanas.net/docs/<#constructor-7>)
  - `color_picker(default_color, id)`[](https://docs.project-sylvanas.net/docs/<#color_pickerdefault_color-id>)
  - `render(label, tooltip (optional))`[](https://docs.project-sylvanas.net/docs/<#renderlabel-tooltip-optional-2>)
  - `get()`[](https://docs.project-sylvanas.net/docs/<#get-3>)
- [Key Checkbox 🖱️](https://docs.project-sylvanas.net/docs/<#key-checkbox-️>)
  - [Constructor](https://docs.project-sylvanas.net/docs/<#constructor-8>)
  - `key_checkbox(default_key, initial_toggle_state, default_state, show_in_binds, default_mode_state, id)`[](https://docs.project-sylvanas.net/docs/<#key_checkboxdefault_key-initial_toggle_state-default_state-show_in_binds--default_mode_state-id>)
  - `render(label, tooltip (optional))`[](https://docs.project-sylvanas.net/docs/<#renderlabel-tooltip-optional-3>)
- [Code Examples 🧰](https://docs.project-sylvanas.net/docs/<#code-examples->)
- [Notes 📝](https://docs.project-sylvanas.net/docs/<#notes->)
