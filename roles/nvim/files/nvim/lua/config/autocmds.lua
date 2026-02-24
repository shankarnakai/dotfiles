vim.api.nvim_create_autocmd('WinClosed', {
  callback = function(tbl)
    if vim.api.nvim_buf_is_valid(tbl.buf) then
      vim.api.nvim_buf_delete(tbl.buf, { force = true })
    end
  end,
  group = vim.api.nvim_create_augroup('barbar_close_buf', {}),
})
