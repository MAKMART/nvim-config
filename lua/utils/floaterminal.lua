local M = {}

local state = {
    floating = {
        buf = -1,
        win = -1,
    }
}

local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)

    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)
    local buf

    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true)
    end

    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
    }

    local win = vim.api.nvim_open_win(buf, true, win_config)
    return { buf = buf, win = win }
end

--- Toggle floating terminal window
-- @param cmd (string or table) command or args to run inside terminal (optional)
function M.toggle_terminal(cmd)
    -- If window valid and visible, hide it and return
    if vim.api.nvim_win_is_valid(state.floating.win) then
        local ok, _ = pcall(vim.api.nvim_win_hide, state.floating.win)
        state.floating.win = -1
        return
    end

    -- Create or reuse floating window
    state.floating = create_floating_window { buf = state.floating.buf }

    -- If buffer is not terminal or empty, start terminal job
    local buftype = vim.bo[state.floating.buf].buftype
    if buftype ~= "terminal" then
        -- If cmd is table, flatten to string for terminal()
        if type(cmd) == "table" then
            cmd = table.concat(cmd, " ")
        end
        if cmd and cmd ~= "" then
            vim.fn.termopen(cmd)
        else
            vim.cmd.terminal()
        end
    end
end

function M.setup()
    vim.api.nvim_create_user_command("Floaterminal", function(opts)
        -- Pass args from :Floaterminal [args...]
        local cmd = table.concat(opts.fargs, " ")
        if cmd == "" then cmd = nil end
        M.toggle_terminal(cmd)
    end, { nargs = "*" })
end

return M
