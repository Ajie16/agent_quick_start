#!/bin/bash
# ============================================
# 树莓派64位系统国内镜像源切换脚本
# 适用于: Raspberry Pi OS (64-bit) / Ubuntu ARM64 / Debian ARM64
# ============================================

set -e

echo "=========================================="
echo "  树莓派64位系统镜像源切换工具"
echo "=========================================="

# 检测系统类型
detect_system() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VERSION=$VERSION_ID
        CODENAME=$VERSION_CODENAME
        echo "检测到系统: $NAME $VERSION ($CODENAME)"
    else
        echo "无法检测系统类型"
        exit 1
    fi
}

# 显示菜单
show_menu() {
    echo ""
    echo "请选择要切换的镜像源:"
    echo ""
    echo "  1) 清华大学 (Tsinghua) - 推荐"
    echo "  2) 阿里云 (Aliyun)"
    echo "  3) 中科大 (USTC)"
    echo "  4) 华为云 (Huawei)"
    echo "  5) 腾讯云 (Tencent)"
    echo "  6) 恢复官方源 (Original)"
    echo ""
    echo "  0) 退出"
    echo ""
}

# 备份原有配置
backup_sources() {
    echo ""
    echo "正在备份原有配置..."
    
    BACKUP_DIR="/etc/apt/backup-$(date +%Y%m%d-%H%M%S)"
    sudo mkdir -p "$BACKUP_DIR"
    
    # 备份主要源文件
    if [ -f /etc/apt/sources.list ]; then
        sudo cp /etc/apt/sources.list "$BACKUP_DIR/"
        echo "  ✓ 已备份 /etc/apt/sources.list"
    fi
    
    # 备份 sources.list.d 中的文件
    if [ -d /etc/apt/sources.list.d ]; then
        sudo cp -r /etc/apt/sources.list.d "$BACKUP_DIR/"
        echo "  ✓ 已备份 /etc/apt/sources.list.d/"
    fi
    
    echo "备份位置: $BACKUP_DIR"
}

# 切换清华源
tsinghua_mirror() {
    echo ""
    echo "正在切换到清华大学镜像源..."
    
    case $OS in
        "ubuntu")
            sudo tee /etc/apt/sources.list > /dev/null << EOF
# Ubuntu ARM64 - Tsinghua Mirror
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports $CODENAME main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports $CODENAME-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports $CODENAME-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports $CODENAME-security main restricted universe multiverse
EOF
            ;;
        "debian"|"raspbian")
            sudo tee /etc/apt/sources.list > /dev/null << EOF
# Debian ARM64 - Tsinghua Mirror
deb https://mirrors.tuna.tsinghua.edu.cn/debian $CODENAME main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian $CODENAME-updates main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian $CODENAME-backports main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security $CODENAME-security main contrib non-free non-free-firmware
EOF
            ;;
    esac
    
    # 处理树莓派专用源
    if [ "$OS" = "raspbian" ]; then
        sudo rm -f /etc/apt/sources.list.d/raspi.list
        sudo tee /etc/apt/sources.list.d/raspi.list > /dev/null << EOF
# Raspberry Pi Repository - Tsinghua Mirror
deb https://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ $CODENAME main
EOF
    fi
}

# 切换阿里云源
aliyun_mirror() {
    echo ""
    echo "正在切换到阿里云镜像源..."
    
    case $OS in
        "ubuntu")
            sudo tee /etc/apt/sources.list > /dev/null << EOF
# Ubuntu ARM64 - Aliyun Mirror
deb https://mirrors.aliyun.com/ubuntu-ports/ $CODENAME main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu-ports/ $CODENAME-updates main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu-ports/ $CODENAME-backports main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu-ports/ $CODENAME-security main restricted universe multiverse
EOF
            ;;
        "debian"|"raspbian")
            sudo tee /etc/apt/sources.list > /dev/null << EOF
# Debian ARM64 - Aliyun Mirror
deb https://mirrors.aliyun.com/debian/ $CODENAME main contrib non-free non-free-firmware
deb https://mirrors.aliyun.com/debian/ $CODENAME-updates main contrib non-free non-free-firmware
deb https://mirrors.aliyun.com/debian/ $CODENAME-backports main contrib non-free non-free-firmware
deb https://mirrors.aliyun.com/debian-security/ $CODENAME-security main contrib non-free non-free-firmware
EOF
            ;;
    esac
    
    if [ "$OS" = "raspbian" ]; then
        sudo rm -f /etc/apt/sources.list.d/raspi.list
        sudo tee /etc/apt/sources.list.d/raspi.list > /dev/null << EOF
# Raspberry Pi Repository - Aliyun Mirror (使用清华)
deb https://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ $CODENAME main
EOF
    fi
}

# 切换中科大源
ustc_mirror() {
    echo ""
    echo "正在切换到中科大镜像源..."
    
    case $OS in
        "ubuntu")
            sudo tee /etc/apt/sources.list > /dev/null << EOF
# Ubuntu ARM64 - USTC Mirror
deb https://mirrors.ustc.edu.cn/ubuntu-ports/ $CODENAME main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu-ports/ $CODENAME-updates main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu-ports/ $CODENAME-backports main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu-ports/ $CODENAME-security main restricted universe multiverse
EOF
            ;;
        "debian"|"raspbian")
            sudo tee /etc/apt/sources.list > /dev/null << EOF
# Debian ARM64 - USTC Mirror
deb https://mirrors.ustc.edu.cn/debian $CODENAME main contrib non-free non-free-firmware
deb https://mirrors.ustc.edu.cn/debian $CODENAME-updates main contrib non-free non-free-firmware
deb https://mirrors.ustc.edu.cn/debian $CODENAME-backports main contrib non-free non-free-firmware
deb https://mirrors.ustc.edu.cn/debian-security $CODENAME-security main contrib non-free non-free-firmware
EOF
            ;;
    esac
    
    if [ "$OS" = "raspbian" ]; then
        sudo rm -f /etc/apt/sources.list.d/raspi.list
        sudo tee /etc/apt/sources.list.d/raspi.list > /dev/null << EOF
# Raspberry Pi Repository - USTC Mirror
deb https://mirrors.ustc.edu.cn/raspberrypi/ $CODENAME main
EOF
    fi
}

# 切换华为云源
huawei_mirror() {
    echo ""
    echo "正在切换到华为云镜像源..."
    
    case $OS in
        "ubuntu")
            sudo tee /etc/apt/sources.list > /dev/null << EOF
# Ubuntu ARM64 - Huawei Mirror
deb https://repo.huaweicloud.com/ubuntu-ports/ $CODENAME main restricted universe multiverse
deb https://repo.huaweicloud.com/ubuntu-ports/ $CODENAME-updates main restricted universe multiverse
deb https://repo.huaweicloud.com/ubuntu-ports/ $CODENAME-backports main restricted universe multiverse
deb https://repo.huaweicloud.com/ubuntu-ports/ $CODENAME-security main restricted universe multiverse
EOF
            ;;
        "debian"|"raspbian")
            sudo tee /etc/apt/sources.list > /dev/null << EOF
# Debian ARM64 - Huawei Mirror
deb https://repo.huaweicloud.com/debian/ $CODENAME main contrib non-free non-free-firmware
deb https://repo.huaweicloud.com/debian/ $CODENAME-updates main contrib non-free non-free-firmware
deb https://repo.huaweicloud.com/debian/ $CODENAME-backports main contrib non-free non-free-firmware
deb https://repo.huaweicloud.com/debian-security/ $CODENAME-security main contrib non-free non-free-firmware
EOF
            ;;
    esac
    
    if [ "$OS" = "raspbian" ]; then
        sudo rm -f /etc/apt/sources.list.d/raspi.list
        sudo tee /etc/apt/sources.list.d/raspi.list > /dev/null << EOF
# Raspberry Pi Repository - Tsinghua Mirror
deb https://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ $CODENAME main
EOF
    fi
}

# 切换腾讯云源
tencent_mirror() {
    echo ""
    echo "正在切换到腾讯云镜像源..."
    
    case $OS in
        "ubuntu")
            sudo tee /etc/apt/sources.list > /dev/null << EOF
# Ubuntu ARM64 - Tencent Mirror
deb https://mirrors.cloud.tencent.com/ubuntu-ports/ $CODENAME main restricted universe multiverse
deb https://mirrors.cloud.tencent.com/ubuntu-ports/ $CODENAME-updates main restricted universe multiverse
deb https://mirrors.cloud.tencent.com/ubuntu-ports/ $CODENAME-backports main restricted universe multiverse
deb https://mirrors.cloud.tencent.com/ubuntu-ports/ $CODENAME-security main restricted universe multiverse
EOF
            ;;
        "debian"|"raspbian")
            sudo tee /etc/apt/sources.list > /dev/null << EOF
# Debian ARM64 - Tencent Mirror
deb https://mirrors.cloud.tencent.com/debian/ $CODENAME main contrib non-free non-free-firmware
deb https://mirrors.cloud.tencent.com/debian/ $CODENAME-updates main contrib non-free non-free-firmware
deb https://mirrors.cloud.tencent.com/debian/ $CODENAME-backports main contrib non-free non-free-firmware
deb https://mirrors.cloud.tencent.com/debian-security/ $CODENAME-security main contrib non-free non-free-firmware
EOF
            ;;
    esac
    
    if [ "$OS" = "raspbian" ]; then
        sudo rm -f /etc/apt/sources.list.d/raspi.list
        sudo tee /etc/apt/sources.list.d/raspi.list > /dev/null << EOF
# Raspberry Pi Repository - Tsinghua Mirror
deb https://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ $CODENAME main
EOF
    fi
}

# 恢复官方源
original_source() {
    echo ""
    echo "正在恢复到官方源..."
    
    case $OS in
        "ubuntu")
            sudo tee /etc/apt/sources.list > /dev/null << EOF
# Ubuntu ARM64 - Official
deb http://ports.ubuntu.com/ubuntu-ports/ $CODENAME main restricted universe multiverse
deb http://ports.ubuntu.com/ubuntu-ports/ $CODENAME-updates main restricted universe multiverse
deb http://ports.ubuntu.com/ubuntu-ports/ $CODENAME-backports main restricted universe multiverse
deb http://ports.ubuntu.com/ubuntu-ports/ $CODENAME-security main restricted universe multiverse
EOF
            ;;
        "debian")
            sudo tee /etc/apt/sources.list > /dev/null << EOF
# Debian ARM64 - Official
deb http://deb.debian.org/debian $CODENAME main contrib non-free non-free-firmware
deb http://deb.debian.org/debian $CODENAME-updates main contrib non-free non-free-firmware
deb http://deb.debian.org/debian $CODENAME-backports main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security $CODENAME-security main contrib non-free non-free-firmware
EOF
            ;;
        "raspbian")
            sudo tee /etc/apt/sources.list > /dev/null << EOF
# Raspberry Pi OS - Official
deb http://archive.raspbian.org/raspbian $CODENAME main contrib non-free rpi
EOF
            sudo rm -f /etc/apt/sources.list.d/raspi.list
            sudo tee /etc/apt/sources.list.d/raspi.list > /dev/null << EOF
deb http://archive.raspberrypi.org/debian/ $CODENAME main
EOF
            ;;
    esac
}

# 更新apt缓存
update_apt() {
    echo ""
    echo "正在更新 apt 缓存..."
    sudo apt-get update
    echo ""
    echo "✅ 镜像源切换完成!"
}

# 主流程
main() {
    detect_system
    
    # 检查是否为ARM64架构
    ARCH=$(uname -m)
    if [[ "$ARCH" != "aarch64" && "$ARCH" != "arm64" ]]; then
        echo ""
        echo "警告: 当前架构为 $ARCH，此脚本主要为 ARM64 架构设计"
    fi
    
    # 交互式选择或直接通过参数
    if [ -z "$1" ]; then
        show_menu
        read -p "请输入选项 (0-6): " choice
    else
        choice=$1
    fi
    
    case $choice in
        1) 
            backup_sources
            tsinghua_mirror
            update_apt
            ;;
        2)
            backup_sources
            aliyun_mirror
            update_apt
            ;;
        3)
            backup_sources
            ustc_mirror
            update_apt
            ;;
        4)
            backup_sources
            huawei_mirror
            update_apt
            ;;
        5)
            backup_sources
            tencent_mirror
            update_apt
            ;;
        6)
            backup_sources
            original_source
            update_apt
            ;;
        0)
            echo "退出"
            exit 0
            ;;
        *)
            echo "无效选项: $choice"
            exit 1
            ;;
    esac
    
    echo ""
    echo "当前源配置:"
    echo "----------------------------------------"
    cat /etc/apt/sources.list
    if [ -f /etc/apt/sources.list.d/raspi.list ]; then
        echo ""
        cat /etc/apt/sources.list.d/raspi.list
    fi
    echo "----------------------------------------"
    echo ""
    echo "提示: 可以使用 'sudo apt upgrade' 更新系统"
}

main "$@"
