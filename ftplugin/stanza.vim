" Vim filetype plugin file
" Language:    Stanza
" Author:      Tyler Lanphear <t.lanphear@jitx.com>
" Last Change: 2021 Aug 18

if exists("b:did_ftplugin") | finish | endif

let s:saved_cpo= &cpo
set cpo&vim

setlocal iskeyword+=~,!,@-@,#,*,$,%,?,+,-,=,^

setlocal cinkeys-=0#
setlocal indentkeys-=0#

setlocal include=^\\s*import
setlocal define=^\\s*\\(public\\\|protected\\\|private\\)\\?\\s*\\(defn\\\|defmethod\\\|defstruct\\)

setlocal comments=:;
setlocal commentstring=;\ %s

setlocal matchpairs+=<:>

setlocal formatoptions-=t formatoptions+=croqnl

function! FindStanzaEntity()
    let l:word = expand('<cword>')
    let l:pattern = '(defn|defmethod|defstruct|deftype|defenum)'
    if search(escape(l:pattern, '()|').' '.l:word.'\>', 'w') != 0
        " Add this location to the jumplist -- search() doesn't do that,
        " despite setting the cursor there
        k '
    else
        if exists('*FindStanzaEntityFallback')
            call FindStanzaEntityFallback(l:pattern, l:word)
        endif
    endif
endfunction

function! s:JumpToIndent(indent, flags)
    let pos = searchpos('^'.repeat(' ', a:indent).'\zs\S', a:flags.'nW')
    if pos != [0, 0]
        call cursor(pos)
    endif
endfunction

function! s:UpIndent()
    call s:JumpToIndent(indent(line('.')) - shiftwidth(), 'b')
endfunction

function! s:DownIndent()
    call s:JumpToIndent(indent(line('.')) + shiftwidth(), '')
endfunction

function! s:GetCurrentPackage()
    let l:defpackage_line = getline(search("^defpackage", 'bcnw'))
    let l:package = get(matchlist(l:defpackage_line, '^\s*defpackage\s*\(\S\+\)\s*:'), 1)
    return l:package
endfunction

function! s:GetCurrentTestPackage()
    let l:package = s:GetCurrentPackage()
    if l:package =~# '\<test\>'
        return l:package
    endif
    if get(b:, 'stanza_current_test_package', '') !=# ''
        return b:stanza_current_test_package
    endif
    if get(g:, 'stanza_current_test_package', '') !=# ''
        return g:stanza_current_test_package
    endif
    return l:package
endfunction

function! s:RunCurrentTestPackage()
    let l:stanza_cmd = get(g:, "stanza_command", "")
    if l:stanza_cmd ==# ''
        echo 'Error: no stanza command set (i.e. `g:stanza_command`)'
        return
    endif
    let l:package = s:GetCurrentTestPackage()
    if l:package ==# ''
        echo 'Error: could not determine current package: invalid or no `defpackage` detected.'
        return
    endif
    if l:package !~# 'test'
        echo 'Error: package `'.l:package.'` does not appear to be a test package.'
        if input('Run anyways? [y/N] ', 'N') == 'N'
            return
        endif
    endif
    execute l:stanza_cmd.' run-test '.l:package
endfunction

function! s:OpenReplInCurrentPackage()
    let l:stanza_cmd = get(g:, "stanza_command", "")
    if l:stanza_cmd ==# ''
        echo 'Error: no stanza command set (i.e. `g:stanza_command`)'
        return
    endif
    let l:package = s:GetCurrentPackage()
    if l:package ==# ''
        echo 'Error: could not determine current package: invalid or no `defpackage` detected.'
        return
    endif
    execute l:stanza_cmd.' repl '.l:package
endfunction

nnoremap <Plug>(stanza-up-indent)   <Cmd>call <SID>UpIndent()<CR>
nnoremap <Plug>(stanza-down-indent) <Cmd>call <SID>DownIndent()<CR>
nnoremap <Plug>(stanza-open-repl-in-current-package) <Cmd>call <SID>OpenReplInCurrentPackage()<CR>
nnoremap <Plug>(stanza-run-current-test-package) <Cmd>call <SID>RunCurrentTestPackage()<CR>

let b:undo_ftplugin = "
            \setlocal iskeyword< cinkeys< indentkeys< include< define< suffixesadd< comments< commentstring< matchpairs< formatoptions<
            \|delfunction! FindStanzaEntity
            \|nunmap <Plug>(stanza-up-indent)
            \|nunmap <Plug>(stanza-down-indent)
            \|nunmap <Plug>(stanza-open-repl-in-current-package)
            \|nunmap <Plug>(stanza-run-current-test-package)"

let &cpo = s:saved_cpo
unlet s:saved_cpo

let b:did_ftplugin = 1
