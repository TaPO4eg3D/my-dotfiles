require('lualine').setup({
    tabline = {
        lualine_a = {
            {
                'buffers',
                filetype_names = {
                    NvimTree = 'File Explorer'
                }
            }
        },
        lualine_z = {'tabs'}
    },
})
