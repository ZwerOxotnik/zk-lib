local zk_lib = {}
remote.remove_interface('zk-lib')
remote.add_interface('zk-lib', {
    insert_random_item = random_items.insert_random_item
})

zk_lib.on_init = function()
    global.zk_lib = global.zk_lib or {}
end

zk_lib.events = {}
return zk_lib
