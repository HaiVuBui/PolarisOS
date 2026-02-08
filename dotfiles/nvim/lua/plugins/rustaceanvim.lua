return {
  'mrcjkb/rustaceanvim',
  version = '^7', -- Recommended
  lazy = false, -- This plugin is already lazy
  init = function()
    vim.g.rustaceanvim = {
      server = {
        settings = {
          ['rust-analyzer'] = {
            check = {
              command = 'clippy',
            },
            checkOnSave = {
              command = 'clippy',
            },
          },
        },
      },
    }
  end,
}
