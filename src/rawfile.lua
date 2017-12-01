function exists_file(file_path)
	local f = io.open(file_path, "rb")
	if f then
	f:close()
	end
	return f ~= nil
end

function read_lines(file_path)
	if not exists_file(file_path) then
		return {}
	end
	local lines = {}
	for line in io.lines(file_path) do
		lines[#lines + 1] = line
	end
	return lines
end

function write(file_path, data)
	local f = io.open(file_path, "w")
	f:write(data)
	f:close()
end

function clear(file_path)
	write(file_path, "")
end