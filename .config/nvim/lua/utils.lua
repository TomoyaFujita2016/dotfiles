local fn = vim.fn
local M = {}


function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

function M._echo_multiline(msg)
  for _, s in ipairs(fn.split(msg, "\n")) do
    vim.cmd("echom '" .. s:gsub("'", "''") .. "'")
  end
end

function M.info(msg)
  vim.cmd("echohl Directory")
  M._echo_multiline(msg)
  vim.cmd("echohl None")
end

function M.warn(msg)
  vim.cmd("echohl WarningMsg")
  M._echo_multiline(msg)
  vim.cmd("echohl None")
end

function M.err(msg)
  vim.cmd("echohl ErrorMsg")
  M._echo_multiline(msg)
  vim.cmd("echohl None")
end

-- Python環境のキャッシュ用変数
local cached_python_env = nil
local cached_env_info = nil

function M.get_python_env()
  -- キャッシュされた環境がある場合はそれを返す
  if cached_python_env then
    return cached_python_env
  end

  -- 1. Poetry環境の確認
  local poetry_path = vim.fn.system('poetry env info -p 2>/dev/null'):gsub('\n', '')
  if poetry_path ~= '' then
    cached_python_env = poetry_path .. '/bin/python'
    cached_env_info = 'Poetry environment detected: ' .. poetry_path
    M.info(cached_env_info)
    return cached_python_env
  end

  -- 2. Pyenv virtualenv環境の確認
  local pyenv_version = vim.fn.system('pyenv version-name 2>/dev/null'):gsub('\n', '')
  if pyenv_version ~= '' and pyenv_version ~= 'system' then
    cached_python_env = vim.fn.expand('~/.pyenv/versions/' .. pyenv_version .. '/bin/python')
    cached_env_info = 'Pyenv environment detected: ' .. pyenv_version
    M.info(cached_env_info)
    return cached_python_env
  end

  -- 3. Mason環境のPython
  local mason_path = vim.fn.stdpath('data') .. '/mason/packages'
  if vim.fn.isdirectory(mason_path) ~= 0 then
    cached_python_env = mason_path .. '/python/venv/bin/python'
    cached_env_info = 'Mason environment detected: ' .. mason_path
    M.info(cached_env_info)
    return cached_python_env
  end

  -- フォールバック: システムのPython
  cached_python_env = 'python'
  cached_env_info = 'No Python environment detected. Using system Python.'
  M.warn(cached_env_info)
  return cached_python_env
end

-- 環境情報をクリアする関数（必要に応じて使用）
function M.clear_python_env_cache()
  cached_python_env = nil
  cached_env_info = nil
end

return M
