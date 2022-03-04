if exists("current_compiler") | finish | endif
let current_compiler = "stanza"

let s:save_cpo = &cpo
set cpo&vim

if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif

let b:stanza_command = get(g:, 'stanza_command', 'stanza')

exec 'CompilerSet makeprg='.b:stanza_command

CompilerSet errorformat=%E%f:%l.%c:\ %m,%C\ \ %m

let &cpo = s:save_cpo
unlet s:save_cpo
