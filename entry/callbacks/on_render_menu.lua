---@type color
local color = require("common/color")

---@alias on_render_menu fun()

---@type on_render_menu
function FS.entry_helper.on_render_menu()
    FS.menu.main_tree:render("FS Rotations", function()
        FS.menu.enable_script_check:render("Enable Script")
        if not FS.settings.is_enabled() then return end
        --FS.menu.enable_bitch_mode:render("Enable BitchMode", "In BitchMode you'll get humanized AF.")
        --FS.menu.enable_cd_manager:render("Enable CD Manager",
        --    "CD Manager automatically pulls CDs on certain encounters.")
        FS.menu.humanizer:render("Humanizer", color.white())
        FS.menu.min_delay:render("Min delay", "Min delay until next run.")
        FS.menu.max_delay:render("Max delay", "Min delay until next run.")

        if FS.spec_config.on_render_menu then
            FS.spec_config.on_render_menu()
        end
    end)
end
