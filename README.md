# 树莓派 ARM64 快速配置脚本集

适用于 64 位树莓派系统（Raspberry Pi OS / Ubuntu ARM64 / Debian ARM64）的快速安装和配置脚本。

## 📋 脚本清单

| 脚本 | 功能 | 说明 |
|------|------|------|
| `switch-mirror-arm64.sh` | 切换国内镜像源 | 支持 Ubuntu/Debian/Raspbian，提供5种国内镜像选择 |
| `install-kimi-cli.sh` | 安装 Kimi CLI | Moonshot AI 的命令行工具 |
| `install-opencode.sh` | 安装 OpenCode | AI 编程助手，支持终端交互 |

## 🚀 快速开始

### 1. 下载脚本

```bash
git clone <仓库地址>
cd raspberrypi-scripts
```

### 2. 添加执行权限

```bash
chmod +x *.sh
```

### 3. 按顺序执行（推荐）

```bash
# 第一步：切换国内镜像源（加速后续安装）
./switch-mirror-arm64.sh

# 第二步：安装 AI 工具（按需选择）
./install-kimi-cli.sh
./install-opencode.sh
```

---

## 📖 详细说明

### switch-mirror-arm64.sh - 镜像源切换工具

自动检测系统类型（Ubuntu/Debian/Raspbian），切换为指定的国内镜像源，大幅提升 `apt` 下载速度。

#### 支持的镜像源

| 编号 | 镜像源 | 特点 |
|------|--------|------|
| 1 | 清华大学 | 速度快，推荐 |
| 2 | 阿里云 | 速度快，稳定 |
| 3 | 中科大 | 老牌镜像，可靠 |
| 4 | 华为云 | 企业级带宽 |
| 5 | 腾讯云 | 国内多节点 |
| 6 | 官方源 | 恢复默认 |

#### 使用方式

```bash
# 交互式选择
./switch-mirror-arm64.sh

# 快速切换（参数模式）
./switch-mirror-arm64.sh 1   # 切换清华源
./switch-mirror-arm64.sh 2   # 切换阿里云
```

#### 特性

- ✅ 自动备份原配置到 `/etc/apt/backup-<时间>/`
- ✅ 支持 Ubuntu ARM64 / Debian ARM64 / Raspberry Pi OS
- ✅ 自动处理树莓派专用源（`raspi.list`）
- ✅ 切换后自动执行 `apt update`

---

### install-kimi-cli.sh - Kimi CLI 安装脚本

一键安装 [Kimi CLI](https://github.com/moonshot-ai/kimi-cli) - Moonshot AI 的命令行交互工具。

#### 安装内容

- `uv` - 高性能 Python 包管理器
- `kimi-cli` - Kimi AI 命令行工具

#### 使用方式

```bash
./install-kimi-cli.sh
```

#### 安装后使用

```bash
# 首次使用需要配置 API Key
kimi configure

# 启动 Kimi
kimi

# 查看帮助
kimi --help
```

#### 注意事项

- 需要联网下载 `uv` 和 `kimi-cli`
- 脚本会自动配置 PATH 环境变量（写入 `~/.bashrc`）
- 安装完成后可能需要 `source ~/.bashrc` 或重新登录

---

### install-opencode.sh - OpenCode 安装脚本

一键安装 [OpenCode](https://opencode.ai/) - AI 编程助手，支持智能代码补全和终端对话。

#### 安装内容

- `Node.js 24 LTS`（如未安装或版本过低）
- `opencode-ai` - OpenCode CLI 工具

#### 使用方式

```bash
./install-opencode.sh
```

#### 安装后使用

```bash
# 启动 OpenCode
opencode

# 查看帮助
opencode --help

# 配置 API Key
opencode config
```

#### 注意事项

- 会自动安装/更新 Node.js 到 24 LTS 版本
- 如 npm 安装失败，脚本会自动尝试官方安装脚本
- 部分功能需要配置 API Key 才能使用

---

## 🖥️ 系统要求

| 项目 | 要求 |
|------|------|
| 架构 | ARM64 (aarch64) |
| 系统 | Raspberry Pi OS (64-bit) / Ubuntu ARM64 / Debian ARM64 |
| 网络 | 需要联网下载 |
| 权限 | 需要 sudo 权限（用于 apt/npm） |

### 查看系统架构

```bash
uname -m
# 输出应为: aarch64
```

## ⚠️ 常见问题

### Q: 执行脚本时提示 "Permission denied"
```bash
chmod +x *.sh
```

### Q: 切换镜像源后无法更新
可能是镜像源暂时不可用，尝试切换到其他镜像：
```bash
./switch-mirror-arm64.sh 2  # 尝试阿里云
```

### Q: kimi/opencode 命令未找到
重新加载 shell 配置：
```bash
source ~/.bashrc
```

### Q: 安装过程中网络超时
1. 先运行 `./switch-mirror-arm64.sh` 切换国内镜像
2. 检查网络连接
3. 重试安装

## 📝 更新日志

### 2024-02
- 初始版本发布
- 支持 5 种国内镜像源切换
- 集成 Kimi CLI 和 OpenCode 安装

## 🔗 相关链接

- [Kimi CLI GitHub](https://github.com/moonshot-ai/kimi-cli)
- [OpenCode 官网](https://opencode.ai/)
- [清华大学开源镜像站](https://mirrors.tuna.tsinghua.edu.cn/)
- [阿里云镜像站](https://developer.aliyun.com/mirror/)

## 📄 License

MIT License - 自由使用和修改

---

> 💡 **提示**: 建议在全新安装的系统上先运行 `switch-mirror-arm64.sh` 切换国内源，可大幅提升后续软件安装速度。
