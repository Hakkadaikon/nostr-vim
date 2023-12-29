"-------------------------------
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

function! s:getBorder() abort
    let wininfo = getwininfo(win_getid())[0]
    let width = winwidth(0)
    if has_key(wininfo, 'textoff')
      let width += wininfo.textoff
    endif
    return repeat("─", width-6)
endfunction

function! s:createBuffer(buffer_title) abort
    silent noautocmd split __Nostr_TL__
    setlocal buftype=nofile bufhidden=wipe noswapfile
    setlocal wrap nonumber signcolumn=no filetype=markdown
    wincmd p
    return bufwinid(a:buffer_title)
endfunction

function! s:addBuffer(list) abort
    call win_execute(s:winid, 'setlocal modifiable', 1)
    call win_execute(s:winid, 'normal! G', 1)
    call win_execute(s:winid, 'call append(line("$"), a:list)', 1)
    call win_execute(s:winid, 'setlocal nomodifiable nomodified', 1)
endfunction

function! s:jobCallback(id, data, event) abort
    let l:list = []
    for l:tl_str in a:data
        let l:tl_json = ""
        try
            let l:tl_json = json_decode(l:tl_str)
        catch
            continue
        endtry

        let l:id         = l:tl_json["id"]
        let l:pubkey     = l:tl_json["pubkey"]
        let l:created_at = l:tl_json["created_at"]
        let l:kind       = l:tl_json["kind"]
        let l:sig        = l:tl_json["sig"]
        let l:content    = l:tl_json["content"]
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

            " draw border
            let border = s:getBorder()
            call add(l:list, border)
        endif
    endfor

    let s:buffer_title = '__Nostr_TL__'
    let s:winid = bufwinid(s:buffer_title)
    if s:winid ==# -1
      let s:winid = s:createBuffer(s:buffer_title)
    endif

    call s:addBuffer(l:list)
endfunction

function! s:close(ch) abort
    call jobstop(a:ch)
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
    call s:close(s:ch)
endfunction

function! nostr#post(str) abort
    call s:post(a:str)
endfunction

function! nostr#popup() abort
    call s:popupTimeLine()
endfunction
