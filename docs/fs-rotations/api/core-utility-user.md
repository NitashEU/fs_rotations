# Core Utility

The **Core Utility** module in Sylvanas serves as a centralized hub for handling **item usage, racial spells, and custom events**. This module may seem a bit complex due to the variety of functions it handles, but it is designed to provide flexible and automated solutions for managing **offensive** , **defensive** , and **utility** items and spells during combat. In summary, this module provides a wide range of automated solutions to enhance your gameplay experience, from handling item usage to managing specific PvP and PvE events. It is highly customizable, allowing you to fine-tune your settings based on your preferred playstyle or content needs.
To access this plugin's menu, follow this path: **Main Menu - > Core Utility**
note
We always **welcome feedback** to ensure this module stays up-to-date and continues to evolve alongside the game.

## 1 - Items[​](https://docs.project-sylvanas.net/docs/<#1---items> "Direct link to 1---items")

### Trinkets[​](https://docs.project-sylvanas.net/docs/<#trinkets> "Direct link to Trinkets")

The **Trinkets** module is designed to support all trinkets in the game. You just have to craft the correct settings for the type of trinket that you are going to use, and that's it.
note
To navigate to the Trinkets sub menu, go to Core Utility -> Items -> Trinkets
![](https://downloads.project-sylvanas.net/1731435379939-trinkets1.png)

#### Crafting the settings[​](https://docs.project-sylvanas.net/docs/<#crafting-the-settings> "Direct link to crafting-the-settings")

We need to craft the way the script will cast our trinkets. Since this tool is supposed to support all trinkets in the game, you will have to do a little bit of manual configuration. But don't worry, as you just need to do this once (until you get a new trinket).

- First, we have to set the "Item Slot" dropdown. Use "Top" to enable the cast just for the top trinket, "Bot" for the bottom one or "Both" to enable the functionality for both of your trinkets.
- After setting the previous slider, more options will appear: ![](https://downloads.project-sylvanas.net/1731435691119-trinkets_2.png)
- Global cooldown: Set to "Skips Global (Common)" if the trinket skips GCD, "Has Global" otherwise.
- Logic type: Offensive o defensive.
- Cast type: Self, target or skillshot.

note
If cast type is set to skillshot, two new sub-menus will appear: ![](https://downloads.project-sylvanas.net/1731436616805-trinket_pred.png)

- For prediction settings:
-     * Prediction type:  -> most hits will cast the spell where it would hit more enemies. Accuracy will cast the spell in the most difficult position for the target to scape from the skillshot.
-     * Prediction mode:
-     *       * No prediction will cast the spell at the enemy position directly
-     *       * Center will cast the spell at the enemy's center
-     *       * Intersection will cast the spell behind the target, making it impossible for it to evade the spell by moving backwards.
-     *       * Custom mode will spawn a new slider, "Interception percentage". This is how behind the target the spell will be casted. Modify with caution.
-     * For Spell Data Settings:  Most of the options are self-explanatory. The time to hit override slider is used in cases where the spell will always hit the target after X seconds, no matter what.

- Finally, just select the preset for the trinket.

### Offensive, Defensive and Utility[​](https://docs.project-sylvanas.net/docs/<#offensive-defensive-and-utility> "Direct link to Offensive, Defensive and Utility")

This part of the module is in charge of casting defensive and offensive items, such as healthstone or elixirs. More elements will be supported in the future, according to feedback and game updates.
note
To navigate to the Offensive, Defensive and Utility sub menus, go to Core Utility -> Items
![](https://downloads.project-sylvanas.net/1731446766985-ofensive.png)
All of the following elements have the same menu structure, discussed below:
![](https://downloads.project-sylvanas.net/1731446977033-menuelementsofensive.png)

- Forecast Mode: This is useful to prevent the script from casting the spell / item if the expected combat length is less than what's specified in the dropdown.
- Health threshold: This slider is used to prevent the script from casting the spell / item if your health percentage is lower than the value specified in the slider.
- Distance filter: This slider is used to prevent the script from casting the spell / item if the target enemy's distance is superior than the value specified in the slider.
- Combat length filter: This slider is used to prevent the script from casting the spell / item if the time in combat is inferior to the value specified in the slider.

## 2 - Racial Spells[​](https://docs.project-sylvanas.net/docs/<#2---racial-spells> "Direct link to 2---racial-spells")

In addition to items, the **Core Utility** module manages the use of **racial spells** , such as:

- **Blood Fury** (Orc racial)
- **Arcane Torrent** (Blood Elf racial)
- **Berserking** (Troll racial)

These spells can be triggered at optimal times during combat. We are always accepting feedback to improve the current spells or to add any missing racial abilities so we can improve functionality further.
note
These spells are under the "Spells" sub-menu. To navigate there, use the following path: **Main Menu - > Core Utility -> Spells**
note
Visit [items](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/core-utility-user>) for a more in-depth guide and new features about the "Items" section.

## 3 - Custom Events[​](https://docs.project-sylvanas.net/docs/<#3---custom-events> "Direct link to 3---custom-events")

The **Core Utility** module also supports a variety of **custom events** that automate specific actions. These events include **Dispel** , **Defensive** , **Reflect** and **Mythic Affix** handling.

### Dispel[​](https://docs.project-sylvanas.net/docs/<#dispel> "Direct link to dispel")

The **Dispel** feature works similarly to [Core Interrupt](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/core-interrupt-user>), but it focuses on automatically removing debuffs from yourself or allies. It supports all dispels across all classes and works in both **PvP** and **PvE** environments.
However, it is common for some debuffs or solutions to be missing, so we encourage users to provide feedback if they encounter issues with missing dispels or incorrectly handled debuffs.

### Reflect[​](https://docs.project-sylvanas.net/docs/<#reflect> "Direct link to reflect")

The **Reflect** function is designed to handle **spell reflection** , similar to interrupts and dispels. It currently supports:

- **Warrior's Spell Reflection**
- **Spell Block**

This feature is scalable, allowing us to add future mechanics or items with reflection properties (such as potential new spells from future expansions or WoW versions like **Season of Discovery**). We welcome feedback to ensure it continues to evolve.

### Defensive[​](https://docs.project-sylvanas.net/docs/<#defensive> "Direct link to defensive")

The **Defensive** plugin works in conjunction with [Health Prediction](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/health-prediction-user>) to more accurately trigger defensive abilities. It analyzes incoming damage for both **PvP** and **PvE** , ensuring defensives are used proactively based on predicted damage rather than waiting until health drops to a dangerous level.
This plugin helps to optimize defensive cooldowns, making it a critical component for surviving high-stakes encounters.

### Mythic Affix[​](https://docs.project-sylvanas.net/docs/<#mythic-affix> "Direct link to mythic-affix")

The **Mythic Affix** feature is designed to handle events triggered by **Mythic+ affixes** , such as:

- **Incorporeal Being**
- **Afflicted Soul**

The **Core Utility** module will automatically apply the appropriate **dispel** or **crowd control (CC)** to manage these affixes. It is flexible enough to scale with new affixes introduced in future seasons or expansions, depending on user feedback and requests.
note
These custom events options are under the "Custom Events" sub-menu. To navigate there, use the following path: **Main Menu - > Core Utility -> Custom Events**
[[core-interrupt-user]]

- [Overview](https://docs.project-sylvanas.net/docs/<#overview>)
- [1 - Items](https://docs.project-sylvanas.net/docs/<#1---items>)
  - [Trinkets](https://docs.project-sylvanas.net/docs/<#trinkets>)
  - [Offensive, Defensive and Utility](https://docs.project-sylvanas.net/docs/<#offensive-defensive-and-utility>)
- [2 - Racial Spells](https://docs.project-sylvanas.net/docs/<#2---racial-spells>)
- [3 - Custom Events](https://docs.project-sylvanas.net/docs/<#3---custom-events>)
  - [Dispel](https://docs.project-sylvanas.net/docs/<#dispel>)
  - [Reflect](https://docs.project-sylvanas.net/docs/<#reflect>)
  - [Defensive](https://docs.project-sylvanas.net/docs/<#defensive>)
  - [Mythic Affix](https://docs.project-sylvanas.net/docs/<#mythic-affix>)
