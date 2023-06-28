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

return utils
