" ~/.vimrc — 最小实用版（无插件，纯内置能力）

set nocompatible
filetype plugin indent on
syntax on

" ===== 界面 =====
set number              " 行号
set ruler               " 右下角光标位置
set showcmd             " 显示输入中的命令
set wildmenu            " 命令行补全菜单
set laststatus=2        " 总是显示状态栏
set scrolloff=5         " 光标上下保留 5 行
set display=lastline    " 长行尽量显示完整
set termguicolors       " 真彩色
set mouse=a             " 鼠标可用

" ===== 搜索 =====
set ignorecase          " 搜索忽略大小写
set smartcase           " 但有大写时区分大小写
set incsearch           " 边输入边高亮
set hlsearch            " 高亮所有匹配
" 回车清除搜索高亮
nnoremap <silent> <CR> :nohlsearch<CR><CR>

" ===== 缩进 =====
set expandtab           " Tab 转空格
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

" ===== 编辑体验 =====
set hidden              " 允许有未保存改动时切缓冲区
set backspace=indent,eol,start
" 与系统剪贴板互通：当前 vim 是 -clipboard 编译版，装 gvim 包即可获得 +clipboard
if has('clipboard')
  set clipboard=unnamedplus
endif
set encoding=utf-8
set updatetime=300

" ===== 文件 / 持久撤销 =====
set noswapfile
set nobackup
set undofile
set undodir=~/.cache/vim/undo//
if !isdirectory(expand('~/.cache/vim/undo'))
  call mkdir(expand('~/.cache/vim/undo'), 'p')
endif

" ===== 记住上次光标位置 =====
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
