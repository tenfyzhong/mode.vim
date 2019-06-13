"==============================================================
"    file: mapping.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
" created: 2019-06-11 20:09:05
"==============================================================

function! mode#mapping#create(mode, noremap, buffer, lhs, rhs, ...)
  let l:mode = {
        \ 'mode': a:mode,
        \ 'noremap': a:noremap,
        \ 'buffer': a:buffer,
        \ 'lhs': a:lhs,
        \ 'rhs': a:rhs,
        \ 'arguments': a:000,
        \ }
  return l:mode
endfunction

function! mode#mapping#map_cmd(mapping)
  let arguments = ''
  if len(a:mapping['arguments']) > 0
    let arguments = join(a:mapping['arguments'], ' ') . ' '
  endif
  return a:mapping['mode']
        \ . (a:mapping['noremap'] ? 'noremap ' : 'map ')
        \ . (a:mapping['buffer'] ? '<buffer> ' : '')
        \ . arguments
        \ . a:mapping['lhs'] . ' '
        \ . a:mapping['rhs']
endfunction

function! mode#mapping#unmap_cmd(mapping)
  return a:mapping['mode'] . 'unmap ' 
        \ . (a:mapping['buffer'] ? '<buffer> ' : '')
        \ . a:mapping['lhs']
endfunction
