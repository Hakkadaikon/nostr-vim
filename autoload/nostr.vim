function! nostr#open(userCallback) abort
    let s:note    = {}
    let s:ch      = s:open()
    let s:follows = s:getFollows()
    let s:cb      = a:userCallback
endfunction

function! nostr#close() abort
    call s:close(s:ch)
endfunction

function! nostr#post(str) abort
    call s:post(a:str)
endfunction

function! s:close(ch) abort
    call jobstop(a:ch)
endfunction

function! s:post(str) abort
    call system('algia post ' . a:str)
endfunction

function! s:open() abort
    return jobstart(['algia', 'stream', '--kind', '1,6,7'], { 'on_stdout': function('s:jobCallback') })
endfunction

function! s:getFollows() abort
    let l:filepath = expand('~/.config/algia/config.json')
    return json_decode(readfile(l:filepath))
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

        try
            let l:profile_json = s:follows["follows"][l:pubkey]
        catch
            let l:profile_json = {}
        endtry

        s:cb(l:tl_json, l:profile_json)
    endfor
endfunction
