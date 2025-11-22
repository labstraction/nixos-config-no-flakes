{ pkgs, ... }:
{
  environment.variables = { EDITOR = "vim"; };

  environment.systemPackages = with pkgs; [

    ((vim_configurable.override {  }).customize{

      name = "vim";

      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ 
          vim-nix
          copilot-vim
        ];
        opt = [];
      };

      vimrcConfig.customRC = ''
        let mapleader=" "

        nnoremap <leader>b :buffers<CR>:buffer<Space>

        nnoremap <leader>r :registers<CR>:normal<Space>"
        vnoremap <leader>r :registers<CR>:normal<Space>"

        nnoremap <leader>m :marks<CR>:normal<Space>'

        nnoremap <tab> <C-w>W

        "remap leader z to toggle fold
        nnoremap <leader>z za
        "remap leader c to toggle comment"
        nnoremap <Leader>c :call ToggleComment()<CR>
        vnoremap <Leader>c :call ToggleComment()<CR>
        "remap a Ctrl-c to toggle between auto complete modes
        inoremap <C-@> <C-R>=ToggleAutoComplete()<CR>
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
        
        "remap control up and down to move lines
        nnoremap <A-Down> :m .+1<CR>==
        nnoremap <A-Up> :m .-2<CR>==
        inoremap <A-Down> <Esc>:m .+1<CR>==gi
        inoremap <A-Up> <Esc>:m .-2<CR>==gi
        vnoremap <A-Down> :m '>+1<CR>gv=gv
        vnoremap <A-Up> :m '<-2<CR>gv=gv
        
        "remap leader qr to search and repalce quickfix files
        nnoremap <leader>qr :cfdo :%s///gc<Left><Left><Left><Left>

        "remap esc esc to exit terminal mode
        tnoremap <Esc><Esc> <C-\><C-n>

        "remap Q to use macro q
        nnoremap Q @q

        syntax enable "enable syntax highlighting
        autocmd! BufNewFile,BufRead *.frag set ft=c
        autocmd! BufNewFile,BufRead *.*js set syntax=typescript
        autocmd! BufNewFile,BufRead *.*json set ft=json

        set laststatus=2 "always show statusline
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
        highlight Normal ctermbg=BLACK guibg=BLACK
        colorscheme retrobox
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
        set wildoptions=pum

        "findfiles---------------------------
        set path+=** "search subdirectories

        set number "set line numbers
        set relativenumber "set relative line numbers

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
        inoremap `` ``<left>
        "If you close a bracket that is already closed, it overwrites
        inoremap <expr> ) strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
        inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
        inoremap <expr> ] strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
        inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "'" ? "\<Right>" : "'"
        inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\""
        inoremap <expr> ` strpart(getline('.'), col('.')-1, 1) == "`" ? "\<Right>" : "`"
        "enclose a selection in visual mode with "'({[
        vnoremap ` <Esc>`<i`<Esc>`>a<right>`<Esc>
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
        \   "nix": '#'
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
