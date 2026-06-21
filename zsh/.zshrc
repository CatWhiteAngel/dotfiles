# ~/.zshrc — 2026-06-06 优化版（原配置备份在 ~/.zshrc.bak-20260606）

#环境变量
export PATH="$HOME/.local/bin:$PATH"
export GPG_TTY=$(tty)   # GPG 签名时 pinentry 需要知道当前 tty

# ===== 历史记录 =====
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
setopt share_history          # 多终端实时共享历史
setopt hist_ignore_all_dups   # 重复命令只留最新一条
setopt hist_ignore_space      # 空格开头的命令不入历史（输密码等敏感操作可用）
setopt hist_reduce_blanks     # 去除多余空格
setopt hist_verify            # 历史展开先显示再执行

# ===== 常用选项 =====
setopt autocd                 # 直接输目录名即可 cd
setopt interactive_comments   # 命令行里可以写 # 注释

# ===== 补全系统 =====
# zsh-completions 包安装在 /usr/share/zsh/site-functions，已在默认 fpath 中
autoload -Uz compinit
# 补全缓存每天只重建一次，其余时间用 -C 跳过检查加速启动
_zcd=~/.cache/zsh/zcompdump
if [[ -n $_zcd(#qN.mh-24) ]]; then
	compinit -C -d "$_zcd"
else
	compinit -d "$_zcd"
fi
unset _zcd
zstyle ':completion:*' menu select                          # 方向键可选的补全菜单
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'      # 大小写不敏感
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"     # 补全列表带颜色
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.cache/zsh/zcompcache
zstyle ':completion:*:descriptions' format '%F{13}-- %d --%f'

# ===== 提示符（保留原风格 + git 信息）=====
autoload -Uz add-zsh-hook vcs_info
zstyle ':vcs_info:git:*' formats ' %F{#3DFF6E}(%b%u%c)%f'        # 霓虹绿 (分支*+)
zstyle ':vcs_info:git:*' actionformats ' %F{#FFB02E}(%b|%a)%f'   # rebase/merge 时橙色
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'                    # 有未暂存改动
zstyle ':vcs_info:git:*' stagedstr '+'                      # 有已暂存改动
add-zsh-hook precmd vcs_info
setopt prompt_subst
# 用户名粉红、主机名灰、路径亮青、括号亮紫；%# 按上条命令退出状态变色（成功绿/失败红）
PROMPT='%F{#C77DFF}[%f%F{#FF6BD6}%n%f%F{#7A7A8C}@%m%f %F{#33D9FF}%~%f%F{#C77DFF}]%f${vcs_info_msg_0_}
%(?.%F{#3DFF6E}.%F{#FF4757})%B%#%b%f '

# ===== 设置标题 =====
function xterm_title_precmd () {
	print -Pn -- '\e]2; %~\a'
	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
	print -Pn -- '\e]2; %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|wezterm*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

# ===== 插件（顺序有讲究：syntax-highlighting 之后才能加载 substring-search）=====
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# ===== 高亮颜色（高对比方案）=====
# -- 错误：粗体亮红，敲错命令一眼看出 --
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF4757,bold'
# -- 可执行物：霓虹绿粗体；不同来源用色温区分 --
ZSH_HIGHLIGHT_STYLES[command]='fg=#3DFF6E,bold'            # 外部命令
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#3DFF6E,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#2EE6A8,bold'            # 内置命令（偏青绿）
ZSH_HIGHLIGHT_STYLES[alias]='fg=#A8FF4A,bold'              # 别名（偏黄绿）
ZSH_HIGHLIGHT_STYLES[function]='fg=#A8FF4A,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#FF6BD6,bold'      # if/for/while 等
# -- sudo/doas 等前缀：橙底色块，最高警觉度 --
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#1A1A1A,bg=#FFA502,bold'
# -- 路径：亮青+下划线，存在的路径才会亮 --
ZSH_HIGHLIGHT_STYLES[path]='fg=#33D9FF,underline'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#33D9FF,underline'
# -- 字符串：明黄；带变量插值的部分更亮 --
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#FFE94A'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#FFE94A'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#FFE94A'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#FFB02E,bold'  # "$var"
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#FFB02E,bold'
# -- 选项参数：亮紫，和提示符呼应 --
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#C77DFF'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#C77DFF'
# -- 结构符号：粉红粗体（管道/分号/重定向/通配） --
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#FF6BD6,bold'   # | ; &&
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#FF6BD6,bold'        # > >> <
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#FF6BD6,bold'           # * ? [..]
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#FF6BD6,bold'  # !!
# -- 变量赋值/展开 --
ZSH_HIGHLIGHT_STYLES[assign]='fg=#33D9FF'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#33D9FF'
# -- 注释：灰色斜体，安静地待着 --
ZSH_HIGHLIGHT_STYLES[comment]='fg=#7A7A8C,italic'
# -- 命令替换 $(...)、反引号 --
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#FFB02E,bold'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#FFB02E,bold'

# 自动建议（灰色幽灵文字）调亮一档，看得清但不抢戏
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6C7086'
# 历史搜索命中高亮
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=#1A1A1A,bg=#3DFF6E,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=#1A1A1A,bg=#FF4757,bold'

# ===== 快捷键 =====
# 上下方向键 / ^P ^N：按已输入前缀搜索历史（substring-search 插件）
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P'   history-substring-search-up
bindkey '^N'   history-substring-search-down
# 常用编辑键
bindkey '^[[H'  beginning-of-line   # Home
bindkey '^[[F'  end-of-line         # End
bindkey '^[[3~' delete-char         # Delete

# ===== 命令行增强工具（未安装则自动跳过）=====
# fzf: Ctrl+R 模糊搜历史 / Ctrl+T 模糊找文件 / Alt+C 模糊跳目录
(( $+commands[fzf] )) && source <(fzf --zsh)
# zoxide: z <关键词> 跳转到常去的目录，zi 交互选择
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# ===== 别名 =====
# 添加方法：alias 名字='实际命令'，改完 source ~/.zshrc 或开新终端生效
if (( $+commands[eza] )); then
	alias ls='eza --icons'
	alias ll='eza -l --icons --git'
	alias la='eza -la --icons --git'
	alias lt='eza --tree --level=2 --icons'
else
	alias ls='ls --color=auto'
	alias ll='ls -lh --color=auto'
	alias la='ls -lah --color=auto'
fi
(( $+commands[bat] )) && alias cat='bat --paging=never'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias df='df -h'
alias ..='cd ..'
alias ...='cd ../..'
# pacman 常用
alias pacin='sudo pacman -S'
alias pacup='sudo pacman -Syu'
alias pacse='pacman -Ss'
alias pacrm='sudo pacman -Rns'
