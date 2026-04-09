---
name: task-complete-notify
description: 任务完成通知系统，播放自定义提示音并显示系统通知。用于当任务执行完成后向用户发送声音和视觉提醒。支持 macOS 系统，使用 afplay 播放音频，osascript 显示通知。当需要通知用户任务已完成、需要确认或需要提醒时使用此 skill。
---

# 任务完成通知系统

## 功能

当任务完成后，通过声音和系统通知提醒用户。

## 使用方法

### 基本用法

运行通知脚本：

```bash
/Users/mbcc/.openclaw/skills/task-complete-notify/scripts/notify.sh "消息内容" "标题"
```

### 示例

```bash
# 使用默认消息
/Users/mbcc/.openclaw/skills/task-complete-notify/scripts/notify.sh

# 自定义消息
/Users/mbcc/.openclaw/skills/task-complete-notify/scripts/notify.sh "文件已保存" "完成"

# 自定义标题和消息
/Users/mbcc/.openclaw/skills/task-complete-notify/scripts/notify.sh "故事梗概已更新" "任务完成"
```

### 在 exec 中使用

```javascript
{
  "command": "/Users/mbcc/.openclaw/skills/task-complete-notify/scripts/notify.sh \"任务已完成\" \"OpenClaw\""
}
```

## 文件结构

```
task-complete-notify/
├── SKILL.md                    # 本文件
├── scripts/
│   └── notify.sh              # 通知脚本
└── assets/
    └── notification.aiff      # 自定义提示音
```

## 自定义提示音

如需更换提示音，替换 `assets/notification.aiff` 文件即可。支持格式：
- AIFF (.aiff)
- MP3 (.mp3)
- WAV (.wav)
- M4A (.m4a)

## 故障排除

如果听不到声音：
1. 检查系统音量
2. 确认音频文件存在：`ls assets/notification.aiff`
3. 测试脚本：`./scripts/notify.sh "测试"`

如果脚本无法执行：
```bash
chmod +x /Users/mbcc/.openclaw/skills/task-complete-notify/scripts/notify.sh
```
