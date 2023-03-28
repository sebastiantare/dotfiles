" plugins
call plug#begin('~/.local/share/nvim/plugged')

Plug 'sheerun/vim-polyglot'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }
call plug#end()

" CONF
syntax on " highlight syntax
set number " show line numbers
set noswapfile " disable the swapfile
set hlsearch " highlight all results
set ignorecase " ignore case in search
set incsearch " show search results as you type
set shiftwidth=3
let mapleader = "<"


" COC CONFIG

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" MY COC CONFS

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

inoremap <silent><expr> <c-space> coc#refresh()

" Vim syntax file
" Language:	C++
" Current Maintainer:	vim-jp (https://github.com/vim-jp/vim-cpp)
" Previous Maintainer:	Ken Shan <ccshan@post.harvard.edu>
" Last Change:	2021 May 04

" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" inform C syntax that the file was included from cpp.vim
let b:filetype_in_cpp_family = 1

" Read the C syntax to start with
runtime! syntax/c.vim
unlet b:current_syntax

" C++ extensions
syn keyword cppStatement	new delete this friend using
syn keyword cppAccess		public protected private
syn keyword cppModifier		inline virtual explicit export
syn keyword cppType		bool wchar_t
syn keyword cppExceptions	throw try catch
syn keyword cppOperator		operator typeid
syn keyword cppOperator		and bitor or xor compl bitand and_eq or_eq xor_eq not not_eq
syn match cppCast		"\<\(const\|static\|dynamic\|reinterpret\)_cast\s*<"me=e-1
syn match cppCast		"\<\(const\|static\|dynamic\|reinterpret\)_cast\s*$"
syn keyword cppStorageClass	mutable
syn keyword cppStructure	class typename template namespace
syn keyword cppBoolean		true false
syn keyword cppConstant		__cplusplus

" C++ 11 extensions
if !exists("cpp_no_cpp11")
  syn keyword cppModifier	override final
  syn keyword cppType		nullptr_t auto
  syn keyword cppExceptions	noexcept
  syn keyword cppStorageClass	constexpr decltype thread_local
  syn keyword cppConstant	nullptr
  syn keyword cppConstant	ATOMIC_FLAG_INIT ATOMIC_VAR_INIT
  syn keyword cppConstant	ATOMIC_BOOL_LOCK_FREE ATOMIC_CHAR_LOCK_FREE
  syn keyword cppConstant	ATOMIC_CHAR16_T_LOCK_FREE ATOMIC_CHAR32_T_LOCK_FREE
  syn keyword cppConstant	ATOMIC_WCHAR_T_LOCK_FREE ATOMIC_SHORT_LOCK_FREE
  syn keyword cppConstant	ATOMIC_INT_LOCK_FREE ATOMIC_LONG_LOCK_FREE
  syn keyword cppConstant	ATOMIC_LLONG_LOCK_FREE ATOMIC_POINTER_LOCK_FREE
  syn region cppRawString	matchgroup=cppRawStringDelimiter start=+\%(u8\|[uLU]\)\=R"\z([[:alnum:]_{}[\]#<>%:;.?*\+\-/\^&|~!=,"']\{,16}\)(+ end=+)\z1"\(sv\|s\|_[_a-zA-Z][_a-zA-Z0-9]*\)\=+ contains=@Spell
  syn match cppCast		"\<\(const\|static\|dynamic\)_pointer_cast\s*<"me=e-1
  syn match cppCast		"\<\(const\|static\|dynamic\)_pointer_cast\s*$"
endif

" C++ 14 extensions
if !exists("cpp_no_cpp14")
  syn match cppNumbers		display transparent "\<\d\|\.\d" contains=cppNumber,cppFloat
  syn match cppNumber		display contained "\<0\([Uu]\=\([Ll]\|LL\|ll\)\|\([Ll]\|LL\|ll\)\=[Uu]\|i[fl]\=\|h\|min\|s\|ms\|us\|ns\|_\i*\)\=\>"
  syn match cppNumber		display contained "\<[1-9]\('\=\d\+\)*\([Uu]\=\([Ll]\|LL\|ll\)\|\([Ll]\|LL\|ll\)\=[Uu]\|i[fl]\=\|h\|min\|s\|ms\|us\|ns\|_\i*\)\=\>"
  syn match cppNumber		display contained "\<0\o\+\([Uu]\=\([Ll]\|LL\|ll\)\|\([Ll]\|LL\|ll\)\=[Uu]\|i[fl]\=\|h\|min\|s\|ms\|us\|ns\|_\i*\)\=\>"
  syn match cppNumber		display contained "\<0b[01]\('\=[01]\+\)*\([Uu]\=\([Ll]\|LL\|ll\)\|\([Ll]\|LL\|ll\)\=[Uu]\|i[fl]\=\|h\|min\|s\|ms\|us\|ns\|_\i*\)\=\>"
  syn match cppNumber		display contained "\<0x\x\('\=\x\+\)*\([Uu]\=\([Ll]\|LL\|ll\)\|\([Ll]\|LL\|ll\)\=[Uu]\|i[fl]\=\|h\|min\|s\|ms\|us\|ns\|_\i*\)\=\>"
  syn match cppFloat		display contained "\<\d\+\.\d*\(e[-+]\=\d\+\)\=\([FfLl]\|i[fl]\=\|h\|min\|s\|ms\|us\|ns\|_\i*\)\=\>"
  syn match cppFloat		display contained "\<\.\d\+\(e[-+]\=\d\+\)\=\([FfLl]\|i[fl]\=\|h\|min\|s\|ms\|us\|ns\|_\i*\)\=\>"
  syn match cppFloat		display contained "\<\d\+e[-+]\=\d\+\([FfLl]\|i[fl]\=\|h\|min\|s\|ms\|us\|ns\|_\i*\)\=\>"
  syn region cppString		start=+\(L\|u\|u8\|U\)\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"\(sv\|s\|_\i*\)\=+ end='$' contains=cSpecial,cFormat,@Spell
endif

" C++ 17 extensions
if !exists("cpp_no_cpp17")
  syn match cppCast		"\<reinterpret_pointer_cast\s*<"me=e-1
  syn match cppCast		"\<reinterpret_pointer_cast\s*$"
  syn match cppFloat		display contained "\<0x\x*\.\x\+p[-+]\=\d\+\([FfLl]\|i[fl]\=\|h\|min\|s\|ms\|us\|ns\|_\i*\)\=\>"
  syn match cppFloat		display contained "\<0x\x\+\.\=p[-+]\=\d\+\([FfLl]\|i[fl]\=\|h\|min\|s\|ms\|us\|ns\|_\i*\)\=\>"

  " TODO: push this up to c.vim if/when supported in C23
  syn match cppCharacter	"u8'[^\\]'"
  syn match cppCharacter	"u8'[^']*'" contains=cSpecial
  if exists("c_gnu")
    syn match cppSpecialError	  "u8'\\[^'\"?\\abefnrtv]'"
    syn match cppSpecialCharacter "u8'\\['\"?\\abefnrtv]'"
  else
    syn match cppSpecialError	  "u8'\\[^'\"?\\abfnrtv]'"
    syn match cppSpecialCharacter "u8'\\['\"?\\abfnrtv]'"
  endif
  syn match cppSpecialCharacter display "u8'\\\o\{1,3}'"
  syn match cppSpecialCharacter display "u8'\\x\x\+'"

endif

" C++ 20 extensions
if !exists("cpp_no_cpp20")
  syn match cppNumber		display contained "\<0\(y\|d\)\>"
  syn match cppNumber		display contained "\<[1-9]\('\=\d\+\)*\(y\|d\)\>"
  syn match cppNumber		display contained "\<0\o\+\(y\|d\)\>"
  syn match cppNumber		display contained "\<0b[01]\('\=[01]\+\)*\(y\|d\)\>"
  syn match cppNumber		display contained "\<0x\x\('\=\x\+\)*\(y\|d\)\>"
  syn keyword cppStatement	co_await co_return co_yield requires
  syn keyword cppStorageClass	consteval constinit
  syn keyword cppStructure	concept
  syn keyword cppType		char8_t
  syn keyword cppModule		import module export
endif

" The minimum and maximum operators in GNU C++
syn match cppMinMax "[<>]?"

" Default highlighting
hi def link cppAccess			cppStatement
hi def link cppCast			cppStatement
hi def link cppExceptions		Exception
hi def link cppOperator			Operator
hi def link cppStatement		Statement
hi def link cppModifier			Type
hi def link cppType			Type
hi def link cppStorageClass		StorageClass
hi def link cppStructure		Structure
hi def link cppBoolean			Boolean
hi def link cppCharacter		cCharacter
hi def link cppSpecialCharacter		cSpecialCharacter
hi def link cppSpecialError		cSpecialError
hi def link cppConstant			Constant
hi def link cppRawStringDelimiter	Delimiter
hi def link cppRawString		String
hi def link cppString			String
hi def link cppNumber			Number
hi def link cppFloat			Number
hi def link cppModule			Include

let b:current_syntax = "cpp"

" vim: ts=8
