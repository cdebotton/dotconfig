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
      -- version = "1.76.1",
      version = "1.x",
      build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
    },
  },
  config = function()
    require("dap-vscode-js").setup({
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
    })

    require("dap").adapters["pwa-node"] = {
      type = "server",
      host = "::1",
      port = "${port}",
      executable = {
        command = "js-debug-adapter",
        args = {
          "${port}",
        },
      },
    }

    --- Gets a path to a package in the Mason registry.
    --- Prefer this to `get_package`, since the package might not always be
    --- available yet and trigger errors.
    ---@param pkg string
    ---@param path? string
    local function get_pkg_path(pkg, path)
      pcall(require, "mason")
      local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
      path = path or ""
      local ret = root .. "/packages/" .. pkg .. "/" .. path
      return ret
    end

    require("dap").adapters["pwa-chrome"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
          "${port}",
        },
      },
    }

    for _, language in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact", "svelte" }) do
      require("dap").configurations[language] = {
        -- attach to a node process that has been started with
        -- `--inspect` for longrunning tasks or `--inspect-brk` for short tasks
        -- npm script -> `node --inspect-brk ./node_modules/.bin/vite dev`

        {
          name = "Attach debugger to existing `node --inspect` process",
          -- for compiled languages like TypeScript or Svelte.js
          sourceMaps = true,
          -- resolve source maps in nested locations while ignoring node_modules
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
          skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
          type = "pwa-node",
          request = "attach",
          address = "localhost",
          port = 9229,
          cwd = "${workspaceFolder}",
          restart = true,
        },
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Debug SvelteKit in Dia",
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
          type = "pwa-chrome",
          name = "Launch Chrome to debug client",
          request = "launch",
          url = "http://localhost:5173",
          sourceMaps = true,
          protocol = "inspector",
          port = 9222,
          webRoot = "${workspaceFolder}/src",
          -- skip files from vite's hmr
          skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
        },
        -- only if language is javascript, offer this debug action
        language == "javascript"
            and {
              -- use nvim-dap-vscode-js's pwa-node debug adapter
              type = "pwa-node",
              -- launch a new process to attach the debugger to
              request = "launch",
              -- name of the debug action you have to select for this config
              name = "Launch file in new node process",
              -- launch current file
              program = "${file}",
              runtimeExecutable = "npx",
              cwd = "${workspaceFolder}",
            }
          or nil,
      }
    end

    -- require("dapui").setup()
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open({ reset = true })
    end
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close
  end,
}
