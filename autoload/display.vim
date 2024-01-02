"-------------------------------
" File        : display.vim
" Description : 
" Author      : hakkadaikon
"--------------------------------
let g:Display = {}

function! g:Display.getBorder() abort
    let wininfo = getwininfo(win_getid())[0]
    let width = winwidth(0)
    if has_key(wininfo, 'textoff')
      let width += wininfo.textoff
    endif
    return repeat("─", width-6)
endfunction

function! g:Display.getProfile(
    \ id,
    \ display_name,
    \ name,
    \ valid_profile,
    \ valid_auth,
    \ time
\ ) abort
    let l:profile_line = ""
    if a:valid_profile ==# 1
        let l:profile_line = printf("[%s/@%s] ", a:display_name, a:name)
        if a:valid_auth ==# 1
            let l:profile_line = printf("✓👤%s", l:profile_line)
        endif
    else
        let l:profile_line = printf("[%s] ", a:id)
    endif
    let l:profile_line = printf("%s %s", l:profile_line, a:time)

    return l:profile_line
endfunction

function! g:Display.getNote(
    \ list,
    \ profile,
    \ note
\ ) abort
    call add(a:list, a:profile)
    call add(a:list, "")

    let l:notes = split(a:note, "\n")
    for l:item in l:notes
        call add(a:list, l:item)
    endfor
    call add(a:list, g:Display.getBorder())
    return a:list
endfunction
