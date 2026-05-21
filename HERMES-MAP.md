# ARS → Hermes 技能映射表

本仓库是 [Academic Research Skills (ARS) v3.9.4.2](https://github.com/Imbad0202/academic-research-skills) 的 Hermes Agent 适配分支。

ARS 是 Claude Code 生态的全链路学术研究工具包。本映射表说明每个 ARS 模块在 Hermes 生态中的对应关系和适配路径。

---

## 核心 Skill 映射

| ARS 模块 | agents | Hermes Skill | 对应已有 Skill | 状态 |
|----------|--------|-------------|---------------|------|
| `deep-research` | 13 | `ars-deep-research` | `arxiv`, `academic-paper-research-workflow`, `academic-research-stack-selection` | ✅ 已转换 |
| `academic-paper` | 12 | `ars-academic-paper` | — | ✅ 已转换 |
| `academic-paper-reviewer` | 7 | `ars-academic-paper-reviewer` | `thesis-introduction-peer-review`, `thesis-final-review` | ✅ 已转换 |
| `academic-pipeline` | 5 (orchestrator) | `ars-academic-pipeline` | `subagent-driven-development`, `obsidian-thesis-parallel-audit` | ✅ 已转换 |

---

## Agent → 已有 Hermes Skill 映射

### ars-deep-research (13 agents)

| ARS Agent | 对应 Hermes Skill | 适配方式 |
|-----------|------------------|---------|
| `research_question_agent` | — | 引用 `academic-paper-research-workflow` 的 RQ 构建流程 |
| `socratic_mentor_agent` | — | 苏格拉底引导模式，可封装为独立 Hermes skill |
| `research_architect_agent` | `academic-research-stack-selection` | 方法栈选择 |
| `bibliography_agent` | `arxiv`, `openalex (MCP)`, `semantic_scholar (MCP)` | MCP 工具直接替代 |
| `source_verification_agent` | `thesis-section-fact-check` | 引用验证 |
| `synthesis_agent` | — | 综合提炼，可复用 `obsidian-thesis-parallel-audit` 的并行子Agent模式 |
| `risk_of_bias_agent` | — | 偏倚风险评估（新逻辑） |
| `meta_analysis_agent` | — | 元分析（新逻辑） |
| `report_compiler_agent` | — | 报告编排（新逻辑） |
| `editor_in_chief_agent` | — | 主编审查（新逻辑） |
| `devils_advocate_agent` | — | 魔鬼代言人（含让步阈值协议，可对接答辩场景） |
| `ethics_review_agent` | — | 伦理审查（新逻辑） |
| `monitoring_agent` | — | 文献追踪（新逻辑） |

### ars-academic-paper (12 agents)

| ARS Agent | 对应 Hermes Skill | 适配方式 |
|-----------|------------------|---------|
| `intake_agent` | — | 需求采集（新逻辑） |
| `socratic_mentor_agent` | — | 苏格拉底规划（新逻辑） |
| `structure_architect_agent` | — | 论文结构设计（新逻辑） |
| `literature_strategist_agent` | — | 文献策略（新逻辑） |
| `argument_builder_agent` | — | 论证构建（新逻辑） |
| `draft_writer_agent` | — | 初稿撰写（新逻辑） |
| `peer_reviewer_agent` | `ars-academic-paper-reviewer` | 交叉引用 |
| `revision_coach_agent` | `thesis-interactive-batch-edit` | 修订教练 ↔ 批次式改写 |
| `citation_compliance_agent` | — | 引用格式合规（新逻辑） |
| `formatter_agent` | `thesis-chapter-md-to-docx`, `thesis-defense-ppt` | 格式输出 → 本地格式转换 |
| `visualization_agent` | `matplotlib-chinese-charts`, `mermaid-thesis-render`, `obsidian-arch-diagram-svg-png` | 图表生成 → 本地渲染 |
| `abstract_bilingual_agent` | — | 双语摘要（新逻辑） |

### ars-academic-paper-reviewer (7 agents)

| ARS Agent | 对应 Hermes Skill | 适配方式 |
|-----------|------------------|---------|
| `eic_agent` | — | 主编决策（新逻辑） |
| `field_analyst_agent` | — | 领域分析（新逻辑） |
| `methodology_reviewer_agent` | — | 方法论审查（新逻辑） |
| `domain_reviewer_agent` | — | 领域审查（新逻辑） |
| `perspective_reviewer_agent` | — | 交叉视角审查（新逻辑） |
| `devils_advocate_reviewer_agent` | — | 魔鬼代言人（含让步阈值协议） |
| `editorial_synthesizer_agent` | — | 编辑综合（新逻辑） |

### ars-academic-pipeline (5 agents)

| ARS Agent | 对应 Hermes Skill | 适配方式 |
|-----------|------------------|---------|
| `pipeline_orchestrator_agent` | — | 管线调度器（新逻辑） |
| `integrity_verification_agent` | — | 学术诚信验证（新逻辑，涵盖引用审计） |
| `claim_ref_alignment_audit_agent` | — | L3 主张对齐审计（新逻辑） |
| `collaboration_depth_agent` | — | 协作深度观察（新逻辑） |
| `state_tracker_agent` | — | 管线状态追踪（新逻辑） |

---

## 已有 Hermes Skill 覆盖的中国特色场景

| 场景 | 对应 Skill | 原始仓库无此能力 |
|------|-----------|----------------|
| **维普AIGC检测降重** | `anti-aigc-vip`, `anti-aigc-vip-rewrite` | ✅ 独有 |
| **法学论文事实风险清理** | `law-thesis-fact-risk-sanitization` | ✅ 独有 |
| **西南林业大学格式DOCX** | `thesis-chapter-md-to-docx` | ✅ 独有 |
| **答辩PPT生成** | `thesis-defense-ppt` | ✅ 独有 |
| **图表编号一致性** | `thesis-figure-table-renumber-consistency` | ✅ 独有 |
| **图表正文锚定检查** | `thesis-figure-text-anchoring` | ✅ 独有 |
| **代码插入（CS论文）** | `thesis-code-insertion` | ✅ 独有 |
| **非功能需求扩展** | `thesis-nonfunctional-req-expansion` | ✅ 独有 |
| **教科书式论文转型** | `thesis-textbook-to-research-law-cs` | ✅ 独有 |
| **论文最终审查 + 政策扫描** | `thesis-final-review`, `thesis-last-mile-frontier-sweep` | ✅ 独有 |
| **Obsidian 集成（同步/审计/重构）** | `obsidian-*` 系列 | ✅ 独有 |
| **Mermaid 图表渲染** | `mermaid-thesis-render` | ✅ 独有 |
| **中文 matplotlib 图表** | `matplotlib-chinese-charts` | ✅ 独有 |

---

## 管线集成架构（推荐）

```
用户入口
  │
  ├─ /ars-plan          → ars-deep-research（苏格拉底引导）
  ├─ /ars-write         → ars-academic-paper（论文撰写）
  ├─ /ars-review        → ars-academic-paper-reviewer（同行评审）
  ├─ /ars-pipeline      → ars-academic-pipeline（全流程）
  │
  └─ 中国论文专项（并行）
       ├─ 降重 → anti-aigc-vip
       ├─ 格式 → thesis-chapter-md-to-docx
       ├─ 图表 → matplotlib-chinese-charts / mermaid-thesis-render
       ├─ 代码 → thesis-code-insertion
       ├─ 答辩 → thesis-defense-ppt
       └─ 终审 → thesis-final-review
```

**推荐执行模式：**
- ARS 模块用 `delegate_task` 子Agent 模式执行（对标 `subagent-driven-development`）
- 中国论文专项用 Hermes skill 直接调用
- 全流程编排由 `ars-academic-pipeline` skill 负责调度

---

## 使用方式

### 在 Hermes 中安装 skill

```bash
# 从本仓库安装
ln -sf ~/academic-research-skills-hermes/hermes-skills/*.md ~/.hermes/skills/
```

### 按需加载

```
# 启动深度研究
hermes> 帮我研究一下 XXX 课题 /ars-plan

# 撰写论文
hermes> 帮我写一篇关于 XXX 的论文 /ars-write

# 审查论文
hermes> 审查这篇论文 /ars-review

# 启动全流程
hermes> 我要做一篇完整的研究论文 /ars-pipeline
```

---

## 维护说明

- ARS 上游更新时，`git fetch upstream` + `git merge` 同步
- `hermes-skills/` 中的文件需手动更新以匹配上游变化
- 每次合并后更新 `HERMES-CHANGELOG.md`
- 中国特色 skill 的更新不依赖于上游
