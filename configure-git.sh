#!/bin/bash
set -e

GIT_USER_NAME="xujie"
GIT_USER_EMAIL="1690663374@qq.com"

echo "=========================================="
echo "  Git 环境快速配置工具"
echo "=========================================="

if ! command -v git &> /dev/null; then
    echo "Git 未安装，正在安装..."
    sudo apt-get update
    sudo apt-get install -y git
else
    echo "Git 已安装: $(git --version)"
fi

echo ""
echo "[1/3] 配置 Git 用户信息..."
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
echo "  用户名: $GIT_USER_NAME"
echo "  邮箱: $GIT_USER_EMAIL"

echo ""
echo "[2/3] 配置 Git 常用选项..."
git config --global init.defaultBranch main
git config --global push.default simple
git config --global pull.rebase true
git config --global color.ui auto
echo "  常用选项配置完成"

echo ""
echo "[3/3] 检查 SSH 密钥..."
SSH_KEY_FILE="$HOME/.ssh/id_ed25519"
if [ -f "$SSH_KEY_FILE" ]; then
    echo "  SSH 密钥已存在"
else
    echo "  正在生成 SSH 密钥..."
    mkdir -p "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$GIT_USER_EMAIL" -f "$SSH_KEY_FILE" -N ""
    echo "  SSH 密钥生成完成"
fi

echo ""
echo "=========================================="
echo "  配置完成！"
echo "=========================================="
echo ""
echo "SSH 公钥（请添加到 GitHub）:"
cat "$SSH_KEY_FILE.pub"
echo ""
echo "测试命令: ssh -T git@github.com"