local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name

local bundles = {
  vim.fn.glob(
    "/home/willem/Downloads/vscjava.vscode-java-debug-0.59.0/extension/server/com.microsoft.java.debug.plugin-*.jar", true
  )
}

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

require('jdtls').start_or_attach(config)
