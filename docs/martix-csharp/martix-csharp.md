# Custom MartiX C# 14+ Skill

## Goal

Define the source strategy and planning inputs required to create a
high-quality `martix-csharp` skill focused on modern C# language guidance.

This folder should contain:

- [martix-csharp.prompt.md](./martix-csharp.prompt.md) to drive planning work.
- [martix-csharp-skill-plan.md](./martix-csharp-skill-plan.md) as the detailed
  implementation and research plan.

## Primary source set

Use these as mandatory high-priority inputs:

- C# documentation root:
  [dotnet/docs/csharp](https://github.com/dotnet/docs/tree/main/docs/csharp)
- C# table of contents:
  [dotnet/docs/csharp/toc.yml](https://github.com/dotnet/docs/blob/main/docs/csharp/toc.yml)
- C# version updates:
  - [What's new in C# 14](https://github.com/dotnet/docs/blob/main/docs/csharp/whats-new/csharp-14.md)
  - [What's new in C# 13](https://github.com/dotnet/docs/blob/main/docs/csharp/whats-new/csharp-13.md)
  - [What's new in C# 12](https://github.com/dotnet/docs/blob/main/docs/csharp/whats-new/csharp-12.md)
  - [C# version history](https://github.com/dotnet/docs/blob/main/docs/csharp/whats-new/csharp-version-history.md)
- Core language guidance sections:
  - [How-to index](https://github.com/dotnet/docs/blob/main/docs/csharp/how-to/index.md)
    and children
  - [Programming guide](https://github.com/dotnet/docs/tree/main/docs/csharp/programming-guide)
    and children

## Comparative source set

Collect and compare existing C#/.NET agent assets:

- [.NET Skills for Claude Code by Aaron Stannard](https://skills.sh/aaronontheweb/dotnet-skills)
- [Source repository for Aaron Stannard .NET Skills](https://github.com/aaronontheweb/dotnet-skills)
- [dotnet-10-csharp-14 skill pack](https://skills.sh/mhagrelius/dotfiles/dotnet-10-csharp-14)
- [Awesome Copilot C# .NET Development plugin](https://github.com/github/awesome-copilot/tree/main/plugins/csharp-dotnet-development)
- [C# Expert agent](https://github.com/github/awesome-copilot/blob/main/agents/csharp-expert.agent.md)
- [Expert .NET software engineer mode agent](https://github.com/github/awesome-copilot/blob/main/agents/expert-dotnet-software-engineer.agent.md)
- [C# instruction](https://github.com/github/awesome-copilot/blob/main/instructions/csharp.instructions.md)
- [Copilot SDK C# instruction](https://github.com/github/awesome-copilot/blob/main/instructions/copilot-sdk-csharp.instructions.md)
- [`csharp-async`](https://github.com/github/awesome-copilot/blob/main/skills/csharp-async/SKILL.md)
- [`csharp-docs`](https://github.com/github/awesome-copilot/blob/main/skills/csharp-docs/SKILL.md)
- [`csharp-mcp-server-generator`](https://github.com/github/awesome-copilot/blob/main/skills/csharp-mcp-server-generator/SKILL.md)
- [`csharp-mstest`](https://github.com/github/awesome-copilot/blob/main/skills/csharp-mstest/SKILL.md)
- [`csharp-nunit`](https://github.com/github/awesome-copilot/blob/main/skills/csharp-nunit/SKILL.md)
- [`csharp-tunit`](https://github.com/github/awesome-copilot/blob/main/skills/csharp-tunit/SKILL.md)
- [`csharp-xunit`](https://github.com/github/awesome-copilot/blob/main/skills/csharp-xunit/SKILL.md)
- [`dotnet-best-practices`](https://github.com/github/awesome-copilot/blob/main/skills/dotnet-best-practices-ensure/SKILL.md)
- [`dotnet-design-pattern-review`](https://github.com/github/awesome-copilot/blob/main/skills/dotnet-design-pattern-review/SKILL.md)

## Supporting references

- [Repository README](../README.md)
- [What's new in C# 14 (DomeTrain summary)](https://dometrain.com/blog/whats-new-in-csharp-14)
- [Claude Plugin Marketplaces](https://code.claude.com/docs/en/plugin-marketplaces)
- [Discover Plugins](https://code.claude.com/docs/en/discover-plugins)
- [Agent Skills Specification](http://agentskills.io/)
- [About CLI Plugins](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-cli-plugins)
- [Creating Plugins](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-creating)
- [CLI Plugin Reference](https://docs.github.com/en/copilot/reference/cli-plugin-reference)
- [Create Skills](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-skills)
- [Create Custom Agents for CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli)

## Planning workflow

1. Use C# docs TOC to identify MUST and SHOULD source pages.
2. Prioritize official language pages over community summaries.
3. Compare external skills/instructions to identify reusable patterns and gaps.
4. Capture all findings in `martix-csharp-skill-plan.md`.
5. Use `skill-creator` only after the plan is complete and internally reviewed.

## Scope for `martix-csharp`

- Focus on C# language features and C# coding best practices.
- Target C# 14+ while using C# 13 and C# 12 pages for migration context.
- Keep examples language-focused and framework-neutral where possible.

## Candidate skill content domains

- C# 14 syntax and modernization guidance.
- Async/await patterns and concurrency safety in pure C# code.
- API design and naming conventions for C# types and members.
- Nullability, immutability, and defensive coding.
- Testing strategy mapping for C# code (TUnit/xUnit/NUnit/MSTest).
- C# documentation quality (XML docs and public API clarity).

## Quality gates

- Avoid framework lock-in unless explicitly requested.
- Prefer language-level patterns over platform abstractions.
- Mark guidance as C#-only or framework-dependent when needed.
- Keep source citations for major recommendations.

## Non-goals

Do not center this skill on:

- .NET Framework migration or project-system specifics.
- ASP.NET Core endpoint architecture.
- Blazor, WinUI, MAUI, or UI framework implementation details.
- Containerization, deployment, CI/CD, or cloud hosting topics.
