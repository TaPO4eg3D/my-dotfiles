local opt = vim.opt

-- Display relative number of lines
opt.nu = true
opt.rnu = true

-- Disable swapfile
opt.swapfile = false

-- Set tab size
opt.sts = 4
opt.ts = 4
opt.sw = 4

-- Search tweaks
opt.ignorecase = true
opt.hlsearch = true
opt.incsearch = true

-- Disable annoying sound on errors
opt.errorbells = false
opt.visualbell = false
opt.tm = 500

-- Use spaces instead tabs
opt.expandtab = true

-- Indents
opt.ai = true -- Auto indent
opt.si = true -- Smart indent
opt.wrap = true -- Wrap lines

-- Mouse support
opt.mouse = "a"

-- Use system clipboard
opt.clipboard = opt.clipboard + { "unnamedplus" }
