"  _  _  ____  _  _  ____  __  __ 
" ( )/ )( ___)( \/ )(_  _)(  \/  )
"  )  (  )__)  \  /  _)(_  )    ( 
" (_)\_)(____)  \/  (____)(_/\/\_)
" 
" Go find your own vimrc file
"

"----------------------------------------------------------------------
" Macros
"----------------------------------------------------------------------
imap jj <Esc>
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <silent> <C-p> :Files<CR>
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>
nnoremap <leader>l :call LanguageClient_contextMenu()<CR>
nnoremap K :call LanguageClient#textDocument_hover()<CR>
nnoremap gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <leader>r :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> <C-g> :Rg<CR>
nnoremap <silent> <C-f> :LinesWithPreview<CR>
nnoremap <silent> <C-o> :All<cr>

"----------------------------------------------------------------------
" VIM Options
"----------------------------------------------------------------------
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set backspace=indent,eol,start
set ttymouse=xterm2
set mouse=a

" ----------------------------------------------------------------------------
" PLUGIN SETTINGS
" ----------------------------------------------------------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.dotfiles/.vim/plugged')
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf.vim'
        Plug 'dense-analysis/ale'
        Plug 'preservim/nerdtree'
        Plug 'jiangmiao/auto-pairs'
        Plug 'tpope/vim-commentary'
        Plug 'christoomey/vim-tmux-navigator'
        Plug 'othree/yajs.vim'
        Plug 'sheerun/vim-polyglot'
        Plug 'pangloss/vim-javascript'
        Plug 'leafgarland/typescript-vim'
        Plug 'maxmellon/vim-jsx-pretty'
        Plug 'jiangmiao/auto-pairs'
        Plug 'skywind3000/asyncrun.vim'
        Plug 'ycm-core/YouCompleteMe'
        Plug 'christoomey/vim-tmux-navigator'
        Plug 'beautify-web/js-beautify'
call plug#end()

"----------------------------------------------------------------------
" Linters & Fixers
"----------------------------------------------------------------------
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    let g:jsx_ext_required = 0
    let g:ale_sign_error = '✘'
    let g:ale_sign_warning = '⚠'
    let g:ale_lint_on_enter = 0
    let g:ale_lint_on_text_changed = 'never'
    highlight ALEErrorSign ctermbg=NONE ctermfg=red
    highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
    let g:ale_linters_explicit = 1
    let g:ale_lint_on_save = 1
    let g:ale_fix_on_save = 1
    let g:ale_javascript_prettier_options = '--no-semi --single-quote --trailing-comma none'
    let g:ale_javascript_eslint_use_global = 1
    let g:ale_linters = {
    \   'javascript': ['xo'],
    \}
    let g:ale_fixers = {
     \    'javascript': ['prettier', 'eslint'],
     \    'typescript': ['prettier', 'tslint'],
     \    'vue': ['eslint'],
     \    'scss': ['prettier'],
     \    'html': ['prettier'],
     \    'reason': ['refmt'],
     \    '*': ['remove_trailing_lines', 'trim_whitespace']
    \}
    let g:LanguageClient_serverCommands = {
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
    \ }
    let g:ale_sign_error = '✘'
    let g:ale_sign_warning = '⚠'
    let g:ale_lint_on_enter = 0
    let g:ale_lint_on_text_changed = 'never'
    highlight ALEErrorSign ctermbg=NONE ctermfg=red
    highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
    let g:ale_linters_explicit = 1
    let g:ale_lint_on_save = 1
    let g:ale_fix_on_save = 1
    let g:ale_javascript_prettier_options = '--no-semi --single-quote --trailing-comma none'
    return l:counts.total == 0 ? 'OK' : printf(
        \   '%d⨉ %d⚠ ',
        \   all_non_errors,
        \   all_errors
        \)
endfunction
set statusline+=%=
set statusline+=\ %{LinterStatus()}

"----------------------------------------------------------------------
" Prettifier
"----------------------------------------------------------------------
let g:diminactive_use_colorcolumn = 1
syntax on

" ----------------------------------------------------------------------------
" CUSTOM COMMANDS
" ----------------------------------------------------------------------------
command! -bang -nargs=*  All
  \ call fzf#run(fzf#wrap({'source': 'rg --files --hidden --no-ignore-vcs --glob "!{node_modules/*,.git/*}"', 'down': '40%', 'options': '--expect=ctrl-t,ctrl-x,ctrl-v --multi --reverse' }))

command! -bang -nargs=* LinesWithPreview
      \ call fzf#vim#grep(
    \   'rg --with-filename --column --line-number --no-heading --color=always --smart-case . '.fnameescape(expand('%')), 1,
    \   fzf#vim#with_preview({'options': '--delimiter : --nth 4.. --no-sort'}, 'up:50%', '?'),
    \   1)
