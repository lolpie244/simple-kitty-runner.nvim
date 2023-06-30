local utils = {}

function utils.get_uuid()
	local uuid_handle = io.popen([[uuidgen]])
	local uuid = uuid_handle:read("*l")
	uuid_handle:close()
	return uuid
end

function utils.copy(obj)
	if type(obj) ~= 'table' then
		return obj
	end
	local result = {}
	for k, v in pairs(obj) do
		result[utils.copy(k)] = utils.copy(v)
	end

	return result
end

function utils.merge_arrays(...)
	local mergedArray = {}
	local startIndex = 1

	for _, array in ipairs({ ... }) do
		local endIndex = startIndex + #array - 1
		table.move(array, 1, #array, startIndex, mergedArray)
		startIndex = endIndex + 1
	end

	return mergedArray
end

function utils.split_respecting_quotes(s, quotes, delimeter)
	quotes = quotes or '""'
	delimeter = delimeter or ' '
	local result = {}

	for match in s:gsub('%b' .. quotes, function(x) return x:gsub(delimeter, '@') end):gmatch(string.format('[^%s]+', delimeter)) do
		local res = match:gsub('@', ' ')
		table.insert(result, res)
	end

	return result
end

return utils
