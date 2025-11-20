{ pkgs, ... }:
{
  environment.variables = { EDITOR = "vim"; };

  environment.systemPackages = with pkgs; [

    ((vim_configurable.override {  }).customize{

      name = "vim";

      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-nix ];
        opt = [];
      };

      vimrcConfig.customRC = ''
        set nocompatible "be iMproved, required
        "set leader to space
        let mapleader=" "
        "remap leader b to open buffer list and switch
        nnoremap <leader>b :buffers<CR>:buffer<Space>
        "remap leader r to use registers
        nnoremap <leader>r :registers<CR>:normal<Space>"
        vnoremap <leader>r :registers<CR>:normal<Space>"
        "remap leader m to use marks
        nnoremap <leader>m :marks<CR>:normal<Space>'
        "remap tab to switch between visible windows
        nnoremap <tab> <C-w>W
        "remap leader i to indent current line
        nnoremap <leader>i ==
        "remap leader i to indent selection
        vnoremap <leader>i =
        "remap leader e to open filetree
        nnoremap <leader>e :Lexplore<cr><cr>
        "remap leader z to toggle fold
        nnoremap <leader>z za
        "remap leader c to toggle comment"
        nnoremap <Leader>c :call ToggleComment()<CR>
        vnoremap <Leader>c :call ToggleComment()<CR>
        "remap leader v to edit vimrc
        nnoremap <Leader>v :e $MYVIMRC<cr>
        "remap leader vs to source vimrc
        nnoremap <Leader>vs :source $MYVIMRC<cr>
        "remap a Ctrl-c to toggle between auto complete modes
        inoremap <C-@> <C-R>=ToggleAutoComplete()<CR>
        "remap leader t to toggle terminal
        nnoremap <leader>t <cmd>call ToggleTerm()<cr>
        "remap leader K to kill
        nnoremap <leader>k :wa<CR>:mks! ~/temp_vim/main-session.vim<CR>:qa<CR>
        "remap leader l to open last session
        nnoremap <leader>l :source ~/temp_vim/main-session.vim<CR>
        "remap leader h to clear search highlight
        nnoremap <leader>h :nohlsearch<CR>
        "remap leader f to replace
        nnoremap <leader>f :%s///gc<Left><Left><Left><left>
        "remap leader g to grep project
        nnoremap <leader>g :call GrepProject(v:true)<CR>
        "remap leader gg to grep project for word under cursor
        nnoremap <leader>gg :call GrepProject(v:false)<CR>
        "remap leader a to select all
        nnoremap <leader>a ggVG
        "remap control up and down to move lines
        nnoremap <A-Down> :m .+1<CR>==
        nnoremap <A-Up> :m .-2<CR>==
        inoremap <A-Down> <Esc>:m .+1<CR>==gi
        inoremap <A-Up> <Esc>:m .-2<CR>==gi
        vnoremap <A-Down> :m '>+1<CR>gv=gv
        vnoremap <A-Up> :m '<-2<CR>gv=gv
        "remap leader q to open/close quickfix
        nnoremap <leader>q :call ToggleQuickFix()<CR>
        "remap leader qn to go to next quickfix
        nnoremap <leader>qn :cn<CR>
        "remap leader qp to go to previous quickfix
        nnoremap <leader>qp :cp<CR>
        "remap leader qr to search and repalce quickfix files
        nnoremap <leader>qr :cfdo :%s///gc<Left><Left><Left><Left>
        "remap ctrl-d to insert date
        inoremap <C-d> <C-R>=strftime("%FT%T%z")<CR>


        "remap esc esc to exit terminal mode
        tnoremap <Esc><Esc> <C-\><C-n>


        "remap leader s to toggle spellcheck
        nnoremap <leader>s :setlocal spell!<cr>
        "remap leader ss to suggest word under cursor
        nnoremap <leader>ss z=
        "remap leader sn to next misspelled word"
        nnoremap <leader>sn ]s
        "remap leader sp to previous misspelled word
        nnoremap <leader>sp [s
        "remap leader sa to add word to dictionary
        nnoremap <leader>sa zg
        "remap leader sr to remove word from dictionary
        nnoremap <leader>sr zw

        "remap Q to use macro q
        nnoremap Q @q

        "syntax-------------------------------
        syntax enable "enable syntax highlighting
        autocmd! BufNewFile,BufRead *.frag set ft=c
        autocmd! BufNewFile,BufRead *.*js set syntax=typescript
        autocmd! BufNewFile,BufRead *.*json set ft=json

        "statusline---------------------------
        set laststatus=2 "always show statusline
        if has('nvim')
        set laststatus=3  "only one statusline in neovim
        endif        
        set showcmd "show command in bottom right
        set statusline=[%n][%f]%y%=%(%h%1*%m%*%r%w%q%)[%l(%p%%/%L),%v]

        "display--------------------------------
        let &t_SI = "\e[6 q" "set cursor to block
        let &t_EI = "\e[2 q" "set cursor to line
        set ttimeout "enable timeout
        set ttimeoutlen=1 "set timeout length
        set ttyfast "speed up terminal vim
        set shortmess=atI "hide startup message
        set t_Co=256 "set terminal to 256 colors
        set termguicolors "enable true colors
        set background=dark "set background to dark
        set cursorline "highlight current line
        set cursorcolumn "highlight current column
        set cmdheight=1 "height of command bar
        set showmode "show current mode
        set scrolloff=3 "keep 3 lines above and below cursor
        set nowrap "don't wrap lines
        if has('nvim')
        colorscheme habamax "set color scheme
        highlight Normal ctermbg=BLACK guibg=BLACK
        else
        if v:version >= 900
            colorscheme retrobox
        else
            colorscheme slate
        endif
        endif
        set splitbelow "open new split below
        set splitright "open new split to the right

        "indentation---------------------------
        set autoindent "autoindent
        set shiftwidth=4 "set shiftwidth to 4
        set tabstop=4 "set tabstop to 4
        set softtabstop=4 "set softtabstop to 4
        set expandtab "expand tabs to spaces
        "-------------------------------------

        "search-------------------------------
        set ignorecase "ignore case when searching
        set smartcase "ignore case if search pattern is all lowercase
        set incsearch "incremental search
        set hlsearch "highlight search results

        "wildmenu-----------------------------
        set wildmenu "enable wildmenu
        set wildignorecase "ignore case when searching
        if v:version >= 900
        set wildoptions=pum
        endif
        "findfiles---------------------------
        set path+=** "search subdirectories

        "linenumber---------------------------
        set number "set line numbers
        set relativenumber "set relative line numbers

        "filetree-----------------------------
        let g:netrw_banner = 0 "disable banner
        let g:netrw_liststyle = 3 "tree style
        let g:netrw_browse_split = 4 "open in previous window
        let g:netrw_altv = 1 "open splits to the right
        let g:netrw_winsize = 20 "set width of netrw window

        "smallfix-----------------------------
        set clipboard^=unnamed,unnamedplus "enable clipboard
        set noerrorbells visualbell t_vb= "no beeps
        set lazyredraw "redraw only when we need to.
        "set shortmess+=aI "no splash screen
        set backspace=indent,eol,start "backspace through everything in insert mode
        set viminfo=h,'500,<1000,s1000,/1000,:1000 "nohlsearch,'filemarks,<register,/search,:commands
        set hidden "hide buffers when they are abandoned
        set ffs=unix,dos,mac  "fileformats
        set encoding=utf8 "set encoding to utf8
        set tags=tags
        set mouse=a

        "fold----------------------------------
        set foldenable "enable folding
        set foldlevelstart=10 "open most folds by default
        set foldnestmax=10 "deepest fold is 10 levels
        set foldmethod=indent "fold based on indent level


        "terminal"------------------------------"
        fun! ToggleTerm()
        let l:OpenTerm = {x -> x
            \  ? { -> execute('botright 10 split +term') }
            \  : { -> execute('botright term ++rows=10') }
            \ }(has('nvim'))
        let term = gettabvar(tabpagenr(), 'term',
            \ {'main': -1, 'winnr': -1, 'bufnr': -1})
        if ! bufexists(term.bufnr)
        call l:OpenTerm()
        call settabvar(tabpagenr(), 'term',
              \ {'main': winnr('#'), 'winnr': winnr(), 'bufnr': bufnr()})
        setl winheight=10
        else
        if ! len(filter(tabpagebuflist(), {_,x -> x == term.bufnr}))
          exe 'botright 10 split +b\ ' . term.bufnr
        else
          exe term.winnr . ' wincmd c'
        endif
        endif
        endfun

        "autocomplete---------------------------
        filetype plugin on "enable filetype plugins
        filetype indent on "enable filetype indentation
        set omnifunc=syntaxcomplete#Complete "set omnifunc to syntaxcomplete
        set completeopt=noinsert,menuone,preview "set completeopt
        inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
        let g:auto_complete_modes = [
                \    "\<C-x>\<C-n>",
                \    "\<C-x>\<C-f>",
                \    "\<C-x>\<C-o>",
                \    "\<C-x>\<C-l>"]
        let g:auto_complete_mode_index = 0

        function! ToggleAutoComplete()
        let l:auto_complete_mode = g:auto_complete_modes[g:auto_complete_mode_index]
        let g:auto_complete_mode_index = (g:auto_complete_mode_index + 1) % len(g:auto_complete_modes)
        return l:auto_complete_mode
        endfunction

        autocmd CompleteDone * if !empty(v:completed_item) | let g:auto_complete_mode_index = 1 | endif

        "brackets-------------------------------
        set showmatch "show matching brackets
        "Close brackets automatically, with return
        inoremap {<cr> {<cr>}<C-O><S-O>
        inoremap (<cr> (<cr>)<c-o><s-o>
        inoremap [<cr> [<cr>]<c-o><s-o>
        "Close brackets without return
        inoremap (( ()<left>
        inoremap {{ {}<left>
        inoremap [[ []<left>
        inoremap "" ""<left>
        inoremap ''' '''<left>
        "If you close a bracket that is already closed, it overwrites
        inoremap <expr> ) strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
        inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
        inoremap <expr> ] strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
        inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "'" ? "\<Right>" : "'"
        inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\""
        "enclose a selection in visual mode with "'({[
        vnoremap ' <Esc>`<i'<Esc>`>a<right>'<Esc>
        vnoremap " <Esc>`<i"<Esc>`>a<right>"<Esc>
        vnoremap ( <Esc>`<i(<Esc>`>a<right>)<Esc>
        vnoremap { <Esc>`<i{<Esc>`>a<right>}<Esc>
        vnoremap [ <Esc>`<i[<Esc>`>a<right>]<Esc>
        "autoclose tags
        inoremap >> ><left><C-o>yi<<C-o>f><right></<C-o>p><C-o>F<
        inoremap >>> ><left><C-o>yi<<C-o>f><right></<C-o>p><C-o>F<<CR><C-o>O

        "autoread-------------------------------
        set autoread "auto reload files when changed outside vim
        au FocusGained,BufEnter * checktime "check for changes when vim regains focus

        "spell----------------------------------
        set spelllang=en,it "set spell language

        "regex-----------------------------------
        set magic "set magic
        set regexpengine=0 "set regex engine to auto

        "one dir for backup and undo--------------
        set nobackup "disable backup
        set undofile "enable undo file
        set undolevels=10000 "set undo levels
        set undoreload=10000 "set undo reload
        set undodir=~/temp_vim/undo// "set undo dir to ~/temp/undo
        set dir=~/temp_vim/swp// "set swap dir to ./swp

        "clean trailing spaces-------------------"
        fun! CleanExtraSpaces()
        let save_cursor = getpos(".")
        let old_query = getreg('/')
        silent! %s/\s\+$//e
        call setpos('.', save_cursor)
        call setreg('/', old_query)
        endfun
        "add command CleanSpaces to clean trailing spaces
        command! CleanSpaces call CleanExtraSpaces()

        "install copilot----------------------
        function! InstallCopilot()
        let slash = has('unix') ? '/' : '\'
        let path = strpart($MYVIMRC, 0, strridx($MYVIMRC, slash)+1)
        let copilotPath = path.'pack'.slash.'github'.slash.'start'.slash.'copilot.vim'
        echo 'is this the correct path: '.copilotPath.'?'
        let choice = input('press Y to continue, E to edit the path, or any other key to cancel')
        if choice == 'E'
            let copilotPath = input('enter the new path')
        endif
        if choice == 'Y' || choice == 'E'
            if empty(glob(copilotPath))
                echo 'Installing copilot.vim...'
                execute '!git clone https://github.com/github/copilot.vim.git '.copilotPath
            else
                echo 'Updating copilot.vim...'
                execute '!cd '.copilotPath.' && git pull'
            endif
        endif
        endfunction
        command! InstallCopilot call InstallCopilot()

        "toggle quickfix-----------------------------------
        fun! ToggleQuickFix()
        if empty(filter(getwininfo(), 'v:val.quickfix'))
            copen
        else
            cclose
        endif
        endfun

        "grep project-------------------------------
        fun! GrepProject(askWord)
        let search = expand('<cword>')
        if a:askWord
            let search = input('?: ')
        endif
        let cmd = 'grep -r '.search.' **'
        exec cmd
        exec 'copen'
        endfun

        "fuction to automate comment--------------
        let s:comment_map = {
        \   "c": '\/\/',
        \   "javascript": '\/\/',
        \   "typescript": '\/\/',
        \   "lua": '--',
        \   "python": '#',
        \   "rust": '\/\/',
        \   "sh": '#',
        \   "bashrc": '#',
        \   "mail": '>',
        \   "vim": '"',
        \ }

        fun! ToggleComment()
        if has_key(s:comment_map, &filetype)
            let comment_leader = s:comment_map[&filetype]
            if getline('.') =~ '^\s*$'
                return
            endif
            if getline('.') =~ '^\s*' . comment_leader
                exec 'silent s/\v\s*\zs' . comment_leader . '\s*\ze//'
            else
                exec 'silent s/\v^(\s*)/\1' . comment_leader . ' /'
            endif
        else
            echo "No comment leader found for filetype"
        endif
        endfun
      '';

    })
  ];
}
