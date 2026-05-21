# Hermes Adaptation Changelog

追踪本 fork 相对于上游 [Imbad0202/academic-research-skills](https://github.com/Imbad0202/academic-research-skills) 的自定义改动。

---

## v3.9.4.2-h1 (2026-05-21)

### Fork 创建
- Fork 自 `Imbad0202/academic-research-skills` v3.9.4.2
- 仓库更名为 `academic-research-skills-hermes`

### 已移除（Claude Code 专属）
- `.claude-plugin/` — Claude Code plugin 配置
- `.claude/` — Claude Code CLAUDE.md 和 CHANGELOG
- `commands/` — Claude Code 斜杠命令
- `hooks/` — Claude Code 钩子
- `tests/` 和 `conftest.py` — Claude Code 测试框架
- `.github/` — Claude Code CI/CD 配置
- `MODE_REGISTRY.md`, `POSITIONING.md` — Claude Code 特有
- `requirements-dev.txt` — Claude Code 依赖
- `README.ja-JP.md` — 非中文 locale

### 已转换（Hermes 格式）
- `deep-research/SKILL.md` → `hermes-skills/ars-deep-research.md`
- `academic-paper/SKILL.md` → `hermes-skills/ars-academic-paper.md`
- `academic-paper-reviewer/SKILL.md` → `hermes-skills/ars-academic-paper-reviewer.md`
- `academic-pipeline/SKILL.md` → `hermes-skills/ars-academic-pipeline.md`

**转换内容：** 前注（frontmatter）从 Claude Code 格式改为 Hermes 格式（`name`, `category`, `description`）。正文内容完全保留。

### 已添加
- `HERMES-MAP.md` — ARS 模块 ↔ 已有 Hermes Skill 完整映射表
- `hermes-skills/` — 转换后的 Hermes 格式 skill 文件

### 保留的原始内容
- `deep-research/`, `academic-paper/`, `academic-paper-reviewer/`, `academic-pipeline/` — 原始目录结构、agent 定义文件、references、templates
- `agents/` — 共享 agent definitions
- `shared/` — 共享协议和模式
- `scripts/` — 工具脚本
- `docs/` — 文档
- `examples/` — 示例
- `CHANGELOG.md`, `README.md`, `README.zh-CN.md` — 原版文档

### 尚未适配
- 所有 agent definition markdown 文件（`agents/*.md`）保持原样，作为 reference 使用
- 管线编排逻辑未改（Hermes 侧需用 `delegate_task` + 已有 skill 实现）
- 编辑 `README.md` 添加 Hermes 使用说明
