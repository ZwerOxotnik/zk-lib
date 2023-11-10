**[Screenshots](#screenshots)** |
**[Addons](#addons)** |
**[FAQ](#faq)** |
**[Notice](#notice)** |
**[Contributing](#contributing)** |
**[License](#license)**

---

<p align="center">
  <img
    width="250"
    src="thumbnail.png"
    alt="thumbnail"
  />
</p>

<p align="center">
  <a href="https://github.com/ZwerOxotnik/zk-lib/tags">
    <img src="https://img.shields.io/github/tag/ZwerOxotnik/zk-lib.svg?label=Release&color=FF5500" alt="Release">
  </a>
  <a href="https://github.com/ZwerOxotnik/zk-lib/stargazers">
    <img src="https://img.shields.io/github/stars/ZwerOxotnik/zk-lib.svg?label=Stars&color=F08125" alt="Star">
  </a>
  <a href="https://discordapp.com/invite/YyJVUCa">
    <img src="https://discordapp.com/api/guilds/480103519769067542/widget.png?style=shield" alt="Discord">
  <br/>
  <a href="https://www.patreon.com/ZwerOxotnik">
    <img src="https://ionicabizau.github.io/badges/patreon.svg" alt="Patreon">
  <a href="https://ko-fi.com/zweroxotnik">
    <img src="https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg" height="20" alt="Buy me a coffee">
  <a href="http://github.com/ZwerOxotnik/zk-lib/fork">
    <img src="https://img.shields.io/github/forks/ZwerOxotnik/zk-lib.svg?label=Forks&color=7889DD" alt="Fork">
  </a>
</p>

<p align="center">
  <a href="changelog.txt">Changelog</a>
  ·
  <a href="https://crowdin.com/project/factorio-mods-localization">Translations</a>
</p>

<h1></h1>

<img
  src="https://mods-data.factorio.com/assets/961685040434656713a16c830fde63a02ef62381.png"
  align="right"
/>

**Multipurpose mod with switchable addons**

**Also, supports auto-generated mods etc.**

- **Customizable:** each addon is switchable.
- **Universal:** many libraries for various purposes.
- **Easy:** doesn't require specific requirements.

<p align="center">
<a href="https://mods.factorio.com/mod/zk-lib/downloads"><strong>Download the mod&nbsp;&nbsp;▶</strong></a>
</p>

| Settings stage | Data stage | Control stage |
| -------------- | ---------- | ------------- |
| [ZKSettings](/experimental/ZKSettings.lua) - libary with new features for settings | [sound auto-handling](https://github.com/ZwerOxotnik/Mod-generator) + [PUAN2 api](/data-api/puan2_api.lua) | ["zk-lib" - remote interface of libs](/zk-lib/control.lua)
| ["Static libs"](#static-libs) | ["Static libs"](#static-libs) | ["Static libs"](#static-libs) |
| [lazyAPI](/experimental/lazyAPI.lua) | [lazyAPI](/experimental/lazyAPI.lua) - Are you lazy to change/add/remove/check some prototypes in the data stage? Use this library then. | [Event listener][event-listener] (not important, currently) |
| | [simpleTiers](/experimental/simpleTiers.lua) | |
| | [easyTemplates](/experimental/easyTemplates.lua) | |
| | [SPD](/experimental/SPD.lua) - Simple postdate data (WIP) | [event_handler_vZO](/static-libs/lualibs/event_handler_vZO.lua) - improved version of Factorio event_handler |
| | [fakes](/data-api/fakes.lua) - creates fake entitites |
| | [sprite list](/.scripts/create_zk_sprite_list.sh) - creates sprite list and zk-lib adds them (new) |

**3rd party libraries**:
- [basexx](/lualib/basexx.lua) - library for base2, base16, base32, base64, base85 decoding and encoding of data strings. ([source](https://github.com/aiq/basexx))
```lua
local basexx = require(require("__zk-lib__/defines").modules.basexx)
```
- [bitwise](/lualib/bitwise.lua) - Bitwise operations. ([source](https://github.com/davidm/lua-bit-numberlua/blob/master/lmod/bit/numberlua.lua))
```lua
local bitwise = require(require("__zk-lib__/defines").modules.bitwise)
```
- [fun](/lualib/fun.lua) - a functional programming library ([documentation](https://luafun.github.io/), [source](https://github.com/luafun/luafun/blob/master/fun.lua))
```lua
local fun = require(require("__zk-lib__/defines").modules.fun)
--- or
require(require("__zk-lib__/defines").modules.fun)()
```
- [candran](/lualib/candran/candran.lua) - a Lua dialect and simple preprocessor ([source](https://github.com/Reuh/candran/tree/1e118381f8276fe66a2cad02f1b9f4535e7e253e)) (**WARNING:** this modified version has some bugs and some functions were removed due to technical limitations, please report in this repository if you have any issues with it)
```lua
local candran = require(require("__zk-lib__/defines").modules.candran)
```
- [LuLPeg](/lualib/LuLPeg) - A port of LPeg 100% written in Lua. ([source](https://github.com/pygy/LuLPeg/tree/f07f5be09d0461b1e83a8f811ca2c9cb79a69ab2)) (use with cautious)
```lua
local lpeg = require(require("__zk-lib__/defines").modules.lulpeg)
```
- [Luxtre](/lualib/luxtre/) is a fully portable dialect of Lua 5.2 which compiles back into native code, written entirely in native Lua. It adds helpful additions and changes to Lua's default syntax and enables useful macros and preprocessing. ([documentation](https://github.com/DimitriBarronmore/luxtre/tree/a2854ef166b71b0e74252a55b0ec245cbc45f947/docs), [source](https://github.com/DimitriBarronmore/luxtre/tree/a2854ef166b71b0e74252a55b0ec245cbc45f947)) (not fully tested, can't be used outside of control.lua parsing yet)
```lua
local luxtre = require(require("__zk-lib__/defines").modules.luxtre)
```
- [lal](/lualib/lal/) is the implementation of a Compiler for a Scheme like dialect of Lisp that compiles to Lua. ([documentation](/lualib/lal/doc/), [source](https://github.com/WeirdConstructor/lal/tree/38aaa0c426a9b52cd8d74d375f9a11e117be2007)) (expect bugs (I should fix some of them), can't be used outside of control.lua parsing yet)
`# FAIL LAL-Compiler (74 OF 82 OK, 82 of 82 were run)`\
```lua
local lal = require(require("__zk-lib__/defines").modules.lal)
```
- [tl](/lualib/tl/) is compiler for Teal, a typed dialect of Lua. ([tutorial](https://github.com/teal-language/tl/tree/28f8fd9eb1a756267b8cde25990dfae27f8f5bcc/docs/tutorial.md), [source](https://github.com/teal-language/tl/tree/28f8fd9eb1a756267b8cde25990dfae27f8f5bcc)) (not fully tested)
```lua
local tl = require(require("__zk-lib__/defines").modules.tl)
```
- [moonscript](/lualib/moonscript/) is a programmer friendly language that compiles into Lua. ([source](https://github.com/leafo/moonscript/tree/d5341c9093c49d3724072b209cde28b5cb0f47c9)) (not fully tested)
```lua
local moonscript = require(require("__zk-lib__/defines").modules.moonscript)
```
- [std](/lualib/std/) is collection of Lua libraries. ([source](https://github.com/lua-stdlib/lua-stdlib/tree/a632078f216ac6b9994449b7f1435a419172b44f)) (not fully tested, some stuff were removed)
```lua
local std_modules = require("__zk-lib__/defines").modules.std
local init    = require(std_modules.init)
local _base   = require(std_modules._base)
local package = require(std_modules.package)
local debug   = require(std_modules.debug)
local string  = require(std_modules.string)
local table   = require(std_modules.string)
local math    = require(std_modules.math)
```
- [vivid](/lualib/vivid.lua) is simple color manipulation library. Used for color conversion and math. ([source](https://github.com/WetDesertRock/vivid/blob/55cb54578949f74534ab89e75e72a3f013292fda/vivid.lua), [documentation](https://github.com/WetDesertRock/vivid/tree/55cb54578949f74534ab89e75e72a3f013292fda))
```lua
local vivid = require(require("__zk-lib__/defines").modules.vivid)
```
- [Penlight](/lualib/Penlight) brings together a set of generally useful pure Lua modules. ([source](https://github.com/lunarmodules/Penlight/tree/dc6d19c5c1e1b4ac55b14df17b7645af6b410140)) (not tested, some stuff were removed)
```lua
compat = require("__zk-lib__/lualib/Penlight/lua/pl/compat")
warn "@on"
```
```lua
local PL_modules = require("__zk-lib__/defines").modules.penlight
require(PL_modules.init) -- Entry point for loading all PL libraries only on demand, into the global space
local import_into = require(PL_modules.import_into)
local compat      = require(PL_modules.compat)
local luabalanced = require(PL_modules.luabalanced)
local OrderedMap  = require(PL_modules.OrderedMap)
local MultiMap = require(PL_modules.MultiMap)
local template = require(PL_modules.template)
local operator = require(PL_modules.operator)
local stringio = require(PL_modules.stringio)
local array2d  = require(PL_modules.array2d)
local stringx  = require(PL_modules.stringx)
local permute  = require(PL_modules.permute)
local tablex   = require(PL_modules.tablex)
local config   = require(PL_modules.config)
local strict   = require(PL_modules.strict)
local pretty   = require(PL_modules.pretty)
local input    = require(PL_modules.input)
local class    = require(PL_modules.class)
local lexer    = require(PL_modules.lexer)
local types    = require(PL_modules.types)
local utils    = require(PL_modules.utils)
local lapp     = require(PL_modules.lapp)
local func     = require(PL_modules.func)
local data     = require(PL_modules.data)
local List     = require(PL_modules.List)
local test     = require(PL_modules.test)
local seq      = require(PL_modules.seq)
local sip      = require(PL_modules.sip)
local app      = require(PL_modules.app)
local Map      = require(PL_modules.Map)
local Set      = require(PL_modules.Set)
local url      = require(PL_modules.url)
local xml      = require(PL_modules.xml)
local comprehension = require(PL_modules.comprehension)
```
- [Allen](/lualib/allen.lua) is a Lua library which provides a set of utilities and helpers for strings operations.\
Allen can be considered as an extension of the built-in Lua string library. ([source](https://github.com/Yonaba/Allen/tree/9abdcd0330d7007d77d67a97b0c4627a46a7f278), [documentation](https://yonaba.github.com/Allen))
(WARNING: messes around with some data, don't require it with [moonscript](/lualib/moonscript/))
```lua
local allen = require(require("__zk-lib__/defines").modules.allen)
```
- [Guard](/lualib/guard.lua) Minimalistic library providing [Elixir](https://elixir-lang.org/crash-course.html)-style guards for Lua. ([source](https://github.com/Yonaba/guard.lua/tree/cc38583241195209f2af7c92cd97eb42a82f6514), [documentation](https://github.com/Yonaba/guard.lua/wiki))
```lua
local guard = require(require("__zk-lib__/defines").modules.guard)
```
- Lua Class System ([LCS](/lualib/LCS.lua)) is a small library which offers a clean, minimalistic but powerful API for (Pseudo) Object Oriented programming style using Lua. ([source](https://github.com/Yonaba/Lua-Class-System/tree/7c8b7c816eee282770bdf206e253d38d348bc732))
```lua
local LCS = require(require("__zk-lib__/defines").modules.LCS)
```

If you're interested in switchable commands with filters and in basic examples for Factorio, check out https://github.com/ZwerOxotnik/factorio-example-mod

<a name="static-libs"></a> [Static libs](https://github.com/ZwerOxotnik/zk-factorio-static-lib) [![source](https://img.shields.io/badge/%E2%81%A4-source-blue.svg?logo=github&colorB=7289DA)](https://github.com/ZwerOxotnik/zk-factorio-static-lib)
-------------------------------------------------------

Screenshots
-----------

![image1](https://mods-data.factorio.com/assets/a9b5a52ec854cf30f62023a9fb18f1e98d69d1b9.png)
![image2](https://mods-data.factorio.com/assets/961685040434656713a16c830fde63a02ef62381.png)

Addons
------

* https://mods.factorio.com/mod/random-gifts-by-timer
* https://mods.factorio.com/mod/kill-nest-get-gift
* https://mods.factorio.com/mod/scan-rocket-with-radars
* https://mods.factorio.com/mod/auto-mining
* https://mods.factorio.com/mod/searching-flashlightR
* https://mods.factorio.com/mod/adrenaline
* https://mods.factorio.com/mod/CopyAssemblerPipeDirection
* Delete decorations

FAQ
---

**Q**: What the addons are?

**A**: Wrapped embedded code into this mod

**Q**: Are addons better than mods?

**A**: Addons have more convenient way of managment **for players**, but, unfortunately, mod devs can't use some features for addons, at this moment. So, if a mod has simple events, then it'll be nice to have the mod as an addon.

‼️ Important Links (Translations, Discord Support)
---------------------------------------------------------------

| Installation Guide | Translations | Discord |
| ------------------ | ------------ | ------- |
| 📖 [Installation Guide](https://wiki.factorio.com/index.php?title=Installing_Mods) | 📚 [Help with translations](https://crowdin.com/project/factorio-mods-localization) | 🦜 [Discord](https://discord.gg/zYTM3rZM4T) |

If you want to download from this source, then use commands below (requires [git](https://git-scm.com/downloads)).

```bash
git clone --recurse-submodules -j8 https://github.com/ZwerOxotnik/zk-lib
cd zk-lib
```

[Contributing](/CONTRIBUTING.md)
--------------------------------

Don't be afraid to contribute! We have many, many things you can do to help out. If you're trying to contribute but stuck, tag @ZwerOxotnik

Alternatively, join the [Discord group](https://discordapp.com/invite/YyJVUCa) and send a message there.

Please read the [contributing file](/CONTRIBUTING.md) for other details on how to contribute.

Notice
------

This project contains work from multiple sources + [addons](#overview).

* [Event listener][event-listener]
* [zk-factorio-static-lib](https://github.com/ZwerOxotnik/zk-factorio-static-lib)
* [Sounds from other authors](/sound/README.txt)

Also, this project used [Mod generator](https://github.com/ZwerOxotnik/Mod-generator).\
Some images were copied from the game "Factorio" and changed, please, read terms of service: https://www.factorio.com/terms-of-service.\
[./fonts/NerdFontsSymbolsOnly](./fonts/NerdFontsSymbolsOnly) is licensed under the [MIT](./fonts/NerdFontsSymbolsOnly/LICENSE) licence. Original source: https://www.nerdfonts.com/font-downloads

Artwork
-------

<table>
 <thead>
  <tr>
   <th>Type</th>
   <th>Artist</th>
   <th>Image</th>
   <th>License</th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>Thumbnail</td>
   <td><a href="https://github.com/ZwerOxotnik">ZwerOxotnik</a></td>
   <td><a href="thumbnail.png"><img src="thumbnail.png" height="128" alt="zweroxotnik logo" title="thumbnail" /></a></td>
   <td><a href="https://choosealicense.com/no-permission/">All right are reserved</a></td>
  </tr>
 </tbody>
</table>

License
-------

This project is copyright © 2018-2023 ZwerOxotnik \<zweroxotnik@gmail.com\>.

This project is licensed under the [European Union Public License v. 1.2 only](/LICENCE).

[homepage]: http://mods.factorio.com/mod/zk-lib
[ZwerOxotnik]: github.com/ZwerOxotnik/
[event-listener]: https://gitlab.com/ZwerOxotnik/factorio-event-listener
