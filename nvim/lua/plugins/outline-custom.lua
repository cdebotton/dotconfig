return {
  "hedyhli/outline.nvim",
  lazy = false,
  opts = function(_, opts)
    -- Add custom keybinding for centered modal outline
    vim.keymap.set("n", "<leader>co", function()
      -- Get LSP symbols for current buffer
      local params = vim.lsp.util.make_position_params()
      params.textDocument = vim.lsp.util.make_text_document_params()
      
      vim.lsp.buf_request(0, "textDocument/documentSymbol", params, function(err, result, ctx, config)
        if err or not result or vim.tbl_isempty(result) then
          vim.notify("No symbols found", vim.log.levels.INFO)
          return
        end
        
        -- Get window dimensions
        local width = vim.api.nvim_get_option("columns")
        local height = vim.api.nvim_get_option("lines")
        
        -- Calculate centered window size (30% of screen width, 60% height)
        local win_width = math.floor(width * 0.3)
        local win_height = math.floor(height * 0.6)
        
        -- Calculate position to center the window
        local col = math.floor((width - win_width) / 2)
        local row = math.floor((height - win_height) / 2)
        
        -- Create a new buffer for the outline
        local buf = vim.api.nvim_create_buf(false, true)
        
        -- Get LazyVim icons
        local icons = LazyVim.config.icons.kinds
        
        -- Function to flatten symbols into a list with proper styling
        local function flatten_symbols(symbols, depth, prefix)
          depth = depth or 0
          prefix = prefix or ""
          local items = {}
          
          for i, symbol in ipairs(symbols) do
            local kind_name = vim.lsp.protocol.SymbolKind[symbol.kind] or "Text"
            local icon = icons[kind_name] or "󰈔 "
            local line = symbol.range.start.line + 1
            
            -- Create indentation for nested symbols
            local indent = string.rep("  ", depth)
            local guide = ""
            if depth > 0 then
              guide = i == #symbols and "└ " or "├ "
            end
            
            local display_name = symbol.name
            local formatted_text = string.format("%s%s%s%s", indent, guide, icon, display_name)
            
            table.insert(items, {
              text = formatted_text,
              line = line,
              col = symbol.range.start.character + 1,
              symbol = symbol,
              kind = kind_name,
              depth = depth
            })
            
            -- Add children if they exist
            if symbol.children then
              local child_items = flatten_symbols(symbol.children, depth + 1, display_name .. ".")
              for _, child in ipairs(child_items) do
                table.insert(items, child)
              end
            end
          end
          
          return items
        end
        
        -- Flatten the symbols
        local symbol_items = flatten_symbols(result)
        
        -- Create content for the buffer
        local lines = {}
        for _, item in ipairs(symbol_items) do
          table.insert(lines, item.text)
        end
        
        -- Set buffer content
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_buf_set_option(buf, "modifiable", false)
        vim.api.nvim_buf_set_option(buf, "filetype", "outline")
        
        -- Apply syntax highlighting to match the sidebar
        local ns = vim.api.nvim_create_namespace("outline_modal_hl")
        
        for i, item in ipairs(symbol_items) do
          local line_idx = i - 1
          local text = item.text
          
          -- Highlight the icon based on symbol kind
          local icon_start = item.depth * 2 + (item.depth > 0 and 2 or 0) -- account for guide chars
          local icon_end = icon_start + 2 -- most icons are 2 chars wide
          
          -- Get appropriate highlight group for the symbol kind
          local hl_group = "Function"
          if item.kind == "Class" then hl_group = "Type"
          elseif item.kind == "Method" or item.kind == "Function" then hl_group = "Function" 
          elseif item.kind == "Variable" or item.kind == "Field" then hl_group = "Identifier"
          elseif item.kind == "Constant" then hl_group = "Constant"
          elseif item.kind == "String" then hl_group = "String"
          elseif item.kind == "Number" then hl_group = "Number"
          elseif item.kind == "Boolean" then hl_group = "Boolean"
          elseif item.kind == "Interface" or item.kind == "Struct" then hl_group = "Structure"
          elseif item.kind == "Enum" then hl_group = "Type"
          elseif item.kind == "Property" then hl_group = "Identifier"
          end
          
          -- Highlight the icon
          vim.api.nvim_buf_add_highlight(buf, ns, hl_group, line_idx, icon_start, icon_end)
          
          -- Highlight guide lines in comment color
          if item.depth > 0 then
            vim.api.nvim_buf_add_highlight(buf, ns, "Comment", line_idx, item.depth * 2, item.depth * 2 + 2)
          end
          
          -- Highlight the symbol name
          local name_start = icon_end
          vim.api.nvim_buf_add_highlight(buf, ns, hl_group, line_idx, name_start, -1)
        end
        
        -- Create the floating window
        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = win_width,
          height = win_height,
          col = col,
          row = row,
          style = "minimal",
          border = "rounded",
          title = " Symbols Outline ",
          title_pos = "center",
        })
        
        -- Add padding and configure line numbers
        vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal,FloatBorder:FloatBorder")
        vim.api.nvim_win_set_option(win, "number", true)
        vim.api.nvim_win_set_option(win, "relativenumber", true)
        vim.api.nvim_win_set_option(win, "signcolumn", "no")
        vim.api.nvim_win_set_option(win, "foldcolumn", "0")
        vim.api.nvim_win_set_option(win, "wrap", false)
        vim.api.nvim_win_set_option(win, "cursorline", true)
        
        -- Add some padding by setting left margin
        vim.api.nvim_win_set_option(win, "numberwidth", 4)
        
        -- Update the window options for better padding
        vim.api.nvim_win_call(win, function()
          vim.opt_local.scrolloff = 4
          vim.opt_local.sidescrolloff = 8
        end)
        
        -- Function to jump to symbol
        local function jump_to_symbol()
          local cursor = vim.api.nvim_win_get_cursor(win)
          local line_idx = cursor[1]
          
          if line_idx <= #symbol_items then
            local item = symbol_items[line_idx]
            -- Close the modal first
            vim.api.nvim_win_close(win, true)
            -- Jump to the symbol location
            vim.api.nvim_win_set_cursor(0, {item.line, item.col - 1})
            vim.cmd("normal! zz") -- Center the line
          end
        end
        
        -- Close modal on symbol selection (Enter key)
        vim.keymap.set("n", "<CR>", jump_to_symbol, { buffer = buf, nowait = true })
        
        -- Close on Escape
        vim.keymap.set("n", "<Esc>", function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
        end, { buffer = buf, nowait = true })
        
        -- Close on q
        vim.keymap.set("n", "q", function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
        end, { buffer = buf, nowait = true })
        
        -- Close modal when leaving buffer
        local group = vim.api.nvim_create_augroup("OutlineModalClose", { clear = true })
        vim.api.nvim_create_autocmd("BufLeave", {
          group = group,
          buffer = buf,
          callback = function()
            if vim.api.nvim_win_is_valid(win) then
              vim.api.nvim_win_close(win, true)
            end
            vim.api.nvim_del_augroup_by_id(group)
          end,
        })
      end)
    end, { desc = "Open symbols outline in centered modal" })
    
    return opts
  end,
}