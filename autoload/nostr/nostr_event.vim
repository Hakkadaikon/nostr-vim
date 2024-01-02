"-------------------------------
" File        : nostr_event.vim
" Description : 
" Author      : hakkadaikon
"--------------------------------
let g:NostrEvent = {}

function! g:NostrEvent(tl_json) abort
    let g:NostrEvent["id"]         = a:tl_json["id"]
    let g:NostrEvent["pubkey"]     = a:tl_json["pubkey"]
    let g:NostrEvent["created_at"] = a:tl_json["created_at"]
    let g:NostrEvent["kind"]       = a:tl_json["kind"]
    let g:NostrEvent["sig"]        = a:tl_json["sig"]
    let g:NostrEvent["content"]    = a:tl_json["content"]
endfunction

function! g:NostrEvent.getId() abort
    return self.id
endfunction

function! g:NostrEvent.getPubkey() abort
    return self.pubkey
endfunction

function! g:NostrEvent.getCreatedAt() abort
    return self.created_at
endfunction

function! g:NostrEvent.getTime() abort
    return strftime("%Y/%m/%d %H:%M:%S", self.created_at)
endfunction

function! g:NostrEvent.getKind() abort
    return self.kind
endfunction

function! g:NostrEvent.getSig() abort
    return self.sig
endfunction

function! g:NostrEvent.getContent() abort
    return self.content
endfunction
