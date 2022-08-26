return [[@keywords {
    "break",
    "goto",
    "do",
    "end",
    "while",
    "repeat",
    "until",
    "in",
    "if",
    "then",
    "elseif",
    "else",
    "for",
    "function",
    "local",
    "return",
    "nil",
    "false",
    "true",
    "and",
    "or",
    "not"
  }

@operators {
    '==',
    '<=',
    '>=',
    '~=',
    '::',
    '...',
    '..',
  }

START -> chunk

chunk -> block

block -> {statement} [return_statement] {%
		out.scope:push()
		out:flush()
		local stlist = self.children[1]:print(out, true)
		for _,stat in ipairs(stlist) do
			stat:print(out)
            out:push_next()
		end
		if #self.children[2].children > 0 then
			self.children[2]:print(out)
		end
		out.scope:pop()
	%}

statement -> ';'
    | assignment
    | function_call
    | label
    | break
    | goto Name
    | do_block
    | while_block
    | repeat_block
    | if_statement
    | for_numeric
    | for_in
    | function_assignment
    | local_function_assignment
    | local_assignment

assignment -> variable_list '=' expression_list
do_block -> do block end
while_block -> while expression do_block
repeat_block -> repeat block until expression
if_statement -> if expression then block {elseif expression then block} [else block] end
for_numeric -> for Name '=' expression ',' expression [',' expression] do_block
for_in -> for name_list in expression_list do_block
function_assignment -> function function_name function_body
local_function_assignment -> local function Name function_body
local_assignment -> local name_list ['=' expression_list]

return_statement -> return [expression_list] [';']

label -> '::' Name '::'

function_name -> Name {'.' Name} [':' Name]

variable_list -> variable {',' variable}
name_list -> Name {',' Name}
expression_list -> expression {',' expression}

variable -> Name
    | prefix_expression '[' expression ']'
    | prefix_expression '.' Name

expression -> nil
    | false
    | true
    | Number
    | String
    | '...'
    | anonymous_function
    | prefix_expression
    | table_constructor
    | expression binop expression
    | unop expression

prefix_expression -> variable
    | function_call
    | '(' expression ')'

function_call -> prefix_expression [':' Name] arguments

arguments -> '(' [expression_list] ')'
    | table_constructor
    | String

anonymous_function -> function function_body

function_body -> '(' [paramlist] ')' block end

paramlist -> name_list [',' '...']
    | '...'

table_constructor -> '{' [field_list] '}'

field_list -> field {field_separator field} [field_separator]

field -> '[' expression ']' '=' expression
    | Name '=' expression
    | expression

field_separator -> ',' | ';'

binop -> '+'
    | '-'
    | '*'
    | '/'
    | '^'
    | '%'
    | '..'
    | '<'
    | '<='
    | '>'
    | '>='
    | '=='
    | '~='
    | 'and'
    | 'or'

unop -> '-' | not | '#'
]]
