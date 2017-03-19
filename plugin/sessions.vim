let s:nvim_path = split(&runtimepath, ",")[0]

function! s:CloseSession()
    bufdo bdelete
    cd $HOME
endfunction

function! s:SessionDir()
    let session_dir = s:nvim_path . "/sessions/"
    return session_dir
endfunction

function! s:SessionFile(session)
    let session_dir = s:SessionDir()
    return session_dir . a:session . ".vim"
endfunction

function! s:Delete(session)
    let session_file = s:SessionFile(a:session)
    call delete(session_file)
    call s:CloseSession()
endfunction

function! s:Open(session)
    let session_file = s:SessionFile(a:session)
    execute "source " . session_file
    let g:sessions#session = a:session
endfunction

function! s:Save(session)
    let session_file = s:SessionFile(a:session)
    execute "mksession! " . session_file
    echo "Saved session " . a:session
    let g:sessions#session = a:session
endfunction

function s:SaveCurrent()
    if exists("g:sessions#session")
        call s:Save(g:sessions#session)
    endif
endfunction

function s:SessionCompletion(arg, cmd_line, cursor_pos)
    echomsg a:arg
    let session_dir = s:SessionDir()
    let sessions = split(system("find " . session_dir . " -name '*" . a:arg . "*.vim' -printf '%f\n' -type f"), "\n")
    call map(sessions, "split(v:val, '\\.')[0]")
    return sessions
endfunction

command! CloseSession call s:CloseSession()
command! CurrentSessionSave call s:SaveCurrent()
command! -nargs=1 -complete=customlist,s:SessionCompletion DeleteSession call s:Delete(<q-args>)
command! -nargs=1 -complete=customlist,s:SessionCompletion OpenSession call s:Open(<q-args>)
command! -nargs=1 -complete=customlist,s:SessionCompletion SaveSession call s:Save(<q-args>)
