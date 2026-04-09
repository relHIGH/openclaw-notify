#!/bin/bash
# 整点报时脚本 v1.1 - Hourly Chime
# 每小时整点播放报时声音和通知

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
AUDIO_FILE="$SKILL_DIR/assets/notification.aiff"
LOG_FILE="/tmp/hourly-chime.log"

# 获取当前时间
HOUR=$(date '+%H')
MINUTE=$(date '+%M')

# 记录日志
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# 如果是整点（00分）或强制测试模式
if [ "$MINUTE" = "00" ] || [ "$FORCE_CHIME" = "1" ]; then
    log_message "开始报时 - 当前时间: ${HOUR}:${MINUTE}"
    
    # 生成中文报时文本
    case $HOUR in
        00) TIME_TEXT="午夜十二点" ;;
        01) TIME_TEXT="凌晨一点" ;;
        02) TIME_TEXT="凌晨两点" ;;
        03) TIME_TEXT="凌晨三点" ;;
        04) TIME_TEXT="凌晨四点" ;;
        05) TIME_TEXT="凌晨五点" ;;
        06) TIME_TEXT="早上六点" ;;
        07) TIME_TEXT="早上七点" ;;
        08) TIME_TEXT="上午八点" ;;
        09) TIME_TEXT="上午九点" ;;
        10) TIME_TEXT="上午十点" ;;
        11) TIME_TEXT="上午十一点" ;;
        12) TIME_TEXT="中午十二点" ;;
        13) TIME_TEXT="下午一点" ;;
        14) TIME_TEXT="下午两点" ;;
        15) TIME_TEXT="下午三点" ;;
        16) TIME_TEXT="下午四点" ;;
        17) TIME_TEXT="下午五点" ;;
        18) TIME_TEXT="傍晚六点" ;;
        19) TIME_TEXT="晚上七点" ;;
        20) TIME_TEXT="晚上八点" ;;
        21) TIME_TEXT="晚上九点" ;;
        22) TIME_TEXT="晚上十点" ;;
        23) TIME_TEXT="晚上十一点" ;;
    esac
    
    # 播放提示音
    if [ -f "$AUDIO_FILE" ]; then
        if afplay "$AUDIO_FILE"; then
            log_message "提示音播放成功"
        else
            log_message "错误: 提示音播放失败"
        fi
    else
        log_message "警告: 音频文件不存在: $AUDIO_FILE"
    fi
    
    # 语音报时
    if say "现在${TIME_TEXT}"; then
        log_message "语音报时成功: 现在${TIME_TEXT}"
    else
        log_message "错误: 语音报时失败"
    fi
    
    # 显示通知
    if osascript -e "display notification \"现在${TIME_TEXT}\" with title \"整点报时\""; then
        log_message "通知显示成功"
    else
        log_message "错误: 通知显示失败"
    fi
    
    log_message "报时完成"
else
    # 非整点时不执行（但记录调试信息）
    if [ "$DEBUG_CHIME" = "1" ]; then
        log_message "调试: 非整点，跳过报时 (${HOUR}:${MINUTE})"
    fi
fi
