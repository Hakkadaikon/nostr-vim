"--------------------------------
" File        : nostr-vim
" Description : 
" Author      : hakkadaikon
"--------------------------------
function! s:showTimeLineAlgia() abort
    return jobstart(['algia', 'stream'], { 'on_stdout': function('s:jobCallback') })
endfunction

function! s:showTimeLine() abort
    return s:showTimeLineAlgia()
endfunction

function! s:getFollowings() abort
    let l:filepath = expand('~/.config/algia/config.json')
    return json_decode(readfile(l:filepath))
endfunction

function! s:jobCallback(id, data, event) abort
    let l:timelineStrs = split(join(a:data), "\n")

    let l:str = ""
    for l:timelineStr in l:timelineStrs
        let l:timelineJson = ""
        try
            let l:timelineJson = json_decode(l:timelineStr)
        catch
            continue
        endtry

        let l:id           = l:timelineJson["id"]
        let l:content      = l:timelineJson["content"]
        let l:pubkey       = l:timelineJson["pubkey"]
        let l:created_at   = l:timelineJson["created_at"]
        let l:content      = substitute(l:content, "\n", " ", "g")

        try
            let l:target = g:following["follows"][l:pubkey]
            let l:display_name = l:target["display_name"]
            let l:str = l:str . printf("[%s] %s", l:display_name, l:content)
        catch
            let l:str = l:str . printf("[%s] %s", l:pubkey, l:content)
        endtry

    endfor

    let l:winid = bufwinid('__Nostr_TL__')
    if l:winid ==# -1
      silent noautocmd split __Nostr_TL__
      setlocal buftype=nofile bufhidden=wipe noswapfile
      setlocal wrap nonumber signcolumn=no filetype=markdown
      wincmd p
      let l:winid = bufwinid('__Nostr_TL__')
    endif

    call win_execute(l:winid, 'setlocal modifiable', 1)
    call win_execute(l:winid, 'normal! G', 1)
    call win_execute(l:winid, 'call append(line("$"), l:str)', 1)
    call win_execute(l:winid, 'setlocal nomodifiable nomodified', 1)
endfunction

function! s:popupTimeLine() abort
    " TODO: not implemented yet
    " let l:text   = s:get_timeline(a:limit)
    " let win_id = popup_create(
    " \ l:text, 
    " \ { 
    " \     'pos'      : 'center',
    " \     'minwidth' : 1,
    " \     'zindex'   : 200,
    " \     'time'     : 3000
    " \ }
    " \ )
    " call win_execute(win_id, 'syntax enable')
endfunction

function! s:post(str) abort
    call system('algia post ' . a:str)
endfunction

function! nostr#showTimeLine() abort
    let g:following = s:getFollowings()
    let g:ch = s:showTimeLine()
endfunction

function! nostr#post(str) abort
    call s:post(a:str)
endfunction

function! nostr#popupTimeLine() abort
    call s:popupTimeLine()
endfunction
