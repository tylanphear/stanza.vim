" Vim filetype plugin file
" Language:    Stanza
" Author:      Tyler Lanphear <t.lanphear@jitx.com>
" Last Change: 2021 Aug 10

if exists("b:did_ftplugin") | finish | endif

let s:saved_cpo= &cpo
set cpo&vim

setlocal iskeyword+=-,*,?,!,/

setlocal cinkeys-=0#
setlocal indentkeys-=0#

setlocal include=^\\s*import
setlocal define=^\\s*\\(public\\\|protected\\\|private\\)\\?\\s*\\(defn\\\|defmethod\\\|defstruct\\)

setlocal comments=:;
setlocal commentstring=;\ %s

setlocal formatoptions-=t formatoptions+=croqnl

let &cpo = s:saved_cpo
unlet s:saved_cpo

let b:did_ftplugin = 1
