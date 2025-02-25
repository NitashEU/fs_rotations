---@type color
local color = require("common/color")

---@alias on_render_menu fun()

---@type on_render_menu
function FS.entry_helper.on_render_menu()
    FS.menu.main_tree:render("FS Rotations v" .. FS.version:toString(), function()
        FS.menu.enable_script_check:render("Enable Script")
        if not FS.settings.is_enabled() then return end

        FS.menu.humanizer:render("Humanizer", color.white())
        FS.menu.min_delay:render("Min delay", "Min delay until next run.")
        FS.menu.max_delay:render("Max delay", "Max delay until next run.")

        -- Add jitter settings to menu
        FS.menu.humanizer_jitter.enable_jitter:render("Enable Jitter",
            "Adds randomization to delays for more human-like behavior")

        if FS.settings.jitter.is_enabled() then
            FS.menu.humanizer_jitter.base_jitter:render("Base Jitter %",
                "Base percentage of delay to use for randomization")
            FS.menu.humanizer_jitter.latency_jitter:render("Latency Jitter %",
                "Additional jitter based on current latency")
            FS.menu.humanizer_jitter.max_jitter:render("Max Jitter %",
                "Maximum total jitter percentage")
        end

        for _, module in pairs(FS.loaded_modules) do
            if module.on_render_menu then
                module.on_render_menu()
            end
        end
        if FS.spec_config.on_render_menu then
            FS.spec_config.on_render_menu()
        end
    end)
end
