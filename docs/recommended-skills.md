# Recommended AI/Copilot Skills and Plugin Ecosystem

This page is my curated shortlist of AI/Copilot plugin and skill resources I
use most often for day-to-day development.

## Document status

- **Last updated:** 2026-03-25
- **Maintained by:** MartiXDev
- **Scope:** Favorite AI/Copilot plugins, agents, skills, instructions, and prompts

## Core resources I recommend first

- [skills.sh registry (installable reusable capabilities)](https://skills.sh/)
- [Awesome Copilot (community collection of agents, prompts, and instructions)](https://github.com/github/awesome-copilot)
- [Claude Skills library (browse installable skills)](https://mcpservers.org/claude-skills)
- [Anthropic Skills repository (official examples and file workflows)](https://github.com/anthropics/skills/)
- [OpenAI Skills repository (official skill patterns)](https://github.com/openai/skills)
- [MCP Market](https://mcpmarket.com/tools/skills/leaderboard)
- [Agent Skills specification (open skill format)](https://agentskills.io/)

## The best .NET and C# skill packs

- [.NET Skills for Claude Code by Aaron Stannard](https://skills.sh/aaronontheweb/dotnet-skills) — csharp-coding-standards,
  efcore-patterns, csharp-concurrency-patterns, project-structure,
  database-performance, playwright-blazor,
  csharp-type-design-performance, csharp-api-design,
  microsoft-extensions-configuration,
  microsoft-extensions-dependency-injection, local-tools, serialization,
  package-management, testcontainers, mjml-email-templates,
  crap-analysis, slopwatch, akka-best-practices, akka-testing-patterns,
  snapshot-testing, aspire-integration-testing, aspire-service-defaults,
  akka-management, akka-hosting-actor-patterns,
  akka-aspire-configuration, skills-index-snippets,
  marketplace-publishing, ilspy-decompile, playwright-ci-caching,
  aspire-mailpit-integration, verify-email-snapshots, aspire-configuration,
  dotnet-devcert-trust
  - **NEW picks:** `microsoft-extensions-dependency-injection`,
    `skills-index-snippets`, `marketplace-publishing`,
    `dotnet-devcert-trust`
  - [Source repository for Aaron Stannard .NET Skills](https://github.com/aaronontheweb/dotnet-skills)

  ```bash
  npx skills add https://github.com/aaronontheweb/dotnet-skills --skill csharp-coding-standards
  npx skills add https://github.com/aaronontheweb/dotnet-skills --skill efcore-patterns
  npx skills add https://github.com/aaronontheweb/dotnet-skills --skill csharp-concurrency-patterns
  npx skills add https://github.com/aaronontheweb/dotnet-skills --skill project-structure
  npx skills add https://github.com/aaronontheweb/dotnet-skills --skill database-performance
  # NEW picks:
  npx skills add https://github.com/aaronontheweb/dotnet-skills --skill marketplace-publishing
  npx skills add https://github.com/aaronontheweb/dotnet-skills --skill dotnet-devcert-trust

  ```

- [dotnet-10-csharp-14 skill pack](https://skills.sh/mhagrelius/dotfiles/dotnet-10-csharp-14)
  - **NEW** [working-with-aspire](https://github.com/mhagrelius/dotfiles/tree/main/.claude/skills/working-with-aspire) — .NET Aspire 13 guidance for distributed apps, polyglot services, service discovery, deployment, and debugging.

  ```bash
  npx skills add https://github.com/mhagrelius/dotfiles --skill dotnet-10-csharp-14
  # NEW:
  npx skills add https://github.com/mhagrelius/dotfiles --skill working-with-aspire
  ```

- [Awesome Copilot C# .NET Development plugin (reference only, not preferred)](https://github.com/github/awesome-copilot/tree/main/plugins/csharp-dotnet-development)

  ```bash
  npx skills add https://github.com/github/awesome-copilot --skill csharp-docs
  npx skills add https://github.com/github/awesome-copilot --skill csharp-tunit
  ```

## The best UI and frontend skills

- [Fluent UI Blazor skill](https://skills.sh/github/awesome-copilot/fluentui-blazor)

  `npx skills add https://github.com/github/awesome-copilot --skill fluentui-blazor`
- [Approved Skills collection including Fluent 2 design system references](https://github.com/fefogarcia/approved-skills)
- ❤️⭐ [Vercel Labs Agent Skills (frontend and React focused)](https://github.com/vercel-labs/agent-skills) — Vercel's official collection of agent skills
  - **NEW** [vercel-cli-with-tokens](https://github.com/vercel-labs/agent-skills/tree/main/skills/vercel-cli-with-tokens) — Deploy and manage Vercel projects with token-based CLI authentication.

  ```bash
  npx skills add https://github.com/vercel-labs/agent-skills --skill react-best-practices
  npx skills add https://github.com/vercel-labs/agent-skills --skill web-design-guidelines
  npx skills add https://github.com/vercel-labs/agent-skills --skill composition-patterns
  npx skills add https://github.com/vercel-labs/agent-skills --skill react-native-skills
  # OPTIONAL:
  npx skills add https://github.com/vercel-labs/agent-skills --skill deploy-to-vercel
  # NEW:
  npx skills add https://github.com/vercel-labs/agent-skills --skill vercel-cli-with-tokens
  ```

- ❤️⭐ [Vercel Labs Next Skills (Next.js focused)](https://github.com/vercel-labs/next-skills) —

  ```bash
  npx skills add https://github.com/vercel-labs/next-skills --skill next-best-practices
  npx skills add https://github.com/vercel-labs/next-skills --skill next-cache-components
  # OPTIONAL:
  npx skills add https://github.com/vercel-labs/next-skills --skill next-upgrade
  ```

- ❤️⭐ [Vercel Labs Agent Browser](https://github.com/vercel-labs/agent-browser) —

  `npx skills add https://github.com/vercel-labs/agent-browser --skill agent-browser`
- ❤️⭐ [Vercel Labs Find Skills](https://github.com/vercel-labs/skills) — The CLI for the open agent skills ecosystem => `npx skills`

  `npx skills add https://github.com/vercel-labs/skills --skill find-skills`

## Other favorite types of skills

### From Anthropic

- ❤️⭐ [frontend-design](https://skills.sh/anthropics/skills/frontend-design) — This skill guides creation of distinctive, production-grade frontend interfaces that avoid generic "AI slop" aesthetics. Implement real working code with exceptional attention to aesthetic details and creative choices.

  `npx skills add https://github.com/anthropics/skills --skill frontend-design`
- ❤️⭐ [skill-creator](https://skills.sh/anthropics/skills/skill-creator) — This skill helps design and scaffold new reusable skills with strong metadata, trigger phrases, and workflow structure.

  `npx skills add https://github.com/anthropics/skills --skill skill-creator`
- ⭐ [pdf](https://skills.sh/anthropics/skills/pdf) — This skill creates and edits PDF outputs for documentation workflows, including structured content and export-ready formatting.

  `npx skills add https://github.com/anthropics/skills --skill pdf`
- ⭐ [pptx](https://skills.sh/anthropics/skills/pptx) — This skill generates and updates PowerPoint presentations with slide-level structure, formatting, and content automation.

  `npx skills add https://github.com/anthropics/skills --skill pptx`
- ⭐ [docx](https://skills.sh/anthropics/skills/docx) — This skill builds and revises Word documents with consistent structure, headings, and reusable content patterns.

  `npx skills add https://github.com/anthropics/skills --skill docx`
- ⭐ [xlsx](https://skills.sh/anthropics/skills/xlsx) — This skill creates spreadsheet outputs with tabular organization, formulas, and report-ready data layouts.

  `npx skills add https://github.com/anthropics/skills --skill xlsx`
- ⭐ [webapp-testing](https://skills.sh/anthropics/skills/webapp-testing) — This skill runs browser-based checks for web apps, including interaction validation, screenshots, and debugging support.

  `npx skills add https://github.com/anthropics/skills --skill webapp-testing`
- [mcp-builder](https://skills.sh/anthropics/skills/mcp-builder) — This skill scaffolds and iterates MCP servers, tools, and integration patterns for agent-enabled workflows.

  `npx skills add https://github.com/anthropics/skills --skill mcp-builder`
- [canvas-design](https://skills.sh/anthropics/skills/canvas-design) — This skill helps produce visual layouts and design compositions using canvas-style workflows and reusable visual patterns.

  `npx skills add https://github.com/anthropics/skills --skill canvas-design`
- [doc-coauthoring](https://skills.sh/anthropics/skills/doc-coauthoring) — This skill supports collaborative document refinement, editing passes, and consistency checks across long-form content.

  `npx skills add https://github.com/anthropics/skills --skill doc-coauthoring`
- [algorithmic-art](https://skills.sh/anthropics/skills/algorithmic-art) — This skill generates algorithm-driven visual art concepts using repeatable prompt and composition techniques.

  `npx skills add https://github.com/anthropics/skills --skill algorithmic-art`
- [theme-factory](https://skills.sh/anthropics/skills/theme-factory) — This skill creates coherent visual themes, including color systems, typography direction, and style variants.

  `npx skills add https://github.com/anthropics/skills --skill theme-factory`
- [web-artifacts-builder](https://skills.sh/anthropics/skills/web-artifacts-builder) — This skill assembles web-ready artifacts and assets from prompts into practical outputs for demos or prototypes.

  `npx skills add https://github.com/anthropics/skills --skill web-artifacts-builder`
- [brand-guidelines](https://skills.sh/anthropics/skills/brand-guidelines) — This skill applies brand voice, tone, and visual rules to keep outputs consistent with Anthropic brand guidance.

  `npx skills add https://github.com/anthropics/skills --skill brand-guidelines`
- [internal-comms](https://skills.sh/anthropics/skills/internal-comms) — This skill drafts internal communication artifacts such as updates, announcements, and stakeholder-ready summaries.

  `npx skills add https://github.com/anthropics/skills --skill internal-comms`
- [slack-gif-creator](https://skills.sh/anthropics/skills/slack-gif-creator) — This skill generates short GIF-style assets for Slack communication and lightweight team engagement.

  `npx skills add https://github.com/anthropics/skills --skill slack-gif-creator`
- [claude-api](https://skills.sh/anthropics/skills/claude-api) — This skill supports integration workflows for the Claude API, including setup, request structure, and usage patterns.

  `npx skills add https://github.com/anthropics/skills --skill claude-api`

### From OpenAI

- [linear](https://skills.sh/openai/skills/linear) — This skill supports Linear-centric issue workflows, including planning, tracking, and execution updates.

  `npx skills add https://github.com/openai/skills --skill linear`
- [screenshot](https://skills.sh/openai/skills/screenshot) — This skill captures and manages screenshots for review, documentation, and debugging workflows.

  `npx skills add https://github.com/openai/skills --skill screenshot`
- ⭐ [figma-implement-design](https://skills.sh/openai/skills/figma-implement-design) — This skill translates Figma designs into implementation-ready UI tasks and coded outcomes.

  `npx skills add https://github.com/openai/skills --skill figma-implement-design`
- ⭐ [figma](https://skills.sh/openai/skills/figma) — This skill helps inspect and operationalize Figma artifacts for UI planning and build alignment.

  `npx skills add https://github.com/openai/skills --skill figma`
- **NEW** [figma-code-connect-components](https://github.com/openai/skills/tree/main/skills/.curated/figma-code-connect-components) — Connect Figma design components to code implementations using Code Connect mappings and codebase matching.

  `npx skills add https://github.com/openai/skills --skill figma-code-connect-components`
- ⭐ **NEW** [frontend-skill](https://github.com/openai/skills/tree/main/skills/.curated/frontend-skill) — Visually strong landing-page, website, app, prototype, demo, and game UI guidance focused on composition, hierarchy, and restrained motion.

  `npx skills add https://github.com/openai/skills --skill frontend-skill`
- ⭐ [spreadsheet](https://skills.sh/openai/skills/spreadsheet) — This skill creates and edits spreadsheet-style outputs for structured data analysis and reporting.

  `npx skills add https://github.com/openai/skills --skill spreadsheet`
- ⭐ [playwright](https://skills.sh/openai/skills/playwright) — This skill drives browser automation for web testing, interaction checks, and reproducible validation flows.

  `npx skills add https://github.com/openai/skills --skill playwright`
- **NEW** [playwright-interactive](https://github.com/openai/skills/tree/main/skills/.curated/playwright-interactive) — Persistent browser and Electron interaction through `js_repl` for fast iterative UI debugging.

  `npx skills add https://github.com/openai/skills --skill playwright-interactive`
- ⭐ [security-best-practices](https://skills.sh/openai/skills/security-best-practices) — This skill applies practical secure-coding and security review guidance across implementation workflows.

  `npx skills add https://github.com/openai/skills --skill security-best-practices`
- ⭐ [gh-address-comments](https://skills.sh/openai/skills/gh-address-comments) — This skill helps triage and resolve GitHub pull request comments in a structured, actionable way.

  `npx skills add https://github.com/openai/skills --skill gh-address-comments`
- ⭐ [gh-fix-ci](https://skills.sh/openai/skills/gh-fix-ci) — This skill focuses on diagnosing and fixing CI issues in GitHub workflows and build pipelines.

  `npx skills add https://github.com/openai/skills --skill gh-fix-ci`
- [jupyter-notebook](https://skills.sh/openai/skills/jupyter-notebook) — This skill supports Jupyter notebook workflows for analysis, experimentation, and reproducible documentation.

  `npx skills add https://github.com/openai/skills --skill jupyter-notebook`
- ⭐ [develop-web-game](https://skills.sh/openai/skills/develop-web-game) — This skill guides web-game implementation with gameplay loops, architecture, and iterative feature delivery.

  `npx skills add https://github.com/openai/skills --skill develop-web-game`
- ⭐ [skill-creator](https://skills.sh/openai/skills/skill-creator) — This skill helps define, scaffold, and refine new skills with reusable structure and clear triggers.

  `npx skills add https://github.com/openai/skills --skill skill-creator`
- ⭐ [imagegen](https://skills.sh/openai/skills/imagegen) — This skill supports image generation workflows for concepting, visual assets, and prompt-driven iterations.

  `npx skills add https://github.com/openai/skills --skill imagegen`
- [notion-research-documentation](https://skills.sh/openai/skills/notion-research-documentation) — This skill helps turn research notes into structured Notion documentation and knowledge pages.

  `npx skills add https://github.com/openai/skills --skill notion-research-documentation`
- ⭐ [pdf](https://skills.sh/openai/skills/pdf) — This skill creates and updates PDF documents for polished reports, summaries, and shareable deliverables.

  `npx skills add https://github.com/openai/skills --skill pdf`
- ⭐ [security-threat-model](https://skills.sh/openai/skills/security-threat-model) — This skill supports threat-model creation to identify risks, attack surfaces, and mitigation strategies.

  `npx skills add https://github.com/openai/skills --skill security-threat-model`
- ⭐ [openai-docs](https://skills.sh/openai/skills/openai-docs) — This skill helps navigate and apply OpenAI documentation accurately during implementation tasks.

  `npx skills add https://github.com/openai/skills --skill openai-docs`
- [skill-installer](https://skills.sh/openai/skills/skill-installer) — This skill streamlines installation and setup workflows for adding skills into a repository.

  `npx skills add https://github.com/openai/skills --skill skill-installer`
- [speech](https://skills.sh/openai/skills/speech) — This skill supports speech generation and speech-related UX scenarios across applications.

  `npx skills add https://github.com/openai/skills --skill speech`
- ⭐ [doc](https://skills.sh/openai/skills/doc) — This skill assists with structured document authoring, editing, and formatting workflows.

  `npx skills add https://github.com/openai/skills --skill doc`
- **NEW** [slides](https://github.com/openai/skills/tree/main/skills/.curated/slides) — Create and edit editable PowerPoint decks (`.pptx`) with layout helpers and validation utilities.

  `npx skills add https://github.com/openai/skills --skill slides`
- [vercel-deploy](https://skills.sh/openai/skills/vercel-deploy) — This skill guides deployment workflows for shipping apps to Vercel with practical checks.

  `npx skills add https://github.com/openai/skills --skill vercel-deploy`
- [netlify-deploy](https://skills.sh/openai/skills/netlify-deploy) — This skill helps deploy and verify applications on Netlify with consistent release steps.

  `npx skills add https://github.com/openai/skills --skill netlify-deploy`
- [transcribe](https://skills.sh/openai/skills/transcribe) — This skill supports transcription workflows for audio-to-text processing and downstream analysis.

  `npx skills add https://github.com/openai/skills --skill transcribe`
- [cloudflare-deploy](https://skills.sh/openai/skills/cloudflare-deploy) — This skill guides Cloudflare deployment workflows for edge-hosted and web delivery scenarios.

  `npx skills add https://github.com/openai/skills --skill cloudflare-deploy`
- [sora](https://skills.sh/openai/skills/sora) — This skill helps with Sora-oriented workflows for generating and iterating on video outputs.

  `npx skills add https://github.com/openai/skills --skill sora`
- [sentry](https://skills.sh/openai/skills/sentry) — This skill supports Sentry integration and error-monitoring workflows for production observability.

  `npx skills add https://github.com/openai/skills --skill sentry`
- [notion-spec-to-implementation](https://skills.sh/openai/skills/notion-spec-to-implementation) — This skill turns Notion specs into implementation plans and execution-ready tasks.

  `npx skills add https://github.com/openai/skills --skill notion-spec-to-implementation`
- [notion-knowledge-capture](https://skills.sh/openai/skills/notion-knowledge-capture) — This skill captures and organizes team knowledge into maintainable Notion artifacts.

  `npx skills add https://github.com/openai/skills --skill notion-knowledge-capture`
- [render-deploy](https://skills.sh/openai/skills/render-deploy) — This skill guides app deployment and verification flows for Render-hosted services.

  `npx skills add https://github.com/openai/skills --skill render-deploy`
- [yeet](https://skills.sh/openai/skills/yeet) — This skill provides a fast utility workflow for quick execution and shipping tasks.

  `npx skills add https://github.com/openai/skills --skill yeet`
- [security-ownership-map](https://skills.sh/openai/skills/security-ownership-map) — This skill maps security ownership across systems, teams, and control responsibilities.

  `npx skills add https://github.com/openai/skills --skill security-ownership-map`
- [notion-meeting-intelligence](https://skills.sh/openai/skills/notion-meeting-intelligence) — This skill converts meeting content into actionable Notion summaries, decisions, and follow-ups.

  `npx skills add https://github.com/openai/skills --skill notion-meeting-intelligence`
- [chatgpt-apps](https://skills.sh/openai/skills/chatgpt-apps) — This skill guides development workflows for building and shipping ChatGPT-integrated applications.

  `npx skills add https://github.com/openai/skills --skill chatgpt-apps`
- ⭐ [winui-app](https://skills.sh/openai/skills/winui-app) — This skill supports WinUI application development patterns for modern Windows desktop experiences.

  `npx skills add https://github.com/openai/skills --skill winui-app`
- ⭐ [aspnet-core](https://skills.sh/openai/skills/aspnet-core) — This skill helps implement and evolve ASP.NET Core applications using practical backend patterns.

  `npx skills add https://github.com/openai/skills --skill aspnet-core`

### From Awesome Copilot

#### 🔌 [Plugins](https://github.com/github/awesome-copilot/blob/main/docs/README.plugins.md)

- [awesome-copilot](https://github.com/github/awesome-copilot/tree/main/plugins/awesome-copilot)
  - Commands
    - `/awesome-copilot:suggest-awesome-github-copilot-collections`
    - `/awesome-copilot:suggest-awesome-github-copilot-instructions`
    - `/awesome-copilot:suggest-awesome-github-copilot-prompts`
    - `/awesome-copilot:suggest-awesome-github-copilot-agents`
    - `/awesome-copilot:suggest-awesome-github-copilot-skills`
  - Agents
    - `meta-agentic-project-scaffold`
- [azure-cloud-development](https://github.com/github/awesome-copilot/tree/main/plugins/azure-cloud-development)
  - Commands
    - `/azure-cloud-development:azure-resource-health-diagnose`
    - `/azure-cloud-development:az-cost-optimize`
  - Agents
    - `azure-principal-architect`
    - `azure-saas-architect`
    - `azure-logic-apps-expert`
    - `azure-verified-modules-bicep`
    - `azure-verified-modules-terraform`
    - `terraform-azure-planning`
    - `terraform-azure-implement`
- [context-engineering](https://github.com/github/awesome-copilot/tree/main/plugins/context-engineering)
  - Commands
    - `/context-engineering:context-map`
    - `/context-engineering:what-context-needed`
    - `/context-engineering:refactor-plan`
  - Agents
    - `context-architect`
- [csharp-dotnet-development](https://github.com/github/awesome-copilot/tree/main/plugins/csharp-dotnet-development)
  - Commands
    - ⭐ `/csharp-dotnet-development:csharp-async`
    - ⭐ `/csharp-dotnet-development:aspnet-minimal-api-openapi`
    - `/csharp-dotnet-development:csharp-xunit`
    - `/csharp-dotnet-development:csharp-nunit`
    - `/csharp-dotnet-development:csharp-mstest`
    - ⭐ `/csharp-dotnet-development:csharp-tunit`
    - ⭐ `/csharp-dotnet-development:dotnet-best-practices`
    - `/csharp-dotnet-development:dotnet-upgrade`
  - Agents
    - `expert-dotnet-software-engineer`
- [database-data-management](https://github.com/github/awesome-copilot/tree/main/plugins/database-data-management)
  - Commands
    - `/database-data-management:sql-optimization`
    - `/database-data-management:sql-code-review`
    - `/database-data-management:postgresql-optimization`
    - `/database-data-management:postgresql-code-review`
  - Agents
    - `postgresql-dba`
    - `ms-sql-dba`
- [frontend-web-dev](https://github.com/github/awesome-copilot/tree/main/plugins/frontend-web-dev)
  - Commands
    - `/frontend-web-dev:playwright-explore-website`
    - `/frontend-web-dev:playwright-generate-test`
  - Agents
    - `expert-react-frontend-engineer`
    - `electron-angular-native`
- [project-planning](https://github.com/github/awesome-copilot/tree/main/plugins/project-planning)
  - Commands
    - `/project-planning:breakdown-feature-implementation`
    - `/project-planning:breakdown-feature-prd`
    - `/project-planning:breakdown-epic-arch`
    - `/project-planning:breakdown-epic-pm`
    - `/project-planning:create-implementation-plan`
    - `/project-planning:update-implementation-plan`
    - `/project-planning:create-github-issues-feature-from-implementation-plan`
    - `/project-planning:create-technical-spike`
  - Agents
    - `task-planner`
    - `task-researcher`
    - `planner`
    - `plan`
    - `prd`
    - `implementation-plan`
    - `research-technical-spike`
- [security-best-practices](https://github.com/github/awesome-copilot/tree/main/plugins/security-best-practices)
  - Commands
    - `/security-best-practices:ai-prompt-engineering-safety-review`
- [software-engineering-team](https://github.com/github/awesome-copilot/tree/main/plugins/software-engineering-team)
  - Agents
    - `se-ux-ui-designer`
    - `se-technical-writer`
    - `se-gitops-ci-specialist`
    - `se-product-manager-advisor`
    - `se-responsible-ai-code`
    - `se-system-architecture-reviewer`
    - `se-security-reviewer`
- [testing-automation](https://github.com/github/awesome-copilot/tree/main/plugins/testing-automation)
  - Commands
    - `/testing-automation:playwright-explore-website`
    - `/testing-automation:playwright-generate-test`
    - `/testing-automation:csharp-nunit`
    - `/testing-automation:java-junit`
    - `/testing-automation:ai-prompt-engineering-safety-review`
  - Agents
    - `tdd-red`
    - `tdd-green`
    - `tdd-refactor`
    - `playwright-tester`

#### 🤖 [Agents](https://github.com/github/awesome-copilot/blob/main/docs/README.agents.md)

- **Accessibility Expert** ([accessibility.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/accessibility.agent.md)) — Expert assistant for web accessibility (WCAG 2.1/2.2), inclusive UX, and a11y testing.
- **API Architect** ([api-architect.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/api-architect.agent.md)) — API architecture mentor that provides practical guidance and working implementation patterns.
- **9x Azure* agents** ([azure agents collection](https://github.com/github/awesome-copilot/tree/main/agents)) — Curated Azure architecture and IaC agents for Well-Architected guidance, Logic Apps, and implementation workflows.
- **2x Bicep* agents** ([bicep agents collection](https://github.com/github/awesome-copilot/tree/main/agents)) — Bicep-focused planning and implementation agents for Azure IaC.
- **⭐ C# Expert** ([csharp-expert.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/csharp-expert.agent.md)) — .NET-focused engineering agent for C# development tasks.
- **Context Architect** ([context-architect.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/context-architect.agent.md)) — Plans and executes multi-file changes by identifying dependencies and required context.
- **Context7 Expert** ([context7-expert.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/context7-expert.agent.md)) — Uses up-to-date documentation and best practices for accurate framework guidance.
- **Create PRD Chat Mode** ([create-prd-chat-mode.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/create-prd-chat-mode.agent.md)) — Generates complete PRDs with stories, acceptance criteria, and technical considerations.
- **Custom Agent Foundry** ([custom-agent-foundry.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/custom-agent-foundry.agent.md)) — Designs and creates custom VS Code agents with strong defaults.
- **Debug Mode Instructions** ([debug-mode-instructions.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/debug-mode-instructions.agent.md)) — Dedicated bug-finding and fix guidance mode.
- **DevOps Expert** ([devops-expert.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/devops-expert.agent.md)) — DevOps specialist across plan, build, test, release, deploy, operate, and monitor phases.
- **⭐ Expert .NET software engineer mode instructions** ([expert-dotnet-software-engineer.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/expert-dotnet-software-engineer.agent.md)) — Expert .NET engineering guidance using modern design patterns.
- **⭐ Expert React Frontend Engineer** ([expert-react-frontend-engineer.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/expert-react-frontend-engineer.agent.md)) — React expert focused on modern hooks, TypeScript, and performance.
- **Expert Vue.js Frontend Engineer** ([expert-vuejs-frontend-engineer.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/expert-vuejs-frontend-engineer.agent.md)) — Vue 3 frontend expert for Composition API, state, testing, and performance.
- **GitHub Actions Expert** ([github-actions-expert.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/github-actions-expert.agent.md)) — Secure CI/CD specialist for GitHub Actions, OIDC, and least-privilege pipelines.
- **High Level Big Picture Architect (HLBPA)** ([high-level-big-picture-architect.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/high-level-big-picture-architect.agent.md)) — High-level architecture review and documentation assistant.
- **Implementation Plan Generation Mode** ([implementation-plan-generation-mode.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/implementation-plan-generation-mode.agent.md)) — Creates implementation plans for new features or refactors.
- **Lingo.dev Localization (i18n) Agent** ([lingodev-localization-agent.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/lingodev-localization-agent.agent.md)) — i18n implementation specialist with checklist-driven workflows.
- **Markdown Accessibility Assistant** ([markdown-accessibility-assistant.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/markdown-accessibility-assistant.agent.md)) — Improves markdown accessibility using GitHub accessibility best practices.
- **MAUI Expert** ([maui-expert.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/maui-expert.agent.md)) — Supports .NET MAUI development with controls, XAML, handlers, and performance patterns.
- **Microsoft Agent Framework .NET** ([microsoft-agent-framework-dotnet.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/microsoft-agent-framework-dotnet.agent.md)) — Builds and refactors code with Microsoft Agent Framework for .NET.
- **Modernization Agent** ([modernization-agent.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/modernization-agent.agent.md)) — Human-in-the-loop modernization planning and architecture analysis assistant.
- **Mongodb Performance Advisor** ([mongodb-performance-advisor.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/mongodb-performance-advisor.agent.md)) — Analyzes MongoDB performance and recommends query/index improvements.
- **MS SQL Database Administrator** ([ms-sql-database-administrator.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/ms-sql-database-administrator.agent.md)) — SQL Server database assistance via MS SQL tooling and best practices.
- **⭐ Next.js Expert** ([nextjs-expert.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/nextjs-expert.agent.md)) — Next.js App Router expert for modern React, caching, and performance.
- **OpenAPI to Application Generator** ([openapi-to-application-generator.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/openapi-to-application-generator.agent.md)) — Generates working applications from OpenAPI specifications.
- **Playwright Tester Mode** ([playwright-tester-mode.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/playwright-tester-mode.agent.md)) — Playwright-focused testing mode for E2E automation.
- **Playwright Tester Mode** ([playwright-tester-mode.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/playwright-tester-mode.agent.md)) — Playwright-focused testing mode for E2E automation.
- **4x Power BI agents** ([power-bi agents collection](https://github.com/github/awesome-copilot/tree/main/agents)) — Collection for Power BI data modeling, DAX, performance, and visualization.
- **2x Power Platform agents** ([power-platform agents collection](https://github.com/github/awesome-copilot/tree/main/agents)) — Collection for Power Platform app development and MCP connector integration.
- **Principal software engineer** ([principal-software-engineer.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/principal-software-engineer.agent.md)) — Principal-level engineering guidance for technical leadership and execution quality.
- **Prompt Builder** ([prompt-builder.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/prompt-builder.agent.md)) — Prompt engineering assistant for creating and validating high-quality prompts.
- **Prompt Engineer** ([prompt-engineer.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/prompt-engineer.agent.md)) — Prompt analysis and improvement mode based on structured prompt-engineering methods.
- **QA** ([qa.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/qa.agent.md)) — QA subagent for test planning, edge-case analysis, and implementation verification.
- **Repo Architect Agent** ([repo-architect-agent.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/repo-architect-agent.agent.md)) — Scaffolds and validates agentic repo structures for Copilot workflows.
- **RUG** ([rug.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/rug.agent.md)) — Orchestration agent that delegates tasks to subagents and validates outcomes.
- **Search & AI Optimization Expert** ([search-ai-optimization-expert.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/search-ai-optimization-expert.agent.md)) — SEO/AEO/GEO optimization expert for AI-ready content strategy.
- **Semantic Kernel .NET** ([semantic-kernel-dotnet.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/semantic-kernel-dotnet.agent.md)) — [Semantic Kernel](https://learn.microsoft.com/en-us/semantic-kernel/overview) is a lightweight, open-source development kit that lets you easily build AI agents and integrate the latest AI models into your C#, Python, or Java codebase. It serves as an efficient middleware that enables rapid delivery of enterprise-grade solutions.
- **Senior Cloud Architect** ([senior-cloud-architect.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/senior-cloud-architect.agent.md)) — Architecture expert for modern patterns, NFRs, and system-level design artifacts.
- **Software Engineer Agent** ([software-engineer-agent.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/software-engineer-agent.agent.md)) — Production-oriented software engineering agent with specification-driven execution.
- **Specification** ([specification.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/specification.agent.md)) — Generates or updates feature specifications for implementation.
- **SWE** ([swe.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/swe.agent.md)) — Senior software engineering subagent for coding, debugging, refactoring, and tests.
- **TDD Green Phase Make Tests Pass Quickly** ([tdd-green-phase-make-tests-pass-quickly.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/tdd-green-phase-make-tests-pass-quickly.agent.md)) — Implements the minimal code needed to pass failing tests.
- **TDD Red Phase Write Failing Tests First** ([tdd-red-phase-write-failing-tests-first.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/tdd-red-phase-write-failing-tests-first.agent.md)) — Drives test-first development by writing failing tests from requirements.
- **TDD Refactor Phase Improve Quality & Security** ([tdd-refactor-phase-improve-quality-security.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/tdd-refactor-phase-improve-quality-security.agent.md)) — Refactors for quality/security while preserving green tests.
- **Technical Content Evaluator** ([technical-content-evaluator.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/technical-content-evaluator.agent.md)) — Reviews technical learning content for accuracy, quality, and instructional clarity.
- **Technical Debt Remediation Plan** ([technical-debt-remediation-plan.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/technical-debt-remediation-plan.agent.md)) — Produces remediation plans for technical debt in code, tests, and docs.
- **3x Terra* agents** ([terraform agents collection](https://github.com/github/awesome-copilot/tree/main/agents)) — Terraform-focused agents for implementation, review, and module testing workflows.
- **WinForms Expert** ([winforms-expert.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/winforms-expert.agent.md)) — Guides development of .NET WinForms Designer-compatible applications.
- **WinUI 3 Expert** ([winui3-expert.agent.md](https://github.com/github/awesome-copilot/blob/main/agents/winui3-expert.agent.md)) — WinUI 3 and Windows App SDK expert for correct desktop patterns and API usage.

#### 📋 [Instructions](https://github.com/github/awesome-copilot/blob/main/docs/README.instructions.md)

- **.NET Framework Development** ([dotnet-framework.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/dotnet-framework.instructions.md)) — Guidance for .NET Framework projects, structure, language versioning, and NuGet practices (applyTo: `**/*.csproj, **/*.cs`).
- **.NET MAUI** ([dotnet-maui.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/dotnet-maui.instructions.md)) — .NET MAUI component and application patterns (applyTo: `**/*.xaml, **/*.cs`).
- **Accessibility instructions** ([a11y.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/a11y.instructions.md)) — Accessibility guidance for creating inclusive code and experiences (applyTo: `**`).
- **⭐ Agent Skills File Guidelines** ([agent-skills.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/agent-skills.instructions.md)) — Guidelines for high-quality GitHub Copilot Agent Skills files (applyTo: `**/.github/skills/**/SKILL.md, **/.claude/skills/**/SKILL.md`).
- **AI Prompt Engineering & Safety Best Practices** ([ai-prompt-engineering-safety-best-practices.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/ai-prompt-engineering-safety-best-practices.instructions.md)) — Best practices for prompt quality, safety, and responsible AI usage (applyTo: `*`).
- **⭐ ASP.NET REST API Development** ([aspnet-rest-apis.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/aspnet-rest-apis.instructions.md)) — Guidance for building REST APIs with ASP.NET (applyTo: `**/*.cs, **/*.json`).
- **Azure DevOps Pipeline YAML Best Practices** ([azure-devops-pipelines.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/azure-devops-pipelines.instructions.md)) — Best practices for Azure DevOps pipeline YAML authoring (applyTo: `**/azure-pipelines.yml, **/azure-pipelines*.yml, **/*.pipeline.yml`).
- **⭐ Blazor** ([blazor.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/blazor.instructions.md)) — Blazor component and application patterns (applyTo: `**/*.razor, **/*.razor.cs,**/*.razor.css`).
- **⭐ C# Development** ([csharp.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/csharp.instructions.md)) — Guidelines for building C# applications (applyTo: `**/*.cs`).
- **Containerization & Docker Best Practices** ([containerization-docker-best-practices.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/containerization-docker-best-practices.instructions.md)) — Secure, optimized Docker and container best practices (applyTo: `**/Dockerfile,**/Dockerfile.*,**/*.dockerfile,**/docker-compose*.yml,**/docker-compose*.yaml,**/compose*.yml,**/compose*.yaml`).
- **Context Engineering** ([context-engineering.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/context-engineering.instructions.md)) — Structuring projects for better Copilot context quality (applyTo: `**`).
- **Context7-aware development** ([context7.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/context7.instructions.md)) — Use Context7 when local context is insufficient (applyTo: `**`).
- **⭐ Copilot Prompt Files Guidelines** ([prompt.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/prompt.instructions.md)) — Guidelines for creating strong prompt files (applyTo: `**/*.prompt.md`).
- **⭐ Custom Agent File Guidelines** ([agents.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/agents.instructions.md)) — Guidelines for creating custom agent files (applyTo: `**/*.agent.md`).
- **⭐ Custom Instructions File Guidelines** ([instructions.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/instructions.instructions.md)) — Guidelines for creating custom instruction files (applyTo: `**/*.instructions.md`).
- **14x Dataverse SKD*** ([dataverse-python.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/dataverse-python.instructions.md)) — Collection of Dataverse SDK instruction files covering advanced scenarios and references (applyTo: `dataverse instruction files in awesome-copilot`).
- **🔷 DDD Systems & .NET Guidelines** ([dotnet-architecture-good-practices.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/dotnet-architecture-good-practices.instructions.md)) — DDD and .NET architecture guidance (applyTo: `**/*.cs,**/*.csproj,**/Program.cs,**/*.razor`).
- **DevOps Core Principles** ([devops-core-principles.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/devops-core-principles.instructions.md)) — Core DevOps principles, CALMS culture, and DORA metrics guidance (applyTo: `*`).
- **Generic Code Review Instructions (JAVA)** ([code-review-generic.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/code-review-generic.instructions.md)) — Reusable code-review guidance adaptable across projects (applyTo: `**`).
- **⭐ GitHub Actions CI/CD Best Practices** ([github-actions-ci-cd-best-practices.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/github-actions-ci-cd-best-practices.instructions.md)) — Secure, robust GitHub Actions CI/CD guidance (applyTo: `.github/workflows/*.yml, .github/workflows/*.yaml`).
- **GitHub Copilot SDK C# Instructions** ([copilot-sdk-csharp.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/copilot-sdk-csharp.instructions.md)) — Guidance for C# apps using GitHub Copilot SDK (applyTo: `**.cs,**.csproj`).
- **⭐ Guidance for Localization** ([localization.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/localization.instructions.md)) — Guidelines for localizing markdown content (applyTo: `**/*.md`).
- **HTML CSS Style Color Guide** ([html-css-style-color-guide.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/html-css-style-color-guide.instructions.md)) — Accessible color and styling rules for web UI (applyTo: `**/*.html, **/*.css,**/*.js`).
- **Kubernetes Deployment Best Practices** ([kubernetes-deployment-best-practices.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/kubernetes-deployment-best-practices.instructions.md)) — Practical Kubernetes deployment best practices (applyTo: `*`).
- **Kubernetes Manifests Instructions** ([kubernetes-manifests.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/kubernetes-manifests.instructions.md)) — Kubernetes YAML best practices for security and operability (applyTo: `k8s/**/*.yaml, k8s/**/*.yml, manifests/**/*.yaml, manifests/**/*.yml, deploy/**/*.yaml, deploy/**/*.yml, charts/**/templates/**/*.yaml, charts/**/templates/**/*.yml`).
- **⭐ Markdown** ([markdown.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/markdown.instructions.md)) — Documentation and markdown content standards (applyTo: `**/*.md`).
- **⭐ Markdown Accessibility Review Guidelines** ([markdown-accessibility.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/markdown-accessibility.instructions.md)) — Markdown accessibility review best practices (applyTo: `**/*.md`).
- **Next.js + Tailwind Development Instructions** ([nextjs-tailwind.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/nextjs-tailwind.instructions.md)) — Next.js + Tailwind development standards (applyTo: `**/*.tsx, **/*.ts,**/*.jsx, **/*.js, **/*.css`).
- **⭐ Next.js Best Practices for LLMs (2026)** ([nextjs.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/nextjs.instructions.md)) — Next.js App Router best practices with modern caching and boundaries (applyTo: `**/*.tsx, **/*.ts,**/*.jsx, **/*.js, **/*.css`).
- **Performance Optimization Best Practices** ([performance-optimization.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/performance-optimization.instructions.md)) — Full-stack performance optimization guidance (applyTo: `*`).
- **Playwright .NET Test Generation Instructions** ([playwright-dotnet.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/playwright-dotnet.instructions.md)) — Playwright .NET testing guidance (applyTo: `**`).
- **Playwright Typescript** ([playwright-typescript.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/playwright-typescript.instructions.md)) — Playwright TypeScript testing guidance (applyTo: `**`).
- **4x Power Apps** ([power-apps-code-apps.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/power-apps-code-apps.instructions.md)) — Collection of Power Apps instruction files for YAML, code apps, and component guidance (applyTo: `Power Apps instruction files in awesome-copilot`).
- **6x Power BI** ([power-bi-data-modeling-best-practices.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/power-bi-data-modeling-best-practices.instructions.md)) — Collection of Power BI instruction files for modeling, DAX, reporting, performance, security, and ALM (applyTo: `Power BI instruction files in awesome-copilot`).
- **2x Power Platform** ([power-platform-connector.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/power-platform-connector.instructions.md)) — Collection of Power Platform connector and MCP integration instruction files (applyTo: `Power Platform instruction files in awesome-copilot`).
- **⭐ PowerShell Cmdlet Development Guidelines** ([powershell.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/powershell.instructions.md)) — PowerShell cmdlet and script best practices (applyTo: `**/*.ps1,**/*.psm1`).
- **PowerShell Pester v5 Testing Guidelines** ([powershell-pester-5.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/powershell-pester-5.instructions.md)) — Pester v5 testing conventions and patterns (applyTo: `**/*.Tests.ps1`).
- **Python Coding Conventions** ([python.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/python.instructions.md)) — Python coding conventions and style guidance (applyTo: `**/*.py`).
- **ReactJS Development Instructions** ([reactjs.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/reactjs.instructions.md)) — ReactJS standards and best practices (applyTo: `**/*.jsx, **/*.tsx,**/*.js, **/*.ts, **/*.css, **/*.scss`).
- **⭐ Secure Coding and OWASP Guidelines** ([security-and-owasp.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/security-and-owasp.instructions.md)) — Secure coding guidance aligned with OWASP (applyTo: `*`).
- **⭐ Self-explanatory Code Commenting Instructions** ([self-explanatory-code-commenting.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/self-explanatory-code-commenting.instructions.md)) — Commenting guidance for self-explanatory code (applyTo: `**`).
- **⭐ Shell Scripting Guidelines** ([shell.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/shell.instructions.md)) — Shell scripting conventions and best practices (applyTo: `**/*.sh`).
- **⭐ SQL Development** ([sql-sp-generation.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/sql-sp-generation.instructions.md)) — SQL generation and stored-procedure guidance (applyTo: `**/*.sql`).
- **Style Components with Modern Theming (Preview)** ([pcf-fluent-modern-theming.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/pcf-fluent-modern-theming.instructions.md)) — Fluent UI theming guidance for modern components (applyTo: `**/*.{ts,tsx,js,json,xml,pcfproj,csproj}`).
- **Tailwind CSS v4+ Installation with Vite** ([tailwind-v4-vite.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/tailwind-v4-vite.instructions.md)) — Tailwind v4 + Vite setup and configuration guidance (applyTo: `vite.config.ts, vite.config.js, **/*.css, **/*.tsx,**/*.ts, **/*.jsx, **/*.js`).
- **Terraform Conventions** ([terraform.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/terraform.instructions.md)) — Terraform conventions and coding guidelines (applyTo: `**/*.tf`).
- **⭐ TypeScript Development** ([typescript-5-es2022.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/typescript-5-es2022.instructions.md)) — TypeScript 5.x / ES2022 development guidance (applyTo: `**/*.ts`).
- **TypeSpec for Microsoft 365 Copilot Development Guidelines** ([typespec-m365-copilot.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/typespec-m365-copilot.instructions.md)) — TypeSpec guidance for M365 Copilot declarative agents and API plugins (applyTo: `**/*.tsp`).
- **⭐ Update Documentation on Code Change** ([update-docs-on-code-change.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/update-docs-on-code-change.instructions.md)) — Guidance for updating docs when code changes (applyTo: `**/*.{md,js,mjs,cjs,ts,tsx,jsx,py,java,cs,go,rb,php,rs,cpp,c,h,hpp}`).
- **VueJS 3 Development Instructions** ([vuejs3.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/vuejs3.instructions.md)) — Vue 3 + Composition API + TypeScript best practices (applyTo: `**/*.vue, **/*.ts,**/*.js, **/*.scss`).
- **WinUI 3 / Windows App SDK** ([winui3.instructions.md](https://github.com/github/awesome-copilot/blob/main/instructions/winui3.instructions.md)) — WinUI 3 and Windows App SDK coding guidance (applyTo: `**/*.xaml, **/*.cs,**/*.csproj`).

#### 🪝 [Hooks](https://github.com/github/awesome-copilot/blob/main/docs/README.hooks.md)

- **Session Auto-Commit** — Automatically commits and pushes changes when a Copilot coding agent session ends.

#### 🎯 [Skills](https://github.com/github/awesome-copilot/blob/main/docs/README.skills.md)

- **appinsights-instrumentation** ([appinsights-instrumentation.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/appinsights-instrumentation/SKILL.md)) — Instrument web apps to send useful telemetry to Azure Application Insights.
- **aspire** ([aspire.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/aspire/SKILL.md)) — Guidance for .NET Aspire workflows including orchestration, integrations, and deployment.
- **aspnet-minimal-api-openapi** ([aspnet-minimal-api-openapi.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/aspnet-minimal-api-openapi/SKILL.md)) — Create ASP.NET Minimal API endpoints with proper OpenAPI documentation.
- **az-cost-optimize** ([az-cost-optimize.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/az-cost-optimize/SKILL.md)) — Analyze Azure resources and identify cost optimization opportunities.
- **9x azure-*** ([9x azure-* collection](https://github.com/github/awesome-copilot/tree/main/skills)) — Collection of Azure-focused skills for diagnostics, cost optimization, observability, RBAC, and infrastructure workflows.
- **containerize-aspnet-framework** ([containerize-aspnet-framework.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/containerize-aspnet-framework/SKILL.md)) — Containerize ASP.NET .NET Framework projects with tailored Dockerfiles.
- **containerize-aspnetcore** ([containerize-aspnetcore.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/containerize-aspnetcore/SKILL.md)) — Containerize ASP.NET Core projects with tailored Dockerfiles.
- **context-map** ([context-map.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/context-map/SKILL.md)) — Generate a map of relevant files before implementing changes.
- **conventional-commit** ([conventional-commit.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/conventional-commit/SKILL.md)) — Generate Conventional Commit messages with a structured workflow.
- **convert-plaintext-to-md** ([convert-plaintext-to-md.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/convert-plaintext-to-md/SKILL.md)) — Convert plaintext documents to markdown using guided rules.
- **copilot-instructions-blueprint-generator** ([copilot-instructions-blueprint-generator.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/copilot-instructions-blueprint-generator/SKILL.md)) — Generate robust `copilot-instructions.md` blueprints from codebase patterns.
- **NEW** **copilot-cli-quickstart** ([copilot-cli-quickstart.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/copilot-cli-quickstart/SKILL.md)) — Step-by-step GitHub Copilot CLI tutorials and on-demand Q&A for getting started quickly.
- **create-agentsmd** ([create-agentsmd.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/create-agentsmd/SKILL.md)) — Generate an `AGENTS.md` file for the repository.
- **create-github-action-workflow-specification** ([create-github-action-workflow-specification.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/create-github-action-workflow-specification/SKILL.md)) — Create AI-optimized specs for GitHub Actions workflows.
- **create-readme** ([create-readme.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/create-readme/SKILL.md)) — Generate a project README file.
- **⭐ csharp-async** ([csharp-async.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/csharp-async/SKILL.md)) — Get best practices for C# async programming
- **⭐ csharp-docs** ([csharp-docs.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/csharp-docs/SKILL.md)) — Ensure that C# types are documented with XML comments and follow best practices for documentation.
- **csharp-mcp-server-generator** ([csharp-mcp-server-generator.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/csharp-mcp-server-generator/SKILL.md)) — Generate a complete MCP server project in C# with tools, prompts, and proper configuration
- **csharp-mstest** ([csharp-mstest.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/csharp-mstest/SKILL.md)) — Get best practices for MSTest 3.x/4.x unit testing, including modern assertion APIs and data-driven tests
- **csharp-nunit** ([csharp-nunit.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/csharp-nunit/SKILL.md)) — Get best practices for NUnit unit testing, including data-driven tests
- **⭐ csharp-tunit** ([csharp-tunit.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/csharp-tunit/SKILL.md)) — Get best practices for TUnit unit testing, including data-driven tests
- **🔷csharp-xunit** ([csharp-xunit.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/csharp-xunit/SKILL.md)) — Get best practices for XUnit unit testing, including data-driven tests
- **4x dataverse-*** ([4x dataverse-* collection](https://github.com/github/awesome-copilot/tree/main/skills)) — Collection of Dataverse-focused skills for Python SDK usage, integrations, and practical workflows.
- **documentation-writer** ([documentation-writer.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/documentation-writer/SKILL.md)) — Diátaxis-focused technical documentation expert skill.
- **⭐ dotnet-best-practices** ([dotnet-best-practices.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/dotnet-best-practices/SKILL.md)) — Ensure .NET/C# code meets best practices for the solution/project.
- **⭐ dotnet-design-pattern-review** ([dotnet-design-pattern-review.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/dotnet-design-pattern-review/SKILL.md)) — Review the C#/.NET code for design pattern implementation and suggest improvements.
- **dotnet-upgrade** ([dotnet-upgrade.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/dotnet-upgrade/SKILL.md)) — Ready-to-use prompts for comprehensive .NET framework upgrade analysis and execution
- **⭐ editorconfig** ([editorconfig.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/editorconfig/SKILL.md)) — Generates a comprehensive and best-practice-oriented .editorconfig file based on project analysis and user preferences.
- **⭐ ef-core** ([ef-core.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/ef-core/SKILL.md)) — Get best practices for Entity Framework Core
- **entra-agent-user** ([entra-agent-user.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/entra-agent-user/SKILL.md)) — Create Agent Users in Microsoft Entra ID from Agent Identities, enabling AI agents to act as digital workers with user identity capabilities in Microsoft 365 and Azure environments.
- **⭐ fluentui-blazor** ([fluentui-blazor.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/fluentui-blazor/SKILL.md)) — Guide for using the Microsoft Fluent UI Blazor component library (Microsoft.FluentUI.AspNetCore.Components NuGet package) in Blazor applications. Use this when the user is building a Blazor app with Fluent UI components, setting up the library, using FluentUI components like FluentButton, FluentDataGrid, FluentDialog, FluentToast, FluentNavMenu, FluentTextField, FluentSelect, FluentAutocomplete, FluentDesignTheme, or any component prefixed with "Fluent". Also use when troubleshooting missing providers, JS interop issues, or theming.
- **game-engine** ([game-engine.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/game-engine/SKILL.md)) — Build web games/game engines with HTML5 Canvas/WebGL patterns.
- **github-issues** ([github-issues.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/github-issues/SKILL.md)) — Create, update, and manage GitHub issues via MCP workflows.
- **⭐ javascript-typescript-jest** ([javascript-typescript-jest.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/javascript-typescript-jest/SKILL.md)) — Jest testing best practices for JavaScript/TypeScript.
- **legacy-circuit-mockups** ([legacy-circuit-mockups.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/legacy-circuit-mockups/SKILL.md)) — Create breadboard and retro-electronics mockups with HTML5 Canvas.
- **make-repo-contribution** ([make-repo-contribution.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/make-repo-contribution/SKILL.md)) — All changes to code must follow the guidance documented in the repository. Before any issue is filed, branch is made, commits generated, or pull request (or PR) created, a search must be done to ensure the right steps are followed. Whenever asked to create an issue, commit messages, to push code, or create a PR, use this skill so everything is done correctly.
- **🔷 make-skill-template** ([make-skill-template.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/make-skill-template/SKILL.md)) — Scaffold new GitHub Copilot Agent Skills with proper structure.
- **meeting-minutes** ([meeting-minutes.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/meeting-minutes/SKILL.md)) — Generate concise, actionable internal meeting minutes.
- **microsoft-code-reference** ([microsoft-code-reference.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/microsoft-code-reference/SKILL.md)) — Look up Microsoft API references, find working code samples, and verify SDK code is correct. Use when working with Azure SDKs, .NET libraries, or Microsoft APIs—to find the right method, check parameters, get working examples, or troubleshoot errors. Catches hallucinated methods, wrong signatures, and deprecated patterns by querying official docs.
- **microsoft-docs** ([microsoft-docs.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/microsoft-docs/SKILL.md)) — Query official Microsoft documentation to find concepts, tutorials, and code examples across Azure, .NET, Agent Framework, Aspire, VS Code, GitHub, and more. Uses Microsoft Learn MCP as the default, with Context7 and Aspire MCP for content that lives outside learn.microsoft.com.
- **NEW** **microsoft-agent-framework** ([microsoft-agent-framework.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/microsoft-agent-framework/SKILL.md)) — Create, update, refactor, explain, or review Microsoft Agent Framework solutions using current official guidance.
- **⭐ microsoft-skill-creator** ([microsoft-skill-creator.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/microsoft-skill-creator/SKILL.md)) — Create agent skills for Microsoft technologies using Learn MCP tools. Use when users want to create a skill that teaches agents about any Microsoft technology, library, framework, or service (Azure, .NET, M365, VS Code, Bicep, etc.). Investigates topics deeply, then generates a hybrid skill storing essential knowledge locally while enabling dynamic deeper investigation.
- **NEW** **semantic-kernel** ([semantic-kernel.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/semantic-kernel/SKILL.md)) — Create, update, refactor, explain, or review Semantic Kernel solutions using shared guidance plus language-specific .NET and Python references.
- **model-recommendation** ([model-recommendation.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/model-recommendation/SKILL.md)) — Recommend optimal AI models based on task complexity and cost.
- **multi-stage-dockerfile** ([multi-stage-dockerfile.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/multi-stage-dockerfile/SKILL.md)) — Create optimized multi-stage Dockerfiles for any stack.
- **nano-banana-pro-openrouter** ([nano-banana-pro-openrouter.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/nano-banana-pro-openrouter/SKILL.md)) — Generate or edit images via OpenRouter with the Gemini 3 Pro Image model. Use for prompt-only image generation, image edits, and multi-image compositing; supports 1K/2K/4K output.
- **next-intl-add-language** ([next-intl-add-language.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/next-intl-add-language/SKILL.md)) — Add new language to a Next.js + next-intl application
- **nuget-manager** ([nuget-manager.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/nuget-manager/SKILL.md)) — Manage NuGet package add/remove/update workflows for .NET projects.
- **openapi-to-application-code** ([openapi-to-application-code.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/openapi-to-application-code/SKILL.md)) — Generate production-ready applications from OpenAPI specs.
- **plantuml-ascii** ([plantuml-ascii.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/plantuml-ascii/SKILL.md)) — Generate terminal-friendly ASCII diagrams with PlantUML text mode.
- **playwright-automation-fill-in-form** ([playwright-automation-fill-in-form.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/playwright-automation-fill-in-form/SKILL.md)) — Automate filling in a form using Playwright MCP
- **playwright-explore-website** ([playwright-explore-website.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/playwright-explore-website/SKILL.md)) — Website exploration for testing using Playwright MCP
- **playwright-generate-test** ([playwright-generate-test.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/playwright-generate-test/SKILL.md)) — Generate a Playwright test based on a scenario using Playwright MCP
- **postgresql-code-review** ([postgresql-code-review.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/postgresql-code-review/SKILL.md)) — PostgreSQL-specific code review assistant focusing on PostgreSQL best practices, anti-patterns, and unique quality standards. Covers JSONB operations, array usage, custom types, schema design, function optimization, and PostgreSQL-exclusive security features like Row Level Security (RLS).
- **postgresql-optimization** ([postgresql-optimization.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/postgresql-optimization/SKILL.md)) — PostgreSQL-specific development assistant focusing on unique PostgreSQL features, advanced data types, and PostgreSQL-exclusive capabilities. Covers JSONB operations, array types, custom types, range/geometric types, full-text search, window functions, and PostgreSQL extensions ecosystem.
- **7x Power*** ([7x Power* collection](https://github.com/github/awesome-copilot/tree/main/skills)) — Collection of Power Platform and Power BI skills for connectors, analytics, modeling, and performance.
- **prd** ([prd.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/prd/SKILL.md)) — Generate high-quality Product Requirements Documents for software and AI features.
- **sql-code-review** ([sql-code-review.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/sql-code-review/SKILL.md)) — Universal SQL code review assistant that performs comprehensive security, maintainability, and code quality analysis across all SQL databases (MySQL, PostgreSQL, SQL Server, Oracle). Focuses on SQL injection prevention, access control, code standards, and anti-pattern detection. Complements SQL optimization prompt for complete development coverage.
- **sql-optimization** ([sql-optimization.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/sql-optimization/SKILL.md)) — Universal SQL performance optimization assistant for comprehensive query tuning, indexing strategies, and database performance analysis across all SQL databases (MySQL, PostgreSQL, SQL Server, Oracle). Provides execution plan analysis, pagination optimization, batch operations, and performance monitoring guidance.
- **suggest-awesome-github-copilot-agents** ([suggest-awesome-github-copilot-agents.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/suggest-awesome-github-copilot-agents/SKILL.md)) — Suggest relevant GitHub Copilot Custom Agents files from the awesome-copilot repository based on current repository context and chat history, avoiding duplicates with existing custom agents in this repository, and identifying outdated agents that need updates.
- **suggest-awesome-github-copilot-instructions** ([suggest-awesome-github-copilot-instructions.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/suggest-awesome-github-copilot-instructions/SKILL.md)) — Suggest relevant GitHub Copilot instruction files from the awesome-copilot repository based on current repository context and chat history, avoiding duplicates with existing instructions in this repository, and identifying outdated instructions that need updates.
- **suggest-awesome-github-copilot-prompts** ([suggest-awesome-github-copilot-prompts.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/suggest-awesome-github-copilot-prompts/SKILL.md)) — Suggest relevant GitHub Copilot prompt files from the awesome-copilot repository based on current repository context and chat history, avoiding duplicates with existing prompts in this repository, and identifying outdated prompts that need updates.
- **suggest-awesome-github-copilot-skills** ([suggest-awesome-github-copilot-skills.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/suggest-awesome-github-copilot-skills/SKILL.md)) — Suggest relevant GitHub Copilot skills from the awesome-copilot repository based on current repository context and chat history, avoiding duplicates with existing skills in this repository, and identifying outdated skills that need updates.
- **update-markdown-file-index** ([update-markdown-file-index.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/update-markdown-file-index/SKILL.md)) — Update a markdown file section with an index/table of files from a specified folder.
- **web-design-reviewer** ([web-design-reviewer.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/web-design-reviewer/SKILL.md)) — This skill enables visual inspection of websites running locally or remotely to identify and fix design issues. Triggers on requests like "review website design", "check the UI", "fix the layout", "find design problems". Detects issues with responsive design, accessibility, visual consistency, and layout breakage, then performs fixes at the source code level.
- **webapp-testing** ([webapp-testing.SKILL.md](https://github.com/github/awesome-copilot/blob/main/skills/webapp-testing/SKILL.md)) — Toolkit for interacting with and testing local web applications using Playwright. Supports verifying frontend functionality, debugging UI behavior, capturing browser screenshots, and viewing browser logs.

#### ⚡ [Agentic Workflows](https://github.com/github/awesome-copilot/blob/main/docs/README.workflows.md)

## How I use this list

1. Start from [Awesome Copilot](https://github.com/github/awesome-copilot) to
   identify a proven baseline.
2. Check [skills.sh](https://skills.sh/) and
   [Claude Skills library](https://mcpservers.org/claude-skills) for quickly
   installable skills.
3. Prefer official patterns from
   [Anthropic Skills](https://github.com/anthropics/skills/) and
   [OpenAI Skills](https://github.com/openai/skills) when creating custom
   internal skills.
4. For .NET-heavy work, prioritize
   [Aaron Stannard .NET Skills](https://skills.sh/aaronontheweb/dotnet-skills)
   and keep the rest as complementary references.

## Install guide for a new repository

Use `.github/skills/` in your target repository as the destination for
imported skills.

### Recommended folder layout

```text
<your-repo>/
   .github/
      skills/
         <skill-name>/
            SKILL.md
            references/
            scripts/
```

### Quick install of one skill (GitHub source)

Use this when you want to test one skill before importing many.

```powershell
# from your target repo root
New-Item -ItemType Directory -Force -Path ".github/skills" | Out-Null
git clone --depth 1 https://github.com/aaronontheweb/dotnet-skills .tmp-dotnet-skills
Copy-Item ".tmp-dotnet-skills/*" ".github/skills/dotnet-skills" -Recurse -Force
Remove-Item ".tmp-dotnet-skills" -Recurse -Force
```

### Batch install multiple favorite skills (PowerShell)

This script imports several GitHub-hosted skill packs in one run.

```powershell
# run from your target repo root
$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Force -Path ".github/skills" | Out-Null

$sources = @(
   @{ Name = "dotnet-skills"; Repo = "https://github.com/aaronontheweb/dotnet-skills" },
   @{ Name = "anthropic-skills"; Repo = "https://github.com/anthropics/skills" },
   @{ Name = "openai-skills"; Repo = "https://github.com/openai/skills" },
   @{ Name = "vercel-agent-skills"; Repo = "https://github.com/vercel-labs/agent-skills" },
   @{ Name = "vercel-next-skills"; Repo = "https://github.com/vercel-labs/next-skills" },
   @{ Name = "approved-skills"; Repo = "https://github.com/fefogarcia/approved-skills" }
)

foreach ($source in $sources) {
   $tempPath = ".tmp-$($source.Name)"
   if (Test-Path $tempPath) {
      Remove-Item $tempPath -Recurse -Force
   }

   git clone --depth 1 $source.Repo $tempPath

   $targetPath = ".github/skills/$($source.Name)"
   if (Test-Path $targetPath) {
      Remove-Item $targetPath -Recurse -Force
   }
   Copy-Item "$tempPath/*" $targetPath -Recurse -Force
   Remove-Item $tempPath -Recurse -Force
}

Write-Host "Imported skill packs into .github/skills"
```

### Install all favorites from this page in one batch

The fastest repeatable approach is to keep a local script like the one above
in your template repository (for example: `scripts/bootstrap-skills.ps1`) and
run it for every new repository.

### Notes for skills.sh and Claude Skills library links

- `skills.sh` and the Claude Skills directory are excellent discovery and
   install sources.
- Use each skill page's official install instructions when available.
- If a skill links back to GitHub, you can include that repository in the
   batch script list above for one-command setup.

### Verify installation

After import, open each skill folder and confirm `SKILL.md` exists at the
expected path. Then run your normal Copilot skill discovery command (for
example, `/skills list` in compatible environments).
