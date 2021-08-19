" Vim syntax file
" Language: Stanza
" Maintainer: Tyler Lanphear
" Last Change: 2021 Aug 18

if exists("b:current_syntax") | finish | endif

let s:saved_cpo = &cpo
set cpo&vim

" Stanza stuff {{{1
syn keyword stanzaKeyword in let let-var where with within label switch match to through by not and or fn fn* generate yield break attempt do return fatal val var
syn keyword stanzaLostanzaKeywords call-c call-prim goto sizeof
syn keyword stanzaException try catch finally throw
syn keyword stanzaConditional if else when
syn keyword stanzaRepeat for while
syn keyword stanzaBoolean true false
syn keyword stanzaAccess public protected private lostanza
syn keyword stanzaThis this
syn keyword stanzaBuiltinType True False Byte Int Long Float Double String Char Symbol ?
syn keyword stanzaLostanzaBuiltinType int byte ref long float double ptr
syn keyword stanzaTypeOperator upcast-as as as? is-not is new nextgroup=stanzaAnnotatedType skipwhite
syn keyword stanzaNull null

syn keyword stanzaKeyword defsyntax defrule defproduction fail-if nextgroup=stanzaMacroName skipwhite
syn match stanzaMacroName display contained "\K\k*"

syn region stanzaPackageDefinition matchgroup=stanzaKeyword start="^\z(\s*\)defpackage" matchgroup=NONE end="^\z1\S"me=e-1 contains=stanzaInclude,stanzaOperator
syn keyword stanzaInclude contained from import

" Kind of a hack, but anything top-level (doesn't have `contains`) syntax
" group that can be contained in a stanza anonymous function should be added
" to this cluster
syn cluster stanzaAnonFnTop contains=stanzaKeyword,stanzaException,stanzaConditional,stanzaRepeat,stanzaBoolean,stanzaThis,stanzaBuiltinType,stanzaLostanzaBuiltinType,stanzaTypeOperator

syn match stanzaTabError "\t\+" display
syn cluster stanzaAnonFnTop add=stanzaTabError

syn keyword stanzaKeyword deftest nextgroup=stanzaTestParams,stanzaTestCase
syn region stanzaTestParams start="(" end=")" display contained contains=stanzaTestParam nextgroup=stanzaTestCase
syn match stanzaTestParam "\K\k*" display contained
syn match stanzaTestCase ")\? .\{-}:"hs=s+1,he=e-1 display contained

syn keyword stanzaKeyword defn defn* defmulti defmethod extern nextgroup=stanzaFunctionName skipwhite
syn match stanzaFunctionName "\K\k*" display contained

syn keyword stanzaKeyword defstruct deftype defenum nextgroup=stanzaStructName skipwhite
syn match stanzaStructName "\K\k*" display contained

" Operators that can't appear in Stanza identifiers
syn match stanzaOperator "\%(:\||\|&\|\$>\|<\|<=\|<\|>=\|>\|=>\)"
" Operators that *can* appear in Stanza identifiers
syn match stanzaOperator "\k\@<!\%(\~\|\^\|\$\|-\|+\|\*\|/\|%\|!=\|==\|=\)\k\@!"
syn cluster stanzaAnonFnTop add=stanzaOperator

" This has to come *after* the matches for `:`, `<`, `-`, and `>` so it takes priority
syn match stanzaTypeAnnotation "\%(->\|<:\)" nextgroup=stanzaAnnotatedType skipwhite
syn match stanzaAnnotatedType "\K\k*" display contained
syn cluster stanzaAnonFnTop add=stanzaTypeAnnotation

syn match stanzaComment ";.*$"
syn cluster stanzaAnonFnTop add=stanzaComment

" A block comment is started with ;<TAG> and then ended by <TAG>, where TAG
" can be any identifier
syn region stanzaBlockComment start=+;\z(<\k\+>\)+ end=+\z1+

syn match stanzaCapture "?\w\+" display

syn match stanzaDirective "#\K\k*"
syn cluster stanzaAnonFnTop add=stanzaDirective

syn match stanzaNumber "\<-\?\d\+[LY]\?\>"
syn match stanzaNumber "\<-\?\d\+\.\d*\%(e[\-0-9]\+\)\?[fF]\?"
syn match stanzaNumber "\<-\?0x\x\+[LY]\?\>"
syn match stanzaNumber "\<-\?0o\o\+\>"
syn match stanzaNumber "\<0b[01]\+\>"
syn cluster stanzaAnonFnTop add=stanzaNumber

syn match stanzaCharacter "'\%(\\[abfnrtv'"\\]\|.\)'"
syn cluster stanzaAnonFnTop add=stanzaCharacter

syn region stanzaString matchgroup=stanzaQuotes start=+"+ end=+"+ skip=+\\\\\|\\"+ contains=stanzaEscape,stanzaContinuation,stanzaFormatSpecifier
syn cluster stanzaAnonFnTop add=stanzaString

syn match stanzaFormatSpecifier "%[_*,~@]" contained
syn match stanzaEscape +\\[abfnrtv"\\]+ contained
syn match stanzaContinuation "\\\n\s*" contained

syn region stanzaAnonymousFn start="{" end="}" contains=@stanzaAnonFnTop,stanzaAnonymousParameter
syn match stanzaAnonymousParameter "_\d\?" display contained
syn cluster stanzaAnonFnTop add=stanzaAnonymousFn

syn region stanzaRawString matchgroup=stanzaQuotes start="\\\z(<\k\+>\)" end=+\z1+
syn cluster stanzaAnonFnTop add=stanzaRawString

syn match stanzaSymbol "`\k\+" display
syn cluster stanzaAnonFnTop add=stanzaSymbol

syn sync match stanzaSync grouphere NONE "^\s*\%(\%(public\|private\|protected\)\s*\)\?\%(defpackage\|defn\|defstruct\)\s\+\K\k*:"

hi def link stanzaAccess StorageClass
hi def link stanzaAnnotatedType Type
hi def link stanzaBlockComment Comment
hi def link stanzaBoolean Boolean
hi def link stanzaBuiltinType Type
hi def link stanzaLostanzaBuiltinType Type
hi def link stanzaCapture Type
hi def link stanzaCharacter String
hi def link stanzaComment Comment
hi def link stanzaConditional Conditional
hi def link stanzaDirective PreProc
hi def link stanzaEscape Special
hi def link stanzaContinuation Special
hi def link stanzaException Exception
hi def link stanzaFormatSpecifier Special
hi def link stanzaFunctionName Function
hi def link stanzaInclude Include
hi def link stanzaKeyword Statement
hi def link stanzaNumber Number
hi def link stanzaOperator Operator
hi def link stanzaQuotes String
hi def link stanzaRawString String
hi def link stanzaRepeat Repeat
hi def link stanzaString String
hi def link stanzaStructName Structure
hi def link stanzaSymbol Macro
hi def link stanzaTestCase Identifier
hi def link stanzaTestParam Define
hi def link stanzaTypeAnnotation Operator
hi def link stanzaTypeOperator Operator
hi def link stanzaThis Constant
hi def link stanzaVariableDefinition Statement
hi def link stanzaAnonymousParameter Macro
hi def link stanzaNull constant
hi def link stanzaLostanzaKeywords Statement
hi def link stanzaTabError Error

" }}}
" JITX stuff{{{1

" Grab the first line of the file and check for a #use-added-syntax directive
let s:first_line_of_file = getline(1)
let s:syntax_matches = matchlist(s:first_line_of_file, "#use-added-syntax(\\(.\\{-}\\))")
let s:added_syntax = get(s:syntax_matches, 1, "")

if s:added_syntax == "jitx" || s:added_syntax == "esir"
    syn keyword jitxKeyword pcb-module pcb-symbol pcb-component pcb-package pcb-design pcb-pad pcb-board pcb-landpattern pcb-material pcb-stackup
    syn keyword jitxKeyword port pin net require pad unique self
    syn keyword jitxKeyword at on
    syn keyword jitxType Bottom Top

    syn keyword jitxBuiltinFn place instances symbol property ref reference-designator schematic-group loc layer

    syn match jitxKeyword "^\s*\(public\|private\|protected\)\?\s*inst"hs=e-4 nextgroup=jitxInstName contains=stanzaAccess
    syn match jitxInstName "[^:]*" display contained

    syn match jitxKeyword "^\s*\(public\|private\|protected\)\?\s*net"hs=e-3 nextgroup=jitxNetName contains=stanzaAccess
    syn match jitxNetName "[^()]*" display contained nextgroup=jitxTypeAnnotation

    syn region jitxTypeAnnotation start=":" end="$" contained contains=jitxType
    syn match jitxType "\K[^\s]*" contained

    hi def link jitxKeyword Statement
    hi def link jitxBuiltinFn Macro
    hi def link jitxInstName Identifier
    hi def link jitxNetName Identifier
    hi def link jitxType Type
endif

let &cpo = s:saved_cpo
unlet s:saved_cpo

unlet s:first_line_of_file s:syntax_matches s:added_syntax

let b:current_syntax = "stanza"

"}}}
" vim: foldmethod=marker:
