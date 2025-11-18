## 配置检查清单

- 输入法：微软拼音
- 准备 VPN：[Clash Verge](https://github.com/clash-verge-rev/clash-verge-rev)
- 安装 [scoop](https://github.com/ScoopInstaller/Scoop)：包管理器
- 配置 [dotfiles](https://github.com/AK47are/dotfiles)
  1. 安装 `git`：`scoop install git`
  2. `git clone --bare git@github.com:AK47are/dotfiles.git $HOME/.cfg`
- 安装软件：最好提前将配置文件拉取过来
  1. pwsh：Windows Shell
  2. Wezterm：终端仿真器
    - 注意：Wezterm 稳定版很久没更新，最好使用 wezterm-nightly，避免 nvim 渲染问题
  3. AutoHotkey：映射快捷键
  4. nvim：代码编辑器
    - curl：一般原生自带
    - tree-sitter：语法解析器
    - C 编译器：gnu 或 [msvc](https://gist.github.com/mmozeiko/7f3162ec2988e81e56d5c4e22cde9977)
    - 可选见 [LazyVim](https://www.lazyvim.org/#%EF%B8%8F-requirements)
    - 输入法自动切换依赖：只简单切换成英文模式，不记忆上次状态
      - 微软拼音
      - AutoHotkey
- 可选：若长期使用推荐添加，大部分可通过 scoop 安装，没有配置文件
  - [Pot Desktop](https://github.com/pot-app/pot-desktop/)：OCR / 翻译软件
  - [Obsidian](https://obsidian.md/)：笔记软件
    - 需要[坚果云插件](https://github.com/nutstore/obsidian-nutstore-sync)同步笔记
  - [Bitwarden](https://bitwarden.com/)：密码管理器
  - [Zen](https://zen-browser.app/)：浏览器

## 相关资源

- [Scoop 搭建 Windows 开发环境 | 潇然工作室](https://www.xrgzs.top/posts/scoop-dev-setup)
- [你需要掌握的Scoop技巧和知识 - 知乎](https://zhuanlan.zhihu.com/p/135278662)
