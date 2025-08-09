return {
  "ojroques/nvim-osc52",
  event = "VeryLazy",
  config = function()
    local osc52 = require("osc52")

    osc52.setup({
      max_length = 0,          -- Unlimited clipboard length
      trim = false,            -- Do not trim text
      silent = false,          -- Notify on copy
    })

    -- Use OSC52 as a clipboard provider
    vim.g.clipboard = {
      name = "osc52",
      copy = {
        ["+"] = osc52.copy,
        ["*"] = osc52.copy,
      },
      paste = {
        ["+"] = osc52.paste,
        ["*"] = osc52.paste,
      },
    }

    -- Optional: auto copy on yank
    local function copy_on_yank()
      if vim.v.event.operator == "y" and vim.v.event.regname == "" then
        require("osc52").copy_register("")
      end
    end

    vim.api.nvim_create_autocmd("TextYankPost", {
      callback = copy_on_yank,
    })
  end,
}
