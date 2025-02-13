# Holy Paladin Rotation Analysis and Optimization for Princess Kyveza (Patch 11.0.7)

## Executive Summary

This report analyzes the performance of a Holy Paladin rotation, hosted on GitHub ([https://github.com/NitashEU/fs_rotations](https://github.com/NitashEU/fs_rotations)), against top-performing Holy Paladins on Princess Kyveza (WarcraftLogs report: [https://www.warcraftlogs.com/reports/rP7FGhanwjp4k921?fight=43&type=healing](https://www.warcraftlogs.com/reports/rP7FGhanwjp4k921?fight=43&type=healing)). The primary metric for evaluation is effective Healing Per Second (HPS). The rotation is implemented as a plugin for an internal script/cheat within the Project Sylvanas environment ([https://project-sylvanas.net](https://project-sylvanas.net)). The goal is to identify areas for improvement in the rotation to achieve HPS performance closer to that of top players, acknowledging that raid composition, gear, talents, and external factors also play a role.

## 1. Problem Definition

The current Holy Paladin rotation, implemented as a plugin for Project Sylvanas, exhibits suboptimal HPS performance compared to top Holy Paladins on the Princess Kyveza encounter. The user aims to optimize the rotation to minimize the performance gap, focusing on achieving higher effective HPS.

## 2. Data and Methodology

*   **Target Rotation:** The Holy Paladin rotation hosted on GitHub ([https://github.com/NitashEU/fs_rotations](https://github.com/NitashEU/fs_rotations)).
*   **Benchmark Data:** WarcraftLogs report from a top Holy Paladin (Kaiyote) on Princess Kyveza ([https://www.warcraftlogs.com/reports/rP7FGhanwjp4k921?fight=43&type=healing](https://www.warcraftlogs.com/reports/rP7FGhanwjp4k921?fight=43&type=healing)).
*   **Performance Metric:** Effective Healing Per Second (HPS).
*   **Environment:** Patch 11.0.7, Project Sylvanas server.
*   **Analysis Approach:**
    *   **Comparative Log Analysis:** Detailed examination of Kaiyote's WarcraftLogs report to identify key differences in spell usage, timing, talent choices, and buff/debuff management.
    *   **Rotation Code Review:** In-depth analysis of the provided GitHub rotation code to pinpoint inefficiencies, incorrect priorities, or missing functionalities.
    *   **Simulation (if possible):** If the Project Sylvanas environment allows, simulate the rotation under various conditions to quantify the impact of different optimizations.
    *   **Consideration of External Factors:** While the focus is on the rotation, acknowledge and account for the influence of raid composition, gear, and encounter-specific mechanics.

## 3. Detailed Analysis of Kaiyote's WarcraftLogs Report

To understand the performance gap, a thorough analysis of Kaiyote's log is crucial. Here's a breakdown of key areas to investigate:

*   **3.1. Spell Usage Distribution:**
    *   Identify the frequency and percentage of total healing contributed by each spell (e.g., Holy Shock, Light of Dawn, Holy Light, Flash of Light, Beacon of Light healing, etc.).
    *   Compare Kaiyote's spell usage distribution to the target rotation's distribution. Significant deviations indicate potential areas for optimization.
    *   Pay close attention to the usage of cooldowns like Avenging Wrath, Holy Avenger, and Divine Toll.  Are these used optimally in the log?
*   **3.2. Timing and Sequencing:**
    *   Analyze the timing of spell casts relative to encounter events (e.g., damage spikes, boss abilities).  Are key heals being used proactively or reactively?
    *   Examine the sequencing of spells.  Are there specific combinations or rotations that Kaiyote uses effectively (e.g., Holy Shock -> Light of Dawn)?
    *   Look for instances where Kaiyote anticipates damage and pre-casts heals or uses defensive cooldowns.
*   **3.3. Talent Choices and Synergies:**
    *   Document Kaiyote's talent build.  Identify key talents that contribute significantly to their HPS.
    *   Analyze how the chosen talents synergize with their spell usage and rotation.  Are there specific talent combinations that are particularly effective?
    *   Consider talents that enhance mana efficiency, healing output, or cooldown reduction.
*   **3.4. Beacon of Light Management:**
    *   Determine the uptime of Beacon of Light.  High uptime is crucial for consistent healing.
    *   Identify the targets of Beacon of Light.  Are they consistently on the tank or are they being switched strategically based on damage patterns?
    *   Analyze the amount of overhealing on the Beacon target.  Excessive overhealing indicates potential inefficiencies.
*   **3.5. Buff and Debuff Management:**
    *   Track the uptime of important buffs like Avenging Wrath and Infusion of Light.
    *   Analyze how these buffs are utilized to maximize healing output.
    *   Identify any debuffs on the boss or raid that affect healing effectiveness.
*   **3.6. Mana Efficiency:**
    *   Assess Kaiyote's mana consumption throughout the fight.  Are they able to maintain high HPS without running out of mana?
    *   Identify mana-saving talents and abilities that they utilize.
    *   Analyze their usage of mana potions and other mana regeneration tools.

**Example Analysis (Illustrative):**

Let's say Kaiyote's log shows a significantly higher usage of Holy Shock compared to the target rotation. Further investigation reveals that Kaiyote is using the 

## Sources

- https://www.archon.gg/wow/builds/holy/paladin/raid/talents/heroic/kyveza
- https://www.archon.gg/wow/builds/holy/paladin/raid/overview/heroic/kyveza
- https://www.warcraftlogs.com/character/eu/twisting-nether/Kaiyote
- https://www.warcraftlogs.com/zone/rankings/38?boss=2920&class=Paladin&spec=Retribution
- https://www.warcraftlogs.com/zone/rankings/38?boss=2922&metric=hps&class=Paladin&spec=Holy
- https://www.icy-veins.com/wow/holy-paladin-pve-healing-rotation-cooldowns-abilities
- https://www.icy-veins.com/wow/holy-paladin-pve-healing-stat-priority
- https://www.icy-veins.com/wow/holy-paladin-pve-healing-guide
- https://www.icy-veins.com/wow/holy-paladin-pvp-guide
- https://www.archon.gg/wow/builds/holy/paladin/raid/talents/normal/kyveza
- https://www.archon.gg/wow/builds/holy/paladin/mythic-plus/gear-and-tier-set/10/all-dungeons/this-week
- https://www.archon.gg/wow/builds/holy/paladin/mythic-plus/overview/high-keys/siege-of-boralus/this-week
- https://www.archon.gg/wow/builds/holy/paladin/mythic-plus/overview/10/siege-of-boralus/this-week
- https://www.unknowncheats.me/forum/anti-cheat-bypass/621526-internal-detection-vectors.html
- https://project-sylvanas.net/
- https://project-sylvanas.net/roadmap
- https://www.ownedcore.com/forums/world-of-warcraft/world-of-warcraft-bots-programs/1045646-early-access-sylvanas-project-internal-wow-cheat.html
- https://www.elitepvpers.com/forum/wow-bots/5259938-early-access-sylvanas-project-internal-wow-cheat.html
- https://wowpedia.fandom.com/wiki/Sylvanas_Windrunner
- https://www.method.gg/guides/holy-paladin
- https://www.icy-veins.com/wow/holy-paladin-pve-healing-mythic-plus-tips
- https://www.wowhead.com/guide/classes/paladin/holy/overview-pve-healer
- https://www.method.gg/guides/holy-paladin/playstyle-and-rotation
- https://www.skill-capped.com/articles/wow/holy-paladin-the-war-within-pvp-guide/
- https://www.icy-veins.com/wow/holy-paladin-hero-talents-pve-guide
- https://murlok.io/paladin/holy/lightsmith/mm+
- https://www.wowhead.com/guide/classes/paladin/holy/talent-builds-pve-healer
- https://maxroll.gg/wow/class-guides/holy-paladin-mythic-plus-guide
- https://www.method.gg/guides/holy-paladin/talents
- https://www.warcraftlogs.com/
- https://www.wowanalyzer.com/
- https://www.reddit.com/r/CompetitiveWoW/comments/cvu68h/need_help_with_indepth_holy_paladin_log_analysis/
- https://us.forums.blizzard.com/en/wow/t/holy-paladin-is-a-joke/765250
- https://u.gg/wow/holy/paladin/talents?stat=dps
- https://murlok.io/paladin/holy/mm+
- https://www.icy-veins.com/wow/holy-paladin-pve-healing-spec-builds-talents
- https://www.wowvalor.app/en/paladin/holy/mm
- https://www.wowhead.com/guide/classes/paladin/holy/mythic-plus-dungeon-tips
- https://wingsisup.com/mplus-dungeons-affixes
- https://www.icy-veins.com/wow/holy-paladin-pvp-best-arena-compositions
- https://murlok.io/paladin/holy/2v2