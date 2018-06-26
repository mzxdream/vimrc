" General {
    filetype off                   " 这是必需的 
    set nocompatible               " 关闭 vi 兼容模式
    set autoread                   " 文件外部变动自动加载
    set autowrite                  " 自动保存
    set mouse=a                    " 鼠标支持
    set helplang=cn                " 中文文档
    set nu
    " set nobackup                 " 从不备份
    " set noswapfile               " 关闭交换文件
    " set whichwrap+=<,>,h,l       " 退格和方向可以换行
    " set mouse=n                  " 所有模式使用鼠标
    " set matchtime=1              " 匹配括号高亮的时间（单位是十分之一秒）
    set fileencodings=utf-8        " 文件编码设置
    " set t_ti= t_te=              " 设置退出vim后，内容显示在终端屏幕
    set hidden                     " 允许在有未保存的修改时切换缓冲区
    map <tab> :bn<cr>              " 切换下一个页面
    map <S-tab> :bp<cr>            " 切换上一个页面
    set autochdir                  " 自动设置当前目录为正在编辑的目录
    syntax on
" }

" Formatting {
    set wrap                        " 控制长行是否折到下一行显示
    set cc=80                       " 显示80个字符竖线
    set expandtab                   " 用空格代替tab
    set shiftwidth=4                " 缩进用4个空格表示
    set tabstop=4                   " 一个tab相当于4个空格
    set softtabstop=4
    set backspace=eol,start,indent  " allow backspace over everything
    set nojoinspaces                " 用J命令合并两行时会用一个空格来分隔
    "set listchars=tab:>-,trail:~,extends:>,precedes:< "show special character
    " show invisible
    set list
    set list listchars=tab:▸\ ,trail:·,precedes:←,extends:→,nbsp:␣
    hi NonText ctermfg=16 guifg=#4a4a59
    hi SpecialKey ctermfg=16 guifg=#4a4a59
" }

" search {
    set incsearch                   " 跟踪搜索
    set hlsearch                    " 高亮搜索
    set ignorecase                  " 搜索忽略大小写
" }

" vim-plug {
    call plug#begin('~/.vim/plugged')

    Plug 'ludovicchabant/vim-gutentags'
    Plug 'scrooloose/nerdtree'
    Plug 'w0rp/ale'
    Plug 'octol/vim-cpp-enhanced-highlight'
    Plug 'Valloric/YouCompleteMe'

    call plug#end()
"}

" nerdtree {
    let NERDTreeQuitOnOpen=0        " not close on file open
    map <C-l> :NERDTreeToggle<CR>
    let NERDTreeShowLineNumbers=1 " 显示行号
    let NERDTreeAutoCenter=1
    let NERDTreeShowHidden=1 " 是否显示隐藏文件
    let NERDTreeWinSize=31 " 设置宽度
    let g:nerdtree_tabs_open_on_console_startup=1 " 在终端启动vim时，共享NERDTree
    let NERDTreeIgnore=['\.pyc','\~$','\.swp'] " 忽略一下文件的显示
    let NERDTreeShowBookmarks=1 " 显示书签列表
" }

" ale {
    let g:ale_sign_column_always = 1
    let g:ale_set_highlights = 0
    let g:ale_sign_error = '✗'
    let g:ale_sign_warning = '⚡'
    let g:ale_statusline_format = ['✗ %d', '⚡ %d', '✔ OK']
    let g:ale_echo_msg_error_str = 'E'
    let g:ale_echo_msg_warning_str = 'W'
    let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
    nmap sp <Plug>(ale_previous_wrap)
    nmap sn <Plug>(ale_next_wrap)
    nmap <Leader>s :ALEToggle<CR>
    nmap <Leader>d :ALEDetail<CR>
    set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}\ %{ALEGetStatusLine()}
    let g:ale_lint_on_text_changed = 'never'
    let g:ale_lint_on_enter = 0
    let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
    let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++11'
" }

" YCM {
    let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
    let g:ycm_add_preview_to_completeopt = 0
    let g:ycm_show_diagnostics_ui = 0
    let g:ycm_server_log_level = 'info'
    let g:ycm_min_num_identifier_candidate_chars = 2
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_complete_in_strings=1
    let g:ycm_key_invoke_completion = '<c-z>'
    set completeopt=menu,menuone
    
    noremap <c-z> <NOP>
    
    let g:ycm_semantic_triggers =  {
               \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
               \ 'cs,lua,javascript': ['re!\w{2}'],
               \ }
"}

" indent {
    let g:indentLine_char='┆'
    let g:indentLine_enabled = 1
    "autocmd BufNewFile,BufRead *.h,*.c setfiletype cpp " h和c文件类型用cpp
    "set autoindent                  " 自动缩进
    "set smartindent                 " 智能缩进
    "set cindent                     " c/c++风格
    "set cino+=g0,:0,l1,b1,t0
    if exists("b:did_indent")
        finish
    endif
    let b:did_indent = 1
    function! GoogleCppIndent()
        let l:cline_num = line('.')
    
        let l:orig_indent = cindent(l:cline_num)
    
        if l:orig_indent == 0 | return 0 | endif
    
        let l:pline_num = prevnonblank(l:cline_num - 1)
        let l:pline = getline(l:pline_num)
        if l:pline =~# '^\s*template' | return l:pline_indent | endif
    
        " TODO: I don't know to correct it:
        " namespace test {
        " void
        " ....<-- invalid cindent pos
        "
        " void test() {
        " }
        "
        " void
        " <-- cindent pos
        if l:orig_indent != &shiftwidth | return l:orig_indent | endif
    
        let l:in_comment = 0
        let l:pline_num = prevnonblank(l:cline_num - 1)
        while l:pline_num > -1
            let l:pline = getline(l:pline_num)
            let l:pline_indent = indent(l:pline_num)
    
            if l:in_comment == 0 && l:pline =~ '^.\{-}\(/\*.\{-}\)\@<!\*/'
                let l:in_comment = 1
            elseif l:in_comment == 1
                if l:pline =~ '/\*\(.\{-}\*/\)\@!'
                    let l:in_comment = 0
                endif
            elseif l:pline_indent == 0
                if l:pline !~# '\(#define\)\|\(^\s*//\)\|\(^\s*{\)'
                    if l:pline =~# '^\s*namespace.*'
                        return 0
                    else
                        return l:orig_indent
                    endif
                elseif l:pline =~# '\\$'
                    return l:orig_indent
                endif
            else
                return l:orig_indent
            endif
    
            let l:pline_num = prevnonblank(l:pline_num - 1)
        endwhile
    
        return l:orig_indent
    endfunction
    
    set cindent
    set cinoptions=l1,g0,t0,W4
    
    let b:undo_indent = "setl sw< ts< sts< et< tw< wrap< cin< cino< inde<"
    
    if has("autocmd")
        autocmd BufEnter *.{cc,cxx,cpp,h,hh,hpp,hxx} setlocal indentexpr=GoogleCppIndent()
    endif
" }

" gutentags{
    " gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
    let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
    
    " 所生成的数据文件的名称
    let g:gutentags_ctags_tagfile = '.tags'
    
    " 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
    let s:vim_tags = expand('~/.cache/tags')
    let g:gutentags_cache_dir = s:vim_tags
    
    " 配置 ctags 的参数
    let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
    let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
    let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
    
    " 检测 ~/.cache/tags 不存在就新建
    if !isdirectory(s:vim_tags)
       silent! call mkdir(s:vim_tags, 'p')
    endif
" }
