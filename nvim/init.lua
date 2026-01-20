-- ==========================================
-- 1. 基本設定 (Basic Settings)
-- ==========================================
-- リーダーキーをスペースに設定 (これが起点となります)
vim.g.mapleader = " "

-- 行番号を表示
vim.opt.number = true
-- 相対行番号を表示（カーソル移動の距離がわかりやすくなります）
-- 慣れていない場合は false にしてもOKです
vim.opt.relativenumber = true 

-- インデント設定 (C/Verilog向けに4スペース)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- タブをスペースに変換
vim.opt.smartindent = true

-- クリップボードをOSと共有 (Ctrl+C / Ctrl+V的な挙動のため)
vim.opt.clipboard = "unnamedplus"

-- 検索設定
vim.opt.ignorecase = true -- 大文字小文字を区別しない
vim.opt.smartcase = true  -- 大文字が含まれる場合のみ区別する

-- マウス操作を有効化
vim.opt.mouse = ""

-- エンコーディング
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"


-- 1. 絵文字を使用しない (絵文字を全角幅として扱わない設定)
-- ※表示自体を禁止するものではありませんが、エディタ上の文字幅計算における「絵文字モード」を無効化します。
vim.opt.emoji = false

-- 2. 相対行表示を無効化する
vim.opt.relativenumber = false
vim.opt.number = true -- 代わりに通常の絶対行番号を表示する（必要であれば）

-- 3. 現在位置の行をハイライト表示する
vim.opt.cursorline = true

-- ==========================================
-- 2. プラグインマネージャ (lazy.nvim) のセットアップ
-- ==========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================
-- 3. プラグインの定義と設定
-- ==========================================
require("lazy").setup({
    --Parser: TreeSitter
--     {
--         'nvim-treesitter/nvim-treesitter',
--         lazy = false,
--         build = ':TSUpdate',
-- 	config = function()
-- 	    require'nvim-treesitter'.install { 'cpp', 'lua' , 'vim', 'vimdoc', 'query', 'markdown' }
-- 	end
--     },
    -- カラースキーム: Gruvbox
    { 
        "ellisonleao/gruvbox.nvim", 
        priority = 1000, 
        config = function()
            vim.o.background = "dark" -- "light" に変更可能
            vim.cmd([[colorscheme gruvbox]])
        end,
    },

    -- ステータスライン: Lualine
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }, -- アイコン表示用
        config = function()
            require('lualine').setup({
                options = { 
                    theme = 'gruvbox',
                    icons_enabled = false, -- アイコン無効化
                    component_separators = '|',
                    section_separators = '',
                },
                tabline = {
                    -- 左上: 開いているバッファ(ファイル)一覧を表示
                    lualine_a = {{
                        'buffers',
                        mode = 2, -- 0: バッファ名のみ, 1: バッファ番号+名, 2: 番号+名(詳細), 4: 番号+名(詳細)+トグル
                    }},
                    -- 右上: タブ番号を表示
                    lualine_z = {'tabs'}
                }
            })
        end
    },
    -- ファイラ: Fern
    {
        'lambdalisue/fern.vim',
        dependencies = {
            'lambdalisue/fern-hijack.vim',            -- 1. nvim {dir} でFernを起動させる
            'lambdalisue/nerdfont.vim',               -- 2. アイコン用フォント

            'lambdalisue/fern-renderer-nerdfont.vim', -- 2. Fernでアイコンを表示するレンダラー
            'lambdalisue/glyph-palette.vim',          -- 2. アイコンに色をつける (VSCodeライクにするため推奨)
        },
        config = function()
            -- -----------------------------------------
            -- 基本設定

            -- -----------------------------------------
            -- Ctrl+n でファイラを開閉
            vim.keymap.set('n', '<C-n>', ':Fern . -drawer -toggle<CR>', { silent = true })
            -- 隠しファイルを表示
            vim.g['fern#default_hidden'] = 1


            -- -----------------------------------------
            -- VSCodeライクな見た目 & 補助線
            -- -----------------------------------------
            -- アイコンを表示するためのレンダラー設定
            vim.g['fern#renderer'] = 'nerdfont'

            -- 3. ディレクトリの階層に補助線（ガイドライン）を引く
            vim.g['fern#renderer#nerdfont#indent_markers'] = 1

            -- アイコンに色をつける自動コマンド (glyph-palette)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "fern",
                callback = function()
                    vim.fn['glyph_palette#apply']()
                
                    -- 2. キーマップ変更: Enterを 'l' (open:or-expand) と同じにする
                    -- local opts = { buffer = true, silent = true, remap = true }
                    -- vim.keymap.set('n', '<CR>', '<Plug>(fern-action-open:or-expand)', opts)
                    vim.keymap.set('n', '<CR>', 'l', { buffer = true, remap = true })
                end,

            })
        end
    },

    -- あいまい検索: Telescope (変更なし)
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        end
    },
    -- 自動補完・LSP: CoC.nvim
    {
        'neoclide/coc.nvim',
        branch = 'release',
        config = function()
            -- CoC用のキーマッピング設定 (重要)
            
            -- Enterキーで補完を確定
            vim.keymap.set("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], { expr = true, silent = true })

            -- 定義ジャンプ (gd)
            vim.keymap.set("n", "gd", "<Plug>(coc-definition)", {silent = true})
            -- 型定義ジャンプ (gy)
            vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
            -- 実装ジャンプ (gi)
            vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", {silent = true})
            -- 参照一覧 (gr)
            vim.keymap.set("n", "gr", "<Plug>(coc-references)", {silent = true})
            
            -- 変数名の一括変更 (<leader>rn)
            vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})
            
            -- カーソル位置のドキュメント表示 (K)
            function _G.show_docs()
                local cw = vim.fn.expand('<cword>')
                if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
                    vim.api.nvim_command('h ' .. cw)
                elseif vim.api.nvim_eval('coc#rpc#ready()') then
                    vim.fn.CocActionAsync('doHover')
                else
                    vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
                end
            end
            vim.keymap.set("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})
        end
    }
})
