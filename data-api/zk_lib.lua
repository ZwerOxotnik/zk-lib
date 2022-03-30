local zk_lib = {}

---@deprecated #Use lazyAPI.attach_custom_input_event instead
zk_lib.attach_custom_input_event = lazyAPI.attach_custom_input_event

---@deprecated #Use lazyAPI.create_trigger_capsule instead
zk_lib.create_tool = lazyAPI.create_trigger_capsule

---@deprecated #Use lazyAPI.array_to_locale instead or require("__zk-lib__/static-libs/lualibs/locale").array_to_locale
zk_lib.merge_localization = require("static-libs/lualibs/locale").array_to_locale

return zk_lib
