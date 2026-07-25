# OpenAI Prompt Cache Strategy

Scope: OpenAI Responses API and Chat Completions API. Provider behavior is not
assumed to apply to Claude, Copilot, or other services.

## Rules

- Put stable instructions, examples, tools, images, and schemas first; put the
  changing request last. OpenAI caches an exact reusable prompt prefix.
- Keep images, image `detail`, tools, and structured-output schemas identical
  when they are part of the reusable prefix.
- Automatic caching applies at `1,024` input tokens or more. Shorter requests
  expose cache fields but have `0` cached tokens.
- Use a stable `prompt_cache_key` for recurring common prefixes. On GPT-5.6+
  families, OpenAI recommends supplying one; partition high traffic across
  stable keys and target about 15 requests per minute per key.

## Controls

- GPT-5.6+ supports `prompt_cache_options` with `implicit` or `explicit` mode.
- An explicit `prompt_cache_breakpoint` fixes the cached-prefix boundary; text
  after it may change without invalidating the earlier prefix.
- GPT-5.6+ supports a documented `30m` minimum eligible TTL through
  `prompt_cache_options.ttl`; older models use `prompt_cache_retention` policies.
- Older in-memory caches generally last 5-10 minutes while active and up to one
  hour after inactivity. Some supported models offer `24h` retention. Check the
  model documentation before relying on a duration.

## Cost and measurement

- Cache reads use the model's cached-input rate. Before GPT-5.6, cache writes
  have no additional fee; GPT-5.6+ writes are billed at `1.25x` the uncached
  input-token rate.
- Do not use a universal discount percentage. Rates vary by model and API.
- Responses usage: `input_tokens_details.cached_tokens` and
  `cache_write_tokens`.
- Chat Completions usage: `prompt_tokens_details.cached_tokens` and
  `cache_write_tokens`.
- Log read and write counts and compare them with the OpenAI Usage dashboard.

## Local workflow guidance

These are repository practices, not OpenAI API guarantees:

- Keep `AGENTS.md`, `.github/copilot-instructions.md`, skills, and prompts
  short and stable so reusable context can remain a cacheable prefix.
- Load only the skills, MCP servers, and tools needed for the task.
- Template recurring workflows instead of rewriting long instructions.
- Use focused tests and linters to avoid expensive retry loops.

## Sources

- [Prompt caching guide](https://developers.openai.com/api/docs/guides/prompt-caching)
- [Responses create API: prompt cache controls](https://developers.openai.com/api/docs/api-reference/responses/create#responses-create-prompt_cache_key)
- [Responses object API](https://developers.openai.com/api/docs/api-reference/responses/object)
- [Chat object API](https://developers.openai.com/api/docs/api-reference/chat/object)
