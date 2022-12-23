local status_ok, whichkey = pcall(require, "which-key")
if not status_ok then
  return
end

whichkey.setup {
  -- Use the default config at the moment.
}

