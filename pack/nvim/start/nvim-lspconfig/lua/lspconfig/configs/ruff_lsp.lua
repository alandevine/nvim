local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ruff-lsp' },
    filetypes = { 'python' },
    root_dir = util.root_pattern('pyproject.toml', 'ruff.toml') or util.find_git_ancestor(),
    single_file_support = true,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/astral-sh/ruff-lsp

A Language Server Protocol implementation for Ruff, an extremely fast Python linter and code transformation tool, written in Rust. It can be installed via pip.

```sh
pip install ruff-lsp
```

Extra CLI arguments for `ruff` can be provided via

```lua
require'lspconfig'.ruff_lsp.setup{
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  }
}
```

  ]],
  },
}
