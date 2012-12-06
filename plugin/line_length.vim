" line_length.vim - Hilight background of lines that are too long
"
" Author:  Anders Thøgersen <anders [at] bladre.dk>
" Version: 1.0.0
" Date:    05-dec-2012

if exists('loaded_LineLength') || &cp
    finish
endif

let loaded_LineLength = 1
let s:savedCpo = &cpoptions
set cpoptions&vim

if ! exists("g:LineLength_LineLength")
    let g:LineLength_LineLength = 80
endif

if ! exists("g:LineLength_guibg")
    let g:LineLength_guibg = 'grey80'
endif

if ! exists("g:LineLength_ctermbg")
    let g:LineLength_ctermbg = 2
endif

if ! exists("g:LineLength_active")
    let g:LineLength_active = 1
endif

fun! <SID>LineLengthOn()
    let guibg = g:LineLength_guibg
    if exists("b:LineLength_guibg")
        let guibg = b:LineLength_guibg
    endif
    let ctermbg = g:LineLength_ctermbg
    if exists("b:LineLength_ctermbg")
        let ctermbg = b:LineLength_ctermbg
    endif
    let LineLength = g:LineLength_LineLength
    if exists("b:LineLength_LineLength")
        let LineLength = b:LineLength_LineLength
    endif
    let cmd =  "hi LineLength guibg=". guibg
                 \ ." ctermbg=". ctermbg
                 \ ." | match LineLength /\\%>". LineLength ."c.\\+/"
    execute cmd
endfun

fun! <SID>LineLengthToggle()
    let g:LineLength_active = !g:LineLength_active
    call <SID>LineLengthReadModeLine()
endfun

fun! <SID>LineLengthReadModeLine()
    for line in getline(line("$") - 5, "$")
       let modeline=matchlist(line, 'll:\s*\(\d\+\)\s*\(\w\+\)\?')
       let length=len(modeline)
       if length > 3 && len(modeline[3]) > 0
           let b:LineLength_ctermbg = modeline[3]
       endif
       if length > 2 && len(modeline[2]) > 0
           let b:LineLength_guibg = modeline[2]
       endif
       if length > 1 && len(modeline[1]) > 0
           let b:LineLength_LineLength = modeline[1]
           if g:LineLength_active
               call <SID>LineLengthOn()
           else
               hi clear LineLength
           endif
           return
       endif
    endfor
endfun

au BufEnter * call <SID>LineLengthReadModeLine()
com! -nargs=* LineLength call <SID>LineLengthToggle()
let &cpoptions = s:savedCpo
" ll: 42 yellow
