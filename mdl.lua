require "rawfile"

parsed_tags = {}
parsed_sequences = {}
null_tag = "0"

function mdl_is_comment(line)
	return line[0] == '#'
end

function mdl_is_tag(line)
	return string.find(line, ": ") ~= nil
end

function mdl_tag_name(line)
	if mdl_is_tag(line) == false then return null_tag end
	f, _ = string.find(line, ": ")
	return string.sub(line, 0, f - 1)
end

function mdl_tag_value(line)
	if mdl_is_tag(line) == false then return null_tag end
	_, f = string.find(line, ": ")
	return string.sub(line, f + 1)
end

function mdl_update(file_path)
	parsed_tags = {}
	parsed_sequences = {}
	local lines = read_lines(file_path)
	for i=1, #lines do
		if mdl_is_comment(lines[i]) == false then
			-- runs if line doesnt start with # (is not comment)
			if mdl_is_tag(lines[i]) then
				parsed_tags[mdl_tag_name(lines[i])] = mdl_tag_value(lines[i])
			end
		end
	end
end

mdl_update("test.mdl")
print("tags in test.mdl:")
for tag, value in pairs(parsed_tags) do
	print(tag .. ": " .. value)
end
print("done")