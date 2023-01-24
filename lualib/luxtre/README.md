# Luxtre

Luxtre is a fully portable dialect of [Lua 5.2](http://www.lua.org/) which compiles back into native code, written entirely in native Lua. It adds helpful additions and changes to Lua's default syntax and enables useful macros and preprocessing. 

Advanced users can leverage the existing toolchain and make use of their own custom grammars, allowing them to extend the existing features or even create their own transpiled languages from scratch.

Luxtre is compatible with all major versions of Lua (5.1+ and JIT), but does not backport newer syntax. Existing Lua code will largely work in Luxtre without modification, but some changes may be required ([see the changes to global variables](/docs/language_reference.md#assignment-changes)).

> WARNING: Features you see here are entirely subject to change. Luxtre is still a work in progress, and forward-compatibility is not guaranteed.

## Current Status:
Luxtre is in a complete and usable state. The core functionality is finished and polished, and good-enough-for-now compilation tools are available. Breaking syntax changes are still possible, and the custom grammar creation API will change in the future, but as it stands Luxtre should be entirely usable as a standalone or embedded lua dialect.

Current plans for future versions include bootstrapping luxtre into a more polished (and hopefully more performant) version of itself, reworking the custom syntax system from the ground up to be easier to use, making it possible to embed luxtre into love2d projects, and creating command-line tools which are more cross-platform than at current.

# How to Use
```lua
local luxtre = require "luxtre.loader"

-- Set up Luxtre to run .lux files through require
luxtre.register()
-- This will now load the file "foo.lux"
require("foo")

-- load/dofile equivalents for .lux files
local chunk = luxtre.loadfile("file")
luxtre.dofile("file")

-- load/dostring equivalents for the new syntax
local chunk = luxtre.loadstring(code_string)
luxtre.dostring("return -> print('hello world')")
```

[**See the documentation for more information.**](docs)

# Command-line Use
Luxtre offers extremely basic methods for running and compiling .lux files directly from a command line. It is designed for and tested on Linux but should work in any bash shell; the only requirement is that luajit is installed.

## Running files

Add the `luxtre/bin` folder to your path and run `lux`, or run `luxtre/bin/lux` directly from a bash prompt. 

If run with no arguments, `lux` will open a simple repl. Within the repl ending a line with `\` will extend input capture onto the following line, and the function `exit()` will exit.

If a filename is provided, `lux` will attempt to run that file. By default neither the file being run or any other files loaded by it will be compiled, but this can be changed by adding the `-c` or `--compile` flags.

```
# open the interactive repl
lux

# run a file without compiling anything
lux myawesomefile.lux

# run a file and compile all executed .lux files to .lua
lux myawesomefile.lux --compile
```

## Compiling files
Add the `luxtre/bin` folder to your path and run `luxc`, or run `luxtre/bin/luxc` directly from a bash prompt.

If a filename is provided, the corresponding .lux file is compiled into a .lua file. If a folder is provided, all files in the given folder are compiled. Subfolders can be compiled recursively using the -r and -d flags. See `luxc -h` for more detailed usage instructions.
