#!/bin/bash
# ============================================
# 在64位树莓派系统上快速安装 OpenCode 工具
# 适用于: Raspberry Pi OS (64-bit) / Ubuntu ARM64
# ============================================

set -e

echo "=========================================="
echo "  OpenCode 安装脚本 (ARM64)"
echo "=========================================="

# 检查是否为ARM64架构
ARCH=$(uname -m)
if [[ "$ARCH" != "aarch64" && "$ARCH" != "arm64" ]]; then
    echo "警告: 当前架构为 $ARCH，此脚本主要为 ARM64 架构设计"
    read -p "是否继续安装? (y/N): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        exit 1
    fi
fi

# 安装 Node.js (如果需要)
install_nodejs() {
    echo ""
    echo "[1/3] 检查 Node.js 环境..."
    
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        echo "Node.js 已安装，版本: $NODE_VERSION"
        
        # 检查版本是否 >= 20
        MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$MAJOR_VERSION" -lt 20 ]; then
            echo "警告: Node.js 版本建议 >= 20，当前为 $NODE_VERSION"
            echo "尝试更新 Node.js..."
            install_nodejs_latest
        fi
        return
    fi
    
    install_nodejs_latest
}

# 安装最新版 Node.js
install_nodejs_latest() {
    echo "正在安装 Node.js (LTS 版本)..."
    
    # 更新 apt
    sudo apt-get update
    
    # 安装必要的依赖
    sudo apt-get install -y curl ca-certificates gnupg
    
    # 添加 NodeSource 源 (Node.js 24 LTS)
    curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
    
    # 安装 Node.js
    sudo apt-get install -y nodejs
    
    echo "Node.js 安装完成: $(node --version)"
    echo "npm 版本: $(npm --version)"
}

# 安装 OpenCode
install_opencode() {
    echo ""
    echo "[2/3] 正在安装 OpenCode..."
    
    # 使用 npm 全局安装
    sudo npm install -g opencode-ai
    
    echo "OpenCode 安装完成"
}

# 验证安装
verify_installation() {
    echo ""
    echo "[3/3] 验证安装..."
    
    if command -v opencode &> /dev/null; then
        echo ""
        echo "=========================================="
        echo "  ✅ OpenCode 安装成功!"
        echo "=========================================="
        echo ""
        echo "版本信息:"
        opencode --version
        echo ""
        echo "使用说明:"
        echo "  - 启动 OpenCode: opencode"
        echo "  - 查看帮助: opencode --help"
        echo "  - 配置: opencode config"
        echo ""
    else
        echo "❌ 安装可能未完成，尝试通过官方脚本安装..."
        
        # 尝试使用官方安装脚本
        curl -fsSL https://opencode.ai/install | bash
        
        if command -v opencode &> /dev/null; then
            echo "✅ OpenCode 通过官方脚本安装成功!"
        else
            echo "❌ 安装失败，请检查错误信息"
            exit 1
        fi
    fi
}

# 主流程
main() {
    install_nodejs
    install_opencode
    verify_installation
    
    echo ""
    echo "安装路径:"
    echo "  - opencode: $(which opencode 2>/dev/null || echo '/usr/bin/opencode')"
    echo ""
    echo "提示: 首次使用可能需要配置 API Key"
    echo "  运行: opencode config"
    echo ""
}

main
