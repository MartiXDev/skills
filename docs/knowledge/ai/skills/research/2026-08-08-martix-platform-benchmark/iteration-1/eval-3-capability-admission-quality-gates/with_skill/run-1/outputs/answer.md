# Optional Redis cache capability proposal

## Capability and provider decision

**Status and authority.** This is a target design proposal, not a claim about a
currently shipped API. The skill describes the Platform as a bootstrap/preview
implementation with empty broad support claims; the consuming repository's
framework, package references, `martix.platform.json`, generated manifest, and
composition must be checked before implementation. Redis should therefore be
introduced by a Platform change and an explicit quality-gate profile, not by
assuming that a Wayfinder or blueprint name is already available.

The production-oriented `modular-monolith` preset remains valid without a
cache. Cache is an optimization, never the source of truth, and is not an
implicit dependency of the API, Migrator, or any module.

The manifest schema below is logical target notation only; exact field names
must be approved against the current manifest schema:

```json
{
  "preset": "modular-monolith",
  "capabilities": [
    { "name": "cache", "provider": "redis" }
  ]
}
```

The generator must normalize and validate the complete selection before it
creates a directory or writes a file.

| Selection | Decision |
| --- | --- |
| No cache capability and no cache provider | **Accept**; the default output has no cache. |
| `cache` capability with exactly one declared `redis` provider | **Accept** for the explicitly supported preset/profile. |
| `cache` capability without a provider | **Reject before generation**; the provider is not inferred. |
| `redis` provider without the `cache` capability | **Reject before generation**; a provider cannot opt itself in. |
| Cache with an unknown, undeclared, duplicate, or more than one provider | **Reject before generation**. An in-memory fallback is not silently selected. |
| `redis` named as the database provider, or otherwise in the wrong provider slot | **Reject**; database provider selection remains separate. |
| `modular-monolith` plus an independently declared PostgreSQL or SQL Server profile plus `cache=redis` | **Accept** if both provider profiles pass their own gates; neither provider implies the other. |
| A preset that does not declare the cache capability as allowed | **Reject before generation**. |

A failed combination check must be atomic: no partially generated projects,
package references, configuration, or secrets may remain. A future provider
must be added to the matrix and its own evidence profile; it is not accepted
merely because it implements the same interface.

## Provider-independent seam

Keep the seam outside the framework-independent Kernel and outside Redis. It
should be a small capability contract assembly (or generated capability
contract) referenced only by modules that actually use caching. It must not
expose `StackExchange.Redis`, a multiplexer, Redis commands, connection
objects, `IServiceProvider`, or a serializer chosen by a provider.

An illustrative target contract is byte-oriented so serialization and AOT
choices stay explicit at the application boundary:

```csharp
public interface IApplicationCache
{
    ValueTask<CacheReadResult> GetAsync(
        CacheKey key, CancellationToken cancellationToken);

    ValueTask<CacheOperationResult> SetAsync(
        CacheKey key,
        ReadOnlyMemory<byte> value,
        TimeSpan ttl,
        CacheWriteOptions options,
        CancellationToken cancellationToken);

    ValueTask<CacheOperationResult> RemoveAsync(
        CacheKey key, CancellationToken cancellationToken);
}
```

`CacheKey`, `CacheReadResult`, `CacheOperationResult`, and
`CacheWriteOptions` should be immutable, provider-neutral contracts with
explicit hit/miss/failure outcomes. They should carry a bounded namespace,
version/schema marker, and TTL policy, rather than accepting arbitrary raw key
strings. Typed serialization belongs to the calling slice or an explicitly
selected codec, not to a Redis adapter hidden behind the seam.

The generated API composition registers one concrete Redis adapter explicitly
when the selection is present, for example by a direct registration of the
adapter and its validated options. This is target notation, not a promise that
an `Add...` extension already exists. Do not use assembly scanning, reflection,
service location, or a broad `AddDefaults` helper. The API owns runtime cache
registration; the one-shot Migrator does not acquire a Redis dependency merely
because the API has one. A module consumes only the seam and keeps its cache
policy in the relevant vertical slice.

The seam's semantic contract must state that:

- the authoritative read/write remains the module's database or other source
  of truth;
- every use case declares whether bounded staleness is acceptable;
- authorization and tenant/resource boundaries are evaluated independently of
  a cache hit; a cache hit must never bypass an authorization check;
- TTL, invalidation, cancellation, and serialization/version failures are
  observable outcomes, not provider-specific exceptions leaked to callers.

## Generation presence and absence checks

### Selection and deterministic generation

The generator acceptance suite should parse the manifest, validate all
capability/provider combinations, and compare the generated manifest and file
set to a deterministic fixture. Run validation before rendering and write to a
staging output that is committed only after validation succeeds. Record preset,
Platform version, modules, capabilities, providers, and profile in the
manifest, but never credentials.

### Positive (`modular-monolith + cache=redis`) checks

The selected-output fixture must prove all of the following:

- the manifest records exactly the cache capability and the Redis provider;
- the Redis adapter and the small capability seam are present exactly once,
  with package/project references only in the selected profile;
- the API has an explicit, visible adapter registration and validated Redis
  options; there is no registration by scanning;
- configuration has a documented Redis endpoint/secret binding (for example a
  `ConnectionStrings:Redis` environment or managed-secret binding), but no
  literal credential; the Migrator is not given Redis configuration unless a
  separately justified operation needs it;
- the cache health/dependency check, structured telemetry, and selected-capability
  tests are present and explicitly composed;
- a host test demonstrates a cache hit, miss, set, remove/invalidation, TTL,
  cancellation, and authorization-preserving use by a module; and
- the normal one-API/one-Migrator/one-project-per-genuine-module/consolidated
  test topology is unchanged apart from the selected capability artifacts.

The positive fixture must compile and run against a real, pinned Redis instance
(or an equivalent provider test environment); a mock alone is not provider
evidence.

### Negative/default (`modular-monolith` with cache omitted) checks

Generate the default preset and assert that the output contains **none** of
these items:

- a Redis or cache project, source adapter, package/NuGet reference, lock-file
  entry, or capability-contract reference;
- a cache/Redis manifest selection, `ConnectionStrings:Redis`, Redis options,
  endpoint, environment-variable binding, secret placeholder, or sample
  credential;
- API or Migrator startup registration, health-check registration, readiness
  dependency, hosted service, middleware, or telemetry hook for Redis/cache;
- cache-specific tests, generated service registrations, or hidden startup
  imports; and
- a provider-specific file or empty options object left behind by a disabled
  capability.

The negative test must scan generated projects, source, configuration,
manifests, and generated test output—not just assert that a package is absent.
The default generated diff should be identical to the pre-capability baseline
apart from an intentionally versioned manifest/schema change.

Invalid-combination tests must assert both the diagnostic and an unchanged
output directory: `cache` without `redis`, `redis` without `cache`, unknown or
duplicate providers, and disallowed-preset selections all fail before any
source is emitted.

## Failure, security, and operations

### Redis outage and configuration behavior

Separate configuration failure from provider unavailability:

1. A missing, malformed, insecurely specified, or otherwise invalid required
   Redis setting is a configuration error. The selected host fails fast before
   serving traffic with a stable, redacted diagnostic; it does not quietly
   substitute an undeclared provider.
2. A valid configuration whose Redis endpoint is unreachable, times out, loses
   authentication, or is stopped at runtime is a dependency outage. Each cache
   operation has an explicit short timeout, honors cancellation, and has no
   unbounded retry. A bounded circuit/bypass policy prevents every request from
   paying the provider timeout.
3. A `Get` outage is a cache miss and falls through to the authoritative source.
   A `Set` outage does not invalidate or roll back a successful source-of-truth
   write; it records a cache failure and the next read can repopulate the cache.
   A failed invalidation must not silently serve stale data for a
   correctness-sensitive slice: that slice bypasses cache (or uses a
   versioned key) until recovery, or uses an explicitly documented strict
   policy. No cache failure may corrupt the module database or turn a cache
   optimization into a required write path.
4. When Redis returns, the adapter's recovery is bounded and automatic: health
   becomes healthy again, bypass is cleared after a successful probe, and a
   subsequent read can repopulate and hit. Shutdown cancels outstanding calls
   and disposes the adapter without delaying graceful host shutdown.

The default optional profile keeps application liveness independent of Redis.
It exposes a separately tagged cache dependency health result as degraded when
Redis is unavailable. Overall readiness must remain usable when cache is
non-critical; making readiness depend on Redis requires a distinct, explicitly
selected required-cache profile and additional gates, not a hidden behavior.

### Security and data handling

The threat model must cover cache poisoning, cross-tenant/key collision,
unauthorized reads after a permission change, credential disclosure, TLS
failure, and denial of service through unbounded keys or payloads. The profile
must require:

- credentials and certificates supplied through environment or managed-secret
  configuration; no secret in source, manifests, generated examples, logs,
  traces, Problem Details, health output, or audit events;
- TLS and certificate validation when the deployment requires it, least
  privilege Redis ACLs (no administrative/flush access), network restrictions,
  bounded payloads, and explicit connection/operation timeouts;
- canonical, versioned keys with module and tenant/resource scope; no raw
  attacker-controlled key fragments; and an explicit policy excluding tokens,
  passwords, and data classes that must not be cached;
- authorization checks on every relevant use case, even on hits, plus an
  invalidation/version strategy for ownership or permission changes; and
- redacted, bounded-cardinality logs, traces, metrics, and health signals. Label
  only provider, operation, outcome/error class, and bounded latency buckets—not
  cache keys, values, endpoints, user IDs, or arbitrary tenant labels.

Health evidence must cover healthy, cold/unavailable, timeout, bad
credentials/TLS, and recovery states; distinguish misconfiguration from
transient dependency failure; keep liveness independent; and verify that
responses do not contain raw Redis errors or secrets. Telemetry must make hits,
misses, bypasses, failures, latency, and recovery diagnosable with correlation
context.

## Quality-gate and support status

Create a named candidate profile, for example
`modular-monolith-cache-redis-v1`, in the Platform quality-gate configuration.
The name is a proposal until it exists in the current quality policy. Its
record must pin the Platform/source version, target framework, manifest input,
Redis image/provider version, configuration mode, runner, exact commands,
environment, generated diff, test results, and known limitations. A cache
capability is not complete merely because generated source compiles.

| Gate | Required reproducible evidence | Status required |
| --- | --- | --- |
| Admission | Valid selections are accepted; every invalid combination fails before file emission and leaves no partial output. | Pass |
| Default absence | A clean default generation has no cache/Redis projects, references, config, startup registration, health checks, telemetry hooks, tests, or secret placeholders. | Pass |
| Selected presence | A selected generation has the manifest record, seam, exactly one explicit adapter registration, config binding, health/telemetry, and host tests. | Pass |
| Provider behavior | Real Redis tests cover hit/miss, TTL, set/remove, serialization/version handling, cancellation, and module authorization boundaries. | Pass |
| Failure and recovery | Stop or isolate the pinned Redis instance; verify bounded request latency, authoritative-source fallback, safe invalidation behavior, degraded health, redaction, and recovery after Redis returns. | Pass |
| Security and operations | TLS/ACL and secret injection tests, key/payload policy tests, redaction tests, bounded-cardinality telemetry, liveness/readiness, and graceful shutdown evidence. | Pass |
| Performance/AOT | Any latency, throughput, trimming, or AOT statement names and passes this exact profile; no result from another provider or runner is reused. | Pass or claim is omitted |
| Release record | Immutable source/version, manifest, commands, environment, provider, generated diff, all results, recovery evidence, and limitations are archived and reproducible. | Pass |

The test suite should include separate positive, negative, failure, and recovery
fixtures and record the exact command and artifact for each run. Missing
security, provider, recovery, or absence evidence is a fail-closed gate. If
adding this capability to an existing Generated Solution changes source,
package references, configuration, or operational contracts, handle it as a
planned Platform Migration/application change; do not rerun a template over
application-owned source.

**Decision:** the capability is **Deferred / not Supported** in the current
preview surface. After implementation, it may be labeled **Experimental** only
if the generated-output and real-provider gates pass while limitations remain.
It may be called **Supported** only after every gate in the named
`modular-monolith-cache-redis-v1` profile is green with reproducible positive,
negative, failure, and recovery evidence and the profile is recorded by the
current quality policy. Until then, documentation must not promise Redis
support or production readiness.
