"-------------------------------
" File        : buffer.vim
" Description : 
" Author      : hakkadaikon
"--------------------------------
let g:Buffer = {}

function! g:Buffer.addBuffer(list) abort
    call win_execute(self.winid, 'setlocal modifiable', 1)
    call win_execute(self.winid, 'normal! G', 1)
    call win_execute(self.winid, 'call append(line("$"), a:list)', 1)
    call win_execute(self.winid, 'setlocal nomodifiable nomodified', 1)
endfunction

function! g:Buffer.createBuffer(buffer_title) abort
    silent noautocmd split __Nostr_TL__
    setlocal buftype=nofile bufhidden=wipe noswapfile
    setlocal wrap nonumber signcolumn=no filetype=markdown
    wincmd p
    let g:Buffer["winid"] = bufwinid(a:buffer_title)
endfunction

function! g:Buffer.existsBuffer() abort
    if !exists("self.winid")
        return 0
    endif
    return 1
endfunction

