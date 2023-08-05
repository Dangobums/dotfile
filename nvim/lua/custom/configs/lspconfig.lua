local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local root_pattern = require("lspconfig.util").root_pattern
local util = require "lspconfig.util"

local lspconfig = require "lspconfig"

lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}

lspconfig.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- lspconfig.eslint.setup {
--   on_attach = function(client, bufrn)
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       bufrn = bufrn,
--       command = "EslintFixAll",
--     })
--   end,
-- }

lspconfig.cssmodules_ls.setup {}

lspconfig.cssls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    css = {
      validata = true,
      lint = {
        unknowAtRules = "ignore",
      },
    },
    scss = {
      validata = true,
      lint = {
        unknowAtRules = "ignore",
      },
    },
  },
}

lspconfig.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = root_pattern("tailwind.config.js", "postcss.config.js"),
}

local function get_typescript_server_path(root_dir)
  local global_ts =
  "/home/longthb3/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib"
  -- Alternative location if installed as root:
  -- local global_ts = '/usr/local/lib/node_modules/typescript/lib'
  local found_ts = ""
  local function check_dir(path)
    found_ts = util.path.join(path, "node_modules", "typescript", "lib")
    if util.path.exists(found_ts) then
      return path
    end
  end
  -- return global_ts
  if util.search_ancestors(root_dir, check_dir) then
    return found_ts
  else
    return global_ts
  end
end

lspconfig.volar.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
  end,
}

lspconfig.lua_ls.setup {}
