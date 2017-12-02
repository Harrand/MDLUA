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

function read(file path)
	local s = ""
	for line in read_lines(file_path) do
		s = s .. line .. "\n"
	end
end

function write(file_path, data)
	local f = io.open(file_path, "w")
	f:write(data)
	f:close()
end

function append_line(file_path, line)
	local f = io.open(file_path, "a")
	f:write(line .. "\n")
	f:close()
end

function clear(file_path)
	write(file_path, "")
end