
--[[
        CONCEPT: SECOND DRAFT
    File output is split into three sections:
    The HEADER, BODY, and FOOTER.

    The HEADER is a collection of single lines at the very top of the file.
    This section is used for things such as resolving pre-declared values
      (such as the _export table) or executing specific shared code.

    The FOOTER is the same as the header, but at the very bottom of the file.
    This section is used for final wrap-up, such as returning the file's exported values.

    Grammars can declare special header/footer lines which will always be
      inserted at the very beginning or end of the file, suitable for things
      such as locking a file into a sandbox or forcing it to return a module.

    The BODY is the main content of the code, and the main concern of the grammar.
    BODY lines are executed in CHUNKS, collections of a few related lines at a time.

    Within a CHUNK, lines to edit are stored on a stack. Output rules have the ability
      to create new header and footer lines, create new lines positioned before/after the
      current working line, in the chunk, and push/pop lines to the stack to change the
      current working line.

    Output is always written to the current working line, and rules are responsible for
      managing the stack responsibly and cleaning up after themselves.

    When a chunk is complete, the lines are added to the compiled BODY and a new chunk
      is put in position for editing.
    When the end of the file is reached, the HEADER, BODY, and FOOTER are added together
      and the final lines written to the output.

    Most rules will not need to create new lines. When a line/chunk is created, the creating rule is
      responsible for assigning the source line number.
]]

local path = (...):gsub("parser[./\\]output", "")
local deepcopy = require(path .. "utils/deepcopy")

---@class outp_line
---@field __chunk lux_output
---@field __lastln number
---@field __tobackfill table
local line = {}
line.__index = line

function line:append(text, linenum)
    if type(text) ~= "string" then
        error("invalid first argument; expected string", 2)
    end
    linenum = linenum or self.__lastln or "?"
    for text in string.gmatch(text .. "\n", "[^\n]+\n") do
        text = text:gsub("\n", "")
        local outtab = {tostring(text), linenum}
        if linenum == "?" then
            table.insert(self.__tobackfill, outtab)
        else
            for _,tab in ipairs(self.__tobackfill) do
                tab[2] = linenum
            end
            self.__tobackfill = {}
        end
        table.insert(self, outtab)
    end
    self.__lastln = linenum
    return self
end

function line:pop()
    self.__chunk:pop()
    -- table.remove(self.__chunk.stack)
end

---@class lux_output_scope
---@field __chunk lux_output
---@field __parent outp_line
local scope = {}
scope.__index = scope
local new_scope

function scope:push()
    local ch = self.__chunk
    local newscope = new_scope(ch, self)
    newscope.__parent = self
    ch.scope = newscope
end

function scope:pop()
    local ch = self.__chunk
    ch.scope = self.__parent
end

function new_scope(output, prev)
    if not prev then
        prev = setmetatable({}, scope)
    end
    local tab = deepcopy(prev)
    tab.__chunk = output
    return tab
end






---@class lux_output
---@field _header table
---@field _footer table
---@field _body table
---@field _stack table
---@field _array table
---@field scope table
---@field data table
local output = {}
output.__index = output

---@return outp_line
function output:_new_line()
    local ln = {}
    ln._chunk = self
    ln.__tobackfill = {}
    return setmetatable(ln, line)
end 

function output:push_prior()
    local index = 1
    for i, v in ipairs(self._array) do
        if v == self._stack[#self._stack] then
            index = i
        end
    end
    local line = self:_new_line()
    self:_push(line, index)
    -- table.insert(self._array, index, line)
    return line
end

function output:push_next()
    local index = 1
    for i, v in ipairs(self._array) do
        if v == self._stack[#self._stack] then
            index = i + 1
        end
    end
    local line = self:_new_line()
    self:_push(line, index)
    -- table.insert(self._array, index, line)
    return line
end

function output:push_header()
    local line = self:_new_line()
    table.insert(self._header, line)
    table.insert(self._stack, line)
    return line
end

function output:push_footer()
    local line = self:_new_line()
    table.insert(self._footer, line)
    table.insert(self._stack, line)
    return line
end

function output:_push(line, index)
    line = line or self:_new_line()
    index = index or #self._array + 1
    table.insert(self._array, index, line)
    table.insert(self._stack, line)

    return line
end

function output:line()
    return self._stack[#self._stack]
end

function output:flush()
    table.insert(self._body, self._array)
    self._array = {}
    self._stack = {}
    self:_push()
end

local function ch_append(self, text)
    table.insert(self, text)
end

function output:push_catch()
    local line = { append = ch_append }
    table.insert(self._stack, line)
end

function output:pop()
    local ln = table.remove(self._stack)
    if ln.append == ch_append then
        return table.concat(ln, " ")
    else
        return self._stack[#self._stack]
    end
end

local function do_lines(line, concat, last_num, linemap)

    local concat2 = {}
    for _,txt in ipairs(line) do

        local msg = txt[1]
        if (last_num ~= nil and last_num ~= txt[2]) or _ == #line then
            if last_num == nil then
                last_num = txt[2]
            end
            if _ == #line and last_num == txt[2] then
                table.insert(concat2, msg)
                -- linemap[#linemap+1] = txt[2]
            end
            if #concat2 > 0 then
                table.insert(concat2, "--" .. last_num)
                table.insert(concat,(table.concat(concat2, " ")))
                linemap[#linemap+1] = last_num
            end
            concat2 = {}
            if _ == #line and (last_num ~= nil and last_num ~= txt[2]) then
                table.insert(concat, txt[1] .. "--" .. txt[2])
                linemap[#linemap+1] = txt[2]
            end
            last_num = txt[2]
        elseif last_num == nil then
            last_num = txt[2]
        end
        table.insert(concat2, msg)
    end
    return last_num
end

function output:print()
    self:flush()
    local concat = {}
    local msg = {}
    local linemap = {}
    local last_num
    for _, line in ipairs(self._header) do
        last_num = do_lines(line, concat, last_num, linemap)
    end
    table.insert(concat,"----")
    table.insert(linemap, last_num)
    for _, chunk in ipairs(self._body) do
        for _, line in ipairs(chunk) do
            last_num = do_lines(line, concat, last_num, linemap)
        end
    end
    table.insert(concat,"---")
    table.insert(linemap, last_num)
    for _, line in ipairs(self._footer) do
        last_num = do_lines(line, concat, last_num, linemap)
    end
    return table.concat(concat, "\n"), linemap
end


---@return lux_output
local function new_output()
    local out = {}
    out._header = {}
    out._footer = {}
    out._body = {}

    out._stack = {}
    out._array = {}
    out.data = {}
    setmetatable(out, output)

    out.scope = new_scope(out)
    out:_push()
    return out
end

return new_output