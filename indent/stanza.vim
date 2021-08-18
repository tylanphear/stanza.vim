" Vim indent file
" Language:    Stanza
" Author:      Tyler Lanphear <t.lanphear@jitx.com>
" Last Change: 2021 Aug 18

" Only load this indent file when no other was loaded.
if exists("b:did_indent") | finish | endif

let s:saved_cpo= &cpo
set cpo&vim

setlocal nolisp
setlocal autoindent

setlocal indentexpr=GetStanzaIndent(v:lnum)
setlocal indentkeys+=<:>

" Only define the function once.
if exists("*GetStanzaIndent")
  finish
endif

function! GetStanzaIndent(lnum)

  " If the start of the line is in a string don't change the indent.
  if has('syntax_items')
	\ && synIDattr(synID(a:lnum, 1, 1), "name") =~ "String$"
    return -1
  endif

  " Search backwards for the previous non-empty line.
  let plnum = prevnonblank(v:lnum - 1)
  if plnum == 0
    " This is the first non-empty line, use zero indent.
    return 0
  endif

  " Move the cursor to the first non-blank line and grab some relevant info
  " about the line and its indentation
  call cursor(plnum, 1)
  let plindent = indent(plnum)
  let pline = getline(plnum)
  let pline_len = len(pline)

  " If the line was a comment or a string, don't try to indent
  if has('syntax_items') &&
        \ synIDattr(synID(plnum, pline_len, 1), "name") =~ "Comment$"
    return -1
  endif

  " If the line ends with a colon (:) or an equals (=), indent
  if pline =~ '\(:\|=\)\s*$'
    return plindent + shiftwidth()
  endif

  " If the line begins with else, dedent
  if getline(a:lnum) =~ '^\s*else\>'
    return plindent - shiftwidth()
  endif

  return -1

endfunction

let b:undo_indent = "
            \setlocal lisp< autoindent< indentexpr< indentkeys<
            \| delfunction! GetStanzaIndent"

let &cpo = s:saved_cpo
unlet s:saved_cpo

let b:did_indent = 1
