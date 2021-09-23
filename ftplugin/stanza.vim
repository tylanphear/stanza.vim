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
endfunction!

function! s:JumpToIndent(indent, flags)
    let pos = searchpos('^'.repeat(' ', a:indent).'\zs\S', a:flags.'W')
    if pos != [0, 0]
        call cursor(pos)
    endif
endfunction!

function! s:UpIndent()
    call <SID>JumpToIndent(indent(line('.')) - shiftwidth(), 'b')
endfunction!

function! s:DownIndent()
    call <SID>JumpToIndent(indent(line('.')) + shiftwidth(), '')
endfunction!

nnoremap <Plug>(stanza-up-indent)   :<C-u>call <SID>UpIndent()<CR>
nnoremap <Plug>(stanza-down-indent) :<C-u>call <SID>DownIndent()<CR>

let b:undo_ftplugin = "
            \setlocal iskeyword< cinkeys< indentkeys< include< define< comments< commentstring< formatoptions<
            \|delfunction! FindStanzaEntity"

let &cpo = s:saved_cpo
unlet s:saved_cpo

let b:did_ftplugin = 1
