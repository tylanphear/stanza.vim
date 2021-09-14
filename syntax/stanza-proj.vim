" Vim syntax file
" Language: Stanza project files
" Maintainer: Tyler Lanphear
" Last Change: 2021 Sep 13

if exists("b:current_syntax") | finish | endif

let s:saved_cpo = &cpo
set cpo&vim

syn keyword stanzaProjInclude include
syn keyword stanzaProjKeyword package defined-in requires
syn keyword stanzaProjKeyword build build-test
syn keyword stanzaProjKeyword compile from
syn keyword stanzaProjKeyword var

syn keyword stanzaProjBuildOption ccfiles ccflags external-dependencies inputs o optimize pkg s supported-vm-packages

syn region stanzaProjComment start=";" end="$" oneline

syn region stanzaProjString start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=stanzaProjEscape,stanzaProjEscapeError
syn match stanzaProjEscape +\\\\+ contained
syn match stanzaProjEscapeError "\\[^\\]" contained

hi def link stanzaProjInclude PreProc
hi def link stanzaProjKeyword Statement
hi def link stanzaProjComment Comment
hi def link stanzaProjString String
hi def link stanzaProjBuildOption Macro
hi def link stanzaError Error
hi def link stanzaProjStringError stanzaError
hi def link stanzaProjEscapeError stanzaError

let &cpo = s:saved_cpo
unlet s:saved_cpo

let b:current_syntax = "stanza-proj"
