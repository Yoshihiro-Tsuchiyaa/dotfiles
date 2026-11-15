--
--  Vim: set expandtab tabstop=3 shiftwidth=3 softtabstop=-1:
--
-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action
local theme = 'NightOwl'
local themes = {
   Dracura = {
      wezterm   = "Dracula+",
      vim       = "dracula",
      lightline = "dracura",
   },
   Iceberg = {
      wezterm   = "iceberg-dark",
      vim       = "iceberg",
      lightline = "iceberg",
   },
   TokyoNight = {
      wezterm   = "tokyonight_night",
      vim       = "tokyonight",
      lightline = "tokyonight",
   },
   NightOwl = {
      wezterm   = "Night Owl (Gogh)",
      vim       = "night-owl",
      lightline = "nightowl",
   },
}

local selected = themes[theme]

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.
if wezterm.target_triple:find("windows") then
    config.default_prog = { 'pwsh.exe', '-noLogo' }
else
    config.default_prog = { "bash" }
end
config.default_cwd = "~"

config.automatically_reload_config = true

config.set_environment_variables = {
    TERMINAL_EMULATOR     = 'WezTerm',
    WT_SHELL              = 'pwsh',
    WT_THEME              = selected.wezterm,
    VIM_COLORSCHEME       = selected.vim,
    LIGHTLINE_COLORSCHEME = selected.lightline,
}

config.use_ime = true

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 60

-- or, changing the font size and color scheme.
config.font = wezterm.font('PlemolJP Console NF', { weight = 'Regular' })
config.font_size = 14.0
-- config.color_scheme = 'AdventureTime'
config.color_scheme = selected.wezterm
config.window_background_opacity = 1.0

--------------------------------------------------------------------
-- 見た目
--------------------------------------------------------------------
-- ウィンドウ枠の装飾
-- NONE:なし
-- TITLE: タイトルのみ
-- RESIZE: リサイズ用の枠のみ
-- TITLE | RESIZE: タイトルとリサイズ枠
-- INTEGRATED_BUTTONS|RESIZE: 統合されたボタンとリサイズ枠
config.window_decorations = "TITLE|RESIZE"
config.hide_tab_bar_if_only_one_tab = true
-- フォントサイズを変更したときにウィンドウサイズを変更するか？
-- true: ウィンドウの物理的なサイズ(幅・高さ)が変わる
-- false: ウィンドウサイズはそのまま維持され、中にあるターミナルの行数(rows)や列数(cols)が変化する
-- nil(default): 自動判定(タイリング環境の場合は false、それ以外は true)
config.adjust_window_size_when_changing_font_size = false
-- キーバインド
--------------------------------------------------------------------
config.keys = {
    ------------------------------------------------------------
    -- Ctrl+Shift+c / Ctrl+Shift+v
    -- (標準的なターミナル流儀)
    ------------------------------------------------------------
    {
      key = "c",
      mods = "CTRL|SHIFT",
      action = act.CopyTo("Clipboard"),
    },

    {
      key = "v",
      mods = "CTRL|SHIFT",
      action = act.PasteFrom("Clipboard"),
    },

    ------------------------------------------------------------
    -- Ctrl+C / Ctrl+V
    -- GUIアプリ風に使いたい場合
    ------------------------------------------------------------
--[[
    {
      key = "c",
      mods = "CTRL",
      action = act.CopyTo("Clipboard"),
    },

    {
      key = "v",
      mods = "CTRL",
      action = act.PasteFrom("Clipboard"),
    },
]]
    ------------------------------------------------------------
    -- Ctrl+Shift+T
    -- 新規タブ
    ------------------------------------------------------------
    {
      key = "T",
      mods = "CTRL|SHIFT",
      action = act.SpawnTab("CurrentPaneDomain"),
    },

    ------------------------------------------------------------
    -- Ctrl+Tab
    ------------------------------------------------------------
    {
      key = "Tab",
      mods = "CTRL",
      action = act.ActivateTabRelative(1),
    },

    ------------------------------------------------------------
    -- Ctrl+Shift+Tab
    ------------------------------------------------------------
    {
      key = "Tab",
      mods = "CTRL|SHIFT",
      action = act.ActivateTabRelative(-1),
    },

    ------------------------------------------------------------
    -- Ctrl+=
    -- フォント拡大
    ------------------------------------------------------------
    {
      key = "=",
      mods = "CTRL",
      action = act.IncreaseFontSize,
    },

    ------------------------------------------------------------
    -- Ctrl+-
    -- フォント縮小
    ------------------------------------------------------------
    {
      key = "-",
      mods = "CTRL",
      action = act.DecreaseFontSize,
    },

    ------------------------------------------------------------
    -- Ctrl+0
    -- フォントリセット
    ------------------------------------------------------------
    {
      key = "0",
      mods = "CTRL",
      action = act.ResetFontSize,
    },
}

--------------------------------------------------------------------
-- マウス設定
--------------------------------------------------------------------
config.mouse_bindings = {
    ------------------------------------------------------------
    -- 左ドラッグ選択後に右クリックでコピー
    ------------------------------------------------------------
    {
      event = { Up = { streak = 1, button = "Right" } },
      mods = "NONE",
      action = act.CopyTo("Clipboard"),
    },
  -- マウスで選択時にクリップボードへ自動コピーする
  -- 選択したら自動コピー
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection('ClipboardAndPrimarySelection'),
  },

    ------------------------------------------------------------
    -- 中クリックでペースト
    ------------------------------------------------------------
    {
      event = { Down = { streak = 1, button = "Middle" } },
      mods = "NONE",
      action = act.PasteFrom("Clipboard"),
    },
  -- 右クリックで貼付け
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom('Clipboard'),
  },
}
--[[
config.mouse_bindings = {
    {
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor(
		  "Clipboard"
		),
    },
    {
        event = { Down = { streak = 1, button = "Middle" } },
        mods = "NONE",
        action = wezterm.action.PasteFrom("Clipboard"),
    },
}
]]
--------------------------------------------------------------------
-- Finally, return the configuration to wezterm:
return config
