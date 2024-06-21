require('lazy').setup(
  { import = '../plugins' },
  {
    dev = { path = require("common.env").NVIM_PLUGINS },
    change_detection = { notify = false }
  }
)
