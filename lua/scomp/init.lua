local M = {}

local data = nil
local command = nil

M.setup = function(opts)
	command = opts.command
end

M.reset_data = function()
	data = nil
end

M.run = function()
	-- com, the command to (compile and) run the program
	local com = nil
	if type(command) == "string" then
		com = command
	else -- it is a command
		com = command()
	end
	-- data will be taken from the clipboard
	-- and saved, until it is reset
	if data == nil then
		data = vim.fn.getreg('+')
	end
	-- prepare a terminal
	vim.cmd("split")
	vim.cmd('exe "normal \\<C-W>L"')
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_win_set_buf(win, buf)
	-- run "com"
	local jobid = vim.fn.termopen(com)
	-- send each line of the test data
	for s in data:gmatch(".+[\r\n]+") do
		vim.api.nvim_chan_send(jobid, s)
	end
end

return M
