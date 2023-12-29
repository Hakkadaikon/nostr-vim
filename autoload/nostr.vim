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

function! s:getFollows() abort
    let l:filepath = expand('~/.config/algia/config.json')
    return json_decode(readfile(l:filepath))
endfunction

function! s:jobCallback(id, data, event) abort
    let l:list = []
    for l:timelineStr in a:data
        let l:timelineJson = ""
        try
            let l:timelineJson = json_decode(l:timelineStr)
        catch
            continue
        endtry

        let l:id         = l:timelineJson["id"]
        let l:pubkey     = l:timelineJson["pubkey"]
        let l:created_at = l:timelineJson["created_at"]
        let l:kind       = l:timelineJson["kind"]
        let l:sig        = l:timelineJson["sig"]
        let l:content    = l:timelineJson["content"]
        let l:time       = strftime("%Y/%m/%d %H:%M:%S", l:created_at)

        " profile
        let l:valid_profile = 1
        let l:valid_nip05   = 0
        try
            let l:profile       = s:follows["follows"][l:pubkey]
            let l:website       = l:profile["website"]
            let l:picture       = l:profile["picture"]
            let l:display_name  = l:profile["display_name"]
            let l:name          = l:profile["name"]
            let l:about         = l:profile["about"]
            let l:nip05         = l:profile["nip05"]
            let l:lud16         = l:profile["lud16"]
            if nip05 !=# ""
                "TODO: check nip05
                let l:valid_nip05 = 1
            endif
        catch
            let l:valid_profile = 0
        endtry

        let l:profile_line = printf("[%s] ", l:pubkey)
        if l:valid_profile ==# 1
            let l:profile_line = printf("[%s/@%s] ", l:display_name, l:name)
            if l:valid_nip05 ==# 1
                let l:profile_line = printf("✓👤%s", l:profile_line)
            endif
        endif

        let l:profile_line = printf("%s %s", l:profile_line, l:time)

        if l:kind ==# 1
            call add(l:list, profile_line)
            call add(l:list, "")

            " show note
            let l:contents = split(l:content, "\n")
            for l:item in l:contents
                call add(l:list, l:item)
            endfor
            call add(l:list, "--------------------------------")
        endif
    endfor

    let s:winid = bufwinid('__Nostr_TL__')
    if s:winid ==# -1
      silent noautocmd split __Nostr_TL__
      setlocal buftype=nofile bufhidden=wipe noswapfile
      setlocal wrap nonumber signcolumn=no filetype=markdown
      wincmd p
      let s:winid = bufwinid('__Nostr_TL__')
    endif

    call win_execute(s:winid, 'setlocal modifiable', 1)
    call win_execute(s:winid, 'normal! G', 1)
    call win_execute(s:winid, 'call append(line("$"), l:list)', 1)
    call win_execute(s:winid, 'setlocal nomodifiable nomodified', 1)
endfunction

function! s:close() abort
    call jobstop(s:ch)
    "call win_execute(s:winid, printf("normal! :\<C-u>call popup_close(%d)\<CR>", s:winid))
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

function! nostr#show() abort
    let s:follows = s:getFollows()
    let s:ch      = s:showTimeLine()
endfunction

function! nostr#close() abort
    call s:close()
endfunction

function! nostr#post(str) abort
    call s:post(a:str)
endfunction

function! nostr#popup() abort
    call s:popupTimeLine()
endfunction
