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
    alt="ZwerOxotnik's extendable mod"
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

| Data | Control stage | UI |
| ----------- | ---------- | --------- |
| [sound auto-handling](https://github.com/ZwerOxotnik/Mod-generator) + [PUAN api](/data-api/puan_api.lua) | ["zk-lib" - remote interface of libs](/zk-lib/control.lua) | [universal command widget](zk-lib/universal-command-widget) (WIP) |
| [fakes](/data-api/fakes.lua) - creates fake entitites | ["Static libs"](#static-libs) for embedding | |
| | [Event listener][event-listener] | |

If you're interested in switchable commands with filters, check out https://github.com/ZwerOxotnik/cc-template

<a name="static-libs"></a> [Static libs](/static-libs) [![source](https://img.shields.io/badge/%E2%81%A4-source-blue.svg?logo=github&colorB=7289DA)](https://github.com/ZwerOxotnik/zk-factorio-static-lib)
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

Also, this project used [Mod generator](https://github.com/ZwerOxotnik/Mod-generator)

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

This project is copyright © 2018-2021 ZwerOxotnik \<zweroxotnik@gmail.com\>.

This project is licensed under the [European Union Public License v. 1.2 only](/LICENCE).

[homepage]: http://mods.factorio.com/mod/zk-lib
[ZwerOxotnik]: github.com/ZwerOxotnik/
[event-listener]: https://gitlab.com/ZwerOxotnik/factorio-event-listener
