
local function load_51(text, name, mode, env)
    local iter = function()
        local tx = text
        text = ""
        return tx
    end
    local func, err = load(iter, name)
    if err then
        -- error(err)
        return nil, err
    end
    if env then
        setfenv(func, env)
    end
    return func
end

local load_func
if _VERSION > "Lua 5.1" then
    load_func = load
else
    load_func = load_51
end

return load_func