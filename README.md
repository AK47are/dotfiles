## 快速配置

```powershell
irm raw.githubusercontent.com/AK47are/dotfiles/windows/scripts/startup.ps1 | iex

```

## 检查清单

- 准备 [VPN](https://clashverge.net/)
- 安装 [scoop](https://github.com/ScoopInstaller/Scoop)：包管理器
  - 后续大部分程序都可通过 scoop 安装，如果安装不了，尝试[国内特供版](https://github.com/xrgzs/scoop)
- 拉取 [dotfiles](https://github.com/AK47are/dotfiles)
  1. 安装 `git`：`scoop install git`
  2. 拉取仓库：`git clone --bare https://github.com/AK47are/dotfiles.git $HOME/.cfg`
  3. 读取仓库：`git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout`
    - 可能会存在冲突文件，需要手动处理或者添加 `-f` 强行覆盖
  4. 忽略未追踪文件：`git --git-dir=$HOME/.cfg/ --work-tree=$HOME config --local status.showUntrackedFiles no`
- 输入法：[RIME](https://rime.im/)-[雾凇拼音](https://github.com/iDvel/rime-ice)
  - 行为更符合预期，跨平台，可配置性高
  - 下载[万象语言模型](https://github.com/amzxyz/RIME-LMDG)：优化长句识别，放在用户文件夹
  - 如果受得了微软拼音乱切换输入法状态可以跳过
- 安装软件：`scoop install pwsh wezterm-nightly autohotkey neovim fd ripgrep lazygit tree-sitter nodejs mingw`
  1. pwsh：Shell
  2. wezterm-nightly：终端仿真器
    - 注意：Wezterm 稳定版很久没更新，最好使用 wezterm-nightly，避免 nvim 渲染问题
  3. autohotkey：映射快捷键（`~/scripts/setup.ahk`）
  4. neovim：代码编辑器，初始化时需要 VPN
    - fd：搜索文件
    - ripgrep：搜索文件内容
    - lazygit：可视化 git
    - tree-sitter：语法解析器
    - nodejs: mason 安装部分程序需要
    - C 工具链：MinGW 或 [MSVC](https://gist.github.com/mmozeiko/7f3162ec2988e81e56d5c4e22cde9977)
- 可选：若长期使用推荐添加，大部分可通过 scoop 安装
  - [Pot Desktop](https://github.com/pot-app/pot-desktop/)：OCR / 翻译软件
  - [Obsidian](https://obsidian.md/)：笔记软件
    - 需要[坚果云插件](https://github.com/nutstore/obsidian-nutstore-sync)同步笔记
  - [Bitwarden](https://bitwarden.com/)：密码管理器
  - [Zen](https://zen-browser.app/)：浏览器

## 相关资源

- [Scoop 搭建 Windows 开发环境 | 潇然工作室](https://www.xrgzs.top/posts/scoop-dev-setup)
- [你需要掌握的Scoop技巧和知识 - 知乎](https://zhuanlan.zhihu.com/p/135278662)
