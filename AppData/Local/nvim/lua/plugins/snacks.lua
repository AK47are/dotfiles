return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          projects = {
            patterns = {
              ".git",
              ".project",
              ".root",

              -- Java Projects
              "pom.xml", -- Maven
              "pom.yml", -- Maven
              "pom.yaml", -- Maven
              "build.gradle", -- Gradle
              "settings.gradle", -- Gradle
              "build.gradle.kts", -- Gradle Kotlin DSL
              ".classpath", -- Eclipse project

              -- C/C++ Projects
              "CMakeLists.txt", -- CMake
              "Makefile",
              "GNUmakefile", -- Make
              "configure",
              "configure.ac", -- Autotools
              "Makefile.am", -- Automake
              "meson.build", -- Meson
              "meson.options", -- Meson
              "SConstruct", -- SCons
              "BUILD",
              "WORKSPACE", -- Bazel
              "conanfile.txt",
              "conanfile.py", -- Conan
              "vcpkg.json", -- vcpkg

              -- JavaScript/TypeScript Projects
              "package.json",
              "package-lock.json", -- npm
              "yarn.lock", -- Yarn
              "pnpm-lock.yaml", -- pnpm
              "bun.lockb", -- Bun
              "tsconfig.json",
              "jsconfig.json", -- TypeScript/JavaScript
              "angular.json", -- Angular
              "vue.config.js", -- Vue
              "vite.config.js", -- Vite/Vue
              "next.config.js",
              "next.config.mjs", -- Next.js
              "nuxt.config.js",
              "nuxt.config.ts", -- Nuxt
              "svelte.config.js", -- Svelte
              "webpack.config.js", -- Webpack
              "rollup.config.js", -- Rollup
              ".babelrc",
              ".babelrc.js", -- Babel
              ".eslintrc.js",
              ".eslintrc.json", -- ESLint
              ".prettierrc",
              ".prettierrc.js", -- Prettier

              -- Python Projects
              "pyproject.toml", -- PEP 518
              "setup.py",
              "setup.cfg", -- setuptools
              "requirements.txt",
              "Pipfile", -- pipenv
              "environment.yml", -- conda
              "tox.ini", -- tox
              "pytest.ini",
              "manage.py", -- Django
              "scrapy.cfg", -- Scrapy
              "wsgi.py",
              "asgi.py", -- ASGI/WSGI
              "conftest.py", -- pytest config
              ".python-version", -- pyenv

              -- .NET Projects
              "*.sln", -- Visual Studio Solution
              "*.csproj", -- C# Project
              "*.vbproj", -- VB.NET Project
              "*.fsproj", -- F# Project

              -- Dart & Flutter Projects
              "pubspec.yaml",

              -- Elixir Projects
              "mix.exs",

              -- Haskell Projects
              "*.cabal",
              "stack.yaml",

              -- Godot Engine Projects
              "project.godot",

              -- Nix Projects
              "flake.nix",
              "default.nix",

              -- Other Languages and Tools
              "Cargo.toml", -- Rust
              "go.mod",
              "go.sum", -- Go
              "composer.json", -- PHP
              "Gemfile",
              "Gemfile.lock", -- Ruby
              "Rakefile", -- Rake
              "deps.edn", -- Clojure
              "project.clj", -- Leiningen
              "shadow-cljs.edn", -- Shadow CLJS
              "build.sbt", -- Scala
              "Package.swift", -- Swift
              "build.zig", -- Zig
              "*.Rproj", -- R Studio
              ".terraform.lock.hcl", -- Terraform
              "Tupfile",
              "Tupfile.lua", -- Tup
              "justfile", -- Just
              "Taskfile.yml", -- Task
            },
          },
        },
      },
    },
  },
}
