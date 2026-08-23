-- heuristic-autoload.lua
--
-- author: notuxic
-- license: MIT
-- upstream: https://github.com/notuxic/mpv-heuristic-autoload


mp.msg = require 'mp.msg'
mp.options = require 'mp.options'
mp.utils = require 'mp.utils'


local user_opts = {
	disabled = false,       -- disable plugin
	video = true,           -- enable for video files
	audio = false,          -- enable for audio files
	same_type = true,       -- only add files with the same media type (audio/video) to playlist
	pattern_ignore = "",    -- patterns to ignore for prefix comparison
	prefix_min_length = 5   -- minimum length for common prefix
}

local mpv_opts = {
	video_exts = {},        -- mpv option --video-exts
	audio_exts = {}         -- mpv option --audio-exts
}


function split_to_list(str)
	local elems = {}
	for elem in string.gmatch(str, "([^,]+)") do
		table.insert(elems, elem)
	end
	return elems
end


function split_to_map(str)
	local elems = {}
	for elem in string.gmatch(str, "([^,]+)") do
		elems[elem] = true
	end
	return elems
end


function get_common_prefix(str1, str2)
	local max_len = math.min(#str1, #str2)

	for i = 1, max_len do
		if string.sub(str1, i, i) ~= string.sub(str2, i, i) then
			max_len = i - 1
			break
		end
	end

	return string.sub(str1, 1, max_len)
end


function find_files(path, file)
	-- detect current media type
	local file_ext = string.match(file, "%.([^.]+)$")
	local media_type = nil
	if user_opts.video and mpv_opts.video_exts[file_ext] then
		media_type = "video"
	elseif user_opts.audio and mpv_opts.audio_exts[file_ext] then
		media_type = "audio"
	end
	if media_type == nil then
		mp.msg.debug("aborting, unsuitable file extension: ." .. (file_ext or ""))
		return {}
	end
	mp.msg.trace("media type of current file: " .. media_type)

	-- filter files by media type, find longest common prefix
	local pattern_ignore = split_to_list(user_opts.pattern_ignore)
	local file_cleaned = file
	for _, pattern in ipairs(pattern_ignore) do
		success, file_cleaned = pcall(string.gsub, file_cleaned, pattern, "")
		if not success then
			mp.msg.error("error: option pattern_ignore: " .. file_cleaned .. ": " .. pattern)
		end
	end

	local files = mp.utils.readdir(path, "files")
	local longest_prefix = ""
	local longest_prefix_len = 0
	for i = #files, 1, -1 do
		local file_ext = string.match(files[i], "%.([^.]+)$")
		if not mpv_opts.video_exts[file_ext] and not mpv_opts.audio_exts[file_ext] then
			mp.msg.trace("ignoring file: " .. files[i])
			table.remove(files, i)
		elseif mpv_opts.video_exts[file_ext] and media_type == "audio" and user_opts.same_type then
			mp.msg.trace("ignoring file: " .. files[i])
			table.remove(files, i)
		elseif mpv_opts.audio_exts[file_ext] and media_type == "video" and user_opts.same_type then
			mp.msg.trace("ignoring file: " .. files[i])
			table.remove(files, i)
		else
			entry_cleaned = files[i]

			for _, pattern in ipairs(pattern_ignore) do
				success, entry_cleaned = pcall(string.gsub, entry_cleaned, pattern, "")
				if not success then
					mp.msg.error("error: option pattern_ignore: " .. entry_cleaned .. ": " .. pattern)
				end
			end
			mp.msg.trace("considering file: " .. files[i] .. "\n         cleaned: " .. entry_cleaned)

			files[entry_cleaned] = files[i]
			files[i] = entry_cleaned

			if files[entry_cleaned] ~= file then
				local prefix = get_common_prefix(file_cleaned, entry_cleaned)
				local prefix_len = #prefix
				if prefix_len > longest_prefix_len then
					longest_prefix = prefix
					longest_prefix_len = prefix_len
				end
			end
		end
	end
	longest_prefix = string.gsub(longest_prefix, "%d*$", "")
	longest_prefix_len = #longest_prefix
	mp.msg.debug("choosing prefix: " .. longest_prefix)
	if longest_prefix_len < user_opts.prefix_min_length then
		mp.msg.debug("aborting, prefix is shorter than prefix_min_length (" .. user_opts.prefix_min_length .. ")")
		return {}
	end

	-- filter files by common prefix
	for i = #files, 1, -1 do
		if string.sub(files[i], 1, longest_prefix_len) ~= longest_prefix then
			mp.msg.trace("ignoring file: " .. files[i])
			table.remove(files, i)
		end
	end

	-- sort files
	table.sort(files, function(a, b) return string.lower(a) < string.lower(b) end)

	return files
end


function create_playlist()
	if user_opts.disabled then
		return
	end

	local aborted = mp.get_property_native("playback-abort")
	if aborted then
		return
	end

	local playlist_count = mp.get_property_native("playlist-count")
	if playlist_count > 1 then
		mp.msg.debug("aborting, a playlist already exists")
		return
	end

	local filepath = mp.get_property("path", "")
	local path, file = mp.utils.split_path(filepath)
	if #path == 0 then
		mp.msg.debug("aborting, current file is not a local file")
		return
	end

	local files = find_files(path, file)
	if #files == 0 then
		return
	end

	-- find current file
	local current_idx = 1
	while current_idx < #files do
		if files[files[current_idx]] == file then
			mp.msg.trace("index of current file: " .. current_idx)
			break
		end
		current_idx = current_idx + 1
	end

	-- prepend to playlist
	for i = current_idx-1, 1, -1 do
		filepath = mp.utils.join_path(path, files[files[i]])
		mp.msg.trace("prepending file to playlist: " .. filepath)
		mp.commandv("loadfile", filepath, "insert-at", "0")
	end

	-- append to playlist
	for i = current_idx+1, #files do
		filepath = mp.utils.join_path(path, files[files[i]])
		mp.msg.trace("appending file to playlist: " .. filepath)
		mp.commandv("loadfile", filepath, "append")
	end
end


mp.options.read_options(user_opts, nil, function(list) end)
mp.observe_property("options/video-exts", "string", function(_, value) mpv_opts.video_exts = split_to_map(value) end)
mp.observe_property("options/audio-exts", "string", function(_, value) mpv_opts.audio_exts = split_to_map(value) end)
mp.register_event("start-file", create_playlist)
