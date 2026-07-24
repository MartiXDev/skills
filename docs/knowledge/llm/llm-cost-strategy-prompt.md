/research Optimize LLM selection for cost-effective coding workflow

> Note: LLM routing and some other Markdown docs in this Skills repo may be slightly outdated; a refactor and update are planned soon.
>
> **Important:** Create a **new, independent research output** using **GPT-5.6 Sol** so it can be compared later with other research outputs.
>
> **Hard constraint:** **Do not use, summarize, copy, or rely on any information** from `docs/knowledge/llm-cost-strategy-by-sonnet-5.md` (or any previous research file). Re-research all findings from primary/current sources.

## Objective

Create a tiered LLM strategy for coding/agentic tasks balancing quality and cost (cost is priority).

## Available Models (Copilot Max subscription)

- Claude: Haiku 4.5, Opus 4.6, Sonnet 4.6, Sonnet 5
- Gemini: 3 Flash, 3.1 Pro, 3.6 Flash
- GPT-5: mini, 5.3-Codex, 5.4, 5.4 mini, 5.4 nano, 5.6 Luna, 5.6 Terra
- Others: Kimi K2.7 Code, MAI-Code-1-Flash, Raptor mini
- Local option: Ollama (qwen, ornith) - must fit ~9B, max 35B

## Hardware Constraints

- CPU: Intel Core i7-8750H
- RAM: 32 GB
- GPU: NVIDIA Quadro P1000 (4 GB)

## Tech Stack

- Dotnet 10+, C#, Blazor, React, Vue.js, TypeScript, Fluent UI
- Secondary: PowerShell, SharePoint Server, SharePoint Online, Microsoft 365, Power Platform, Power Automate
- Custom MartiXDev/Skills (improves cheaper model performance)
- Possible future Prompt(s)/Skill(s)/Plugin(s)/etc. recommended by this research

## Key Questions to Answer

1. **Model ranking** by cost/performance ratio for: planning, implementation, code review
2. **Workflow optimization**: Single orchestrator LLM + /fleet subagents vs Matt Pocock's Sandcastle approach
3. **Local LLM viability**: Best options for 32GB/P1000 hardware
4. **Hardware upgrade ROI**: Recommend new config if justified for cost savings

## Matt Pocock Skills Usage

- /wayfinder, /grill-with-docs, /research, /to-spec, /to-tickets
- Comparing: Sandcastle orchestration vs CLI/desktop /fleet approach

## Resources

- <https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing>
- <https://artificialanalysis.ai/>
- <https://livebench.ai/>
- <https://llm-stats.com/>
- <https://benchlm.ai/>
- <https://whatllm.org/>
- <https://ollama.com/search>

## Deliverable

Tiered strategy: when/why/what model for planning, implementation, review - optimized for minimum cost with acceptable quality.

Also include a short section titled **"Comparison Readiness"** confirming this report was produced independently by **GPT-5.6 Sol** and is ready for side-by-side comparison with other future research outputs.
