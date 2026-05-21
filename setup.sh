#!/bin/bash
# setup.sh — 一键安装 ARS Hermes skills
# 用法: ./setup.sh [--symlink|--copy]

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
HERMES_SKILLS_DIR="$HOME/.hermes/skills"
MODE="${1:---symlink}"

echo "📦 ARS Hermes 技能安装脚本"
echo "=========================="
echo "仓库: $REPO_DIR"
echo "目标: $HERMES_SKILLS_DIR"
echo "模式: $MODE"
echo ""

# 确保目标目录存在
mkdir -p "$HERMES_SKILLS_DIR"

# 安装技能
SKILLS=(
  "ars-deep-research.md"
  "ars-academic-paper.md"
  "ars-academic-paper-reviewer.md"
  "ars-academic-pipeline.md"
  "ars-pipeline.md"
)

INSTALLED=0
for skill in "${SKILLS[@]}"; do
  src="$REPO_DIR/hermes-skills/$skill"
  dst="$HERMES_SKILLS_DIR/$skill"
  
  if [ ! -f "$src" ]; then
    echo "⚠️  跳过: $skill (未找到)"
    continue
  fi
  
  if [ "$MODE" = "--copy" ]; then
    cp "$src" "$dst"
    echo "✅ 复制: $skill"
  else
    ln -sf "$src" "$dst"
    echo "✅ 链接: $skill"
  fi
  INSTALLED=$((INSTALLED + 1))
done

echo ""
echo "📊 已安装 $INSTALLED/${#SKILLS[@]} 个技能"
echo ""
echo "💡 使用方式:"
echo "   在 Hermes 中加载 skill 后使用:"
echo "   \"用 ars-pipeline 我要写一篇论文\"  — 全流程"
echo "   \"用 ars-deep-research 帮我研究XX\"  — 文献研究"
echo "   \"用 ars-academic-paper 写论文\"     — 论文撰写"
echo "   \"用 ars-academic-paper-reviewer 审查\" — 同行评审"
echo ""
echo "🔗 详细映射: $REPO_DIR/HERMES-MAP.md"
echo "📝 更新日志: $REPO_DIR/HERMES-CHANGELOG.md"
