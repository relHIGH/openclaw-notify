#!/bin/bash
# 整点报时控制脚本 v1.1
# 使用 macOS 原生 cron 实现

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHIME_SCRIPT="$SCRIPT_DIR/hourly-chime.sh"
CRON_MARKER="# openclaw-hourly-chime"

show_help() {
    echo "整点报时控制"
    echo ""
    echo "用法: $0 [命令]"
    echo ""
    echo "命令:"
    echo "  enable    启用整点报时"
    echo "  disable   禁用整点报时"
    echo "  status    查看当前状态"
    echo "  test      立即测试报时"
    echo "  logs      查看最近报时日志"
    echo "  help      显示帮助"
}

enable_chime() {
    # 检查是否已存在
    if crontab -l 2>/dev/null | grep -q "$CRON_MARKER"; then
        echo "✅ 整点报时已启用"
        return 0
    fi
    
    # 添加到 crontab
    (crontab -l 2>/dev/null; echo "0 * * * * $CHIME_SCRIPT # $CRON_MARKER") | crontab -
    
    if [ $? -eq 0 ]; then
        echo "✅ 整点报时已启用"
        echo "每小时整点将自动报时"
        echo ""
        echo "📋 当前 crontab:"
        crontab -l | grep "$CRON_MARKER"
    else
        echo "❌ 启用失败，请检查 crontab 权限"
        return 1
    fi
}

disable_chime() {
    if ! crontab -l 2>/dev/null | grep -q "$CRON_MARKER"; then
        echo "⛔ 整点报时已是禁用状态"
        return 0
    fi
    
    # 从 crontab 移除
    crontab -l 2>/dev/null | grep -v "$CRON_MARKER" | crontab -
    
    if [ $? -eq 0 ]; then
        echo "⛔ 整点报时已禁用"
    else
        echo "❌ 禁用失败"
        return 1
    fi
}

check_status() {
    if crontab -l 2>/dev/null | grep -q "$CRON_MARKER"; then
        echo "✅ 整点报时状态: 已启用"
        echo "📋 调度规则:"
        crontab -l | grep "$CRON_MARKER"
        echo ""
        echo "🔔 下次报时: 下一个整点"
    else
        echo "⛔ 整点报时状态: 已禁用"
        echo "💡 使用 '$0 enable' 启用"
    fi
}

test_chime() {
    echo "🧪 测试整点报时..."
    echo "提示: 将播放提示音并报出当前时间"
    echo ""
    
    # 强制运行（忽略分钟检查）
    export FORCE_CHIME=1
    bash "$CHIME_SCRIPT"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ 测试完成"
    else
        echo ""
        echo "❌ 测试失败，请检查脚本"
        return 1
    fi
}

show_logs() {
    echo "📋 整点报时最近记录:"
    echo "（注：报时脚本会记录执行日志到 /tmp/hourly-chime.log）"
    if [ -f /tmp/hourly-chime.log ]; then
        tail -10 /tmp/hourly-chime.log
    else
        echo "暂无日志记录"
    fi
}

# 检查依赖
check_deps() {
    if ! command -v crontab >/dev/null 2>&1; then
        echo "❌ 错误: crontab 命令不可用"
        exit 1
    fi
    
    if [ ! -f "$CHIME_SCRIPT" ]; then
        echo "❌ 错误: 报时脚本不存在: $CHIME_SCRIPT"
        exit 1
    fi
}

# 主逻辑
check_deps

case "${1:-status}" in
    enable)
        enable_chime
        ;;
    disable)
        disable_chime
        ;;
    status)
        check_status
        ;;
    test)
        test_chime
        ;;
    logs)
        show_logs
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "未知命令: $1"
        show_help
        exit 1
        ;;
esac
