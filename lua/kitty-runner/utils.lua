local utils = {}

function utils.get_uuid()
	local uuid_handle = io.popen([[uuidgen]])
	local uuid = uuid_handle:read("*l")
	uuid_handle:close()
	return uuid
end

return utils
