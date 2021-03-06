"    
"          ___           ___       ___           ___     
"         /\  \         /\__\     /\__\         /\  \    
"        /::\  \       /:/  /    /:/  /        /::\  \   
"       /:/\:\  \     /:/  /    /:/  /        /:/\:\  \  
"      /::\~\:\  \   /:/  /    /:/  /  ___   /:/  \:\  \ 
"     /:/\:\ \:\__\ /:/__/    /:/__/  /\__\ /:/__/_\:\__\
"     \/__\:\/:/  / \:\  \    \:\  \ /:/  / \:\  /\ \/__/
"          \::/  /   \:\  \    \:\  /:/  /   \:\ \:\__\  
"           \/__/     \:\  \    \:\/:/  /     \:\/:/  /  
"                      \:\__\    \::/  /       \::/  /   
"                       \/__/     \/__/         \/__/    
"    
"===============================================================
"{{{ PLUGINS
"===============================================================
call plug#begin('~/.local/share/nvim/plugged')

Plug 'sheerun/vim-polyglot'
Plug 'Valloric/MatchTagAlways'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'

Plug 'junegunn/vim-plug'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'mbbill/undotree'
Plug 'majutsushi/tagbar'

Plug 'mattn/emmet-vim'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
Plug 'jaxbot/browserlink.vim'
Plug 'wellle/targets.vim'
Plug 'machakann/vim-sandwich'

Plug 'wincent/terminus'
Plug 'tmux-plugins/vim-tmux'
Plug 'christoomey/vim-tmux-navigator'

Plug 'honza/vim-snippets'

Plug 'jiangmiao/auto-pairs'
Plug 'godlygeek/tabular'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vimwiki/vimwiki'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

Plug 'yggdroot/indentline'

Plug 'dylanaraps/wal.vim'
Plug 'mootikins/wpgtk.vim'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'segeljakt/vim-silicon'

Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }

Plug 'sbdchd/neoformat'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'kkoomen/vim-doge'

Plug 'jpalardy/vim-slime'

Plug 'curist/vim-angular-template'

" Initialize plugin system
call plug#end()
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ PLUGIN SETTINGS
"===============================================================

"===============================================================
"{{{ HEXOKINASE.VIM
"===============================================================
let g:Hexokinase_highlighters = ['virtual']
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ LIVE-JOBS
"===============================================================

"===============================================================
"{{{ FRAMEWORK
"===============================================================
function! s:CompilationEvent(job_id, data, event) dict
	if a:event ==? 'stderr'
		let str = 'Compile Error: '.join(a:data)
	elseif a:event ==? 'stdout'
		let str = 'Compile Output: '.join(a:data)
	else
		let str = 'Compilation Successful'
		silent execute "checktime"
	endif
	echo str
endfunction

let s:callbacks = {
			\ 'on_stdout': function('s:CompilationEvent'),
			\ 'on_stderr': function('s:CompilationEvent'),
			\ 'on_exit': function('s:CompilationEvent')
			\ }

function! s:LiveCompile(command)
	let b:compile_job = jobstart(a:command, s:callbacks)
endfunction
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ PANDOC
"===============================================================
function! EnablePandocLive()
	let b:pdf_filename = split(@%, '\.')[0].'.pdf'
	augroup PandocLive
		autocmd! * <buffer>
		autocmd BufWritePost <buffer> silent call s:LiveCompile('pandoc -f markdown '.@%.' -o '.b:pdf_filename)
	augroup END

	command -buffer PandocLiveDisable call s:DisablePandocLive()
	delcommand PandocLiveEnable
endfunction

function! s:DisablePandocLive()
	augroup PandocLive
		autocmd! * <buffer>
	augroup END
	augroup! PandocLive
	delcommand PandocLiveDisable
	command! PandocLiveEnable call EnablePandocLive()
endfunction

augroup PandocLive
	autocmd!
	autocmd Filetype pandoc,vimwiki command! PandocLiveEnable call EnablePandocLive()
augroup END
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ SCSS
"===============================================================
function! EnableSCSSLive()
	let b:css_filename = split(@%, '\.')[0].'.css'
	augroup SCSSLive
		autocmd! * <buffer>
		autocmd BufWritePost <buffer> silent call s:LiveCompile('sassc -a '.@%.' | prettier --stdin-filepath '.b:css_filename.' > '.b:css_filename.'&& touch '.b:css_filename)
	augroup END

	command SCSSLiveDisable call s:DisableSCSSLive()
	delcommand SCSSLiveEnable
endfunction

function! s:DisableSCSSLive()
	augroup SCSSLive
		autocmd! * <buffer>
	augroup END
	augroup! SCSSLive
	delcommand SCSSLiveDisable
	command! SCSSLiveEnable call EnableSCSSLive()
endfunction

augroup SCSSLive
	autocmd! * <buffer>
	autocmd Filetype scss command SCSSLiveEnable call EnableSCSSLive()
augroup END
"===============================================================
"}}}
"===============================================================

"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ POLYGLOT
"===============================================================
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=2
let g:tex_conceal='abdmg'

let g:polyglot_disabled = []
" let g:polyglot_disabled = ['markdown', 'pandoc']
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ AUTO-PAIRS
"===============================================================
augroup FiletypePairs
	autocmd!
	autocmd Filetype pandoc let b:AutoPairs = AutoPairsDefine({
				\ '\left(': ' \right)//k)',
				\ '$': '$',
				\ '$$': '$$'
				\ })
augroup END
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ NERD-COMMENTER
"===============================================================
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ VIM-SLIME
"===============================================================
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.2"}

nmap <leader>s V<C-c><C-c>
vmap <leader>s <C-c><C-c>
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ NEOFORMAT
"===============================================================
let blacklist = ['pandoc']

function! s:EnableNeoformat()
	augroup Neoformat
		autocmd! * <buffer>
		autocmd BufWritePre <buffer> if index(blacklist, &ft) < 0 | silent Neoformat
	augroup END
	command -buffer NeoformatDisable call s:DisableNeoformat()
endfunction

function! s:DisableNeoformat()
	augroup Neoformat
		autocmd!
	augroup END
	augroup! Neoformat
	command! NeoformatEnable call s:EnableNeoformat()
endfunction

command! NeoformatEnable call s:EnableNeoformat()
"===============================================================
"}}}
"===============================================================
"
"===============================================================
"{{{ EMMET
"===============================================================
let g:user_emmet_leader_key = '<C-e>'

let g:user_emmet_settings = {
			\   'typescript' : {
			\      'extends' : 'jsx',
			\   },
			\   'typescriptreact' : {
			\      'extends' : 'jsx',
			\   },
			\   'javascript' : {
			\      'extends' : 'jsx',
			\   }
			\ }
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ COC.NVIM
"===============================================================
set hidden
set shortmess+=c
set updatetime=300

inoremap <silent><expr> <TAB>
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()

inoremap <silent><expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

imap <C-y> <Plug>(coc-snippets-expand)

vmap <C-j> <Plug>(coc-snippets-select)

let g:coc_snippet_next = '<c-j>'

let g:coc_snippet_prev = '<c-k>'

nnoremap <silent> gK :call <SID>show_documentation()<CR>
nmap <silent> <leader>cd <Plug>(coc-definition)
nmap <silent> <leader>ct <Plug>(coc-type-definition)
nmap <silent> <leader>ci <Plug>(coc-implementation)
nmap <silent> <leader>cr <Plug>(coc-references)
nmap <silent> <leader>cn <Plug>(coc-rename)

" navigate chunks of current buffer
nmap [h <Plug>(coc-git-prevchunk)
nmap ]h <Plug>(coc-git-nextchunk)

" show chunk diff at current position
nmap <leader>hs <Plug>(coc-git-chunkinfo)

" show commit contains current position
nmap <leader>hc <Plug>(coc-git-commit)

" create text object for git chunks
omap ih <Plug>(coc-git-chunk-inner)
xmap ih <Plug>(coc-git-chunk-inner)
omap ah <Plug>(coc-git-chunk-outer)
xmap ah <Plug>(coc-git-chunk-outer)
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ VIM-DOGE
"===============================================================
let g:doge_mapping = '<leader><S-d>'
let g:doge_mapping_comment_jump_forward = '<C-j>'
let g:doge_mapping_comment_jump_backward = '<C-k>'
let g:doge_comment_jump_nodes = ['i']
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ INDENT LINE
"===============================================================
let g:indentLine_defaultGroup = 'Whitespace'
let g:indentLine_char ='┆' 
let g:indentLine_fileTypeExclude = ['fzf']
let g:indentLine_enabled = 0
let g:indentLine_setColors = 0

nnoremap <silent> <leader>i :IndentLinesToggle<CR>
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ SANDWICH
"===============================================================
let g:sandwich#recipes = g:sandwich#default_recipes
let g:sandwich#recipes += [
			\ {'buns': ["( ", " )"], 'nesting': 1, 'match_syntax': 1, 'input': ['('] },
			\ {'buns': ["[ ", " ]"], 'nesting': 1, 'match_syntax': 1, 'input': ['['] },
			\ {'buns': ["{ ", " }"], 'nesting': 1, 'match_syntax': 1, 'input': ['{'] },
			\ ]
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ AIRLINE
"===============================================================
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline_extensions = [
			\'branch',
			\'fugitiveline',
			\'hunks',
			\'keymap',
			\'undotree',
			\'netrw',
			\'obsession',
			\'po',
			\'quickfix',
			\'tabline',
			\'tagbar',
			\'term',
			\'vimtex',
			\'wordcount'
			\]
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ ULTISNIPS
"===============================================================
" let g:UltiSnipsExpandTrigger="<C-y>"
" let g:UltiSnipsJumpForwardTrigger="<C-j>"
" let g:UltiSnipsJumpBackwardTrigger="<C-k>"

" let g:UltiSnipsSnippetDirectories = [$HOME.'/dotfiles/snippets', 'Ultisnips']
" let g:UltiSnipsEditSplit="vertical"
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ PANDOC
"===============================================================
let g:pandoc#formatting#mode = 'h'
let g:pandoc#folding#fdc = 0
let g:pandoc#spell#enabled = 0
let g:pandoc#formatting#textwidth = 100
let g:pandoc#syntax#conceal#blacklist = [
			\ 'subscript',
			\ 'superscript',
			\ 'codeblock_start',
			\ 'codeblock_delim',
			\ 'atx',
			\ 'list',
			\ 'dashes'
			\ ]
let g:pandoc#modules#disabled = [
			\ 'folding',
			\ 'spell'
			\ ]
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ SILICON
"===============================================================
let g:silicon = {
			\ 'theme':     'Monokai Extended',
			\ 'font':           'Victor Mono',
			\ 'background':         '#252525',
			\ 'shadow-color':       '#000000',
			\ 'line-pad':                   2,
			\ 'pad-horiz':                 80,
			\ 'pad-vert':                 100,
			\ 'shadow-blur-radius':         5,
			\ 'shadow-offset-x':            0,
			\ 'shadow-offset-y':            0,
			\ 'line-number':           v:true,
			\ 'round-corner':          v:true,
			\ 'window-controls':       v:true,
			\ 'default-file-pattern':      '',
			\ }
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ FZF
"===============================================================
augroup FZF
	autocmd! FileType fzf
	autocmd FileType fzf setlocal nonumber norelativenumber signcolumn=no
	autocmd FileType fzf tnoremap <Esc> <C-c>
augroup end

command! -bang -nargs=* Rg
			\ call fzf#vim#grep(
			\   'rg --column --line-number --no-heading --color=never --smart-case '.shellescape(<q-args>), 1,
			\   fzf#vim#with_preview(),
			\   <bang>0)

if has('nvim')
	hi NormalFloat guibg=None
	if exists('g:fzf_colors.bg')
		call remove(g:fzf_colors, 'bg')
endif

	let g:fzf_layout = { 'window': { 
				\'width': 0.75, 
				\'height': 0.75, 
				\'highlight': 'Special',
				\'border': 'sharp'
				\} }

endif

command! -bang -nargs=* GGrep
			\ call fzf#vim#grep(
			\   'git grep --line-number '.shellescape(<q-args>), 0,
			\   fzf#vim#with_preview({ 'dir': systemlist('git rev-parse --show-toplevel')[0] }), <bang>0)

command! -bang -nargs=? -complete=dir Files
			\ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir HFiles
			\ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'fd --type file --hidden --no-ignore --exclude ".git/*"'}), <bang>0)

autocmd Filetype fzf tmap <silent> <C-d> <Esc>;q<CR>
autocmd Filetype fzf tmap <silent> <C-c> <Esc>;q<CR>

nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>fho :Files ~/<CR>
nnoremap <silent> <leader>fhi :HFiles<CR>
nnoremap <silent> <leader>fhh :HFiles ~/<CR>
nnoremap <silent> <leader>gg :GGrep<CR>
nnoremap <silent> <leader>gf :GFiles<CR>
nnoremap <silent> <leader>rg :Rg<CR>
nnoremap <silent> <leader>fl :BLines<CR>
nnoremap <silent> <leader>fal :Lines<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>fw :Windows<CR>
nnoremap <silent> <leader>ft :Tags<CR>
nnoremap <silent> <leader>fc :Commits<CR>
nnoremap <silent> <leader>fhe :Helptags<CR>
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ UNDOTREE
"===============================================================
nnoremap <silent> <leader>u :UndotreeToggle<CR>

let g:undotree_SplitWidth = 40
let g:undotree_DiffpanelHeight = 15
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ TAGBAR
"===============================================================
nnoremap <silent> <leader>t :TagbarToggle<CR>
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ FUGITIVE
"===============================================================
cnoreabbrev gp Gpush
cnoreabbrev gl Gpull
"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ VIMWIKI
"===============================================================
let g:vimwiki_list = [{'path': '~/vimwiki/',
			\ 'syntax': 'markdown'}]
let g:vimwiki_dir_link = 'index'
let g:vimwiki_folding = 'list'
"===============================================================
"}}}
"===============================================================

"===============================================================
"}}}
"===============================================================

"===============================================================
"{{{ THEMING
"===============================================================
set termguicolors
colorscheme wpgtkAltTrue
let g:airline_theme = 'wpgtk_alternate_true'
"===============================================================
"}}}
"===============================================================
