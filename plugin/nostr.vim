"--------------------------------
" File        : nostr-vim
" Description : 
" Author      : hakkadaikon
"--------------------------------
command! NostrOpen     call nostr#open()
command! NostrPost     call nostr#post(<f-args>)

function! s:setColorScheme() abort
    hi! NostrUserName   ctermfg=216 guifg=#e2a478 cterm=bold
    hi! NostrScreenName ctermfg=150 gui=bold      cterm=bold    guifg=#b4be82
    hi! NostrHashtag    ctermfg=110 guifg=#84a0c6
    hi! NostrLike       ctermfg=203 ctermbg=234   guifg=#e27878 guibg=#161821
    hi! NostrRetweeted  ctermfg=150 gui=bold      guifg=#b4be82
    syntax match NostrScreenName /[^│]\+\s\ze| @.\+/
    syntax match NostrHashtag    /\zs#[^ ]\+/
    syntax match NostrUserName   /@[^ ]\+/
    syntax match NostrLike       /test/
    syntax match NostrRetweeted  /♻/
endfunction

augroup nostr
    autocmd ColorScheme * call s:setColorScheme()
augroup END

call s:setColorScheme()
