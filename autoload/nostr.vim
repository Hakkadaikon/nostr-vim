" Open the nostr stream channel.
" Once the channel is opened, the callback set in the arguments will be called whenever an event is received from the nostr relay via websocket.
" @param {Function} userCallback - The callback to be called when an event is received from the nostr relay.
function! nostr#open(userCallback) abort
    let s:note    = {}
    let s:ch      = s:open()
    let s:follows = s:getFollows()
    let s:cb      = a:userCallback
endfunction

" Close the nostr stream channel.
function! nostr#close() abort
    call s:close(s:ch)
endfunction

" Post a message to the nostr relay.
" @param {String} str - The message to be posted to the nostr relay.
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
