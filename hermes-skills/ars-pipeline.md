---
name: ars-pipeline
category: academic-research
description: "Academic Research Pipeline orchestrator. Entry point for full academic workflow: research → write → integrity check → review → revise → finalize. Chains ars-deep-research, ars-academic-paper, ars-academic-paper-reviewer via Hermes delegate_task subagents. Integrates Chinese thesis skills (降重/格式/答辩/事实核查) as pipeline phases. Trigger: full paper workflow, end-to-end paper, research-to-publication, complete paper workflow, ars-pipeline, pipeline, 论文管线, 全流程论文, 完整论文流程."
---

# ARS Pipeline Orchestrator — 全流程学术论文管线

本 skill 是 **ARS 全流程管线**的 Hermes Agent 编排入口。当用户提出学术论文需求时，按以下流程执行。

## 管线结构

```
入口：用户需求
  │
  ├─ Phase 0: 需求评估
  │   确定用户处于哪个阶段（新项目 / 已有研究 / 已有初稿 / 收到审稿意见）
  │
  ├─ Phase 1: 文献研究 ────────────  ars-deep-research + MCP学术搜索
  │   子Agent: research_architect | bibliography | source_verification | synthesis
  │
  ├─ Phase 2: 论文撰写 ────────────  ars-academic-paper + 本地格式skill
  │   子Agent: structure_architect | draft_writer | citation_compliance | formatter
  │   ├─ CS论文阶段 → thesis-code-insertion（代码插入）
  │   ├─ 法学论文 → law-thesis-fact-risk-sanitization（事实风险）
  │   └─ 格式输出 → thesis-chapter-md-to-docx / ars-academic-paper（LaTeX）
  │
  ├─ Phase 2.5: 学术诚信验证 ──────  (强制闸门，不可跳过)
  │   引用审计 + 数据溯源 + Anti-AIGC
  │   ├─ 引用核查 → thesis-section-fact-check + thesis-figure-table-renumber-consistency
  │   ├─ 降重 → anti-aigc-vip / anti-aigc-vip-rewrite
  │   └─ 图表锚定 → thesis-figure-text-anchoring
  │
  ├─ Phase 3: 同行评审 ────────────  ars-academic-paper-reviewer
  │   子Agent: EIC + 3 Reviewers + Devil's Advocate
  │   ├─ 引言专项 → thesis-introduction-peer-review
  │   └─ 最终审查 → thesis-final-review + thesis-last-mile-frontier-sweep
  │
  ├─ Phase 4: 修订 ────────────────  ars-academic-paper (revision mode)
  │   子Agent: revision_coach | draft_writer
  │   ├─ 批量改写 → thesis-interactive-batch-edit
  │   └─ 章节重构 → obsidian-thesis-chapter-pivot-rewrite
  │
  ├─ Phase 4.5: 最终诚信验证 ──────  (强制闸门)
  │   回归检查：引用、格式、AIGC率
  │
  ├─ Phase 5: 终稿输出
  │   ├─ 答辩 → thesis-defense-ppt（PPT + 演讲稿 + Q&A）
  │   ├─ 图表 → matplotlib-chinese-charts + mermaid-thesis-render + obsidian-arch-diagram-svg-png
  │   └─ 存档 → obsidian-thesis-reference-library-unification
  │
  └─ Phase 6: 过程记录
```

## 执行模式

### 模式 A: 全流程（用户无已有材料）

用户说 "我要写一篇论文" → 从 Phase 0 开始，全程串行。

**执行步骤：**
1. 加载 `ars-deep-research` skill
2. `delegate_task(goal="研究XXX课题", context=..., toolsets=["terminal","web"])` — 子Agent做文献研究
3. 加载 `ars-academic-paper` skill
4. `delegate_task(goal="撰写XXX论文", context=研究结果, toolsets=["terminal","web"])` — 子Agent写初稿
5. 根据论文类型（CS/法学），调用对应本地 skill
6. 加载 `ars-academic-paper-reviewer` skill
7. `delegate_task(goal="审查这篇论文", context=初稿, toolsets=["terminal","web"])` — 子Agent做同行评审模拟
8. 整合审稿意见，指导用户修订
9. 最终输出

### 模式 B: 中间进入（用户已有材料）

| 用户场景 | 入口 Phase | 加载的 skill |
|---------|-----------|-------------|
| 已有研究，需要写论文 | Phase 2 | `ars-academic-paper` |
| 已有初稿，需要审查 | Phase 2.5 → 3 | `thesis-section-fact-check` → `ars-academic-paper-reviewer` |
| 收到审稿意见 | Phase 4 | `ars-academic-paper` (revision mode) + `thesis-interactive-batch-edit` |
| 需要答辩 | Phase 5 | `thesis-defense-ppt` |
| 论文最后冲刺 | Phase 4.5 → 5 | `thesis-final-review` + 各产出 skill |

### 模式 C: 单 skill 调用（用户明确指定）

用户说 "帮我查一下XXX课题" → 仅加载 `ars-deep-research`
用户说 "审查这篇论文" → 仅加载 `ars-academic-paper-reviewer`
用户说 "帮我降重" → 仅加载 `anti-aigc-vip-rewrite`

## delegate_task 子Agent 编排规范

当需要多Agent协作时，用以下模式：

**并行子Agent（独立任务）：**
```
delegate_task(tasks=[
  {"goal": "研究A方向", "context": "...", "toolsets": ["terminal","web"]},
  {"goal": "研究B方向", "context": "...", "toolsets": ["terminal","web"]}
])
```

**串行管道（有依赖）：**
```
# Step 1: 文献研究
result1 = delegate_task(goal="文献回顾", ...)
# Step 2: 基于研究结果写论文
result2 = delegate_task(goal="撰写论文", context=result1, ...)
# Step 3: 审查
result3 = delegate_task(goal="审查", context=result2, ...)
```

**混合（并行研究 → 串行写作 → 并行审查）：**
```
# 并行研究
research_results = delegate_task(tasks=[研究A, 研究B, 研究C])
# 串行写作
draft = delegate_task(goal="综合撰写", context=research_results)
# 并行审查
review_results = delegate_task(tasks=[方法论审查, 领域审查, 魔鬼代言人])
```

## 与现有中国论文 skill 集成

以下 skill 作为管线中的"中国论文专项"插入点：

| 阶段 | 插入点 | 对应 skill | 触发条件 |
|------|--------|-----------|---------|
| 写作 | 初稿完成后 | `thesis-code-insertion` | CS论文，有真实代码 |
| 写作 | 初稿完成后 | `law-thesis-fact-risk-sanitization` | 法学论文，涉及政策/法规 |
| 诚信 | 引用审计 | `thesis-section-fact-check` | 论文章节内容需验证 |
| 诚信 | 格式检查 | `thesis-figure-table-renumber-consistency` | 图表编号需一致 |
| 诚信 | AIGC检测 | `anti-aigc-vip-rewrite` | 需要降维普AIGC检测率 |
| 诚信 | 图表锚定 | `thesis-figure-text-anchoring` | 图表与正文对应关系 |
| 评审 | 引言审查 | `thesis-introduction-peer-review` | 引言章节质量检查 |
| 评审 | 最终审查 | `thesis-final-review` | 论文最后阶段 |
| 输出 | 格式转换 | `thesis-chapter-md-to-docx` | 需要西南林业大学格式DOCX |
| 输出 | 图表渲染 | `matplotlib-chinese-charts` + `mermaid-thesis-render` | 中文图表 |
| 输出 | 答辩准备 | `thesis-defense-ppt` | 需要答辩PPT |
| 输出 | 参考文献 | `obsidian-thesis-reference-library-unification` | 引用库整理 |

## 实例：CS论文全流程

当用户说 "我要写一篇CS论文" 时：

```
Phase 0: 评估 → "CS论文，无现有材料，从头开始"

Phase 1: ars-deep-research → delegate_task 做文献研究
Phase 2: ars-academic-paper → delegate_task 写初稿
         → thesis-code-insertion 插入真实代码（用户决定）
Phase 2.5: thesis-section-fact-check 验证章节
         → thesis-figure-table-renumber-consistency 统一编号
Phase 3: ars-academic-paper-reviewer → 模拟同行评审
Phase 4: 用户根据审稿意见修订
Phase 4.5: anti-aigc-vip 降重（如需）
         → thesis-figure-text-anchoring 锚定检查
Phase 5: thesis-chapter-md-to-docx 输出DOCX
         → matplotlib-chinese-charts + mermaid-thesis-render 最终图表
         → thesis-defense-ppt 答辩准备
Phase 6: obsidian-thesis-reference-library-unification 存档
```

## 实例：法学论文全流程

当用户说 "我要写一篇法学论文" 时：

```
Phase 1: ars-deep-research → 法律文献研究（MCP openalex/semantic scholar）
Phase 2: ars-academic-paper → 初稿
         → law-thesis-fact-risk-sanitization 清理不可核实事实断言
Phase 2.5: thesis-section-fact-check 验证
         → anti-aigc-vip-rewrite 降重
Phase 3: ars-academic-paper-reviewer → 审查
         → thesis-introduction-peer-review 引言专项
Phase 4: thesis-interactive-batch-edit 批量改写
Phase 5: thesis-final-review 终审
         → thesis-defense-ppt 答辩
```

## 注意

- **引用审计不可跳过** — 这是 ARS v3.8 的核心教训（Zhao et al. 2026 发现2025年单年就有146,932个虚构引用）
- **不要编造代码/功能** — `thesis-code-insertion` 使用真实系统代码，适度简化但不编造
- **降重后再做最终格式输出** — 避免重复工作
- **Phase 2.5 和 4.5 是强制闸门** — 除非用户明确跳过，否则不可省略
