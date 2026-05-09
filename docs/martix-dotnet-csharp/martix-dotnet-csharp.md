# MartiX Dotnet C# (CSharp) Skills builder

## Tasks

- First review this task list if its possible to improve it, if yes, create a new *.prompt.md file with improved version for the planning phase
- Create the best in the world Agent Skill "martix-dotnet-csharp" focused on dotnet 10+ and C# 14+ including all the dotnet framework features
- DO NOT use any information from: docs/martix-csharp, src/plugins/martix-dotnet-library, src/plugins/martix-webapi
- DO NOT use automatically any other info from this repo, allways ask me if you can use it, as here are also some non related files for tish Skill
- MUST Follow the [Agent Skills](https://agentskills.io/) specification
- MUST Follow the [Vercel Labs Agent Skills / React Best Practices](https://github.com/vercel-labs/agent-skills/tree/main/skills/react-best-practices) structure and these most important files:
  - [AGENTS.md](https://github.com/vercel-labs/agent-skills/blob/main/AGENTS.md)
  - [skills/react-best-practices/AGENTS.md](https://github.com/vercel-labs/agent-skills/blob/main/skills/react-best-practices/AGENTS.md) — this is only React Skill inspiration for Dotnet / C# Skill
  - [skills/react-best-practices/README.md](https://github.com/vercel-labs/agent-skills/blob/main/skills/react-best-practices/README.md) — this readme can be used almost as is in "martix-dotnet-csharp" Skill
  - [skills/react-best-practices/SKILL.md](https://github.com/vercel-labs/agent-skills/blob/main/skills/react-best-practices/SKILL.md) — this is VERY IMPORTANT inspiration how the final structure and content of SKILL.md should look like
  - [skills/react-best-practices/rules/*.md](https://github.com/vercel-labs/agent-skills/blob/main/skills/react-best-practices/rules/*.md) — *.md files with specific topics linked from the SKILL.md
    - [skills/react-best-practices/rules/_sections.md](https://github.com/vercel-labs/agent-skills/blob/main/skills/react-best-practices/rules/_sections.md) — these are sections for React, it is only inspiration Dotnet / C# Skill
    - [skills/react-best-practices/rules/_template.md](https://github.com/vercel-labs/agent-skills/blob/main/skills/react-best-practices/rules/_template.md) — this template can be used as is in "martix-dotnet-csharp" Skill
- In the deep research phase read ALL the (I really mean the full
  documantation) C# and Dotnet docs (read ALL the markdowns referenced in
  [TOC](https://github.com/dotnet/docs/tree/main/docs/csharp/toc.yml) OR in
  local copy: `C:\Git\dotnet\docs\docs\csharp` if it's better for you to
  process it) to get very detailed info for our Skill => it will be very long
  list of tasks to process and the result will be the most complex c#/dotnet
  Agent Skill in the World
- Prepare a comprehensive plan with many tasks as there is lot of information resources to be processed which is too much for any LLM context window, so prepare very detailed plan with multiple phases and many tasks to achieve this, use Copilot Fleet subagents to work on this in parallell
- The result of research phase will be updated plan (or it can be a separate file, something like future-file-structure.md) which must contain all file names which will be created later in implementation phase, so we can approve it as a last step in planning phase
- My new Skill(s) must be created mainly for Copilot CLI, but optionally also for Claude Code, Codex and Open Code
- I NEED to be able to install the Skill as standalone Skill, so create it in src/skills folder and later reference it in plugin (which might have the same name) .github\plugin\marketplace.json
- There must be more options to install the Skill:
  - Using `npx skill add` syntax
  - Using `/plugin` slash command in Copilot CLI
- Use the .agents\skills\skill-creator skill to create the Skill(s), but you MUST follow all the best practices, structure and style defined above in vercel-labs Skills
- Add all important info to readme
- After the Skill is created, compare it to existing Agent Skills mentioned below in section "Existing Dotnet and/or C# Skills for comparison"
- Prepare a next plan if we can reuse anything usefull or missing from existing Skills to improve our newly created one

## Resources

### Agent Skills and Plugins docs

- [Agent Skills Specification](http://agentskills.io/)
- [Claude Plugin Marketplaces](https://code.claude.com/docs/en/plugin-marketplaces)
- [Discover Plugins](https://code.claude.com/docs/en/discover-plugins)
- [About CLI Plugins](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-cli-plugins)
- [Creating Plugins](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-creating)
- [CLI Plugin Reference](https://docs.github.com/en/copilot/reference/cli-plugin-reference)
- [Create Skills](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-skills)
- [Create Custom Agents for CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli)

### Existing Dotnet and/or C# Skills for comparison

Some of them are quite good, but not as good as I expect. So I need to create my own.

- C:\Git\mhagrelius\dotfiles\.claude\skills\dotnet-10-csharp-14 — this is THE BEST SKill I found, but I plan to create even better
- C:\Git\Aaronontheweb\dotnet-skills\skills — there is lot of skills, here are the best for comparison:
  - C:\Git\Aaronontheweb\dotnet-skills\skills\csharp-api-design
  - C:\Git\Aaronontheweb\dotnet-skills\skills\csharp-coding-standards
  - C:\Git\Aaronontheweb\dotnet-skills\skills\csharp-concurrency-patterns
  - C:\Git\Aaronontheweb\dotnet-skills\skills\csharp-type-design-performance
  - C:\Git\Aaronontheweb\dotnet-skills\skills\database-performance
  - C:\Git\Aaronontheweb\dotnet-skills\skills\efcore-patterns
  - C:\Git\Aaronontheweb\dotnet-skills\skills\playwright-blazor
- C:\Git\MartiXDev\awesome-copilot — there is lot of agents, skills, instructions, etc. these are the best for comparison:
  - C:\Git\MartiXDev\awesome-copilot\agents\CSharpExpert.agent.md
  - C:\Git\MartiXDev\awesome-copilot\agents\csharp-dotnet-janitor.agent.md
  - C:\Git\MartiXDev\awesome-copilot\instructions\aspnet-rest-apis.instructions.md
  - C:\Git\MartiXDev\awesome-copilot\instructions\blazor.instructions.md
  - C:\Git\MartiXDev\awesome-copilot\instructions\copilot-sdk-csharp.instructions.md
  - C:\Git\MartiXDev\awesome-copilot\instructions\csharp.instructions.md
  - C:\Git\MartiXDev\awesome-copilot\instructions\dotnet-architecture-good-practices.instructions.md
  - C:\Git\MartiXDev\awesome-copilot\instructions\dotnet-framework.instructions.md
  - C:\Git\MartiXDev\awesome-copilot\skills\aspnet-minimal-api-openapi
  - C:\Git\MartiXDev\awesome-copilot\skills\csharp-async
  - C:\Git\MartiXDev\awesome-copilot\skills\csharp-docs
  - C:\Git\MartiXDev\awesome-copilot\skills\csharp-tunit
  - C:\Git\MartiXDev\awesome-copilot\skills\dotnet-best-practices
  - C:\Git\MartiXDev\awesome-copilot\skills\dotnet-design-pattern-review
  - C:\Git\MartiXDev\awesome-copilot\skills\ef-core
