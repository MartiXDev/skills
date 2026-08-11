# Optional Redis cache capability proposal

## Decision and scope

Add Redis as an **opt-in capability** of the modular-monolith preset. The preset remains cache-free unless the caller explicitly selects Redis. The capability is a cache acceleration layer only; the application database and other primary stores remain the source of truth.

**Admission status: Proposed / Not Supported.** There is no implementation evidence in this proposal. The capability may be called **Supported** only after every must-pass gate below has passing, repeatable evidence.

## Configuration contract and provider seam

Use one normalized capability declaration, for example:

```yaml
capabilities:
  cache:
    provider: none       # default; alternatively: redis
    required: false
```

When `provider: redis` is selected, require a secret/config reference rather than a literal credential:

```yaml
capabilities:
  cache:
    provider: redis
    required: false
    connectionStringRef: REDIS_CONNECTION
    keyPrefix: myapp
    defaultTtl: 00:05:00
```

The generated application depends only on an internal seam such as:

```text
CacheProvider
  get(key, cancellationToken) -> hit/value or miss
  set(key, value, ttl, cancellationToken)
  remove(key, cancellationToken)
```

The seam must define serialization, key/TTL limits, cancellation, and the distinction between cache miss and provider failure. It must not expose Redis types, connection objects, or provider-specific exceptions to domain/application code. Provide a no-op implementation for `none` and a Redis adapter registered only for `redis`; all consumers use dependency injection against the seam.

### Validity rules

Generation must reject, before writing output, at least these combinations:

| Configuration | Result |
|---|---|
| omitted cache block / `provider: none` | Valid; no cache capability |
| `provider: redis`, `required: false`, valid secret reference | Valid; fail-open cache |
| `provider: redis` with no connection/secret reference | Reject: actionable missing-input error |
| `provider: redis` with `required: true` | Valid only if the preset explicitly supports a hard dependency; otherwise reject for this optional capability |
| `provider: none` plus Redis connection, Redis service, or Redis-only settings | Reject as a conflicting provider combination (or normalize only under a documented strict-schema policy) |
| more than one cache provider selected | Reject; exactly one provider is allowed |
| unknown provider, malformed secret reference, invalid TTL/key prefix, or provider-specific options on another provider | Reject with field and allowed values |

Do not infer Redis from an environment variable, an installed package, or another provider selection. No silent fallback from an invalid selection is permitted.

## Generated-output acceptance checks

Run these checks against a clean temporary generation target and the generated manifest/file inventory:

1. **Default-off golden check (must pass):** with no cache selection, generated code contains no Redis package/reference, adapter, Redis configuration keys, environment placeholders, Docker/Compose/Kubernetes Redis service, Redis port, cache health check, or Redis documentation. The application builds and runs without Redis.
2. **Explicit-selection check (must pass):** `provider: redis` produces only the adapter, seam registration, typed options, secret-reference wiring, bounded health/telemetry wiring, and any explicitly requested local-dev service. The manifest records the selected capability and provider.
3. **Dependency isolation:** domain/application projects reference only the seam; the Redis client appears only in the infrastructure/adapter boundary. There is no transitive Redis dependency in the default graph.
4. **Negative generation checks:** each invalid combination exits non-zero, identifies the offending fields, lists valid combinations, and leaves no partial or misleading output. Generation should stage and commit output atomically.
5. **Build and behavior checks:** generated output compiles, default integration tests pass without a Redis process, explicit Redis integration tests pass with a supported Redis version, and generation is deterministic/idempotent.
6. **Drift check:** generated manifests, configuration schemas, environment examples, container definitions, health names, and docs agree with the selected provider; no secret value is emitted.

## Unavailable-Redis behavior

Redis must be treated as an optional dependency when `required: false`:

- Connect lazily or with a short bounded startup attempt; Redis connection failure must not fail process startup, migrations, liveness, or ordinary request handling.
- On `Get` failure, return a cache miss. On `Set`/`Remove` failure, log/measure the failure and return control without changing the primary operation. Never return stale or fabricated data as a substitute for the source of truth.
- Apply short connect/operation timeouts, cancellation, bounded retries, and a circuit breaker/backoff so an outage cannot exhaust request threads or create retry storms. Recovery should be detected by a background probe or the next bounded operation.
- Cache failures must be observable but non-fatal: structured event/metric with provider, operation, latency, and circuit state; rate-limit and redact logs. Do not log connection strings, tokens, keys containing sensitive data, or cached values.
- If an operation explicitly opts into requiring cache semantics, fail that operation with a documented, typed error; do not silently make the whole application required. Such an opt-in must be a separate contract from the default cache-aside path.

## Security and health evidence

Before admission, provide evidence for:

- TLS in transit, certificate validation, authenticated secret references, rotation without source changes, and no credentials in generated files, logs, snapshots, or image layers.
- Least-privilege Redis ACLs (only required commands), private-network/egress controls, configurable key prefix/namespace, bounded key and value sizes, safe serialization, and protection against untrusted key construction/cache poisoning. Define whether sensitive data is prohibited or encrypted before caching; default to non-sensitive cache entries.
- Dependency/license/SBOM and vulnerability scan for the Redis client; pinned compatible versions and an upgrade/rollback path.
- Health endpoints that report `disabled` as healthy/not-applicable, `enabled and reachable` as healthy, and `enabled but unreachable` as **degraded**. The degraded cache check must not make liveness fail or remove an otherwise usable optional-cache instance from readiness. Health output contains status and latency/error class, never secrets or payloads; document alert thresholds and circuit-open behavior.
- Tests/chaos evidence covering startup with no Redis, DNS refusal, authentication failure, TLS failure, timeout, restart/recovery, partial network loss, and a full cache flush. Verify primary reads/writes and bounded latency in every case.

## Quality-gate status for `Supported`

| Gate | Required evidence | Status before implementation |
|---|---|---|
| Schema and provider matrix | Valid/invalid fixtures and actionable diagnostics | Pending |
| Default absence | Golden generated diff plus build/run with no Redis | Pending |
| Explicit generation | Manifest, adapter, config, and deterministic output checks | Pending |
| Seam and isolation | Contract tests and dependency-graph inspection | Pending |
| Failure safety | Fault-injection/chaos results proving fail-open behavior and bounded latency | Pending |
| Security | Secret, TLS, ACL, network, serialization, SBOM, and vulnerability evidence | Pending |
| Health and operations | Degraded health semantics, metrics/log redaction, alerts, recovery evidence | Pending |
| Compatibility and performance | Supported Redis versions, upgrade path, and workload regression budget | Pending |
| Documentation and supportability | Configuration, failure modes, runbook, and troubleshooting guidance | Pending |
| CI/reproducibility | Clean-generation, negative, default, explicit, and integration jobs | Pending |

**Promotion rule:** keep the capability **Not Supported** (at most Experimental) until all gates are green in CI and the owner has recorded the evidence artifacts and supported-version matrix. A single default-off, invalid-combination, security, or unavailable-Redis failure blocks promotion. Only then should the preset advertise Redis as **Supported**.
