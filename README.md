## 配置检查清单

- 输入法：微软拼音
- 准备 [VPN](https://clashverge.net/)：后续大部分下载都需要翻墙
- 安装 [scoop](https://github.com/ScoopInstaller/Scoop)：包管理器
  - 后续大部分程序都可通过 scoop 安装，如果安装不了，可尝试[国内特供版](https://github.com/xrgzs/scoop)
- 拉取 [dotfiles](https://github.com/AK47are/dotfiles)
  - 安装 `git`：`scoop install git`
  - 拉取仓库：`git clone --bare git@github.com:AK47are/dotfiles.git $HOME/.cfg`
  - 读取仓库：`git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout`
    - 可能会存在冲突文件，需要手动处理或者添加 `-f` 强行覆盖
- 安装软件：部分软件配置需要翻墙下载插件
  1. pwsh：Windows Shell
  2. wezterm-nightly：终端仿真器
    - 注意：Wezterm 稳定版很久没更新，最好使用 wezterm-nightly，避免 nvim 渲染问题
  3. autohotkey：映射快捷键（`~/scripts/setup.ahk`）或实现特殊功能（如切换输入法模式）
  4. nvim：代码编辑器
    - fd：搜索文件
    - ripgrep：搜索文件内容
    - lazygit：可视化 git
    - tree-sitter：语法解析器
    - C 工具链：MinGW 或 [MSVC](https://gist.github.com/mmozeiko/7f3162ec2988e81e56d5c4e22cde9977)
- 可选：若长期使用推荐添加，大部分可通过 scoop 安装，没有配置文件
  - [Pot Desktop](https://github.com/pot-app/pot-desktop/)：OCR / 翻译软件
  - [Obsidian](https://obsidian.md/)：笔记软件
    - 需要[坚果云插件](https://github.com/nutstore/obsidian-nutstore-sync)同步笔记
  - [Bitwarden](https://bitwarden.com/)：密码管理器
  - [Zen](https://zen-browser.app/)：浏览器

## 相关资源

- [Scoop 搭建 Windows 开发环境 | 潇然工作室](https://www.xrgzs.top/posts/scoop-dev-setup)
- [你需要掌握的Scoop技巧和知识 - 知乎](https://zhuanlan.zhihu.com/p/135278662)
