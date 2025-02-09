# Key Algorithms

The following key algorithms are used in the plugin:

*   **Avenging Crusader Rotation:** This rotation is used when the Avenging Crusader talent is active. The rotation prioritizes Judgment and Crusader Strike.
    *   Implementation: The `FS.paladin_holy.logic.rotations.avenging_crusader()` function first checks if the Avenging Crusader talent is active. If it is, it casts Judgment and then Crusader Strike.
    *   [classes/paladin/holy/logic/rotations/avenging\_crusader.lua](classes/paladin/holy/logic/rotations/avenging_crusader.lua)
*   **Healing Rotation:** This rotation is used for healing. The rotation prioritizes Judgment, Crusader Strike, and Hammer of Wrath.
    *   Implementation: The `FS.paladin_holy.logic.rotations.healing()` function casts Judgment, Crusader Strike, and Hammer of Wrath in that order.
    *   [classes/paladin/holy/logic/rotations/healing.lua](classes/paladin/holy/logic/rotations/healing.lua)
*   **Damage Rotation:** This rotation is used for dealing damage. The rotation prioritizes Judgment, Crusader Strike, and Hammer of Wrath.
    *   Implementation: The `FS.paladin_holy.logic.rotations.damage()` function casts Judgment, Crusader Strike, and Hammer of Wrath in that order.
    *   [classes/paladin/holy/logic/rotations/damage.lua](classes/paladin/holy/logic/rotations/damage.lua)