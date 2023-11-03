local defines = {
	modules = {
		easyTemplates = "__zk-lib__/experimental/easyTemplates",
		gui_helper    = "__zk-lib__/experimental/gui-helper",
		simpleTiers   = "__zk-lib__/experimental/simpleTiers",
		ZKSettings    = "__zk-lib__/experimental/ZKSettings",
		lazyAPI = "__zk-lib__/experimental/lazyAPI",
		SPD     = "__zk-lib__/experimental/SPD",
		fakes   = "__zk-lib__/data-api/fakes",
		puan_api   = "__zk-lib__/data-api/puan_api", -- use puan2_api instead
		puan2_api  = "__zk-lib__/data-api/puan2_api",
		zk_lib     = "__zk-lib__/data-api/zk_lib", -- use easyAPi etc. instead
		event_listener = "__zk-lib__/event-listener/branch-1/stable-version", -- use https://github.com/ZwerOxotnik/zk-factorio-static-lib/blob/master/lualibs/event_handler_vZO.lua instead
		moonscript = "__zk-lib__/lualib/moonscript/base",
		candran    = "__zk-lib__/lualib/candran/candran",
		bitwise    = "__zk-lib__/lualib/bitwise",
		luxtre     = "__zk-lib__/lualib/luxtre/init",
		basexx     = "__zk-lib__/lualib/basexx",
		allen      = "__zk-lib__/lualib/allen",
		vivid      = "__zk-lib__/lualib/vivid",
		guard      = "__zk-lib__/lualib/guard",
		lpeg       = "__zk-lib__/lualib/LuLPeg/lulpeg",
		LCS        = "__zk-lib__/lualib/LCS",
		lal        = "__zk-lib__/lualib/lal",
		fun        = "__zk-lib__/lualib/fun",
		tl         = "__zk-lib__/lualib/tl/0.15.1/tl",
		penlight = {
			init = "__zk-lib__/lualib/Penlight/lua/pl/init",
			import_into = "__zk-lib__/lualib/Penlight/lua/pl/import_into",
			compat      = "__zk-lib__/lualib/Penlight/lua/pl/compat",
			luabalanced = "__zk-lib__/lualib/Penlight/lua/pl/luabalanced",
			OrderedMap  = "__zk-lib__/lualib/Penlight/lua/pl/OrderedMap",
			MultiMap = "__zk-lib__/lualib/Penlight/lua/pl/MultiMap",
			template = "__zk-lib__/lualib/Penlight/lua/pl/template",
			operator = "__zk-lib__/lualib/Penlight/lua/pl/operator",
			stringio = "__zk-lib__/lualib/Penlight/lua/pl/stringio",
			array2d  = "__zk-lib__/lualib/Penlight/lua/pl/array2d",
			stringx  = "__zk-lib__/lualib/Penlight/lua/pl/stringx",
			permute  = "__zk-lib__/lualib/Penlight/lua/pl/permute",
			tablex   = "__zk-lib__/lualib/Penlight/lua/pl/tablex",
			pretty   = "__zk-lib__/lualib/Penlight/lua/pl/pretty",
			config   = "__zk-lib__/lualib/Penlight/lua/pl/config",
			strict   = "__zk-lib__/lualib/Penlight/lua/pl/strict",
			input    = "__zk-lib__/lualib/Penlight/lua/pl/input",
			class    = "__zk-lib__/lualib/Penlight/lua/pl/class",
			lexer    = "__zk-lib__/lualib/Penlight/lua/pl/lexer",
			types    = "__zk-lib__/lualib/Penlight/lua/pl/types",
			utils    = "__zk-lib__/lualib/Penlight/lua/pl/utils",
			lapp     = "__zk-lib__/lualib/Penlight/lua/pl/lapp",
			func     = "__zk-lib__/lualib/Penlight/lua/pl/func",
			data     = "__zk-lib__/lualib/Penlight/lua/pl/data",
			List     = "__zk-lib__/lualib/Penlight/lua/pl/List",
			test     = "__zk-lib__/lualib/Penlight/lua/pl/test",
			seq      = "__zk-lib__/lualib/Penlight/lua/pl/seq",
			sip      = "__zk-lib__/lualib/Penlight/lua/pl/sip",
			app      = "__zk-lib__/lualib/Penlight/lua/pl/app",
			Map      = "__zk-lib__/lualib/Penlight/lua/pl/Map",
			Set      = "__zk-lib__/lualib/Penlight/lua/pl/Set",
			url      = "__zk-lib__/lualib/Penlight/lua/pl/url",
			xml      = "__zk-lib__/lualib/Penlight/lua/pl/xml",
			comprehension = "__zk-lib__/lualib/Penlight/lua/pl/comprehension",
		},
		std = {
			init    = "__zk-lib__/lualib/std/init",
			_base   = "__zk-lib__/lualib/std/_base",
			package = "__zk-lib__/lualib/std/package",
			debug   = "__zk-lib__/lualib/std/debug",
			string  = "__zk-lib__/lualib/std/string",
			table   = "__zk-lib__/lualib/std/table",
			math    = "__zk-lib__/lualib/std/math",
		},
	},
	static_libs = {
		event_handler_vZO = "__zk-lib__/static-libs/lualibs/event_handler_vZO",
		all_control_utils = "__zk-lib__/static-libs/all_control_utils",
		all_data_utils    = "__zk-lib__/static-libs/all_data_utils",
		coordinates_util  = "__zk-lib__/static-libs/lualibs/coordinates-util",
		rich_text_util    = "__zk-lib__/static-libs/lualibs/rich-text-util",
		number_util = "__zk-lib__/static-libs/lualibs/number-util",
		time_util   = "__zk-lib__/static-libs/lualibs/time-util",
		version = "__zk-lib__/static-libs/lualibs/version",
		lauxlib = "__zk-lib__/static-libs/lualibs/lauxlib",
		locale  = "__zk-lib__/static-libs/lualibs/locale",
		control_stage = {
			remote_interface_util = "__zk-lib__/static-libs/lualibs/control_stage/remote-interface-util",
			GuiTemplater   = "__zk-lib__/static-libs/lualibs/control_stage/GuiTemplater",
			random_items   = "__zk-lib__/static-libs/lualibs/control_stage/random_items",
			inventory_util = "__zk-lib__/static-libs/lualibs/control_stage/inventory-util",
			prototype_util = "__zk-lib__/static-libs/lualibs/control_stage/prototype-util",
			surface_util   = "__zk-lib__/static-libs/lualibs/control_stage/surface-util",
			entity_util = "__zk-lib__/static-libs/lualibs/control_stage/entity-util",
			market_util = "__zk-lib__/static-libs/lualibs/control_stage/market-util",
			player_util = "__zk-lib__/static-libs/lualibs/control_stage/player-util",
			biter_util  = "__zk-lib__/static-libs/lualibs/control_stage/biter-util",
			force_util  = "__zk-lib__/static-libs/lualibs/control_stage/force-util",
			rcon_util   = "__zk-lib__/static-libs/lualibs/control_stage/rcon-util",
			defines     = "__zk-lib__/static-libs/lualibs/control_stage/defines",
		}
	}
}


return defines