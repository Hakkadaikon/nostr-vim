"-------------------------------
" File        : nostr-vim
" Description : 
" Author      : hakkadaikon
"--------------------------------
function! s:showTimeLineAlgia() abort
    return jobstart(['algia', 'stream', '--kind', '1,6,7'], { 'on_stdout': function('s:jobCallback') })
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
    for l:tl_str in a:data
        let l:tl_json = ""
        try
            let l:tl_json = json_decode(l:tl_str)
            call g:NostrEvent(l:tl_json)
        catch
            continue
        endtry

        " profile
        let l:valid_profile = 1
        let l:valid_nip05   = 0
        let l:name          = ""
        let l:display_name  = ""
        let l:time          = g:NostrEvent.getTime()
        let l:pubkey        = g:NostrEvent.getPubkey()
        let l:id            = g:NostrEvent.getId()

        try
            let l:profile_json = s:follows["follows"][l:pubkey]
            call g:NostrProfile(l:profile_json)
            let l:name         = g:NostrProfile.getName()
            let l:display_name = g:NostrProfile.getDisplayName()
            let l:valid_nip05  = g:NostrProfile.isValidNip05()
        catch
            let l:valid_profile = 0
        endtry

        let l:profile = g:Display.getProfile(
            \ l:pubkey,
            \ l:display_name,
            \ l:name,
            \ l:valid_profile,
            \ l:valid_nip05,
            \ l:time
        \ )

        let l:kind    = g:NostrEvent.getKind()
        let l:content = g:NostrEvent.getContent()
        if l:kind ==# 1
            try
                let l:quote_id   = g:NostrEvent.getTags()[0][1]
                let l:quote_note = deepcopy(s:note[l:quote_id])
                let l:list = g:Display.addQuoteRepost(
                    \ l:list,
                    \ l:id,
                    \ l:profile,
                    \ l:content,
                    \ l:quote_note
                    \ )
            catch
                let l:list = g:Display.addNote(
                    \ l:list,
                    \ l:id,
                    \ l:profile,
                    \ l:content
                    \ )
            endtry
            let s:note[l:id] = deepcopy(l:list)
        elseif l:kind ==# 6
            try
                let l:repost_id   = g:NostrEvent.getTags()[0][1]
                let l:repost_note = deepcopy(s:note[l:repost_id])
                let l:list =
                    \ g:Display.addRepost(
                        \ l:list,
                        \ l:profile,
                        \ l:repost_note
                        \ )
            catch
                echo printf("error repost %s %s", l:id, l:repost_id)
            endtry
        elseif l:kind ==# 7
            try
                let l:reaction_id = g:NostrEvent.getTags()[0][1]
                let l:list =
                    \ g:Display.addReaction(
                        \ l:list,
                        \ l:profile,
                        \ g:NostrEvent.getContent(),
                        \ s:note,
                        \ l:reaction_id)
            catch
                echo printf("error reaction %s %s", l:id, l:reaction_id)
            endtry
        endif
    endfor

    call add(l:list, g:Display.getBorder())
    let s:buffer_title = '__Nostr_TL__'
    if g:Buffer.existsBuffer() ==# 0
        call g:Buffer.createBuffer(s:buffer_title)
    endif
    call g:Buffer.addBuffer(l:list)
endfunction

function! s:close(ch) abort
    call jobstop(a:ch)
endfunction

function! s:post(str) abort
    call system('algia post ' . a:str)
endfunction

function! nostr#show() abort
    let s:follows = s:getFollows()
    let s:note    = {}
    let s:ch      = s:showTimeLine()
endfunction

function! nostr#close() abort
    call s:close(s:ch)
endfunction

function! nostr#post(str) abort
    call s:post(a:str)
endfunction
