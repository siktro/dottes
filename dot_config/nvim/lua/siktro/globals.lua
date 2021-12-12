-- Setup global object with some helper functions.
Q = {
  -- Wrapper around `vim.inspect`.
  q = function(val)
    print(vim.inspect(val))
  end,

  -- Wrapper around `string.format`
  f = function(...)
    return string.format(...)
  end
}