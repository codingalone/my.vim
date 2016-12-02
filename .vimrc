" Note: Skip initialization for vim-tiny or vim-small.
 if 0 | endif

 if &compatible
   set nocompatible               " Be iMproved
 endif

 " Required:
 set runtimepath^=~/.vim/bundle/neobundle.vim/

 " Required:
 call neobundle#begin(expand('~/.vim/bundle/'))

  " Let NeoBundle manage NeoBundle
  " Required:
     NeoBundleFetch 'Shougo/neobundle.vim'

  " 読み込むプラグインを記載
  NeoBundle 'Shougo/vimproc.vim', {
          \ 'build' : {
          \     'windows' : 'tools\\update-dll-mingw',
          \     'cygwin' : 'make -f make_cygwin.mak',
          \     'mac' : 'make -f make_mac.mak',
          \     'unix' : 'make -f make_unix.mak',
          \    },
          \ }
  NeoBundle 'Shougo/unite.vim'
  NeoBundle 'itchyny/lightline.vim'
  NeoBundle 'terryma/vim-multiple-cursors'
  NeoBundle 'scrooloose/nerdtree'
  NeoBundle 'cohama/lexima.vim'
  NeoBundle 'terryma/vim-expand-region'
  NeoBundle 'b4b4r07/vim-shellutils'
  NeoBundle 'thinca/vim-fontzoom'

"  if has('lua')
"    NeoBundleLazy 'Shougo/neocomplete.vim', {
"      \ 'depends' : 'Shougo/vimproc',
"      \ 'autoload' : { 'insert' : 1,}
"      \ }
"  endif

  " My Bundles here:
  " Refer to |:NeoBundle-examples|.
  " Note: You don't set neobundle setting in .gvimrc!

 call neobundle#end()

 " Required:
 filetype plugin indent on

 " If there are uninstalled bundles found on startup,
 " this will conveniently prompt you to install them.
 NeoBundleCheck


" neocomplete {{{
  let g:neocomplete#enable_at_startup               = 1
  let g:neocomplete#auto_completion_start_length    = 3
  let g:neocomplete#enable_ignore_case              = 1
  let g:neocomplete#enable_smart_case               = 1
  let g:neocomplete#enable_camel_case               = 1
  let g:neocomplete#use_vimproc                     = 1
  let g:neocomplete#sources#buffer#cache_limit_size = 1000000
  let g:neocomplete#sources#tags#cache_limit_size   = 30000000
  let g:neocomplete#enable_fuzzy_completion         = 1
  let g:neocomplete#lock_buffer_name_pattern        = '\*ku\*'
" }}}


" その他設定
let g:netrw_liststyle=3
set expandtab
set tabstop=4
set shiftwidth=4
set whichwrap+=<,>,h,l,[,]
set clipboard=unnamed
set iminsert=0


" キーマッピング
nnoremap s <Nop>
nnoremap <C-n>F :MultipleCursorsFind 
nnoremap <CR> a<CR><ESC>
noremap <C-S-Up> ddkkp
noremap <C-S-Down> ddp
noremap <S-h> ^
noremap <S-l> $
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

cnoremap <C-a> <Home>
cnoremap <C-d> <Delete>

map <MiddleMouse> <Esc>
imap <MiddleMouse> <Esc>
cmap <MiddleMouse> <Esc>
map <2-MiddleMouse> <Esc>
imap <2-MiddleMouse> <Esc>
cmap <2-MiddleMouse> <Esc>
map <3-MiddleMouse> <Esc>
imap <3-MiddleMouse> <Esc>
cmap <3-MiddleMouse> <Esc>
map <4-MiddleMouse> <Esc>
imap <4-MiddleMouse> <Esc>
cmap <4-MiddleMouse> <Esc>

" コマンドのリマップ
:command! -narg=? -complete=file Tree :NERDTree <args>


" ビジュアルモードで、連続して同じレジスタをペーストする
vnoremap <silent> <C-p> "0p<CR>

augroup vimrc-auto-mkdir  " {{{
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)  " {{{
    if !isdirectory(a:dir) && (a:force ||
    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction  " }}}
augroup END  " }}}

" jqとのIF
if executable('jq')
    function! s:jq(has_bang, ...) abort range
        execute 'silent' a:firstline ',' a:lastline '!jq' string(a:0 == 0 ? '.' : a:1)
        if !v:shell_error || a:has_bang
            return
        endif
        let error_lines = filter(getline('1', '$'), 'v:val =~# "^parse error: "')
        " 範囲指定している場合のために，行番号を置き換える
        let error_lines = map(error_lines, 'substitute(v:val, "line \\zs\\(\\d\\+\\)\\ze,", "\\=(submatch(1) + a:firstline - 1)", "")')
        let winheight = len(error_lines) > 10 ? 10 : len(error_lines)
        " カレントバッファがエラーメッセージになっているので，元に戻す
        undo
        " カレントバッファの下に新たにウィンドウを作り，エラーメッセージを表示するバッファを作成する
        execute 'botright' winheight 'new'
        setlocal nobuflisted bufhidden=unload buftype=nofile
        call setline(1, error_lines)
        " エラーメッセージ用バッファのundo履歴を削除(エラーメッセージをundoで消去しないため)
        let save_undolevels = &l:undolevels
        setlocal undolevels=-1
        execute "normal! a \<BS>\<Esc>"
        setlocal nomodified
        let &l:undolevels = save_undolevels
        " エラーメッセージ用バッファは読み取り専用にしておく
        setlocal readonly
    endfunction
    command! -bar -bang -range=% -nargs=? Jq  <line1>,<line2>call s:jq(<bang>0, <f-args>)
endif
augroup END
