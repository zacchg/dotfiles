local o = vim.opt

-- file options

  o.shada = "'100,f0,<1000,s100,:100,h"
  o.undofile = true
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

-- configure paths

  local configDir = vim.fn.expand("~/.config/nvim/")
  local cacheDir  = vim.fn.expand("~/.cache/nvim/")
  o.shadafile = { cacheDir .. "main.shada" }
  o.directory = { cacheDir .. "swp" } ; vim.fn.mkdir(o.directory._value, "p")
  o.undodir = { cacheDir .. "undo" }  ; vim.fn.mkdir(o.undodir._value, "p")
  o.viewdir = cacheDir .. "view"      ; vim.fn.mkdir(o.viewdir._value, "p")
                                      ; vim.fn.mkdir(configDir .. "runtime", "p")
  vim.opt.runtimepath:append(configDir .. "runtime")

  vim.fn.stdpath = function(name)
    vim.fn.mkdir(cacheDir .. "state", "p")
    return cacheDir .. "state/" .. name
  end

-- indentation

  o.tabstop = 2 ; o.shiftwidth = 2 ; o.softtabstop = 2 ; o.expandtab = true

  local basicFiletypes = {"text", "json", "sh", "bash", "zsh", "vim", "css", "javascript"}
  vim.api.nvim_create_autocmd("Filetype", { pattern = basicFiletypes, callback = function()
    o.tabstop = 2 ; o.shiftwidth = 2 ; o.softtabstop = 2 ; o.expandtab = true
  end})

  vim.api.nvim_create_autocmd("Filetype", { pattern = "*", callback = function()
    o.tabstop = 2 ; o.shiftwidth = 2 ; o.softtabstop = 2 ; o.expandtab = true
  end})

  vim.api.nvim_create_autocmd("Filetype", { pattern = {"go"}, callback = function()
    o.tabstop = 4 ; o.shiftwidth = 4 ; o.softtabstop = 4 ; o.expandtab = false
  end})

-- formatting, layout, search, keys, mouse

  o.scrolloff = 5                  -- show the following 5 lines while scrolling
  o.number = true                  -- show the number column
  o.cursorline = true              -- highlight the current line
  o.hlsearch = true                -- highlight all matches
  o.incsearch = false              -- don't search while typing
  o.ignorecase = true              -- case-insensitive searching
  o.smartcase = true               --   unless contains uppercase
  o.mouse = "vi"

  -- don't continue comment on the next line
    o.formatoptions:append { c = false, r = false, o = false }
    vim.api.nvim_create_autocmd("BufEnter", {callback = function()
      o.formatoptions = o.formatoptions - { "c", "r", "o" }
    end})

-- save and restore functions

  -- strip whitespace on save
    vim.api.nvim_create_autocmd("BufWritePre", { pattern = "<buffer>", callback = function()
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd [[keeppatterns %s/\s\+$//e]]
      vim.api.nvim_win_set_cursor(0, pos)
    end})
  -- restore cursor to the last position
    vim.api.nvim_create_autocmd("BufReadPost", { pattern = "*", callback = function()
      if vim.tbl_contains({ "gitcommit", "gitrebase" }) then return end
      if vim.fn.line(".") > 1 then return end
      if vim.fn.line([['"]]) > 0 and vim.fn.line([['"]]) <= vim.fn.line("$") then
        vim.cmd [[normal! g`"]]
      end
    end})

-- theme

  vim.opt.background = vim.env.APPEARANCE == "dark" and "dark" or "light"
  if vim.opt.background._value == "dark" then
    vim.cmd [[colorscheme yin]]
  else
    vim.cmd [[colorscheme yang]]
    -- vim.cmd [[colorscheme Mies]]
  end

-- plugins

  local status, nvimTree = pcall(require, "nvim-tree")
  if status then
    nvimTree.setup {
      renderer = {
        icons = {
          show = { file = false, folder = true, folder_arrow = false, git = false },
        },
      },
    }

    vim.keymap.set("n", "<C-e>", require("nvim-tree.api").tree.toggle, {
      noremap = true
    })
  end
