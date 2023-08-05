local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics
local codeAction = null_ls.builtins.code_actions

local root_has_file = function(files)
  return function(utils)
    return utils.root_has_file(files)
  end
end

local eslint_root_files = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintrc.cjs" }
local prettier_root_files = { ".prettierrc", ".prettierrc.js", ".prettierrc.json" }
local stylua_root_files = { "stylua.toml", ".stylua.toml" }
local elm_root_files = { "elm.json" }

local opts = {
  eslint_diagnostics = {
    prefer_local = "node_modules/.bin",
    condition = root_has_file(eslint_root_files),
  },

  prettier_formatting = {
    prefer_local = "node_modules/.bin",
    condition = function(utils)
      local has_eslint = root_has_file(eslint_root_files)(utils)
      local has_prettier = root_has_file(prettier_root_files)(utils)
      return not has_eslint and has_prettier
    end,
    -- condition = root_has_file(prettier_root_files),
  },
  eslint_formatting = {
    prefer_local = "node_modules/.bin",
    condition = function(utils)
      local has_eslint = root_has_file(eslint_root_files)(utils)
      local has_prettier = root_has_file(prettier_root_files)(utils)
      return has_eslint
    end,
  },

  stylua_formatting = {
    condition = root_has_file(stylua_root_files),
  },
  elm_format_formatting = {
    condition = root_has_file(elm_root_files),
  },
}

local sources = {
  formatting.prettierd.with { opts.prettier_formatting },
  formatting.stylua,
  formatting.rustfmt,
  lint.eslint_d.with { opts.eslint_diagnostics },
  formatting.eslint_d.with { opts.eslint_formatting },
  codeAction.eslint_d.with { opts.eslint_diagnostics },
  -- lint.shellcheck,
}

local function on_attach(client, _)
  if client.server_capabilities.document_formatting then
    vim.cmd "command! -buffer Formatting lua vim.lsp.buf.formatting()"
    vim.cmd "command! -buffer FormattingSync lua vim.lsp.buf.formatting_sync()"
  end
end

null_ls.setup {
  debug = true,
  sources = sources,
  on_attach = on_attach,
}
