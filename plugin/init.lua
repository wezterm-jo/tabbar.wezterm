local wezterm = require('wezterm')

local config = {
    mode = {
        names = {
            resize_mode = "RESIZE",
            copy_mode = "VISUAL",
            search_mode = "SEARCH",
        }
    }
}

local process_icons = {
    ["docker"] = {
        { Text = wezterm.nerdfonts.linux_docker },
    },
    ["docker-compose"] = {
        { Text = wezterm.nerdfonts.linux_docker },
    },
    ["fish"] = {
        { Text = wezterm.nerdfonts.cod_terminal },
    },
    ["kuberlr"] = {
        { Text = wezterm.nerdfonts.linux_docker },
    },
    ["kubectl"] = {
        { Text = wezterm.nerdfonts.linux_docker },
    },
    ["nvim"] = {
        { Text = wezterm.nerdfonts.custom_vim },
    },
    ["vim"] = {
        { Text = wezterm.nerdfonts.dev_vim },
    },
    ["vi"] = {
        { Text = wezterm.nerdfonts.custom_vim },
    },
    ["node"] = {
        { Text = wezterm.nerdfonts.mdi_hexagon },
    },
    ["zsh"] = {
        { Text = wezterm.nerdfonts.cod_terminal },
    },
    ["bash"] = {
        { Text = wezterm.nerdfonts.cod_terminal_bash },
    },
    ["btm"] = {
        { Text = wezterm.nerdfonts.mdi_chart_donut_variant },
    },
    ["htop"] = {
        { Text = wezterm.nerdfonts.mdi_chart_donut_variant },
    },
    ["cargo"] = {
        { Text = wezterm.nerdfonts.dev_rust },
    },
    ["go"] = {
        { Text = wezterm.nerdfonts.mdi_language_go },
    },
    ["lazydocker"] = {
        { Text = wezterm.nerdfonts.linux_docker },
    },
    ["git"] = {
        { Text = wezterm.nerdfonts.dev_git },
    },
    ["lua"] = {
        { Text = wezterm.nerdfonts.seti_lua },
    },
    ["wget"] = {
        { Text = wezterm.nerdfonts.mdi_arrow_down_box },
    },
    ["curl"] = {
        { Text = wezterm.nerdfonts.mdi_flattr },
    },
    ["gh"] = {
        { Text = wezterm.nerdfonts.dev_github_badge },
    },
    ["python"] = {
        { Text = wezterm.nerdfonts.dev_python },
    },
    ["python3"] = {
        { Text = wezterm.nerdfonts.dev_python },
    },
    ["ruby"] = {
        { Text = wezterm.nerdfonts.dev_ruby },
    },
    ["beam.smp"] = {
        { Text = wezterm.nerdfonts.custom_elixir },
    },
    ["elixir"] = {
        { Text = wezterm.nerdfonts.custom_elixir },
    },
}

local M = {}

local function basename(s)
    return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

local function get_current_working_dir(pane)
    local cwd_uri = pane:get_current_working_dir()
    local dir = basename(cwd_uri.file_path)

    return dir
end

-- local function get_current_working_dir(tab)
--     local current_dir = tab.active_pane.current_working_dir
--     local HOME_DIR = string.format("file://%s", os.getenv("HOME"))

--     if current_dir == HOME_DIR then
--         return "~"
--     end

--     return string.gsub(current_dir, "(.*[/\\])(.*)", "%2")
-- end

local function get_process(tab)
    local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")
    if string.find(process_name, "kubectl") then
        process_name = "kubectl"
    end

    return wezterm.format(process_icons[process_name] or { { Text = string.format("%s:", process_name) } })
end

function M.apply_to_config()
    wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
        local has_unseen_output = false
        if not tab.is_active then
            for _, pane in ipairs(tab.panes) do
                if pane.has_unseen_output then
                    has_unseen_output = true
                    break
                end
            end
        end

        local title = string.format("%s", get_current_working_dir(tab.active_pane))

        if tab.active_pane.is_zoomed then
            title = title .. " " .. wezterm.nerdfonts.md_alpha_z_box
        end

        if has_unseen_output then
            return {
                { Foreground = { Color = "#89B4FA" } },
                { Text = title },
            }
        end

        return {
            { Foreground = { Color = "#CDD6F4" } },
            { Text = title },
        }
    end)

    wezterm.on("update-status", function(window, pane)
        local mode_text = ""
        local mode = ""
        local active = window:active_key_table()
        if config.mode.names[active] ~= nil then
            mode_text = config.mode.names[active]
        end

        mode = wezterm.format({
            { Foreground = { Color = "#CDD6F4" } },
            { Attribute = { Intensity = "Bold" } },
            { Text = mode_text },
            "ResetAttributes"
        })

        window:set_right_status(mode)
    end)
end

return M
