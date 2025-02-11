# Core Interrupt

The **Core Interrupt** module in Sylvanas is a powerful tool designed to support and manage all possible interrupt spells across every class and talent configuration in the game. These interrupt spells, which we refer to as **Solutions** , are applied to enemy spell casts in both **PvP** and **PvE** environments. The module utilizes a centralized spell database, ensuring that the correct solution is applied based on the scenario.
To configure the Core Interrupt settings, you can access the menu here: **Main Menu - > Core Modules -> Core Interrupt**.
![](https://downloads.project-sylvanas.net/1728300461879-core_interrupt_path.png)

## 1 - PvP and PvE Spell Database[​](https://docs.project-sylvanas.net/docs/<#1---pvp-and-pve-spell-database> "Direct link to 1---pvp-and-pve-spell-database")

The **Core Interrupt** module includes a comprehensive spell database that is organized by caster class for **PvP** spells, and by season for **PvE** spells. This database allows the module to know exactly what spells should be interrupted and when, based on the type of content you are engaging with.
To view the spells database menu options: **Main Menu - > Core Interrupt -> Spells DB**
![](https://downloads.project-sylvanas.net/1728300487974-core_interrupt_db_path.png)

### Smart Filters for PvP and PvE[​](https://docs.project-sylvanas.net/docs/<#smart-filters-for-pvp-and-pve> "Direct link to smart-filters-for-pvp-and-pve")

The **Core Interrupt** module supports **Smart Filters** , which allow you to set different conditions for interrupting spells in **PvP** versus **PvE**. For example:

- In **PvP** , you might want to interrupt a heal only if the target being healed has **less than 70% health**.
- In **PvE** , you might prefer the default behavior of interrupting heals when the target is at **100% health**.

This ensures that your interrupts are more strategically timed based on the specific scenario. You can fine-tune these filters in the settings menu, allowing for a tailored experience in different content types.
note
The smart filters are found in the "PvP Filters" sub-menu, for PvP spells, and in the "PvE Filters" sub-menu, for PvE spells.

## 2 - Supported Solutions[​](https://docs.project-sylvanas.net/docs/<#2---supported-solutions> "Direct link to 2---supported-solutions")

The **Core Interrupt** module supports a wide variety of solutions for each class. For instance, for **Death Knights** , the module supports interrupts such as:

- **Death Grip**
- **Asphyxiate** (includes **Strangulate** as a PvP talent)
- **Mind Freeze**
- **Blinding Sleet**

These solutions cover both **single target** and **area interrupts** , ensuring flexibility across different encounter types, especially in **dungeons** and **raids**.
You can access the **Supported Solutions** menu here: **Main Menu - > Core Modules -> Core Interrupt -> Supported Solutions**.
![](https://downloads.project-sylvanas.net/1728300517959-supported_solutions_path.png)
note
While we strive to include all relevant interrupt solutions, **new spells or talents may be added** in future patches or versions of WoW. If you notice any missing solutions or errors, feel free to **report** them so we can work on improving the module.

### Area-Based Interrupts[​](https://docs.project-sylvanas.net/docs/<#area-based-interrupts> "Direct link to area-based-interrupts")

For **PvE** content, the module attempts to apply area-based solutions that can interrupt multiple spells simultaneously, though this can be tricky. We continuously work on improving these solutions for high-end content, but certain complex encounters may still require **manual intervention**.
This module is designed to help players easily navigate high-end content, but for the absolute highest tiers, such as **Mythic 10+ keys** or **high arena ratings** , you may need to do some **manual adjustments** for optimal performance.

## 3 - Advanced Settings[​](https://docs.project-sylvanas.net/docs/<#3---advanced-settings> "Direct link to 3---advanced-settings")

### Keybinds and Randomization[​](https://docs.project-sylvanas.net/docs/<#keybinds-and-randomization> "Direct link to keybinds-and-randomization")

You can configure **keybinds** to disable the **Core Interrupt** module when you do not want it to be active. **By default** , the module will attempt to interrupt casts regardless of whether you are actively playing or AFK.
In the **Advanced Settings** , you can also customize the percentage at which the interrupt will trigger. **By default** , interrupts are set to trigger near the end of the cast, with a randomized window to make the behavior less predictable, so nobody can determine that you are using scripts by seeing that you always interrupt at the exact same cast percentage, and also giving a more natural feel.

### Drawing Settings[​](https://docs.project-sylvanas.net/docs/<#drawing-settings> "Direct link to drawing-settings")

The **Core Interrupt** module includes a visual aid system that displays **circles** around enemy casters during spell casts. These circles act as a progress bar, showing the time remaining before the spell is cast. The visual indicators follow these colors:

- **White** : The spell is detected, but no solution is currently available.
- **Yellow** : A solution is planned but will only be applied when the interrupt percentage condition is met.
- **Green** : The interrupt has been sent to the game server and will stop the spell.

You can **customize** these visual settings in the menu: ![](https://downloads.project-sylvanas.net/1728300711345-core_interrupt_drawings.png)

## 4 - Limitations and Future Improvements[​](https://docs.project-sylvanas.net/docs/<#4---limitations-and-future-improvements> "Direct link to 4---limitations-and-future-improvements")

The **Core Interrupt** module is already highly effective for most content, but we acknowledge that it may not always provide perfect results in the highest levels of play (e.g., **Mythic 10+ keys** or **high-rated arenas**). Further improvements to the module are possible, but as a project, we must prioritize our time across various areas.
We will continue to collect feedback and work on enhancements, though our current focus remains on broader updates, such as new rotations and support for additional WoW versions.
note
Please feel free to report any issues or suggest improvements, and we will work to refine the module when time allows.
[[paladin-retribution-user]]

- [Overview](https://docs.project-sylvanas.net/docs/<#overview>)
- [1 - PvP and PvE Spell Database](https://docs.project-sylvanas.net/docs/<#1---pvp-and-pve-spell-database>)
  - [Smart Filters for PvP and PvE](https://docs.project-sylvanas.net/docs/<#smart-filters-for-pvp-and-pve>)
- [2 - Supported Solutions](https://docs.project-sylvanas.net/docs/<#2---supported-solutions>)
  - [Area-Based Interrupts](https://docs.project-sylvanas.net/docs/<#area-based-interrupts>)
- [3 - Advanced Settings](https://docs.project-sylvanas.net/docs/<#3---advanced-settings>)
  - [Keybinds and Randomization](https://docs.project-sylvanas.net/docs/<#keybinds-and-randomization>)
  - [Drawing Settings](https://docs.project-sylvanas.net/docs/<#drawing-settings>)
- [4 - Limitations and Future Improvements](https://docs.project-sylvanas.net/docs/<#4---limitations-and-future-improvements>)
