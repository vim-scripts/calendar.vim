" -*- vim -*-
" FILE: "/home/dp/etc/share/vim/calendar.vim" {{{
" LAST MODIFICATION: "Mon, 11 Jun 2001 15:25:14 (dp)"
" (C) 2001 by Douglas L. Potts, <dlpotts@spectral-sys.com>
" DESCRIPTION: Open calendar using Unix 'cal' into a buffer, base on input,
" either an entire year, or a particular month in the year.
"
" Usage: :Cal 2001      |" Show Entire 2001 Calendar
"        :Cal 4 2001    |" Show April 2001
" $Id:$ }}}

"       Bring a year calendar into a new window
com! -n=? Cal exe "call OpenCalendar(\"<a>\")"

" ===========================================================================
function! OpenIfNew( name )
" I used the same logic in several functions, checking if the buffer was
" already around, and then deleting and re-loading it, if it was.
" -----------------------------------------------------------------------------
  " Find out if we already have a buffer for it
  let buf_no = bufnr(expand(a:name))

  " If there is a diffs.tx buffer, delete it
  if buf_no > 0
    if version < 600
      exe 'bd! '.a:name
    else
      exe 'bw! '.a:name
    endif
  endif
  " (Re)open the file (update).
  exe ':sp '.a:name
endf

" This function requires my OpenIfNew function, defined in functions.vim
fun! OpenCalendar(year)
  if a:year == ""
    let year = strftime("%Y")
  else
    let year = a:year
  endif
  let calfilename = "Calendar"

  " Only keep ONE around
  if bufnr(calfilename) > 0
    if version >= 600
      exe 'bw! '.calfilename
    else
      exe 'bd! '.calfilename
    endif
  endif
  exe 'new '.calfilename

  " Make it just a viewable window
  let old_report=&report
  let &report=9999
  if version < 600
    exe ':0r!cal '.year
  else
    set modifiable
    exe "silent exe ':0r!cal '".year
  endif
  set nomodified
  if version >= 600
    set nomodifiable
  endif
  set readonly
  let &report=old_report
  exe 'normal 1G'
endfun
