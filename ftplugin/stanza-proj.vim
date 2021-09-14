" Vim filetype plugin file
" Language:    Stanza project files
" Author:      Tyler Lanphear <t.lanphear@jitx.com>
" Last Change: 2021 Sep 13

if exists("b:did_ftplugin") | finish | endif

let s:saved_cpo= &cpo
set cpo&vim

setlocal iskeyword+=~,!,@-@,#,*,$,%,?,+,-,=,/,^

setlocal cinkeys-=0#
setlocal indentkeys-=0#

setlocal comments=:;
setlocal commentstring=;\ %s

setlocal formatoptions-=t formatoptions+=croqnl

let b:undo_ftplugin = "
            \setlocal iskeyword< cinkeys< indentkeys< comments< commentstring< formatoptions<"

let &cpo = s:saved_cpo
unlet s:saved_cpo

let b:did_ftplugin = 1
