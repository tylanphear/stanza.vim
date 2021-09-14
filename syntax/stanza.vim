" Vim syntax file
" Language: Stanza
" Maintainer: Tyler Lanphear
" Last Change: 2021 Aug 18

if exists("b:current_syntax") | finish | endif

let s:saved_cpo = &cpo
set cpo&vim

syn keyword stanzaKeyword let let-var where with within label switch match to through by not and or fn fn* generate yield break attempt do
syn keyword stanzaException try catch finally throw
syn keyword stanzaConditional if else when
syn keyword stanzaRepeat for while in
syn keyword stanzaBoolean true false
syn keyword stanzaThis this
syn keyword stanzaBuiltinType True False Byte Int Long Float Double String Char Void Symbol
syn keyword stanzaQuestionType ?
syn keyword stanzaTypeOperator upcast-as as as? is-not is new nextgroup=stanzaCompositeType skipwhite
syn keyword stanzaNull null
syn keyword stanzaFatal fatal fatal!

syn keyword stanzaKeyword val var nextgroup=stanzaBindingName skipwhite
syn match stanzaBindingName "\K\k*" contained nextgroup=stanzaVariableType skipwhite
syn region stanzaVariableType matchgroup=stanzaOperator start=":" end="=\|$" contains=stanzaCompositeType,@stanzaComments

" Defined as a match group instead of a set of keywords. This is technically
" incorrect, but is done so that later matches that can contain access
" specifiers (like `stanzaLostanza`) can override this match.
syn match stanzaAccess "public\|protected\|private"

" Any kind of tabs outside of strings and comments are an error in Stanza
" (Stanza doesn't allow tabs!)
syn match stanzaTabError "\t\+" display

" Operators that can't appear in Stanza identifiers
syn match stanzaOperator "\%(:\||\|&\|\$>\|<\|<=\|>\|>=\|=>\)"
" Operators that *can* appear in Stanza identifiers
syn match stanzaOperator "\k\@<!\%(\~\|\~@\|\^\|\$\|-\|+\|\*\|/\|%\|!=\|==\|=\)\k\@!"

syn keyword stanzaKeyword defsyntax defrule defproduction fail-if nextgroup=stanzaMacroName skipwhite
syn match stanzaMacroName display contained "\K\k*"

" Package definition (e.g. `defpackage Foo:\n import Bar`)
syn region stanzaPackageDefinition matchgroup=stanzaKeyword start="^\z(\s*\)\zs\<defpackage\>" matchgroup=NONE skip="^\(\z1\s\|$\)" end="^" contains=TOP
syn keyword stanzaInclude contained from import with containedin=stanzaPackageDefinition

" LoStanza definition (e.g. `lostanza defn String (s: ptr<byte>) -> ref<String>`)
" NOTE: some syntax items are only allowed in `lostanza` definitions and
" should only be highlighted within them.
syn region stanzaLostanza matchgroup=stanzaAccess start="^\z(\s*\)\%(\%(public\|protected\|private\)\s\+\)\?lostanza" matchgroup=NONE skip="^\(\z1\s\|$\)" end="^" contains=TOP,stanzaAnonymousFn,stanzaCurriedFunctionCall,stanzaAppliedFunction

" LoStanza types that are invalid outside of `lostanza` or `extern`
syn keyword stanzaLostanzaBuiltinType byte int long float double ref ptr contained containedin=stanzaLostanza,stanzaExternDecl

" LoStanza keywords that are invalid outside of `lostanza`
syn keyword stanzaLostanzaKeyword return call-c call-prim goto sizeof labels contained containedin=stanzaLostanza

" Extern definition (e.g. `extern malloc: (long) -> ptr<byte>`)
syn keyword stanzaExtern extern nextgroup=stanzaExternFunctionName skipwhite
syn match stanzaExternFunctionName "\K\k*" contained nextgroup=stanzaExternFunctionType skipwhite
syn region stanzaExternFunctionType matchgroup=stanzaOperator start=":" matchgroup=NONE end="$" contained contains=stanzaLostanzaBuiltinType,stanzaQuestionType oneline

" Function definition (e.g. `defn to-int (s: String) -> Int`)
syn keyword stanzaKeyword defn defn* defmulti defmethod nextgroup=stanzaFunctionName skipwhite
syn match stanzaFunctionName "\K\k*" display contained nextgroup=stanzaFunctionParams,stanzaFunctionGenericParams skipwhite
syn region stanzaFunctionGenericParams matchgroup=stanzaAngleBrackets start="<" end=">" contained contains=stanzaType,stanzaCapture nextgroup=stanzaFunctionParams skipwhite
syn region stanzaFunctionParams start="(" end=")" contained contains=stanzaFunctionParam,stanzaFunctionParams,stanzaThis,@stanzaComments nextgroup=stanzaFunctionReturn skipwhite
syn region stanzaFunctionNestedParams start="(" end=")" contained contains=stanzaFunctionNestedParams,stanzaCompositeType nextgroup=stanzaFunctionNestedReturn skipwhite
syn region stanzaFunctionParam matchgroup=stanzaOperator start=":" matchgroup=NONE end=",\|)\|$"me=e-1 contained contains=stanzaFunctionNestedParams,stanzaCompositeType,@stanzaComments
syn region stanzaFunctionReturn matchgroup=stanzaOperator start="->" end=":\|$" contained contains=stanzaCompositeType,@stanzaComments
syn region stanzaFunctionNestedReturn matchgroup=stanzaOperator start="->" matchgroup=NONE end=",\|)"me=e-1 contained contains=stanzaCompositeType

syn match stanzaCompositeType "\K\k*\%(<[^>]*>\)\?" contained contains=stanzaType,stanzaAngleBrackets,stanzaCapture,stanzaQuestionType nextgroup=stanzaAndOr skipwhite
syn match stanzaType "\K\k*" contained

syn match stanzaAngleBrackets "<\|>" contained
syn match stanzaAndOr "|\|&" contained nextgroup=stanzaCompositeType skipwhite

" Struct/type/enum definition (e.g. `deftype Foo`)
syn keyword stanzaKeyword defstruct deftype defenum nextgroup=stanzaStructName skipwhite
syn match stanzaStructName "\K\k*" display contained

" This has to come *after* the matches for `<` and `:` so it takes priority
syn match stanzaTypeAnnotation "<:" nextgroup=stanzaCompositeType skipwhite

syn keyword stanzaTodo TODO FIXME NOTE

syn region stanzaComment start=";" end="$" contains=stanzaTodo,@Spell oneline

" A block comment is started with ;<TAG> and then ended by <TAG>
syn region stanzaBlockComment start=";<\z([^>]*\)>" end="<\z1>" contains=stanzaTodo,@Spell

syn cluster stanzaComments contains=stanzaComment,stanzaBlockComment

" Captured type arguments (e.g. `defn foo<?T>`) or captured syntax match
" groups (e.g. `?tag:id`)
syn match stanzaCapture "?\K\k*" display

" Stanza symbols can also contain forward slashes
syn match stanzaSymbol "`\%(\k\|/\)\+" display

" All kinds of Stanza numbers with their associated prefixes and suffixes

" Stanza decimal numbers (byte, int, long)
syn match stanzaNumber "\<-\?\d\{1,3\}[yY]\>"
syn match stanzaNumber "\<-\?\d\{1,12\}\>"
syn match stanzaNumber "\<-\?\d\{1,19\}[lL]\>"
syn match stanzaNumberError "\<-\?\d\{4,\}[yY]\>"
syn match stanzaNumberError "\<-\?\d\{13,\}\>"
syn match stanzaNumberError "\<-\?\d\{20,\}[lL]\>"

" Stanza octal numbers (byte, int, long)
syn match stanzaNumber "\<-\?0x\x\{1,2\}[yY]\>"
syn match stanzaNumber "\<-\?0x\x\{1,8\}\>"
syn match stanzaNumber "\<-\?0x\x\{1,16\}[lL]\?\>"
syn match stanzaNumberError "\<-\?0x\x\{3,\}[yY]\>"
syn match stanzaNumberError "\<-\?0x\x\{9,\}\>"
syn match stanzaNumberError "\<-\?0x\x\{17,\}[lL]\?\>"

" Stanza hexadecimal numbers (byte, int, long)
syn match stanzaNumber "\<-\?0o\o\{1,3\}[yY]\>"
syn match stanzaNumber "\<-\?0o\o\{1,11\}\>"
syn match stanzaNumber "\<-\?0o\o\{1,22\}[lL]\>"
syn match stanzaNumberError "\<-\?0o\o\{4,\}[yY]\>"
syn match stanzaNumberError "\<-\?0o\o\{12,\}\>"
syn match stanzaNumberError "\<-\?0o\o\{23,\}[lL]\>"

" Stanza binary numbers (byte, int, long)
syn match stanzaNumber "\<0b[01]\{1,8\}[yY]\>"
syn match stanzaNumber "\<0b[01]\{1,32\}\>"
syn match stanzaNumber "\<0b[01]\{1,64\}[lL]\>"
syn match stanzaNumberError "\<0b[01]\{9,\}[yY]\>"
syn match stanzaNumberError "\<0b[01]\{33,\}\>"
syn match stanzaNumberError "\<0b[01]\{65,\}[lL]\>"

" Stanza float/doubles
syn match stanzaFloat "\<-\?\d\+\.\d*\%(e[\-0-9]\+\)\?[fF]\?"

" Stanza characters, as well as some associated errors
syn match stanzaCharacter "'\%(\\.\|.\)'" contains=stanzaEscape,stanzaEscapeError
syn match stanzaCharacterError "''"
syn match stanzaCharacterError "'\%([^\\][^']\{1,\}\|\\[^']\{2,\}\)'\?"

syn region stanzaString matchgroup=stanzaQuotes start=+"+ end=+"+ skip=+\\\\\|\\"+ contains=stanzaEscape,stanzaEscapeError,stanzaContinuation,stanzaFormatSpecifier

syn region stanzaRawString matchgroup=stanzaQuotes start="\\<\z([^>]*\)>" end="<\z1>" contains=stanzaFormatSpecifier

syn match stanzaFormatSpecifier "%[_*,~@]" contained
syn match stanzaContinuation "\\\ze\n\s*" contained
syn match stanzaEscape +\\[bnrt'"\\]+ contained
syn match stanzaEscapeError "\\[^bnrt'"\\]" contained

syn region stanzaAnonymousFn start="{" end="}" contains=TOP

syn match stanzaAnonymousParameter "_\d*" display contained containedin=stanzaAnonymousFn

" Function calls (e.g. `foo(...)`)
syn match stanzaFunctionCall "\K\k*\ze("
syn match stanzaFunctionCall "\K\k*\ze\%(<\K\%(\k\|,\|\s\)*>\)\?("

" Curried function calls (e.g. `foo{...}`)
syn match stanzaCurriedFunctionCall "\K\k*\ze{" nextgroup=stanzaAnonymousFn
syn match stanzaCurriedFunctionCall "\K\k*\ze\%(<\K\%(\k\|,\|\s\)*>\)\?{" nextgroup=stanzaAnonymousFn

" Applied function calls (e.g. `foo $ ...`)
syn match stanzaAppliedFunction "\K\k*\ze\s\+\$"

" Has to come after `stanzaFunctionCall`, since there are some directives
" (e.g. `#if-defined(`) that could also be highlighted as a function call.
syn match stanzaDirective "\k\@<!#\K\k*"

syn sync match stanzaSync grouphere stanzaLostanza "^\s*\%(\%(public\|private\|protected\)\s\+\)\?lostanza\s*"

hi def link stanzaAccess StorageClass
hi def link stanzaType Type
hi def link stanzaCompositeTypeInner stanzaType
hi def link stanzaBlockComment Comment
hi def link stanzaBoolean Boolean
hi def link stanzaBuiltinType stanzaType
hi def link stanzaQuestionType stanzaType
hi def link stanzaLostanzaBuiltinType stanzaType
hi def link stanzaCapture Special
hi def link stanzaCharacter Character
hi def link stanzaComment Comment
hi def link stanzaConditional Conditional
hi def link stanzaDirective PreProc
hi def link stanzaEscape Special
hi def link stanzaContinuation Special
hi def link stanzaException Exception
hi def link stanzaFormatSpecifier Special
hi def link stanzaFunctionName Function
hi def link stanzaFunctionCall Function
hi def link stanzaCurriedFunctionCall stanzaFunctionCall
hi def link stanzaAppliedFunction stanzaFunctionCall
hi def link stanzaExtern stanzaKeyword
hi def link stanzaExternFunctionName stanzaFunctionName
hi def link stanzaInclude Include
hi def link stanzaKeyword Statement
hi def link stanzaNumber Number
hi def link stanzaFloat Float
hi def link stanzaOperator Operator
hi def link stanzaAngleBrackets stanzaOperator
hi def link stanzaString String
hi def link stanzaQuotes stanzaString
hi def link stanzaRawString stanzaString
hi def link stanzaRepeat Repeat
hi def link stanzaStructName Structure
hi def link stanzaSymbol Macro
hi def link stanzaTypeAnnotation Operator
hi def link stanzaTypeOperator Operator
hi def link stanzaAndOr stanzaTypeOperator
hi def link stanzaThis Constant
hi def link stanzaAnonymousParameter Macro
hi def link stanzaNull Constant
hi def link stanzaLostanzaKeyword stanzaKeyword
hi def link stanzaError Error
hi def link stanzaTabError stanzaError
hi def link stanzaNumberError stanzaError
hi def link stanzaEscapeError stanzaError
hi def link stanzaCharacterError stanzaError
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
