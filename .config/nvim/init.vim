" Author kevinz@weghst.com

" Setup
if (!isdirectory(expand('$HOME/.config/nvim/repos/github.com/Shougo/dein.vim')))
  call system(expand('mkdir -p $HOME/.config/repos/github.com/Shougo'))
  call system(expand('git clone https://github.com/Shougo/dein.vim $HOME/.config/nvim/repos/github.com/Shougo/dein.vim'))
endif

set runtimepath+=~/.config/nvim/repos/github.com/Shougo/dein.vim
call dein#begin(expand('~/.config/nvim'))

call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')
call dein#add('altercation/vim-colors-solarized')

call dein#add('scrooloose/nerdtree')
call dein#add('scrooloose/nerdcommenter')
call dein#add('ryanoasis/vim-devicons')
call dein#add('tiagofumo/vim-nerdtree-syntax-highlight')
call dein#add('easymotion/vim-easymotion')
call dein#add('tpope/vim-surround')
call dein#add('ervandew/supertab')
call dein#add('itchyny/vim-cursorword')

call dein#add('editorconfig/editorconfig-vim')
call dein#add('Chiel92/vim-autoformat')
call dein#add('godlygeek/tabular')
call dein#add('tpope/vim-repeat')

call dein#add('tpope/vim-fugitive')
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')
"call dein#add('critiqjo/lldb.nvim')
call dein#add('Shougo/deoplete.nvim')
call dein#add('fatih/vim-go')

call dein#add('majutsushi/tagbar')

call dein#add('valloric/MatchTagAlways', {'on_ft': 'html'})
call dein#add('asciidoc/vim-asciidoc')

if dein#check_install()
  call dein#install()
  let pluginsExist=1
endif
call dein#end()


" 设置文件编码
set enc  =utf-8 nobomb
set fenc =utf-8 nobomb

" Rebind <Leader> key
" I like to have it here because it is easier to reach than the default and
" it it next to ``m`` and ``n`` which I use for navigating between tabs.
let mapleader = ","
let g:mapleader = ","
let maplocalleader = ","
let g:maplocalleader = ","


" bind CTRL+<movement> keys to move around windows, instead of usin CTRL+w+<movement>
" Every unecessary keystroke that can be saved is good for your health :)
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
if has('nvim')
" Hack to get C-h working in NeoVim
  nmap <BS> <C-w>h
endif


" Showing line numbers and length
set nu         " show line numbers
set cursorline " highlight current line
set tabstop    =4
set shiftwidth =4
set expandtab
set history    =700
set undolevels =700
set completeopt-=preview


" Enable syntax highlighting
" You need to reload this file for the change to apply
filetype on
filetype plugin indent on
syntax on


" Remember cursor position between vim sessions
autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " center buffer around cursor when opening files
autocmd BufRead * normal zz


autocmd InsertEnter * let save_cwd = getcwd() | set autochdir
autocmd InsertLeave * set noautochdir | execute 'cd' fnameescape(save_cwd)
" ==================================================================================================
" Plugin Setup
" ==================================================================================================
" https://github.com/altercation/vim-colors-solarized
syntax enable
set background=dark
colorscheme solarized
set guifont=Sauce\ Code\ Pro\ Nerd\ Font\ Complete\ Mono:h12

" https://github.com/scrooloose/nerdtree
map - :NERDTreeToggle<CR>

let g:SuperTabDefaultCompletionType = "<c-n>"

" https://github.com/easymotion/vim-easymotion
map <leader> <Plug>(easymotion-prefix)
nmap <leader>s <Plug>(easymotion-overwin-f2)


" https://github.com/Yggdroot/indentLine
let g:indentLine_char='│'


" https://github.com/Shougo/neosnippet.vim
let g:neosnippet#snippets_directory='~/.config/nvim/repos/github.com/Shougo/neosnippet-snippets/neosnippets'
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#expand_word_boundary = 1
" Plugin key-mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: "\<TAB>"


" https://github.com/Shougo/deoplete.nvim
let g:deoplete#enable_at_startup = 1
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.go = '[^. *\t]\.\w*'


" https://github.com/Shougo/unite.vim
" unite ---------------------------------------------------------------------{{{
"
nnoremap <silent> <C-p> :Unite file buffer -auto-resize -start-insert -direction=botright file_rec/neovim<CR>
let g:unite_source_history_yank_enable = 1
let g:unite_enable_auto_select = 0
let g:unite_prompt                     = '❯ '
let g:unite_source_rec_async_command   = ['ag', '--follow', '--nocolor', '--nogroup',
            \'--hidden', '-g', '', '--ignore', '.git', '--ignore', '*.png', '--ignore', 'lib']
autocmd FileType unite call s:unite_settings()
function! s:unite_settings() "{{{
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction "}}}

" Git from unite...ERMERGERD ------------------------------------------------{{{
let g:unite_source_menu_menus = {} " Useful when building interfaces at appropriate places
let g:unite_source_menu_menus.git = {
  \ 'description' : 'Fugitive interface',
  \}
let g:unite_source_menu_menus.git.command_candidates = [
  \[' git status', 'Gstatus'],
  \[' git diff', 'Gvdiff'],
  \[' git commit', 'Gcommit'],
  \[' git stage/add', 'Gwrite'],
  \[' git checkout', 'Gread'],
  \[' git rm', 'Gremove'],
  \[' git cd', 'Gcd'],
  \[' git push', 'exe "Git! push " input("remote/branch: ")'],
  \[' git pull', 'exe "Git! pull " input("remote/branch: ")'],
  \[' git pull rebase', 'exe "Git! pull --rebase " input("branch: ")'],
  \[' git checkout branch', 'exe "Git! checkout " input("branch: ")'],
  \[' git fetch', 'Gfetch'],
  \[' git merge', 'Gmerge'],
  \[' git browse', 'Gbrowse'],
  \[' git head', 'Gedit HEAD^'],
  \[' git parent', 'edit %:h'],
  \[' git log commit buffers', 'Glog --'],
  \[' git log current file', 'Glog -- %'],
  \[' git log last n commits', 'exe "Glog -" input("num: ")'],
  \[' git log first n commits', 'exe "Glog --reverse -" input("num: ")'],
  \[' git log until date', 'exe "Glog --until=" input("day: ")'],
  \[' git log grep commits',  'exe "Glog --grep= " input("string: ")'],
  \[' git log pickaxe',  'exe "Glog -S" input("string: ")'],
  \[' git index', 'exe "Gedit " input("branchname\:filename: ")'],
  \[' git mv', 'exe "Gmove " input("destination: ")'],
  \[' git grep',  'exe "Ggrep " input("string: ")'],
  \[' git prompt', 'exe "Git! " input("command: ")'],
  \] " Append ' --' after log to get commit info commit buffers
nnoremap <silent> <Leader>g :Unite -direction=botright -silent -buffer-name=git -start-insert menu:git<CR>
"}}}
"}}}

