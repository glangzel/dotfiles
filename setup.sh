#!/bin/bash
set -e

# 設定ファイルアーカイブ名
ARCHIVE_NAME="dotfiles.tar.gz"
EXTRACT_DIR="my_dev_env"

# アーカイブがあるか確認
if [ ! -f "$ARCHIVE_NAME" ]; then
    echo "エラー: $ARCHIVE_NAME が同じディレクトリに見つかりません。"
    exit 1
fi

echo "== 環境構築を開始します =="

# 1. ソフトウェアのインストール (必要に応じてsudoパスワードが求められます)
echo "1. ソフトウェアをインストールしています..."
if command -v apt &> /dev/null; then
    sudo apt update
    sudo apt install -y neovim tmux git curl tar ripgrep
    # ※ ripgrep は neovim (telescope等) でよく使うため追加しています
elif command -v dnf &> /dev/null; then
    # RHEL/CentOS/Fedora系の場合
    sudo dnf install -y neovim tmux git curl tar ripgrep
else
    echo "警告: パッケージマネージャーが特定できませんでした。"
    echo "手動で neovim, tmux, git, curl をインストールしてください。"
fi

# 2. 設定ファイルの展開
echo "2. 設定ファイルを配置しています..."
tar -xzf "$ARCHIVE_NAME"

# バックアップを取りつつ配置
# Bash
if [ -f ~/.bashrc ]; then
    mv ~/.bashrc ~/.bashrc.backup.$(date +%F_%T)
fi
cp "$EXTRACT_DIR/.bashrc" ~/

# Tmux
if [ -f ~/.tmux.conf ]; then
    mv ~/.tmux.conf ~/.tmux.conf.backup.$(date +%F_%T)
fi
cp "$EXTRACT_DIR/.tmux.conf" ~/

# Neovim
mkdir -p ~/.config/nvim
if [ -d ~/.config/nvim ]; then
    # 既存の設定があればバックアップ
    if [ "$(ls -A ~/.config/nvim)" ]; then
        mv ~/.config/nvim ~/.config/nvim.backup.$(date +%F_%T)
        mkdir -p ~/.config/nvim
    fi
fi
cp -r "$EXTRACT_DIR/config/nvim/"* ~/.config/nvim/

# 展開した一時フォルダの削除
rm -rf "$EXTRACT_DIR"

# 3. Tmux Plugin Manager (TPM) のインストール
# tmuxプラグインを自動管理するために必要です
TPM_DIR=~/.tmux/plugins/tpm
if [ ! -d "$TPM_DIR" ]; then
    echo "3. Tmux Plugin Manager (TPM) をインストール中..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    echo "3. TPMは既にインストールされています。"
fi

echo "------------------------------------------------"
echo "完了しました！"
echo ""
echo "【重要: 次のアクション】"
echo "1. bash設定を反映するため、再ログインするか 'source ~/.bashrc' を実行してください。"
echo "2. Neovimを開くと、lazy.nvim等が自動でプラグインをインストールし始めます。"
echo "3. tmuxを開き、'Prefix + I' (大文字アイ) を押してプラグインをインストールしてください。"
