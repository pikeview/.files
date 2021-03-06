function! s:HeaderLevel(lnum)
  " Return early if it's an asciidoc source block, e.g. showing asciidoc examples
  " TODO: Consider using asciidocOneLineTitle as a keep, rather than ListingBlock as a remove.
  let s = synID(a:lnum, 1, 1)
  if synIDattr(s, 'name') ==? 'asciidocListingBlock'
    return -1
  endif

  let l:line = getline(a:lnum)
    if l:line =~ '^== .*$'
        return 1
    endif
    if l:line =~ '^=== .*$'
        return 2
    endif
    if l:line =~ '^==== .*$'
        return 3
    endif
    if l:line =~ '^===== .*$'
        return 4
    endif
    if l:line =~ '^====== .*$'
        return 5
    endif
    if l:line =~ '^======= .*$'
        return 6
    endif

    return -1
endfunction

function! AsciidocLevel()
  let header_level = s:HeaderLevel(v:lnum)
  if header_level > 0
    return ">".header_level
  endif
  return "="
endfunction

function! AsciidocFoldText()
  let level = s:HeaderLevel(v:foldstart)
  let indent = repeat('=', level)
  let title = substitute(getline(v:foldstart), '^=\+\s*', '', '')
  let foldsize = (v:foldend - v:foldstart)
  let linecount = '['.foldsize.' line'.(foldsize>1?'s':'').']'
  return indent.' '.title.' '.linecount
endfunction

setlocal foldexpr=AsciidocLevel()
setlocal foldmethod=expr
setlocal foldtext=AsciidocFoldText()
abbrev <buffer> wauthor Dominic Monroe <dominic@juxt.pro>

