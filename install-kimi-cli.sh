#!/bin/bash
# ============================================
# 在64位树莓派系统上快速安装 Kimi CLI 工具
# ============================================

set -e

echo "=========================================="
echo "  Kimi CLI 安装脚本 (ARM64)"
echo "=========================================="

# 检查是否为ARM64架构
ARCH=$(uname -m)
if [ "$ARCH" != "aarch64" ] && [ "$ARCH" != "arm64" ]; then
    echo "警告: 当前架构为 $ARCH，此脚本主要为 ARM64 架构设计"
    read -p "是否继续安装? (y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        exit 1
    fi
fi

# 安装 uv (Python包管理器)
install_uv() {
    echo ""
    echo "[1/3] 正在安装 uv (Python包管理器)..."
    
    # 检查 uv 是否已安装
    if [ -f "$HOME/.cargo/bin/uv" ]; then
        echo "uv 已安装"
        export PATH="$HOME/.cargo/bin:$PATH"
        echo "uv 版本: $($HOME/.cargo/bin/uv --version)"
        return
    fi
    
    # 下载并安装 uv (ARM64)
    echo "正在下载 uv..."
    UV_VERSION="0.6.0"
    UV_URL="https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-aarch64-unknown-linux-gnu.tar.gz"
    
    cd /tmp
    rm -rf uv-extract uv.tar.gz
    mkdir -p uv-extract
    curl -Lo uv.tar.gz "$UV_URL"
    tar -xzf uv.tar.gz -C uv-extract
    
    # 查找解压后的 uv 和 uvx 文件
    UV_BIN=$(find uv-extract -name "uv" -type f | head -1)
    UVX_BIN=$(find uv-extract -name "uvx" -type f | head -1)
    
    if [ -z "$UV_BIN" ]; then
        echo "错误: 未找到 uv 二进制文件"
        echo "解压后的文件列表:"
        find uv-extract -type f
        exit 1
    fi
    
    # 移动到 cargo/bin
    mkdir -p "$HOME/.cargo/bin"
    cp "$UV_BIN" "$HOME/.cargo/bin/"
    echo "已复制 uv 到 $HOME/.cargo/bin/"
    
    if [ -n "$UVX_BIN" ]; then
        cp "$UVX_BIN" "$HOME/.cargo/bin/"
        echo "已复制 uvx 到 $HOME/.cargo/bin/"
    fi
    
    # 清理
    rm -rf uv-extract uv.tar.gz
    cd - > /dev/null
    
    # 添加 PATH
    export PATH="$HOME/.cargo/bin:$PATH"
    
    # 添加到 .bashrc
    if ! grep -q ".cargo/bin" "$HOME/.bashrc" 2>/dev/null; then
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$HOME/.bashrc"
        echo "已添加 uv 到 ~/.bashrc"
    fi
    
    echo "uv 安装完成: $($HOME/.cargo/bin/uv --version)"
}

# 安装 kimi-cli
install_kimi_cli() {
    echo ""
    echo "[2/3] 正在安装 kimi-cli..."
    
    export PATH="$HOME/.cargo/bin:$PATH"
    
    # 检查 uv 是否存在
    if [ ! -f "$HOME/.cargo/bin/uv" ]; then
        echo "错误: uv 未找到"
        exit 1
    fi
    
    # 安装 kimi-cli
    $HOME/.cargo/bin/uv tool install kimi-cli
    
    echo "kimi-cli 安装完成"
}

# 验证安装
verify_installation() {
    echo ""
    echo "[3/3] 验证安装..."
    
    export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
    
    if command -v kimi &> /dev/null; then
        echo ""
        echo "=========================================="
        echo "  Kimi CLI 安装成功!"
        echo "=========================================="
        echo ""
        kimi --version
        echo ""
        echo "使用说明:"
        echo "  - 启动 Kimi: kimi"
        echo "  - 配置API Key: kimi configure"
        echo ""
        echo "提示: 如果 'kimi' 命令未找到，请运行: source ~/.bashrc"
    else
        echo "kimi-cli 可能安装成功但未在 PATH 中"
        echo "尝试执行: $HOME/.local/bin/kimi --version"
        $HOME/.local/bin/kimi --version 2>/dev/null || echo "未找到 kimi"
    fi
}

# 主流程
main() {
    install_uv
    install_kimi_cli
    verify_installation
    
    echo ""
    echo "安装路径:"
    echo "  - uv: $HOME/.cargo/bin/uv"
    echo "  - kimi: $HOME/.local/bin/kimi"
    echo ""
}

main
