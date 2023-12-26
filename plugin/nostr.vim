"--------------------------------
" File        : nostr-vim
" Description : 
" Author      : hakkadaikon
"--------------------------------
command! -nargs=1 ShowTimeLine  call nostr#showTimeLine(<f-args>)
command!          PopupTimeLine call nostr#popuTimeLine()
