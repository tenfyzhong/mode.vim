"==============================================================
"    file: mode.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
" created: 2019-06-11 19:46:57
"==============================================================

let s:enabled = {}
let s:modes = {}


function! mode#add(name, abbreviation, mappings)
  if a:name == '' || len(a:mappings) == 0
    return 1
  endif
  if has_key(s:modes, a:name)
    return 2
  endif

  let l:mode = {
        \ 'name': a:name,
        \ 'abbr': a:abbreviation,
        \ 'mappings': a:mappings,
        \ }
  let s:modes[a:name] = l:mode
  return 0
endfunction

function! mode#del(name)
  if has_key(s:enabled, a:name)
    call mode#disable(a:name)
  endif
  if has_key(s:modes, a:name)
    call remove(s:modes, a:name)
  endif
endfunction

function! mode#enable(name)
  if a:name == ''
    return 1
  endif
  if !has_key(s:modes, a:name)
    return 2
  endif
  let l:mode = s:modes[a:name]
  let l:mappings = l:mode['mappings']

  let l:old_mappings = []

  for mapping in l:mappings
    let old = maparg(mapping['lhs'], mapping['mode'], 0, 1)
    if len(old) != 0
      call add(l:old_mappings, old)
    endif
    let cmd = mode#mapping#map_cmd(mapping)
    exec cmd
  endfor
  let s:enabled[a:name] = l:old_mappings
  echom 'mode ' . a:name . ' enabled'
  return 0
endfunction

function! mode#disable(name)
  if a:name == ''
    return 1
  endif
  if !has_key(s:enabled, a:name)
    return 2
  endif

  let l:mode = s:modes[a:name]
  for mapping in l:mode['mappings']
    let cmd = mode#mapping#unmap_cmd(mapping)
    exec cmd
  endfor

  let l:old_mappings = s:enabled[a:name]
  for mapping in l:old_mappings
    if !empty(mapping)
        exe     mapping.mode
                    \ . (mapping.noremap ? 'noremap   ' : 'map ')
                    \ . (mapping.buffer  ? ' <buffer> ' : '')
                    \ . (mapping.expr    ? ' <expr>   ' : '')
                    \ . (mapping.nowait  ? ' <nowait> ' : '')
                    \ . (mapping.silent  ? ' <silent> ' : '')
                    \ .  mapping.lhs
                    \ . ' '
                    \ . substitute(mapping.rhs, '<SID>', '<SNR>'.mapping.sid.'_', 'g')
    endif
  endfor

  call remove(s:enabled, a:name)
  echom 'mode ' . a:name . ' disabled'
  return 0
endfunction

function! ModeAirlineStatus()
  let abbrs = []
  for mode_name in keys(s:enabled)
    let abbr = s:modes[mode_name]['abbr']
    call add(abbrs, abbr)
  endfor
  return join(abbrs, '')
endfunction

function! s:airline_status()
  call airline#parts#define_function('mode_vim', 'ModeAirlineStatus')
  let g:airline_section_warning .= airline#section#create_right(['mode_vim'])
endfunction

augroup mode_init
  autocmd!
  autocmd User AirlineAfterInit call <SID>airline_status()
augroup end
