local windline = require('windline')
local helper = require('windline.helpers')
local sep = helper.separators
local b_components = require('windline.components.basic')
local state = _G.WindLine.state
local vim_components = require('windline.components.vim')
local HSL = require('wlanimation.utils')

local lsp_comps = require('windline.components.lsp')
local git_comps = require('windline.components.git')

local hl_list = {
    Black = { 'white', 'black' },
    White = { 'black', 'white' },
    Normal = { 'NormalFg', 'NormalBg' },
    Inactive = { 'InactiveFg', 'InactiveBg' },
    Active = { 'ActiveFg', 'ActiveBg' },
}
local basic = {}

local airline_colors = {}

airline_colors.a = {
    NormalSep = { 'magenta_a', 'magenta_b' },
    InsertSep = { 'green_a', 'green_b' },
    VisualSep = { 'yellow_a', 'yellow_b' },
    ReplaceSep = { 'blue_a', 'blue_b' },
    CommandSep = { 'red_a', 'red_b' },
    Normal = { 'black', 'magenta_a' },
    Insert = { 'black', 'green_a' },
    Visual = { 'black', 'yellow_a' },
    Replace = { 'black', 'blue_a' },
    Command = { 'black', 'red_a' },
}

airline_colors.b = {
    NormalSep = { 'magenta_b', 'magenta_c' },
    InsertSep = { 'green_b', 'green_c' },
    VisualSep = { 'yellow_b', 'yellow_c' },
    ReplaceSep = { 'blue_b', 'blue_c' },
    CommandSep = { 'red_b', 'red_c' },
    Normal = { 'white', 'magenta_b' },
    Insert = { 'white', 'green_b' },
    Visual = { 'white', 'yellow_b' },
    Replace = { 'white', 'blue_b' },
    Command = { 'white', 'red_b' },
}

airline_colors.c = {
    NormalSep = { 'magenta_c', 'NormalBg' },
    InsertSep = { 'green_c', 'NormalBg' },
    VisualSep = { 'yellow_c', 'NormalBg' },
    ReplaceSep = { 'blue_c', 'NormalBg' },
    CommandSep = { 'red_c', 'NormalBg' },
    Normal = { 'white', 'magenta_c' },
    Insert = { 'white', 'green_c' },
    Visual = { 'white', 'yellow_c' },
    Replace = { 'white', 'blue_c' },
    Command = { 'white', 'red_c' },
}

basic.divider = { b_components.divider, hl_list.Normal }

local width_breakpoint = 100

basic.section_a = {
    hl_colors = airline_colors.a,
    text = function(_,_,width)
        if width > width_breakpoint then
            return {
                { ' ' .. state.mode[1] .. ' ', state.mode[2] },
                { sep.right_filled, state.mode[2] .. 'Sep' },
            }
        end
        return {
            { ' ' .. state.mode[1]:sub(1, 1) .. ' ', state.mode[2] },
            { sep.right_filled, state.mode[2] .. 'Sep' },
        }
    end,
}


basic.section_b = {
    hl_colors = airline_colors.b,
    text = function(bufnr,_, width)
        if width > width_breakpoint and git_comps.is_git(bufnr) then
            return {
                { git_comps.git_branch() , state.mode[2] },
                { ' ', '' },
                { sep.right_filled, state.mode[2] .. 'Sep' },
            }
        end
        return { { sep.right_filled, state.mode[2] .. 'Sep' } }
    end,
}


basic.section_c = {
    hl_colors = airline_colors.c,
    text = function()
        return {
            { ' ', state.mode[2] },
            { b_components.cache_file_name('[No Name]', 'unique')},
            { ' '},
            { sep.right_filled, state.mode[2] .. 'Sep' },
        }
    end,
}

basic.section_x = {
    hl_colors = airline_colors.c,
    text = function(_,_,width)
        if width > width_breakpoint then
            return {
            { sep.left_filled, state.mode[2] .. 'Sep' },
            { ' ', state.mode[2] },
            { b_components.file_encoding()},
            { ' ' },
            { b_components.file_format({ icon = true }) },
            { ' ' },
            }
        end
        return {
            { sep.left_filled, state.mode[2] .. 'Sep' },
        }
    end,
}

basic.section_y = {
    hl_colors = airline_colors.b,
    text = function(_,_,width)
        if width > width_breakpoint then
            return {
                { sep.left_filled, state.mode[2] .. 'Sep' },
                { b_components.cache_file_type({ icon = true }), state.mode[2] },
                { ' ' },
            }
        end
        return { { sep.left_filled, state.mode[2] .. 'Sep' } }
    end,
}

local word_count = function()
    local wc = vim.fn.wordcount()
    return wc.words > 0 and string.format(" %d words", wc.words) or ""
end

local function get_active_markdown_header()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local current_line = vim.api.nvim_win_get_cursor(0)[1] -- Get the current line number
    local active_header = nil

    for i, line in ipairs(lines) do
        local level = line:match("^(#+)")
        if level then
            local header_level = #level -- Count the number of `#` symbols to determine the level
            local header_text = line:gsub("^#+%s*", "") -- Remove the `#` symbols and leading spaces

            -- If the cursor is within or after this header, consider it active
            if i <= current_line then
                active_header = {
                    level = header_level,
                    text = header_text
                }
            else
                break -- No need to check further lines
            end
        end
    end

    if active_header then
        local header_display = string.format("%d. %s", active_header.level, active_header.text)
        if #header_display > 25 then
            header_display = header_display:sub(1, 22) .. "..."
        end
        return header_display
    else
        return ""
    end
end

-- Full breadcrumbs (with parent breadcrumbs truncated to 1 char)
--local function get_markdown_breadcrumbs()
--    local breadcrumbs = {}
--    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
--    local current_line = vim.api.nvim_win_get_cursor(0)[1] -- Get the current line number
--
--    local active_breadcrumb = nil
--
--    for i, line in ipairs(lines) do
--        local level = line:match("^(#+)")
--        if level then
--            local header_level = #level -- Count the number of `#` symbols to determine the level
--            local header_text = line:gsub("^#+%s*", "") -- Remove the `#` symbols and leading spaces
--
--            -- Truncate breadcrumbs to the current header level
--            breadcrumbs[header_level] = header_text
--            for j = header_level + 1, #breadcrumbs do
--                breadcrumbs[j] = nil -- Clear deeper levels
--            end
--
--            -- Set the active breadcrumb if the cursor is within this header's range
--            if i <= current_line then
--                active_breadcrumb = header_level
--            end
--        end
--    end
--
--    -- Build the breadcrumb string
--    local result = {}
--    for level, text in ipairs(breadcrumbs) do
--        if level == active_breadcrumb then
--            table.insert(result, text) -- Keep the full text for the active header
--        else
--            table.insert(result, text:sub(1, 1)) -- Truncate to one letter for others
--        end
--    end
--
--    return table.concat(result, " -> ")
--end

-- Now, modify the section where you want to show the word count.
basic.section_z = {
    hl_colors = airline_colors.a,
    text = function(_,_,width)
        local wordcount = word_count() -- Get the word count here
        local header = get_active_markdown_header() -- Get breadcrumbs here

        if width > width_breakpoint then
            return {
                { sep.left_filled, state.mode[2] .. 'Sep' },
                { '', state.mode[2] },
                { b_components.progress_lua},
                { ' '},
                { b_components.line_col_lua},
                { " " .. header, state.mode[2] },
                -- Conditionally add word count
                { wordcount, state.mode[2] }
            }
        end
        return {
            { sep.left_filled, state.mode[2] .. 'Sep' },
            { ' ', state.mode[2] },
            { b_components.line_col_lua, state.mode[2] },
            { " " .. header, state.mode[2] },
            -- Conditionally add word count
            { wordcount, state.mode[2] }, 
        }
    end,
}

basic.lsp_diagnos = {
    name = 'diagnostic',
    hl_colors = {
        red = { 'red', 'NormalBg' },
        yellow = { 'yellow', 'NormalBg' },
        blue = { 'blue', 'NormalBg' },
    },
    text = function(bufnr)
        if lsp_comps.check_lsp(bufnr) then
            return {
                { lsp_comps.lsp_error({ format = '  %s', show_zero = true }), 'red' },
                { lsp_comps.lsp_warning({ format = '  %s', show_zero = true }), 'yellow' },
                { lsp_comps.lsp_hint({ format = '  %s', show_zero = true }), 'blue' },
            }
        end
        return { ' ', 'red' }
    end,
}

basic.git = {
    name = 'git',
    width = width_breakpoint,
    hl_colors = {
        green = { 'green', 'NormalBg' },
        red = { 'red', 'NormalBg' },
        blue = { 'blue', 'NormalBg' },
    },
    text = function(bufnr)
        if git_comps.is_git(bufnr) then
            return {
                { git_comps.diff_added({ format = '  %s' }), 'green' },
                { git_comps.diff_removed({ format = '  %s' }), 'red' },
                { git_comps.diff_changed({ format = '  %s' }), 'blue' },
            }
        end
        return ''
    end,
}
local quickfix = {
    filetypes = { 'qf', 'Trouble' },
    active = {
        { '🚦 Quickfix ', { 'white', 'black' } },
        { helper.separators.slant_right, { 'black', 'black_light' } },
        {
            function()
                return vim.fn.getqflist({ title = 0 }).title
            end,
            { 'cyan', 'black_light' },
        },
        { ' Total : %L ', { 'cyan', 'black_light' } },
        { helper.separators.slant_right, { 'black_light', 'InactiveBg' } },
        { ' ', { 'InactiveFg', 'InactiveBg' } },
        basic.divider,
        { helper.separators.slant_right, { 'InactiveBg', 'black' } },
        { '🧛 ', { 'white', 'black' } },
    },
    always_active = true,
    show_last_status = true
}

local explorer = {
    filetypes = { 'fern', 'NvimTree', 'lir' },
    active = {
        { '  ', { 'white', 'magenta_b' } },
        { helper.separators.slant_right, { 'magenta_b', 'NormalBg' } },
        { b_components.divider, '' },
        { b_components.file_name(''), { 'NormalFg', 'NormalBg' } },
    },
    always_active = true,
    show_last_status = true
}

local default = {
    filetypes = { 'default' },
    active = {
        basic.section_a,
        basic.section_b,
        basic.section_c,
        basic.lsp_diagnos,
        { vim_components.search_count(), { 'cyan', 'NormalBg' } },
        basic.divider,
        basic.git,
        basic.section_x,
        basic.section_y,
        basic.section_z,
    },
    inactive = {
        { b_components.full_file_name, hl_list.Inactive },
        { b_components.divider, hl_list.Inactive },
        { b_components.line_col, hl_list.Inactive },
        { b_components.progress, hl_list.Inactive },
    },
}

local markdown_breadcrumbs_statusline = {
    filetypes = { 'markdown' },
    active = {
        {
            function()
                return get_markdown_breadcrumbs()
            end,
            { 'cyan', 'black' },
        },
    },
    always_active = true,
    show_last_status = true,
}

windline.setup({
    colors_name = function(colors)
        local mod = function (c, value)
            if vim.o.background == 'light' then
                return HSL.rgb_to_hsl(c):tint(value):to_rgb()
            end
            return HSL.rgb_to_hsl(c):shade(value):to_rgb()
        end

        colors.magenta_a = colors.magenta
        colors.magenta_b = mod(colors.magenta,0.5)
        colors.magenta_c = mod(colors.magenta,0.7)

        colors.yellow_a = colors.yellow
        colors.yellow_b = mod(colors.yellow,0.5)
        colors.yellow_c = mod(colors.yellow,0.7)

        colors.blue_a = colors.blue
        colors.blue_b = mod(colors.blue,0.5)
        colors.blue_c = mod(colors.blue,0.7)

        colors.green_a = colors.green
        colors.green_b = mod(colors.green,0.5)
        colors.green_c = mod(colors.green,0.7)

        colors.red_a = colors.red
        colors.red_b = mod(colors.red,0.5)
        colors.red_c = mod(colors.red,0.7)

        return colors
    end,
    statuslines = {
        default,
        quickfix,
        explorer,
--        markdown_breadcrumbs_statusline
    },
})
