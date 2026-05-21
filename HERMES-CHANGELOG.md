# Hermes Adaptation Changelog

追踪本 fork 相对于上游 [Imbad0202/academic-research-skills](https://github.com/Imbad0202/academic-research-skills) 的自定义改动。

---

## v3.9.4.2-h2 (2026-05-21)

### 新增

#### `hermes-skills/ars-pipeline.md` — 管线编排器
Hermes 原生的全流程学术论文管线 skill，提供三种执行模式：
- **模式 A: 全流程** — Phase 0→6，从零开始
- **模式 B: 中间进入** — 根据用户已有材料跳转到对应 phase
- **模式 C: 单 skill** — 明确指定某个 ARS 模块

集成规范：通过 `delegate_task` 子Agent模式编排多Agent协作（并行/串行/混合）

#### `hermes-skills/` 安装到 Hermes
所有 5 个 skill 文件（4 ARS + 1 pipeline orchestrator）已通过 symlink 安装到 `~/.hermes/skills/`

#### `setup.sh` — 一键安装脚本
```bash
./setup.sh          # symlink 模式（默认，推荐）
./setup.sh --copy   # 复制模式（脱机用）
```

### 变更

#### HERMES-MAP.md 更新
- 新增 `ars-pipeline` 映射条目
- 补充管线集成架构的 `delegate_task` 编排规范
- 细化中国论文 skill 在各 phase 的插入点

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
- 管线编排逻辑已通过 `ars-pipeline` skill 实现（Hermes 侧用 `delegate_task` + 已有 skill）
- 编辑 `README.md` 添加 Hermes 使用说明
