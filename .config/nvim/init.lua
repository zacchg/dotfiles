local o = vim.opt ; local fn = vim.fn

-- file options
  o.shada = "'100,f0,<1000,s100,:100,h"
  o.undofile = true
  vim.g.loaded_netrw = 1 ; vim.g.loaded_netrwPlugin = 1

-- directories
  local configDir = fn.expand("~/.config/nvim/")
  local cacheDir  = fn.expand("~/.cache/nvim/")
  o.shadafile = { cacheDir .. "main.shada" }
  o.directory = { cacheDir .. "swp" }          ; fn.mkdir(o.directory._value, "p")
  o.undodir = { cacheDir .. "undo" }           ; fn.mkdir(o.undodir._value, "p")
  o.viewdir = cacheDir .. "view"               ; fn.mkdir(o.viewdir._value, "p")
  o.runtimepath:append(configDir .. "runtime") ; fn.mkdir(configDir .. "runtime", "p")
  fn.stdpath = function(name) return cacheDir .. "state/" .. name end

-- functions
  -- strip whitespace on save
    vim.api.nvim_create_autocmd("BufWritePre", { pattern = "<buffer>", callback = function()
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd [[keeppatterns %s/\s\+$//e]]
      vim.api.nvim_win_set_cursor(0, pos)
    end})
  -- restore cursor to the last position
    vim.api.nvim_create_autocmd("BufReadPost", { callback = function()
      if vim.tbl_contains({ "gitcommit", "gitrebase" }) then return end
      if vim.fn.line(".") > 1 then return end
      if vim.fn.line([['"]]) > 0 and vim.fn.line([['"]]) <= vim.fn.line("$") then
        vim.cmd [[normal! g`"]]
      end
    end})
  -- don't continue comment on new line
    vim.api.nvim_create_autocmd("BufEnter", { callback = function()
      o.formatoptions:remove { "c", "r", "o" }
    end})

-- search
  o.hlsearch = true   -- highlight all matches
  o.incsearch = false -- don't search while typing
  o.ignorecase = true -- case-insensitive searching
  o.smartcase = true  --   unless contains uppercase

-- layout, mouse
  o.number = true     -- show the number column
  o.cursorline = true -- highlight the current line
  o.scrolloff = 5     -- show the following 5 lines while scrolling
  o.mouse = "vi"      -- only visual and insert modes

-- filetype indentation
  -- default settings
    o.tabstop = 2 ; o.shiftwidth = 2 ; o.softtabstop = 2 ; o.expandtab = true
    vim.api.nvim_create_autocmd("Filetype", { pattern = { "*" }, callback = function()
      o.tabstop = 2 ; o.shiftwidth = 2 ; o.softtabstop = 2 ; o.expandtab = true
    end})
  -- tabs
    vim.api.nvim_create_autocmd("Filetype", { pattern = { "go", "gitconfig" }, callback = function()
      o.tabstop = 4 ; o.shiftwidth = 4 ; o.softtabstop = 4 ; o.expandtab = false
    end})

-- theme
  o.background = string.lower(vim.env.APPEARANCE or o.background._value) == "dark" and "dark" or "light"
  if o.background._value == "dark" then
    vim.cmd [[colorscheme yin]]
  else
    -- vim.cmd [[colorscheme yang]]
    vim.cmd [[colorscheme Mies]]
  end
