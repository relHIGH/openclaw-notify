---
name: task-complete-notify
description: 任务完成通知系统，播放自定义提示音并显示系统通知。支持整点报时功能（可选，基于 macOS cron）。用于当任务执行完成后向用户发送声音和视觉提醒。支持 macOS 系统，使用 afplay 播放音频，osascript 显示通知。当需要通知用户任务已完成、需要确认或需要提醒时使用此 skill。
---

# 任务完成通知系统

## 功能

1. **任务完成通知** - 当任务完成后，通过声音和系统通知提醒用户
2. **整点报时**（可选）- 每小时整点自动语音报时（基于 macOS cron）

---

## 任务完成通知

### 基本用法

运行通知脚本：

```bash
/Users/Shared/OpenClaw/skills/task-complete-notify/scripts/notify.sh "消息内容" "标题"
```

### 示例

```bash
# 使用默认消息
/Users/Shared/OpenClaw/skills/task-complete-notify/scripts/notify.sh

# 自定义消息
/Users/Shared/OpenClaw/skills/task-complete-notify/scripts/notify.sh "文件已保存" "完成"

# 自定义标题和消息
/Users/Shared/OpenClaw/skills/task-complete-notify/scripts/notify.sh "故事梗概已更新" "任务完成"
```

---

## 整点报时功能

### 功能说明

每小时整点自动播放提示音，并用中文语音播报当前时间（如"现在上午九点"）。

**依赖**: macOS 原生 cron（crontab）

### 控制命令

```bash
# 查看状态
/Users/Shared/OpenClaw/skills/task-complete-notify/scripts/chime-control.sh status

# 启用整点报时
/Users/Shared/OpenClaw/skills/task-complete-notify/scripts/chime-control.sh enable

# 禁用整点报时
/Users/Shared/OpenClaw/skills/task-complete-notify/scripts/chime-control.sh disable

# 立即测试
/Users/Shared/OpenClaw/skills/task-complete-notify/scripts/chime-control.sh test

# 查看日志
/Users/Shared/OpenClaw/skills/task-complete-notify/scripts/chime-control.sh logs
```

### 报时时段用语

| 时间 | 用语 |
|------|------|
| 00:00 | 午夜十二点 |
| 01-05 | 凌晨一点~五点 |
| 06-07 | 早上六点~七点 |
| 08-11 | 上午八点~十一点 |
| 12:00 | 中午十二点 |
| 13-17 | 下午一点~五点 |
| 18 | 傍晚六点 |
| 19-23 | 晚上七点~十一点 |

---

## 文件结构

```
task-complete-notify/
├── SKILL.md                    # 本文件
├── scripts/
│   ├── notify.sh              # 任务完成通知脚本
│   ├── hourly-chime.sh        # 整点报时脚本（带日志）
│   └── chime-control.sh       # 整点报时控制脚本
└── assets/
    └── notification.aiff      # 自定义提示音
```

---

## 自定义提示音

如需更换提示音，替换 `assets/notification.aiff` 文件即可。支持格式：
- AIFF (.aiff)
- MP3 (.mp3)
- WAV (.wav)
- M4A (.m4a)

---

## 故障排除

### 听不到声音
1. 检查系统音量
2. 确认音频文件存在：`ls assets/notification.aiff`
3. 测试脚本：`./scripts/notify.sh "测试"`

### 整点报时不工作

**检查状态**：
```bash
./scripts/chime-control.sh status
```

**测试功能**：
```bash
./scripts/chime-control.sh test
```

**查看日志**：
```bash
./scripts/chime-control.sh logs
cat /tmp/hourly-chime.log
```

**常见问题**：

1. **crontab 未启用**:
   ```bash
   # 检查系统 cron 服务
   sudo launchctl list | grep cron
   ```

2. **权限问题**:
   ```bash
   # 确保脚本可执行
   chmod +x scripts/*.sh
   ```

3. **通知权限**:
   - 系统设置 > 通知 > 脚本权限

### 脚本无法执行
```bash
chmod +x /Users/Shared/OpenClaw/skills/task-complete-notify/scripts/*.sh
```

---

## 更新历史

- **v1.0**: 初始版本 - 任务完成通知
- **v1.1**: 新增整点报时功能（基于 macOS cron，带日志和调试）
