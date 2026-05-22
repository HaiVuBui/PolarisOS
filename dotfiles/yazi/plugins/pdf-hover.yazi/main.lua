local M = {}

local last_path = nil

function M:setup()
	local script = os.getenv("HOME") .. "/.config/yazi/plugins/pdf-hover.yazi/preview.sh"

	ps.sub("hover", function(_)
		local h = cx.active.current.hovered
		if not h or h.cha.is_dir then
			return
		end

		local path = tostring(h.url)
		if not path:lower():match("%.pdf$") then
			return
		end
		if path == last_path then
			return
		end

		last_path = path
		Command(script):arg(path):spawn()
	end)
end

return M
