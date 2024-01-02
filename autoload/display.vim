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
    \ pubkey,
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
        let l:profile_line = printf("[%s] ", a:pubkey)
    endif
    let l:profile_line = printf("%s %s", l:profile_line, a:time)

    return l:profile_line
endfunction

function! g:Display.addQuoteRepost(
    \ list,
    \ id,
    \ profile,
    \ note,
    \ quote_note,
\ ) abort
    call add(a:list, a:profile)
    call add(a:list, printf("id : %s", a:id))
    call add(a:list, "")

    let l:notes = split(a:note, "\n")
    for l:item in l:notes
        call add(a:list, l:item)
    endfor
    call add(a:list, "")

    for l:item in a:quote_note
        call add(a:list, printf("%s%s", "> ", l:item))
    endfor

    return a:list
endfunction

function! g:Display.addRepost(
    \ list,
    \ profile,
    \ note,
\ ) abort
    call add(a:list, a:profile)
    call add(a:list, "repost")
    call add(a:list, "")

    let l:notes = split(a:note, "\n")
    for l:item in l:notes
        call add(a:list, l:item)
    endfor
    call add(a:list, "")

    return a:list
endfunction

function! g:Display.addNote(
    \ list,
    \ id,
    \ profile,
    \ note
\ ) abort
    call add(a:list, a:profile)
    call add(a:list, printf("id : %s", a:id))
    call add(a:list, "")

    let l:notes = split(a:note, "\n")
    for l:item in l:notes
        call add(a:list, l:item)
    endfor

    return a:list
endfunction

function! g:Display.addReaction(
    \ list,
    \ profile,
    \ reaction,
    \ notes,
    \ reaction_id
\ ) abort
    call add(a:list, a:profile)
    call add(a:list, "")
    call add(a:list, a:reaction)
    call add(a:list, "")

    try
        let l:reaction_note = a:notes[a:reaction_id]
        for l:item in l:reaction_note
            call add(a:list, printf("%s%s", "> ", l:item))
        endfor
    catch
        call add(a:list, printf("reaction note id : %s", a:reaction_id))
    endtry
    return a:list
endfunction
