"--------------------------------
" File        : nostr-vim
" Description : 
" Author      : hakkadaikon
"--------------------------------
command! -nargs=1 ShowTimeLine  call nostr#showTimeLine()
command!          PopupTimeLine call nostr#popupTimeLine()
command!          PostTimeLine  call nostr#post(<f-args>)
