-- cloak.yazi - Redact environment variable values in .env files
-- This plugin previews .env files with their values replaced by asterisks

local M = {}

-- Helper to display messages in the preview widget
function M.msg(job, s)
	ya.preview_widget(job, ui.Text(ui.Line(s):reverse()):area(job.area):wrap(ui.Wrap.YES))
end

-- Redact a single line if it's a KEY=VALUE pattern
local function redact_line(line)
	-- Match lines with KEY=VALUE pattern
	-- Handles various formats: KEY=value, KEY="value", KEY='value', KEY=value with spaces
	local key, equals, value = line:match("^([^#][^=]-)(%s*=%s*)(.+)$")

	if key and equals and value then
		-- Trim whitespace from key
		key = key:match("^%s*(.-)%s*$")

		-- Calculate value length (handle quoted values)
		local value_len
		if value:match('^".-"$') or value:match("^'.-'$") then
			-- Quoted value - preserve quotes, redact content
			local quote = value:sub(1, 1)
			value_len = #value - 2
			if value_len > 0 then
				value = quote .. string.rep("*", value_len) .. quote
			else
				value = quote .. quote
			end
		else
			-- Unquoted value
			value = value:match("^%s*(.-)%s*$") -- trim
			value_len = #value
			if value_len > 0 then
				value = string.rep("*", value_len)
			end
		end

		return key .. equals .. value
	else
		-- Not a KEY=VALUE line (comment, blank, etc.) - keep as is
		return line
	end
end

-- Preview the file with redacted values
function M:peek(job)
	local path = tostring(job.file.url)
	local file = io.open(path, "r")
	if not file then
		return self.msg(job, "Failed to open file")
	end

	local i, j, lines = 0, 0, {}
	local limit = job.area.h

	while true do
		local chunk = file:read(4096)
		if not chunk then
			break
		end

		j = j + #chunk
		if j > 5242880 then
			file:close()
			return self.msg(job, "File too large")
		end

		for line in chunk:gmatch("[^\n]*\n?") do
			i = i + 1
			if i > job.skip + limit then
				break
			elseif i > job.skip then
				-- Redact the line before adding it
				lines[#lines + 1] = redact_line(line)
			end
		end
	end

	file:close()

	if job.skip > 0 and i < job.skip + limit then
		ya.emit("peek", { math.max(0, i - limit), only_if = job.file.url, upper_bound = true })
	else
		ya.preview_widget(job, ui.Text(lines):area(job.area))
	end
end

-- Handle scrolling
function M:seek(job)
	require("code"):seek(job)
end

return M
