[![thumbnail](/thumbnail.png)][homepage]
# ZwerOxotnik's extendable library

[![Discord](https://i.imgur.com/GYTxQdx.png)](https://discordapp.com/invite/YyJVUCa)
[![Patreon](https://i.imgur.com/6n2ifle.png)](https://www.patreon.com/ZwerOxotnik)
[![reddit](https://i.imgur.com/J1k7aGJ.png)](https://reddit.com/r/ZwerOxotnik)

## Contents

* [Overview](#overview)
* [Addons](#addons)
* [Installing](#installing)
* [Notice](#notice)
* [License](#license)

## Overview

This mod provides, combines, packages libraries, utilities for (new) mods and to the game as tools/features (UI isn't ready yet).

Also, supports auto-generated mods and has modified event listener and I consider to provide other extra light files/things for mods.  

| Data | Control stage | UI |
| ----------- | ---------- | --------- |
| [sound auto-handling](https://github.com/ZwerOxotnik/Mod-generator) + [PUAN api](/data-api/puan_api.lua) | ["zk-lib" - remote interface of libs](/zk-lib/control.lua) | [universal command widget](zk-lib/universal-command-widget) (WIP) |
| | ["Static libs"](#static-libs) for embedding | |
| | [customizable] commands of libs (disabled) | |
| | [Event listener][event-listener] | |

## Addons

* https://mods.factorio.com/mod/random-gifts-by-timer
* https://mods.factorio.com/mod/kill-nest-get-gift
* https://mods.factorio.com/mod/teams-zo
* https://mods.factorio.com/mod/scan-rocket-with-radars
* https://mods.factorio.com/mod/auto-mining
* https://mods.factorio.com/mod/timesaver-for-crafting
* https://mods.factorio.com/mod/searching-flashlightR
* Delete decorations

### <a name="static-libs"></a> [Static libs](/static-libs) [![source](https://img.shields.io/badge/%E2%81%A4-source-blue.svg?logo=github&colorB=7289DA)](https://github.com/ZwerOxotnik/zk-factorio-static-lib)

## Installing

Please, use download this mod via Factorio or on [mods.factorio.com][homepage].\
Recommended to read ["Installing Mods"](https://wiki.factorio.com/index.php?title=Installing_Mods) on the Factorio wiki.

If you have downloaded the source archive (GitHub):

* Copy the mod directory into your factorio mods directory
* Rename the mod directory to zk-lib_*versionnumber*, where *versionnumber* is the version of the mod that you've downloaded (e.g., 0.1.0)

## Notice

This project contains work from multiple sources + [addons](#overview).

* [Event listener][event-listener]
* [zk-factorio-static-lib](https://github.com/ZwerOxotnik/zk-factorio-static-lib)
* [Sounds from other authors](/sound/README.txt)

Also, this project used [Mod-generator](https://github.com/ZwerOxotnik/Mod-generator)

## License

[Logo](/thumbnail.png) is a trademark of [ZwerOxotnik][ZwerOxotnik].

This project is copyright © 2018-2020 ZwerOxotnik \<zweroxotnik@gmail.com\>.

This project is licensed under the [European Union Public License v. 1.2 only](/LICENCE).

[homepage]: http://mods.factorio.com/mod/zk-lib
[ZwerOxotnik]: github.com/ZwerOxotnik/
[event-listener]: https://gitlab.com/ZwerOxotnik/factorio-event-listener