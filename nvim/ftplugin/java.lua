local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name

local bundles = {}

vim.list_extend(bundles, vim.fn.glob("/home/willem/Downloads/vscjava.vscode-java-debug-0.59.0/extension/server/com.microsoft.java.debug.plugin-*.jar", false, true))
vim.list_extend(bundles, vim.fn.glob("/home/willem/Downloads/vscjava.vscode-java-test-0.46.0/extension/server/*.jar", false, true))

local config = {
  name = "jdtls",
  cmd = { "jdtls", "-data", workspace_dir },
  root_dir = vim.fs.root(0, { 'gradlew', 'mvnw', '.git', 'pom.xml', 'build.gradle' }),

  settings = {
    java = {},
  },

  init_options = {
    bundles = bundles,
  },
}
local jdtls = require('jdtls')
jdtls.start_or_attach(config)

local function map(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
end
local no_debug = { config_overrides = { noDebug = true } }

map('<leader>tm', function() jdtls.test_nearest_method(no_debug) end, "Test: Run nearest method")
map('<leader>tc', function() jdtls.test_class(no_debug) end, "Test: Run class")
map('<leader>dtm', jdtls.test_nearest_method, "Test: Debug nearest method")
map('<leader>dtc', jdtls.test_class, "Test: Debug class")
