" OS別のエンコーディング
if has("win32")
    set encoding=cp932
elseif has("win32unix")
    set encoding=utf-8
else
    set encoding=utf-8
endif

if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim/dein'))

    call dein#add('Shougo/dein.vim')
    call dein#add('Shougo/vimproc.vim', {'build': 'make'})
    call dein#add('Shougo/neocomplete.vim')
    call dein#add('Shougo/unite.vim')
    call dein#add('Shougo/neomru.vim')
    call dein#add('Shougo/unite-outline')
    call dein#add('Shougo/vimfiler.vim')
    call dein#add('Shougo/neosnippet')
    call dein#add('Shougo/neosnippet-snippets')

    call dein#add("itchyny/lightline.vim")
    call dein#add('junegunn/vim-easy-align')
    call dein#add('terryma/vim-multiple-cursors')
    call dein#add('cohama/lexima.vim')
    call dein#add('terryma/vim-expand-region')
    call dein#add('b4b4r07/vim-shellutils')
    call dein#add('thinca/vim-fontzoom')
    call dein#add('thinca/vim-splash')
    call dein#add('tomasr/molokai')
    call dein#add('chriskempson/vim-tomorrow-theme')
    call dein#add('godlygeek/tabular')
    call dein#add('plasticboy/vim-markdown')

call dein#end()

" 生かしとくといちいちワーニングが出てしまうので、なんとかする。。
" call dein#install()


" neocompleteの設定
" ============================================================

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

" neocomplete推奨キーマップ
" タブで選択
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" スペースでポップアップを閉じる
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  "return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" ============================================================



let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ }

let g:vimfiler_as_default_explorer=1
let g:vimfiler_enable_auto_cd = 1
let g:splash#path = "~/.vim/my/splash.txt"

" Windown CMD上だと色が足りなくて見た目がおかしくなるので、対策
" ============================================================

if has("win32") && !has("gui_running")
    color desert
else
    colorscheme tomorrow-night-eighties
endif

" ============================================================




" その他設定
" ============================================================

set laststatus=2
let g:netrw_liststyle=3
set expandtab
set tabstop=4
set shiftwidth=4
inoremap <S-Tab> <C-d>
set clipboard=unnamed
set whichwrap+=<,>,h,l,[,]
set iminsert=0
set noswapfile
set noundofile
set nobackup

syntax on
set t_Co=256


" キーマッピング
" ============================================================

noremap <C-S-Up> ddkkp
noremap <C-S-Down> ddp
noremap <S-h> ^
noremap <S-l> $

nnoremap <C-a> gg<S-v><S-g>
nnoremap j gj
nnoremap k gk
nnoremap <C-j> <C-e>
nnoremap <C-k> <C-y>
nnoremap s <Nop>
nnoremap <C-n>F :MultipleCursorsFind 
nnoremap <CR> a<CR><ESC>
inoremap <C-S-Up> <Esc>ddkkp
inoremap <C-S-Down> <Esc>ddp

inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
cnoremap <C-a> <Home>
cnoremap <C-d> <Delete>

" ThinkPadだといい感じになる
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


" ビジュアルモードで、連続して同じレジスタをペーストする
" ============================================================
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


" jqの設定
" ============================================================
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
