"--------------------------------
" File        : nostr-vim
" Description : 
" Author      : hakkadaikon
"--------------------------------
command! -nargs=1 ShowTimeLine  call nostr#show()
command!          PopupTimeLine call nostr#popup()
command!          PostTimeLine  call nostr#post(<f-args>)
