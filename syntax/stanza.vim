" Vim syntax file
" Language: Stanza
" Maintainer: Tyler Lanphear
" Last Change: 2021 Aug 18

if exists("b:current_syntax") | finish | endif

let s:saved_cpo = &cpo
set cpo&vim

syn keyword stanzaKeyword in let let-var where with within label switch match to through by not and or fn fn* generate yield break attempt do return val var
syn keyword stanzaException try catch finally throw
syn keyword stanzaConditional if else when
syn keyword stanzaRepeat for while
syn keyword stanzaBoolean true false
syn keyword stanzaAccess public protected private
syn keyword stanzaThis this
syn keyword stanzaBuiltinType True False Byte Int Long Float Double String Char Symbol ?
syn keyword stanzaTypeOperator upcast-as as as? is-not is new nextgroup=stanzaAnnotatedType skipwhite
syn keyword stanzaNull null
syn keyword stanzaFatal fatal fatal!

syn keyword stanzaKeyword defsyntax defrule defproduction fail-if nextgroup=stanzaMacroName skipwhite
syn match stanzaMacroName display contained "\K\k*"

syn region stanzaPackageDefinition matchgroup=stanzaKeyword start="^\z(\s*\)defpackage" matchgroup=NONE end="^\z1\S"me=e-1 contains=stanzaInclude,stanzaOperator,stanzaTabError
syn keyword stanzaInclude contained from import with

syn cluster stanzaCommonTop contains=stanzaKeyword,stanzaConditional,stanzaRepeat,stanzaBoolean,stanzaBuiltinType,stanzaDirective,stanzaOperator,stanzaTypeOperator,stanzaNumber,stanzaComment,stanzaBlockComment,stanzaString,stanzaRawString,stanzaTabError

syn region stanzaLostanza matchgroup=stanzaAccess start="lostanza" matchgroup=NONE end="^\S"me=e-1 contains=@stanzaLostanzaTop
syn cluster stanzaLostanzaTop contains=@stanzaCommonTop,stanzaLostanzaBuiltinType,stanzaLostanzaKeywords
syn keyword stanzaLostanzaBuiltinType int byte ref long float double ptr contained
syn keyword stanzaLostanzaKeywords call-c call-prim goto sizeof labels contained

syn match stanzaTabError "\t\+" display

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
syn match stanzaOperator "\k\@<!\%(\~\|\~@\|\^\|\$\|-\|+\|\*\|/\|%\|!=\|==\|=\)\k\@!"

" This has to come *after* the matches for `:`, `<`, `-`, and `>` so it takes priority
syn match stanzaTypeAnnotation "\%(->\|<:\)" nextgroup=stanzaAnnotatedType skipwhite
syn match stanzaAnnotatedType "\K\k*" display contained

syn keyword stanzaTodo TODO FIXME NOTE

syn region stanzaComment start=";" end="$" contains=stanzaTodo,@Spell oneline

" A block comment is started with ;<TAG> and then ended by <TAG>
syn region stanzaBlockComment start=";\z(<[^>]*>\)" end="\z1" contains=stanzaTodo,@Spell

syn match stanzaCapture "?\w\+" display

syn match stanzaSymbol "`\k\+" display
syn match stanzaDirective "\k\@<!#\K\k*"

syn match stanzaNumber "\<-\?\d\{1,3\}[yY]\>"
syn match stanzaNumber "\<-\?\d\{1,12\}\>"
syn match stanzaNumber "\<-\?\d\{1,19\}[lL]\>"
syn match stanzaNumberError "\<-\?\d\{4,\}[yY]\>"
syn match stanzaNumberError "\<-\?\d\{13,\}\>"
syn match stanzaNumberError "\<-\?\d\{20,\}[lL]\>"

syn match stanzaNumber "\<-\?0x\x\{1,2\}[yY]\>"
syn match stanzaNumber "\<-\?0x\x\{1,8\}\>"
syn match stanzaNumber "\<-\?0x\x\{1,16\}[lL]\?\>"
syn match stanzaNumberError "\<-\?0x\x\{3,\}[yY]\>"
syn match stanzaNumberError "\<-\?0x\x\{9,\}\>"
syn match stanzaNumberError "\<-\?0x\x\{17,\}[lL]\?\>"

syn match stanzaNumber "\<-\?0o\o\{1,3\}[yY]\>"
syn match stanzaNumber "\<-\?0o\o\{1,11\}\>"
syn match stanzaNumber "\<-\?0o\o\{1,22\}[lL]\>"
syn match stanzaNumberError "\<-\?0o\o\{4,\}[yY]\>"
syn match stanzaNumberError "\<-\?0o\o\{12,\}\>"
syn match stanzaNumberError "\<-\?0o\o\{23,\}[lL]\>"

syn match stanzaNumber "\<0b[01]\{1,8\}[yY]\>"
syn match stanzaNumber "\<0b[01]\{1,32\}\>"
syn match stanzaNumber "\<0b[01]\{1,64\}[lL]\>"
syn match stanzaNumberError "\<0b[01]\{9,\}[yY]\>"
syn match stanzaNumberError "\<0b[01]\{33,\}\>"
syn match stanzaNumberError "\<0b[01]\{65,\}[lL]\>"

syn match stanzaNumber "\<-\?\d\+\.\d*\%(e[\-0-9]\+\)\?[fF]\?"

syn match stanzaCharacter "'\%(\\.\|.\)'" contains=stanzaEscape,stanzaEscapeError
syn match stanzaCharacterError "''"
syn match stanzaCharacterError "'\%([^\\][^']\{1,\}\|\\[^']\{2,\}\)'"

syn region stanzaString matchgroup=stanzaQuotes start=+"+ end=+"+ skip=+\\\\\|\\"+ contains=stanzaEscape,stanzaEscapeError,stanzaContinuation,stanzaFormatSpecifier

syn match stanzaFormatSpecifier "%[_*,~@]" contained
syn match stanzaContinuation "\\\n\s*" contained
syn match stanzaEscape +\\[bnrt'"\\]+ contained
syn match stanzaEscapeError "\\[^bnrt'"\\]" contained

syn region stanzaAnonymousFn start="{" end="}" contains=@stanzaAnonFnTop,stanzaAnonymousParameter transparent
syn cluster stanzaAnonFnTop contains=@stanzaCommonTop,stanzaException,stanzaThis,stanzaSymbol

syn match stanzaAnonymousParameter "_\d\?" display contained

syn region stanzaRawString matchgroup=stanzaQuotes start="\\\z(<\k\+>\)" end=+\z1+

syn sync match stanzaSync grouphere NONE "^\s*\%(\%(public\|private\|protected\)\s*\)\?\%(defpackage\|defn\|defstruct\)\s\+\K\k*"

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
hi def link stanzaNull Constant
hi def link stanzaLostanzaKeywords Statement
hi def link stanzaLostanzaKeywordsError Error
hi def link stanzaTabError Error
hi def link stanzaNumberError Error
hi def link stanzaEscapeError Error
hi def link stanzaCharacterError Error
hi def link stanzaFatal PreCondit
hi def link stanzaTodo Todo

" Grab the first line of the file and check for a #use-added-syntax directive
let s:first_line_of_file = getline(1)
let s:syntax_matches = matchlist(s:first_line_of_file, "#use-added-syntax(\\(.\\{-}\\))")
let s:added_syntax = get(s:syntax_matches, 1, "")

if s:added_syntax != ""
    " Restrict runtimepath so we only load Stanza syntax modules
    let s:saved_runtimepath = &runtimepath
    let s:this_runtimepath = expand('<sfile>:p:h')
    if has_key(g:, 'stanza_syntax_modules')
        let s:this_runtimepath .= ','.g:stanza_syntax_modules
    endif
    exec 'set runtimepath='.s:this_runtimepath
    exec 'runtime! '.s:added_syntax.'.vim'
    exec 'set runtimepath='.s:saved_runtimepath
endif

let &cpo = s:saved_cpo
unlet s:saved_cpo

let b:current_syntax = "stanza"
