vim.api.nvim_create_autocmd('WinClosed', {
  callback = function(tbl)
    local buf = tbl.buf
    if vim.api.nvim_buf_is_valid(buf) then
      -- Only delete if no other windows are showing this buffer
      local windows = vim.fn.win_findbuf(buf)
      if #windows == 0 then
        vim.api.nvim_buf_delete(buf, { force = false })
      end
    end
  end,
  group = vim.api.nvim_create_augroup('auto_close_buf', {}),
})
