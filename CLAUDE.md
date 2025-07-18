# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles configuration repository containing:
- **Neovim configuration** (`nvim/`) - LazyVim-based setup with extensive language support
- **Tmux configuration** (`tmux/`) - Terminal multiplexer with Catppuccin theme
- **Starship prompt** (`starship.toml`) - Cross-shell prompt customization
- **Ghostty terminal** (`ghostty/`) - Terminal emulator configuration
- **Graphite aliases** (`graphite/`) - Git workflow aliases

## Key Commands

### Neovim
- **Linting**: Automatic linting is configured via nvim-lint plugin
  - Go: `golangci-lint` (runs when `.golangci.yml/.yaml/.json` config exists)
  - CSS/SCSS/Sass/Less/Svelte: `stylelint` (runs when stylelint config exists)
  - Auto-fix on save for CSS files using `./node_modules/.bin/stylelint --fix`
- **Formatting**: Uses conform.nvim with LazyVim defaults
- **Code style**: StyLua configured with 2-space indentation, 120 column width

### Tmux
- **Prefix**: `Ctrl+Space` (instead of default Ctrl+b)
- **Split panes**: `"` (vertical), `%` (horizontal) - opens in current path
- **Navigation**: Vim-style with tmux-navigator integration
- **Plugin management**: TPM (Tmux Plugin Manager) at `~/.tmux/plugins/tpm/tpm`

## Architecture & Configuration Patterns

### Neovim Structure
```
nvim/
├── init.lua                 # Entry point
├── lua/config/             # Core configuration
│   ├── lazy.lua            # Plugin manager setup + telescope keymaps
│   ├── options.lua         # Vim options
│   ├── keymaps.lua         # Custom keymaps
│   └── autocmds.lua        # Auto commands
└── lua/plugins/            # Plugin configurations
    ├── nvim-lint.lua       # Linting setup (stylelint, golangci-lint)
    ├── nvim-dap.lua        # Debug adapter protocol
    └── [other plugins]     # Individual plugin configs
```

### Language Support
LazyVim extras enabled for: Go, Rust, TypeScript, Terraform, Docker, JSON, YAML, Markdown, SQL, and more. See `lazyvim.json` for complete list.

### Plugin Management
- **Package manager**: Lazy.nvim
- **Theme**: Catppuccin (mocha flavor)
- **Key plugins**: 
  - LSP: nvim-lspconfig with Mason
  - Linting: nvim-lint with language-specific linters
  - DAP: nvim-dap with language adapters
  - Telescope: File/text searching with custom keymaps

### Tmux Plugin Ecosystem
- **Theme**: Catppuccin with status modules (CPU, battery, session, uptime)
- **Navigation**: vim-tmux-navigator for seamless Vim/Tmux pane switching
- **Copy mode**: Vi-style with yank integration
- **Status bar**: Top position with custom modules

## Development Workflow Notes

- Neovim config follows LazyVim patterns - extend via `lua/plugins/` rather than modifying core
- Linters only run when their config files are present in the project
- CSS/Sass files auto-fix on save when local stylelint is available
- Tmux sessions automatically renumber windows and start indexing at 1
- Git workflow enhanced with Graphite aliases (stored in `graphite/aliases`)