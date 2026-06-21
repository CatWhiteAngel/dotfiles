# dotfiles

[English](README.md) | **简体中文**

ThinkPad X1 Carbon / Arch Linux + KDE Plasma (Wayland) 的个人配置，用 [GNU Stow](https://www.gnu.org/software/stow/) 管理。

每个子目录是一个 stow「包」，目录内按相对 `$HOME` 的路径存放文件，stow 会把它们软链回家目录。

## 包含的包

| 包 | 链接到 | 说明 |
|------|--------|------|
| `zsh` | `~/.zshrc` | 手写无框架 zsh（fzf/zoxide/eza/bat，自带补全与高亮） |
| `git` | `~/.gitconfig` | 身份 + 现代默认 + 别名（提交 GPG 签名） |
| `vim` | `~/.vimrc` | 最小实用版，无插件 |
| `bash` | `~/.bashrc` `~/.bash_profile` | 仅作 fallback |
| `konsole` | `~/.local/share/konsole/*` | Catppuccin Mocha 配色 + Nerd Font profile |
| `fontconfig` | `~/.config/fontconfig/fonts.conf` | 合成斜体/加粗 + 次像素渲染 |

## 安装

```sh
sudo pacman -S stow          # 若未安装
git clone git@github.com:CatWhiteAngel/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow zsh git vim bash konsole fontconfig
```

单独装某个包：`stow konsole`。卸载（删软链）：`stow -D konsole`。

### 个人身份（每台机器一次）

Git 身份（name / email / 签名子钥）放在 `~/.gitconfig.local`，**不入库**；仓库里的 `git/.gitconfig` 只用 `include` 引用它。换机时从模板创建：

```sh
cp ~/dotfiles/git/.gitconfig.local.example ~/.gitconfig.local
chmod 600 ~/.gitconfig.local            # 然后填入你的 name/email/signingkey
```

`~/.gitconfig.local` 不存在时 git 会静默忽略该 include，其余配置照常生效。

## 刻意未纳入

以下属 KDE/程序自动生成的机器状态或含隐私，**不入库**：

- GTK `settings.ini`（kded 自动改写，含机器 DPI）
- `kglobalshortcutsrc` / `plasmashellrc` / `kwinoutputconfig.json` 等 KDE rc
- `emailidentities` / `akonadi*` / `kwallet`（邮箱身份、凭据）
- `*history` / `.viminfo` 等历史与本地状态

## 依赖（手动安装）

```sh
sudo pacman -S zsh stow fzf zoxide eza bat vim konsole \
               ttf-dejavu-nerd ttf-hack
```

> vim 默认是 `-clipboard` 编译版；需要系统剪贴板互通改装 `gvim` 包。
