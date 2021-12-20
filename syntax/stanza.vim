" Vim syntax file
" Language: Stanza
" Maintainer: Tyler Lanphear
" Last Change: 2021 Oct 27

if exists("b:current_syntax") | finish | endif

let s:saved_cpo = &cpo
set cpo&vim

syn keyword stanzaKeyword let-var where within switch to through by not and or yield break attempt with
syn keyword stanzaConditional if else when
syn keyword stanzaRepeat for while in
syn keyword stanzaBoolean true false
syn keyword stanzaThis this
syn keyword stanzaQuestionType ?
syn keyword stanzaTypeOperator upcast-as as as? is-not is new nextgroup=stanzaQualifiedType,stanzaCompositeType skipwhite
syn keyword stanzaNull null
syn keyword stanzaFatal fatal fatal!

" `let` binding with optional function params (e.g. `let foo (i = 0):`)
syn keyword stanzaKeyword let nextgroup=stanzaLetBinding skipwhite skipnl
syn match stanzaLetBinding "\K\k*" contained nextgroup=stanzaFunctionParams skipwhite

" Only match do when not of the form `do(`, which should be highlighted as a
" function call
syn match stanzaKeyword "\<do\>(\@!"

" generate<...> where ... is some arbitrary type
syn keyword stanzaKeyword generate nextgroup=stanzaOf

" label<...> where ... is some arbitrary type
syn keyword stanzaKeyword label nextgroup=stanzaOf

syn keyword stanzaException try finally throw
syn keyword stanzaException catch nextgroup=stanzaCatchClause skipwhite
syn region stanzaCatchClause start="(" end=")" contained contains=TOP
syn match stanzaCatchBinding "\K\k*\ze:" contained containedin=stanzaCatchClause contains=TOP nextgroup=stanzaCatchColon skipwhite
syn match stanzaCatchColon ":" contains=stanzaColon contained nextgroup=stanzaQualifiedType,stanzaCompositeType skipwhite

syn keyword stanzaKeyword val var nextgroup=stanzaBindingName skipwhite
syn match stanzaBindingName "\K\k*" contained nextgroup=stanzaVariableColon skipwhite
syn match stanzaVariableColon ":" contained contains=stanzaColon nextgroup=stanzaQualifiedType,stanzaCompositeType skipwhite

syn match stanzaAccess "\<\%(public\|protected\|private\)\>"

" Any kind of tabs outside of strings and comments are an error in Stanza
" (Stanza doesn't allow tabs!)
syn match stanzaTabError "\t\+" display

syn match stanzaColon ":"

" Operators that can appear in Stanza identifiers
syn match stanzaOperator "\k\@<!\%(\~\|\~@\|\^\|\$\|-\|+\|\*\|/\|%\|!=\|==\|=\)\k\@!"
" Operators that *can't* appear in Stanza identifiers
syn match stanzaOperator "\%(|\|&\|<\|<=\|>\|>=\|=>\)"

syn keyword stanzaKeyword defsyntax defrule fail-if nextgroup=stanzaMacroName skipwhite
syn match stanzaMacroName display contained "\K\k*"

syn keyword stanzaKeyword defproduction nextgroup=stanzaProductionName skipwhite
syn match stanzaProductionName display contained "\K\k*" nextgroup=stanzaProductionColon skipwhite
syn match stanzaProductionColon ":" contained contains=stanzaColon skipwhite skipnl nextgroup=stanzaQualifiedType,stanzaCompositeType

" Package definition (e.g. `defpackage Foo:\n import Bar`)
syn region stanzaPackageDefinition matchgroup=stanzaKeyword start="^\z(\s*\)\zs\<defpackage\>" matchgroup=NONE skip="^\(\z1\s\|$\)" end="^" contains=TOP
syn keyword stanzaInclude contained from import with containedin=stanzaPackageDefinition

syn match stanzaAccess "\<lostanza\>"

" LoStanza definition (e.g. `lostanza defn String (s: ptr<byte>) -> ref<String>`)
syn region stanzaLostanzaFunctionDefinition matchgroup=stanzaAccess start="^\z(\s*\)\%(\%(public\|protected\|private\)\s\+\)\?lostanza\ze\s\+defn\>" matchgroup=NONE skip="^\(\z1\s\|$\)" end="^" contains=TOP,stanzaAnonymousFn,stanzaCurriedFunctionCall,stanzaAppliedFunction

" LoStanza-specific keywords
syn keyword stanzaLostanzaKeyword return call-c call-prim goto sizeof labels

" Extern definition (e.g. `extern malloc: (long) -> ptr<byte>`)
syn keyword stanzaExtern extern nextgroup=stanzaKeyword,stanzaExternFunctionName skipwhite
syn match stanzaExternFunctionName "\K\k*" contained nextgroup=stanzaExternFunctionColon skipwhite skipnl
syn match stanzaExternFunctionColon ":" contained contains=stanzaColon nextgroup=stanzaCompositeType skipwhite skipnl

" Function definition (e.g. `defn to-int (s: String) -> Int`)
syn keyword stanzaKeyword defn defn* defmulti defmethod defmethod* nextgroup=stanzaFunctionName skipwhite
syn match stanzaFunctionName "\K\k*" display contained nextgroup=stanzaFunctionParams,stanzaFunctionGenericParams skipwhite
syn region stanzaFunctionGenericParams matchgroup=stanzaAngleBrackets start="<" end=">" contained contains=stanzaType,stanzaCapture nextgroup=stanzaFunctionParams skipwhite oneline
syn region stanzaFunctionParams start="(" end=")" contained contains=TOP nextgroup=stanzaOperator skipwhite skipnl
syn match stanzaFunctionParamColon ":" contains=stanzaColon contained containedin=stanzaFunctionParams nextgroup=stanzaQualifiedType,stanzaCompositeType skipwhite skipnl

syn match stanzaCompositeType "\K\k*\%(<.\{-}\)\?" contained contains=stanzaType,stanzaOf,stanzaCapture,stanzaQuestionType nextgroup=stanzaAndOr,stanzaOperator skipwhite skipnl
syn region stanzaCompositeType start="\[" end="\]" contained contains=stanzaQualifiedType,stanzaCompositeType nextgroup=stanzaAndOr skipwhite skipnl
syn region stanzaCompositeType start="(" end=")" contained contains=stanzaQualifiedType,stanzaCompositeType nextgroup=stanzaOperator skipwhite skipnl

" use `\k\+` here because package names can start with a number
syn match stanzaQualifiedType "\%(\k\+\)\?/"he=e-1 contained nextgroup=stanzaQualifiedType,stanzaCompositeType

syn match stanzaOperator "->" contained nextgroup=stanzaQualifiedType,stanzaCompositeType skipwhite skipnl

syn match stanzaType "\K\k*" contained

" A pair of angle brackets referring to some inner type
syn region stanzaOf matchgroup=stanzaAngleBrackets start="<" end=">\|$" contains=stanzaOf,stanzaQualifiedType,stanzaCompositeType,stanzaOperator contained

syn match stanzaAndOr "|\|&" contained nextgroup=stanzaQualifiedType,stanzaCompositeType skipwhite skipnl

" Enum definition (e.g. `defenum Foo`)
syn keyword stanzaKeyword defenum nextgroup=stanzaStructName skipwhite

syn match stanzaKeyword "\<deftype\>" nextgroup=stanzaStructName skipwhite
syn region stanzaLostanzaTypeDefinition matchgroup=stanzaAccess start="^\z(\s*\)\%(\%(public\|protected\|private\)\s\+\)\?lostanza\ze\s\+deftype\>" matchgroup=NONE skip="^\(\z1\s\|$\)" end="^" contains=TOP
syn region stanzaStructDefinition start="^\z(\s*\)\%(\%(public\|protected\|private\)\s\+\)\?\zedefstruct\>" skip="^\(\z1\s\|$\)" end="^" contains=TOP
syn keyword stanzaKeyword defstruct contained containedin=stanzaStructDefinition nextgroup=stanzaStructName skipwhite
syn match stanzaStructFieldName "\K\k*\ze\s*:" contained containedin=stanzaStructDefinition,stanzaLostanzaTypeDefinition contains=@stanzaComments nextgroup=stanzaStructFieldColon skipwhite
syn match stanzaStructFieldColon ":" contained contains=stanzaColon nextgroup=stanzaQualifiedType,stanzaCompositeType skipwhite

syn match stanzaStructName "\K\k*" display contained nextgroup=stanzaOf

" This has to come *after* the matches for `<` and `:` so it takes priority
syn match stanzaTypeAnnotation "<:" nextgroup=stanzaQualifiedType,stanzaCompositeType skipwhite

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

syn match stanzaFormatSpecifier "%[_*,sn~@%]" contained
syn match stanzaContinuation "\\\ze\n\s*" contained
syn match stanzaEscape +\\[bnrt'"\\]+ contained
syn match stanzaEscapeError "\\[^bnrt'"\\]" contained

syn region stanzaAnonymousFn start="{" end="}" contains=TOP

syn match stanzaAnonymousParameter "_\d*" display contained containedin=stanzaAnonymousFn

" Function calls (e.g. `foo(...)`)
syn match stanzaFunctionCall "\K\k*\ze("
syn match stanzaFunctionCall "\K\k*\ze<.\{-}(" nextgroup=stanzaOf

" Curried function calls (e.g. `foo{...}`)
syn match stanzaCurriedFunctionCall "\K\k*\ze{" nextgroup=stanzaAnonymousFn
syn match stanzaCurriedFunctionCall "\K\k*\ze<.\{-}{" nextgroup=stanzaOf

" Applied function calls (e.g. `foo $ ...`)
syn match stanzaAppliedFunction "\K\k*\ze\s\+\$\%(\s\|$\)"
syn match stanzaAppliedFunction "\K\k*\ze<.\{-}\s\+\$\%(\s\|$\)" nextgroup=stanzaOf

" Reverse applied function calls (e.g. `... $> func`)
syn match stanzaOperator "\$>" nextgroup=stanzaReverseAppliedFunction,stanzaKeyword skipwhite skipnl
syn match stanzaReverseAppliedFunction "\K\k*" contained nextgroup=stanzaOf skipwhite skipnl
syn keyword stanzaKeyword fn fn* nextgroup=stanzaFunctionParams skipwhite

" Has to come after `stanzaFunctionCall`, since there are some directives
" (e.g. `#if-defined(`) that could also be highlighted as a function call.
syn match stanzaDirective "#\%(if-defined\|if-not-defined\|else\|use-added-syntax\)\>"

" Also has to come after `stanzaFunctionCall` so that `match(...)` works
syn match stanzaKeyword "\<match\>" nextgroup=stanzaMatchExpression
syn region stanzaMatchExpression start="(" end=")" contained contains=TOP oneline

" Awful hack to allow `match(func():Foo):`. We know that the matched
" expression can be any arbitrary expression, and may include parentheses. At
" the same time, we want to avoid accidentally matching the closing `)` of the
" `match(...)`. Hence, the special care to disallow `)` as the first character
" of the match (which isn't syntactically correct anyhow).
syn match stanzaMatchedExpression "[^:)][^:]\{-}\ze:" contained containedin=stanzaMatchExpression contains=TOP nextgroup=stanzaMatchColon skipwhite

syn region stanzaMatchClause start="^\s*(" end=")" contains=TOP keepend
syn match stanzaMatchBinding "\K\k*\ze:" contained containedin=stanzaMatchClause contains=TOP nextgroup=stanzaMatchColon skipwhite
syn match stanzaMatchBinding "[^:]\{-1,}\ze:" contained containedin=stanzaMatchClause contains=TOP nextgroup=stanzaMatchColon skipwhite
syn match stanzaMatchColon ":" contains=stanzaColon contained nextgroup=stanzaQualifiedType,stanzaCompositeType skipwhite

syn sync match stanzaSync grouphere stanzaLostanzaFunctionDefinition "^\s*\%(\%(public\|private\|protected\)\s\+\)\?lostanza\s*defn\>"
syn sync match stanzaSync grouphere stanzaLostanzaTypeDefinition "^\s*\%(\%(public\|private\|protected\)\s\+\)\?lostanza\s*deftype\>"
syn sync match stanzaSync grouphere stanzaPackageDefinition "^\s*defpackage\>"

hi def link stanzaAccess StorageClass
hi def link stanzaLostanza StorageClass
hi def link stanzaType Type
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
hi def link stanzaReverseAppliedFunction stanzaFunctionCall
hi def link stanzaExtern stanzaKeyword
hi def link stanzaExternFunctionName stanzaFunctionName
hi def link stanzaInclude Include
hi def link stanzaKeyword Statement
hi def link stanzaNumber Number
hi def link stanzaFloat Float
hi def link stanzaOperator Operator
hi def link stanzaColon stanzaOperator
hi def link stanzaAngleBrackets stanzaOperator
hi def link stanzaString String
hi def link stanzaQuotes stanzaString
hi def link stanzaRawString stanzaString
hi def link stanzaRepeat Repeat
hi def link stanzaStructName Structure
hi def link stanzaLostanzaStructName stanzaStructName
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
hi def link stanzaFormatSpecifierError stanzaError
hi def link stanzaCharacterError stanzaError
hi def link stanzaFatal PreCondit
hi def link stanzaTodo Todo

" Grab the first line of the file and check for a #use-added-syntax directive
let s:first_line_of_file = getline(1)
let s:syntax_matches = matchlist(s:first_line_of_file, '#use-added-syntax(\(.\{-}\))')
let b:stanza_added_syntax_modules =
            \ map(split(get(s:syntax_matches, 1, ""), ','),
            \     {_, module -> trim(module).'.vim'})

if len(b:stanza_added_syntax_modules) > 0
    " Restrict runtimepath so we only load Stanza syntax modules
    let s:saved_runtimepath = &runtimepath
    let s:this_runtimepath = expand('<sfile>:p:h')
    if has_key(g:, 'stanza_syntax_modules')
        let s:this_runtimepath .= ','.g:stanza_syntax_modules
    endif
    exec 'set runtimepath='.s:this_runtimepath
    exec 'runtime! '.join(b:stanza_added_syntax_modules, ' ')
    exec 'set runtimepath='.s:saved_runtimepath
endif

let &cpo = s:saved_cpo
unlet s:saved_cpo

let b:current_syntax = "stanza"
