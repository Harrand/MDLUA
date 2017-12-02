local rawfile = require "rawfile"

parsed_tags = {}
parsed_sequences = {}
null_tag = "0"

function mdl_is_comment(line)
	return line[0] == '#'
end

function mdl_is_sequence(line)
	b, a = string.find(line, "%[")
	return (string.find(line, ": ") ~= nil) and a ~= nil and a+1 >= line:len()
end

function mdl_is_tag(line)
	return string.find(line, ": ") ~= nil and mdl_is_sequence(line) == false
end

function mdl_end_of_sequence(line)
	b, a = string.find(line, "]%")
	return a ~= nil and a+1 >= line:len()
end

function mdl_tag_name(line)
	if mdl_is_tag(line) == false then return null_tag end
	f, _ = string.find(line, ": ")
	return string.sub(line, 0, f - 1)
end

function mdl_sequence_name(line)
	if mdl_is_sequence(line) == false then return null_tag end
	f, _ = string.find(line, ": ")
	return string.sub(line, 0, f - 1)
end

function mdl_tag_value(line)
	if mdl_is_tag(line) == false then return null_tag end
	_, f = string.find(line, ": ")
	return string.sub(line, f + 1)
end

function mdl_sequence_values(lines, index)
	local ending = false
	local ret = {}
	if mdl_is_sequence(lines[index]) == false then
		return {}
	end
	index = index + 1
	while index < #lines and ending == false do
		line = lines[index]
		b, a = string.find(line, "- ")
		print("bam")
		if b ~= nil and b <= 1 then
			print("found sequence value")
			value = string.sub(line, a + 1)
			if mdl_end_of_sequence(value) then
				value = string.sub(value, -2)
				ending = true
				print("ending sequence")
			end
			ret[#ret+1] = value
		end
		index = index + 1
	end
	return ret
end

function mdl_update(file_path)
	parsed_tags = {}
	parsed_sequences = {}
	local lines = rawfile.read_lines(file_path)
	for i=1, #lines do
		if mdl_is_comment(lines[i]) == false then
			-- runs if line doesnt start with # (is not comment)
			if mdl_is_tag(lines[i]) then
				parsed_tags[mdl_tag_name(lines[i])] = mdl_tag_value(lines[i])
			end
			if mdl_is_sequence(lines[i]) then
				print("found a sequence")
				print("name = " .. mdl_sequence_name(lines[i]))
				print("num values = " .. #mdl_sequence_values(lines, i))
				parsed_sequences[mdl_sequence_name(lines[i])] = mdl_sequence_values(lines, i)
			end
		end
	end
end

--[[
mdl_update("../test.mdl")
print("tags in test.mdl:")
for tag, value in pairs(parsed_tags) do
	print(tag .. ": " .. value)
end
print("sequences in test.mdl:")
for name, sequence in pairs(parsed_sequences) do
	print(name .. ": %[")
	for index, value in pairs(sequence) do
		print("- " .. value)
	end
	print("]%")
end
print("done")
--]]