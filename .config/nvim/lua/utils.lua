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

local cached_python_env = nil
local cached_env_info = nil
function M.get_python_env()
  -- キャッシュされた環境がある場合はそれを返す
  if cached_python_env then
    return cached_python_env
  end

  -- 1. プロジェクトルートの.venv（pyproject.tomlがある階層）
  local project_root = vim.fn.finddir(".git/..", vim.fn.expand("%:p:h") .. ";")
  if project_root ~= "" then
    local pyproject_path = project_root .. "/pyproject.toml"
    if vim.fn.filereadable(pyproject_path) == 1 then
      local venv_path = project_root .. "/.venv"
      if vim.fn.isdirectory(venv_path) == 1 then
        cached_python_env = venv_path .. "/bin/python"
        cached_env_info = "Project root .venv detected: " .. venv_path
        M.info(cached_env_info)
        return cached_python_env
      end
    end
  end

  -- 2. Poetry
  local poetry_path = vim.fn.system("poetry env info -p 2>/dev/null"):gsub("\n", "")
  if poetry_path ~= "" then
    cached_python_env = poetry_path .. "/bin/python"
    cached_env_info = "Poetry environment detected: " .. poetry_path
    M.info(cached_env_info)
    return cached_python_env
  end

  -- 3. Mason
  local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
  if vim.fn.isdirectory(mason_path) ~= 0 then
    cached_python_env = mason_path .. "/python/venv/bin/python"
    cached_env_info = "Mason environment detected: " .. mason_path
    M.info(cached_env_info)
    return cached_python_env
  end

  -- 4. Pyenv virtualenv
  local pyenv_version = vim.fn.system("pyenv version-name 2>/dev/null"):gsub("\n", "")
  if pyenv_version ~= "" and pyenv_version ~= "system" then
    cached_python_env = vim.fn.expand("~/.pyenv/versions/" .. pyenv_version .. "/bin/python")
    cached_env_info = "Pyenv environment detected: " .. pyenv_version
    M.info(cached_env_info)
    return cached_python_env
  end

  -- fallback: system's Python
  cached_python_env = "python"
  cached_env_info = "No Python environment detected. Using system Python."
  M.warn(cached_env_info)
  return cached_python_env
end

return M
