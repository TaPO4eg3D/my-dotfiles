local lspconfig = require'lspconfig'

lspconfig.ccls.setup{
    init_options = {
        clang = {
            pathMappings = {
                "/dist/opencv_contrib_retech>/home/tapo4eg3d/Projects/rebotics-stitcher/src"
            },
        }
    }
}
