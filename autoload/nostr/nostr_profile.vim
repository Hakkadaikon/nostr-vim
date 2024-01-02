"-------------------------------
" File        : nostr_profile.vim
" Description : 
" Author      : hakkadaikon
"--------------------------------
let g:NostrProfile = {}

function! g:NostrProfile(profile_json) abort
    let g:NostrProfile["website"]       = a:profile_json["website"]
    let g:NostrProfile["picture"]       = a:profile_json["picture"]
    let g:NostrProfile["display_name"]  = a:profile_json["display_name"]
    let g:NostrProfile["name"]          = a:profile_json["name"]
    let g:NostrProfile["about"]         = a:profile_json["about"]
    let g:NostrProfile["nip05"]         = a:profile_json["nip05"]
    let g:NostrProfile["lud16"]         = a:profile_json["lud16"]
endfunction

function! g:NostrProfile.getWebSite() abort
    return self.website
endfunction

function! g:NostrProfile.getPicture() abort
    return self.picture
endfunction

function! g:NostrProfile.getDisplayName() abort
    return self.display_name
endfunction

function! g:NostrProfile.getName() abort
    return self.name
endfunction

function! g:NostrProfile.getAbout() abort
    return self.about
endfunction

function! g:NostrProfile.getNip05() abort
    return self.nip05
endfunction

function! g:NostrProfile.getLud16() abort
    return self.lud16
endfunction

function! g:NostrProfile.isValidNip05() abort
    return (self.nip05 != "")
endfunction
