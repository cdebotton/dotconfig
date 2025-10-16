-- lua/plugins/dap.lua

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "mxsdev/nvim-dap-vscode-js",
    "theHamsta/nvim-dap-virtual-text",
    -- build debugger from source
    {
      "microsoft/vscode-js-debug",
      version = "1.x",
      build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
    },
  },
  config = function()
    require("dap-vscode-js").setup({
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      node_path = "node",
      -- Log file path (useful for debugging setup issues)
      log_file_path = vim.fn.stdpath("cache") .. "/dap_vscode_js.log",
      log_file_level = vim.log.levels.DEBUG,
      log_console_level = vim.log.levels.ERROR,
      debugger_cmd = { vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter" },
    })

    for _, adapter in pairs({ "pwa-node", "pwa-chrome" }) do
      require("dap").adapters[adapter] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "js-debug-adapter",
          args = { "${port}" },
        },
      }
    end

    for _, language in pairs({ "typescript", "typescriptreact", "javascript", "javascriptreact", "svelte" }) do
      require("dap").configurations[language] = {
        {
          name = "Debug node",
          type = "pwa-node",
          request = "launch",
          sourceMaps = true,
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
          runtimeExecutable = "npm",
          runtimeArgs = { "run", "dev" },
          rootPath = "${workspaceFolder}",
          cwd = function()
            local util = require("lspconfig.util")
            return util.root_pattern("package.json")(vim.fn.expand("%:p")) or vim.fn.getcwd()
          end,
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
          skipFiles = {
            "<node_internals>/**",
            "${workspaceFolder}/node_modules/**/*.js",
            "**/node_modules/**",
            "**/@vite/**",
            "**/vite/dist/**",
          },
        },
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Debug web",
          url = "http://localhost:5173",
          protocol = "inspector",
          port = 9222,
          sourceMaps = true,
          webRoot = "${workspaceFolder}/src",
          runtimeExecutable = "/Applications/Dia.app/Contents/MacOS/Dia",
          userDataDir = "${workspaceFolder}/.chrome-debug",
          skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
        },
        {
          name = "Attach to running process",
          type = "pwa-node",
          request = "attach",
          sourceMaps = true,
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
          processId = require("dap.utils").pick_process,
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
          skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**/*.js" },
        },
      }
    end

    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open({ reset = true })
    end
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close
  end,
}
