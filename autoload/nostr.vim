"--------------------------------
" File        : nostr-vim
" Description : 
" Author      : hakkadaikon
"--------------------------------
function! s:get_timelinestr_algia(limit) abort
    let l:text = "algia tl -n " . printf("%s", a:limit) . " --json"
    return system(l:text)
endfunction

function! s:get_timelinestr(limit) abort
    return s:get_timelinestr_algia(a:limit)
endfunction

function! s:get_timeline(limit) abort
    let l:result = s:get_timelinestr(a:limit)

    let l:timelineStrs = split(l:result, "\n")

    let l:str = ""
    for l:timelineStr in l:timelineStrs
        let l:timelineJson = json_decode(l:timelineStr)
        let l:id           = l:timelineJson["id"]
        let l:content      = l:timelineJson["content"]
        let l:pubkey       = l:timelineJson["pubkey"]
        let l:created_at   = l:timelineJson["created_at"]
        let l:content      = substitute(l:content, "\n", " ", "g")

        let l:str = l:str . printf("%s\n%s\n\n", l:id, l:content)
    endfor

    return str
endfunction

function! s:showTimeLine(limit) abort
    let l:timeline = s:get_timeline(a:limit)
    echo l:timeline
endfunction

function! s:popupTimeLine(limit) abort
    " TODO: not implemented yet
    let l:text   = s:get_timeline(a:limit)
    let win_id = popup_create(
    \ l:text, 
    \ { 
    \     'pos'      : 'center',
    \     'minwidth' : 1,
    \     'zindex'   : 200,
    \     'time'     : 3000
    \ }
    \ )
    call win_execute(win_id, 'syntax enable')
endfunction

function! nostr#showTimeLine(limit) abort
    call s:showTimeLine(a:limit)
endfunction

function! nostr#popupTimeLine(limit) abort
    call s:popupTimeLine(a:limit)
endfunction
