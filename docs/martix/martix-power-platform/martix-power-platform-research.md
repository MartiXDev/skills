<!-- markdownlint-disable MD013 MD024 -->

# Power Platform, Power Automate, flows, and custom connectors

**Research date:** 2026-08-13
**Document role:** dated, source-backed research snapshot for creating a future
`martix-power-platform` skill.  
**Primary evidence:** Microsoft Learn canonical pages, the current connector
navigation JSON, and the six-module Microsoft Learn training path.

This document is a synthesis, not a replacement for the linked product
documentation. Licensing, quotas, preview behavior, portal screens, and
certification processes are volatile and must be rechecked before implementation
or production advice.

## Executive summary

Microsoft Power Platform is a family of low-code products and shared
capabilities: Power Apps, Power Automate, Power BI, Power Pages, Copilot Studio,
Dataverse, connectors, AI Builder, Copilot capabilities, and Power Fx
([Power Platform documentation hub](https://learn.microsoft.com/en-us/power-platform/)).
Power Automate supplies cloud flows, desktop flows, and generative actions
(preview); cloud flows can be automated, instant, or scheduled
([flow types](https://learn.microsoft.com/en-us/power-automate/flow-types);
[cloud-flow overview](https://learn.microsoft.com/en-us/power-automate/overview-cloud)).

A connector is the integration boundary between an app or workflow and a
service. It exposes actions, triggers, connection parameters, schemas, and
maker-facing metadata. A custom connector is a managed wrapper around a REST
API (and, for Logic Apps, some SOAP scenarios) that lets Power Apps, Power
Automate, Copilot Studio, and Azure Logic Apps use an API like a prebuilt
connector ([connectors overview](https://learn.microsoft.com/en-us/connectors/overview);
[custom connector overview](https://learn.microsoft.com/en-us/connectors/custom-connectors/)).

The safest future skill should be a **definition-first, environment-aware
router**, not a collection of generic REST snippets. It should first identify
the target product, environment, license, API security model, authoring path,
and ALM boundary; then select the smallest applicable reference for OpenAPI,
authentication, triggers, policies, code, testing, or certification.

The most important design facts are:

- Microsoft custom connectors currently use OpenAPI/Swagger 2.0; the documented
  import limit is below 1 MB, and client-credentials OAuth is not supported.
- A solution packages the connector definition and connection references, not
  the secret-bearing connections. Target environments therefore need explicit
  connection rebinding.
- Power Automate and Logic Apps support polling and webhook triggers; Power Apps
  does not directly support connector triggers, so an app calls a flow when it
  needs event-driven behavior.
- OpenAPI extensions such as `x-ms-visibility`, `x-ms-summary`,
  `x-ms-dynamic-values`, `x-ms-dynamic-schema`, `x-ms-trigger`,
  `x-ms-capabilities`, and `x-ms-api-annotation` are part of the practical
  connector contract.
- Policies and custom C# code are runtime escape hatches. They can solve
  translation, routing, or response-shape problems, but they increase
  portability, security, test, and ALM risk.
- Current documentation contains material contradictions, including custom-code
  timeout, Postman collection version, request quotas, environment-variable
  support, OAuth redirect examples, and certification timelines. A skill must
  surface these conflicts and require a current-page check rather than invent a
  universal value.

## 1. Scope and research method

### Processed scope

The research covered:

1. The learning path
   [Build custom connectors for Microsoft Power Platform](https://learn.microsoft.com/en-us/training/paths/build-custom-connectors/),
   all six module landing pages, and all 46 listed module units.
2. Every current entry under the `custom-connectors` prefix in
   [the connector TOC](https://learn.microsoft.com/en-us/connectors/toc.json):
   58 entries on 2026-08-13, including policy-template child pages.
3. Four supplemental pages still linked from current content but absent from
   the current custom-connector TOC response: Postman import/creation,
   multiple authentication, and the OAuth permission-grant script.
4. Selected general pages for Power Platform, environments, solutions, flows,
   limits, connector architecture, data protection, and connector selection.

The complete URL inventory is maintained separately in
[`resources.md`](./resources.md).

### Evidence and uncertainty rules

- Prefer the page that owns the claim over a blog, sample, or search result.
- Treat page dates, `updated_at` metadata, preview labels, and product names as
  version signals, not permanent truths.
- Preserve conflicting current statements and identify the pages that conflict.
- Use examples as implementation evidence, not as proof that every tenant,
  region, license, connector type, or designer has the same behavior.
- Microsoft Learn page headers include `original_content_git_url` and a commit
  link. Those links are useful provenance, but the canonical Learn page was the
  evidence surface for this snapshot. Direct GitHub API access to the referenced
  MicrosoftDocs repositories was not available in this session.

## 2. Power Platform foundations

### Product and capability map

The Power Platform hub describes these product surfaces:

| Surface | Relevance to this skill |
| --- | --- |
| Power Apps | Canvas/model-driven apps can call connector actions and invoke flows. |
| Power Automate | Cloud and desktop workflow orchestration; the primary custom-connector flow host. |
| Power BI | Analytics surface; usually a handoff unless automation directly feeds a report. |
| Power Pages | External-facing websites; connector use is a boundary to verify separately. |
| Copilot Studio | Agents and agent flows can use connector actions. |
| Dataverse | Optional environment database and solution/ALM/security foundation. |
| Connectors | The operation, authentication, schema, and runtime integration boundary. |
| AI Builder, Copilot, Power Fx | Shared capabilities that may be adjacent to a flow or app. |

Source: [Microsoft Power Platform documentation hub](https://learn.microsoft.com/en-us/power-platform/).

### Environments are the first boundary

An environment is a tenant-bound, geographically located container for
business data, apps, chatbots, connections, gateways, and flows. It can have
zero or one Dataverse database. Resources created in one environment normally
use data sources and connections in that same environment; moving resources is
an ALM operation, not an implicit cross-environment reference.

The current environment overview identifies production, default, sandbox,
trial, developer, and Dataverse for Teams environment types. Environment Maker
can create apps, connections, custom connectors, and flows. Environment Admin
can manage resources, roles, Dataverse provisioning, and data-loss-prevention
policies. The default environment is intended for experimentation and should
not be treated as a production boundary.

Source: [Power Platform environments overview](https://learn.microsoft.com/en-us/power-platform/admin/environments-overview).

For a future skill, every mutation or deployment recipe should ask the agent
to determine:

- environment name and region;
- whether Dataverse is provisioned;
- maker/admin permissions;
- license and premium-connector availability;
- whether a solution, VNet, gateway, DLP policy, or managed environment is
  involved;
- whether the API endpoint is public, gateway-reachable, or VNet-connected.

### Connector architecture

The connector architecture page models:

- **Actions:** user- or flow-invoked operations such as read, create, update,
  or delete.
- **Triggers:** polling or push events that start a Logic Apps workflow or
  Power Automate flow.
- **Credential and metadata store:** connector metadata, connection ACLs, and
  credentials.
- **Connector runtime:** Azure API Management hosts Swagger and policies and
  validates keys, tokens, certificates, and other credentials; connector web
  applications run in an App Service Environment.

Sources: [connectors architecture](https://learn.microsoft.com/en-us/connectors/connector-architecture);
[connectors overview](https://learn.microsoft.com/en-us/connectors/overview).

## 3. Power Automate and flows

### Flow types

Power Automate documents three broad flow surfaces:

1. **Cloud flows:** automate cloud services and APIs.
2. **Desktop flows:** automate web or desktop UI activity.
3. **Generative actions (preview):** describe intent and let AI select an
   action sequence.

Cloud flows have three authoring types:

| Type | Triggering model | Typical use |
| --- | --- | --- |
| Automated | An event from a connector or service | A new item, message, file, or status change |
| Instant | A button, app, or manual invocation | A user-requested operation |
| Scheduled | A recurrence | A periodic synchronization or report |

The new cloud-flow designer can use Copilot; the classic designer remains a
separate authoring path. A future skill must not assume that screenshots,
designer labels, or Copilot availability are stable.

Sources: [What is Power Automate?](https://learn.microsoft.com/en-us/power-automate/flow-types);
[Overview of cloud flows](https://learn.microsoft.com/en-us/power-automate/overview-cloud).

### Runtime model

A cloud flow is a graph whose first executable boundary is a trigger and whose
subsequent nodes are connector actions, built-in actions, control scopes, and
expressions. Connections supply credentials; OpenAPI schemas supply parameter
and output shapes; dynamic content maps values between operations. Run history
contains per-action status, inputs, outputs, retry information, and errors.

The important distinction is:

- A **connector definition** describes operations and how a connection is made.
- A **connection** is a credential-bearing instance in an environment.
- A **connection reference** is a solution component that points a flow/app to
  a target connection without packaging its secret.
- A **flow** composes triggers, actions, control logic, and connector calls.

This distinction is central to deployment and troubleshooting. A working
connector definition does not prove that a target environment has a valid
connection, connection reference, DLP route, license, or API permission.

### Operational limits that affect design

The current [Power Automate limits page](https://learn.microsoft.com/en-us/power-automate/limits-and-config)
documents, among others:

| Area | Current documented value | Design implication |
| --- | ---: | --- |
| Actions per flow definition | 500 | Split large graphs into child flows or smaller units. |
| Action nesting | 8 levels | Avoid deeply nested control scopes. |
| Variables | 250 | Prefer structured objects, child flows, and connector-side filtering. |
| Expression length | 8,192 characters | Move complex transformation into a policy, API, or child flow. |
| Run duration | 30 days | Do not use a cloud flow as an unbounded worker. |
| Run-history retention | 30 days | Export operational evidence when longer retention is required. |
| Recurrence interval | 60 seconds minimum, 500 days maximum | Validate the connector and plan-specific behavior too. |
| Apply to each items | 5,000 on Low, 100,000 on other profiles | Filter or page large result sets. |
| Apply to each concurrency | 1 by default; configurable to 1-50 | Tune only after checking API throttling and ordering requirements. |
| Synchronous inbound/outbound request | 120 seconds | Use asynchronous polling or a durable pattern for long work. |
| Message size | 100 MB; up to 1 GB with supported chunking | Confirm connector and API chunking support. |
| Custom connector calls | 500 requests/minute per connection on this page | Also check the custom-connector FAQ; current docs disagree on some quotas. |

The same page states that custom-connector flows require a premium or trial
license. Power Platform request limits, connector-specific limits, retries,
pagination, and failed actions all affect capacity. Never use a limit from a
different plan or product as a universal guarantee.

### Flow reliability checklist

For a flow using a custom connector:

1. Identify trigger cardinality and whether it is polling or push.
2. Define idempotency and duplicate-event behavior.
3. Bound pagination, loop counts, concurrency, and payload size.
4. Configure retry behavior only when the operation is safe to retry.
5. Use asynchronous API patterns for work longer than the request timeout.
6. Capture correlation IDs and safe diagnostic properties, not secrets.
7. Test the connector operation independently before testing the entire flow.
8. Inspect raw inputs and outputs in a nonproduction environment.

## 4. Custom connector concept and lifecycle

### What a custom connector is

A custom connector is a wrapper around a REST API that turns API operations
into discoverable actions and triggers for Power Automate, Power Apps, Copilot
Studio, and Logic Apps. It can supply:

- operation paths, HTTP methods, parameters, bodies, responses, and schemas;
- connection parameters and authentication metadata;
- maker-facing summaries, visibility, and dynamic design-time pickers;
- polling or webhook trigger behavior;
- policies for request/response transformation and routing;
- optional C# custom code;
- an optional lightweight test-connection operation.

The documented lifecycle is:

1. Build or identify the API.
2. Secure the API.
3. Describe it with OpenAPI, a Postman collection, the maker portal, or CLI
   files.
4. Create, refine, and test the connector.
5. Use it in a flow, app, Logic Apps workflow, or agent.
6. Share it internally when needed.
7. Certify it if public availability is required.

Source: [Custom connectors overview](https://learn.microsoft.com/en-us/connectors/custom-connectors/).

### API and access prerequisites

The training path assumes basic Power Platform knowledge and familiarity with
Power Apps and Logic Apps. Authenticated-API exercises assume Power Platform
and Power Automate experience. Solution exercises assume a test environment
with Dataverse.

The API should have:

- a stable HTTPS host and documented base path;
- explicit success and error response schemas;
- an authentication model compatible with the connector;
- deterministic operation IDs and stable parameter names;
- a testable nonproduction endpoint;
- clear rate limits, pagination, idempotency, and webhook semantics.

Public APIs can be hosted with Azure Functions, App Service, or API
Management. Private APIs can use the on-premises data gateway where the
connector scenario supports it. Logic Apps additionally documents SOAP
connector creation from WSDL.

### Authoring paths

**Blank designer.** The Power Automate and Power Apps wizard has General,
Security, Definition, optional Code, and Test areas. General settings include
icon, description, scheme, host, and base URL. The API key, host, and base URL
must match the backend.

**OpenAPI import.** Microsoft documents OpenAPI/Swagger 2.0 for custom
connector creation. The definition supplies host, base path, schemes, security
definitions, paths, parameters, responses, and schemas. The designer can
refine the imported definition.

**Postman import.** Current documentation is inconsistent: one tutorial
describes exporting Collection v1, while the FAQ says Collection v2 support
exists. Treat the import format as a current-portal check, not a hard-coded
automation assumption.

**CLI and source control.** `paconn` works with:

- `apiDefinition.swagger.json`;
- `apiProperties.json`;
- `icon.png`;
- optional `script.csx`;
- optional `settings.json`.

Typical commands are:

```text
paconn login
paconn download
paconn create --api-prop apiProperties.json --api-def apiDefinition.swagger.json
paconn update --api-prop apiProperties.json --api-def apiDefinition.swagger.json
paconn validate --api-def apiDefinition.swagger.json
```

Use a nonproduction environment, keep definitions in source control, and
validate before updating a shared connector. The documented CLI login path uses
device code; the CLI page does not document service-principal authentication.

Sources: [Create from scratch](https://learn.microsoft.com/en-us/connectors/custom-connectors/define-blank);
[Create from an OpenAPI definition](https://learn.microsoft.com/en-us/connectors/custom-connectors/define-openapi-definition);
[paconn CLI](https://learn.microsoft.com/en-us/connectors/custom-connectors/paconn-cli);
[custom connector FAQ](https://learn.microsoft.com/en-us/connectors/custom-connectors/faq).

## 5. Authentication and connection parameters

### Supported models

The documented models are:

| Model | Connector behavior | Main risk |
| --- | --- | --- |
| Anonymous | No credential is collected | Unsafe for any non-public API |
| Basic | Username and password are sent over HTTPS | Secret rotation and password exposure |
| API key | Key is injected into a header or query parameter | Key leakage, rotation, and URL logging |
| OAuth 2.0 | User authorizes, connector stores/refreshes tokens | Redirect, consent, scope, and provider drift |
| Microsoft Entra ID | Delegated identity for an API and connector app | App registrations, consent, tenant, and audience |
| Windows/gateway scenario | Training covers gateway-oriented authentication | Verify connector and gateway support in the target environment |

Sources: [connection parameters](https://learn.microsoft.com/en-us/connectors/custom-connectors/connection-parameters);
[authenticated APIs training unit](https://learn.microsoft.com/en-us/training/modules/configure-custom-connectors-api/2-authentication).

### API key and Basic authentication

For an API key, define the user-facing label, the exact parameter name expected
by the service, and whether it is sent in a header or query string. Use HTTPS
and avoid query-string keys where logs, proxies, or browser history can expose
them. Basic authentication must also use HTTPS and should be paired with
rotation and least-privilege credentials.

### OAuth 2.0

Generic OAuth configuration normally includes client ID, client secret,
authorization URL, token URL, refresh URL, optional scope, and a redirect URI.
The connector uses the redirect URI to complete authorization and refreshes
short-lived access tokens without asking the user to sign in for every call.
The connector platform does **not** support the OAuth client-credentials grant.

New OAuth connectors use a per-connector redirect URI. Older documentation and
some certification examples still show global or legacy redirect settings.
Copy the redirect URI generated for the actual connector instance and register
that value with the provider; do not copy a stale global URL from an old sample.

Sources: [OAuth connection parameters](https://learn.microsoft.com/en-us/connectors/custom-connectors/connection-parameters);
[OAuth troubleshooting](https://learn.microsoft.com/en-us/connectors/custom-connectors/troubleshoot-oauth2);
[custom connector overview](https://learn.microsoft.com/en-us/connectors/custom-connectors/).

### Microsoft Entra ID

The delegated design generally has:

1. An app registration representing and protecting the API.
2. An app registration representing the connector.
3. Delegated permission from the connector app to call the API on behalf of
   the signed-in user.

The current tutorial requires an Azure subscription, Power Automate account,
sample OpenAPI definition, app registrations, delegated permissions, client
ID/secret unless managed identity is used, and a redirect URI copied from the
connector. Managed identity guidance is tenant-specific: the current tutorial
requires a single-tenant client application and a real tenant GUID; importing
into another environment can create a new managed identity that must be added
to the API's allowed identities.

Source: [Authenticate with Microsoft Entra ID](https://learn.microsoft.com/en-us/connectors/custom-connectors/azure-active-directory-authentication).

### Multiple authentication

Multiple choices are represented in `apiProperties.json` using
`connectionParameterSets`. The current docs state that the wizard does not
create multi-auth connectors; the CLI is the documented path. Each set needs
its own required UI constraints. Preserve existing connection parameters when
migrating an existing certified connector.

Source: [multiple authentications](https://learn.microsoft.com/en-us/connectors/custom-connectors/multi-auth).

## 6. OpenAPI definition and Microsoft extensions

### Core OpenAPI 2.0 contract

The practical custom-connector definition should contain:

1. `swagger` version.
2. `info` metadata.
3. `host` and `schemes`.
4. `consumes` and `produces`.
5. `paths`.
6. reusable `definitions`.
7. reusable parameters where appropriate.

Use unique, stable, PascalCase `operationId` values; clear summaries and
descriptions; explicit successful responses; correct MIME types; reusable
`$ref` schemas; and exact input/output types. The definition and Postman
artifacts must be below 1 MB.

OpenAPI 3.0 is not documented as supported for custom connector creation. Do
not silently convert an OpenAPI 3 document and assume semantic equivalence;
first adapt and validate it as Swagger 2.0.

Sources: [coding standards](https://learn.microsoft.com/en-us/connectors/custom-connectors/coding-standards);
[OpenAPI definition](https://learn.microsoft.com/en-us/connectors/custom-connectors/define-openapi-definition);
[FAQ](https://learn.microsoft.com/en-us/connectors/custom-connectors/faq).

### Maker-facing metadata

| Extension | Purpose and guidance |
| --- | --- |
| `x-ms-summary` | Human-readable label for a parameter or response property. |
| `x-ms-visibility` | `important`, `advanced`, `internal`, or normal (`none`/missing). |
| `x-ms-api-annotation` | Operation status, family, revision, and lifecycle metadata. |
| `x-ms-operation-context` | Supplies an operation context for trigger-style testing. |
| `x-ms-capabilities` | Test connection and chunk-transfer capabilities. |
| `x-ms-trigger` | Marks a trigger as `single` or `batch`. |
| `x-ms-trigger-hint` | Documents how a trigger can be fired. |
| `x-ms-notification-content` | Webhook notification body schema. |
| `x-ms-notification-url` | Identifies the callback URL parameter. |
| `x-ms-url-encoding` | Selects single or double path-parameter encoding. |
| `x-ms-dynamic-values` | Legacy-compatible design-time dropdown. |
| `x-ms-dynamic-list` | Newer, more explicit dynamic-list form. |
| `x-ms-dynamic-schema` | Legacy-compatible runtime-generated schema. |
| `x-ms-dynamic-properties` | Newer dynamic-schema form. |

Required parameters marked `internal` need default values because makers cannot
enter them. Use `advanced` for optional complexity, not for a required value
that the flow designer must understand.

Source: [OpenAPI extensions](https://learn.microsoft.com/en-us/connectors/custom-connectors/openapi-extensions).

### Dynamic values

`x-ms-dynamic-values` invokes another connector operation to populate a
maker-facing list. The important fields identify the operation, its parameter
values, the collection path, the value path, and the title path. The newer
`x-ms-dynamic-list` format makes parameter paths less ambiguous. When older
flows must remain compatible, Microsoft recommends including both forms where
the documentation supports it.

### Dynamic schema

Dynamic schema calls a design-time operation that returns valid JSON Schema for
the parameters or response fields. The returned schema should include types,
summaries/descriptions, visibility, and required fields. The current designer
does not directly edit these extensions; use the Swagger editor or CLI.

Sources: [OpenAPI extensions - dynamic values](https://learn.microsoft.com/en-us/connectors/custom-connectors/openapi-extensions#x-ms-dynamic-values);
[dynamic schema training unit](https://learn.microsoft.com/en-us/training/modules/custom-connectors-open-api/4-dynamic-schema).

### Test connection and chunk transfer

A test connection should be a lightweight GET that returns HTTP 200 and is
usually `internal`. The capability points to it by operation ID:

```json
"x-ms-capabilities": {
  "testConnection": {
    "operationId": "TestMyApiConnection",
    "parameters": {}
  }
}
```

Chunk transfer requires backend support, `x-ms-capabilities.chunkTransfer: true`
on the operation, and **Allow chunking** enabled on the flow action.

Sources: [test connection](https://learn.microsoft.com/en-us/connectors/custom-connectors/test-connection);
[OpenAPI extension training unit](https://learn.microsoft.com/en-us/training/modules/custom-connectors-open-api/2-open-api-extensions).

## 7. Triggers

Connector triggers are supported in Power Automate cloud flows and Logic Apps,
not directly in Power Apps. An app can call a flow that contains the event
trigger.

### Webhook/push trigger

A webhook connector normally needs:

1. A registration POST endpoint.
2. A notification payload schema.
3. A DELETE endpoint for deregistration.
4. HTTP 201 from successful registration.
5. A `Location` header identifying the subscription.
6. A callback URL parameter marked with `x-ms-notification-url`.
7. `x-ms-trigger: single` for one notification event.

The platform registers the subscription when a trigger is added or updated and
deletes it when the flow or trigger is removed. Missing DELETE support or a
usable `Location` header can leave orphaned subscriptions. The service must
validate callback authenticity and handle duplicate notifications.

Sources: [webhook trigger tutorial](https://learn.microsoft.com/en-us/connectors/custom-connectors/create-webhook-trigger);
[webhook trigger training unit](https://learn.microsoft.com/en-us/training/modules/create-triggers-custom-connectors/2-webhook-trigger).

### Polling trigger

A polling trigger needs an API retrieval operation, a state or filter value,
results sorted so the newest state is first, a collection property, and an
expression that extracts the next state. The connector runtime maintains the
state; the API does not need to store connector state.

Common responses are 202 when there is no new data, a retry interval or state
value, and 200 with a collection when new records exist. The body must be an
object containing an array property rather than a raw array. Use
`x-ms-trigger: batch` and Split On when each returned record should start or
feed separate processing.

Training examples mention intervals around one or two minutes. These are
examples, not an SLA; scheduling is system-controlled and may vary by product,
region, load, and plan.

Sources: [polling trigger tutorial](https://learn.microsoft.com/en-us/connectors/custom-connectors/create-polling-trigger);
[polling trigger training unit](https://learn.microsoft.com/en-us/training/modules/create-triggers-custom-connectors/5-polling-trigger).

## 8. Policies

Policies change request or response behavior at runtime. They live in
`apiProperties.json` under `policyTemplateInstances`, can target all operations
or selected actions/triggers, and execute in order. Order matters when one
policy changes a value consumed by another.

The current policy family includes:

| Policy | Use |
| --- | --- |
| Convert array to object | Key an object by a selected property. |
| Convert object to array | Turn object properties into array entries. |
| Delimited string to array | Parse a delimited string into child objects. |
| Route request | Change relative path and optionally method. |
| Set connection unauthenticated | Mark a connection unauthenticated for a selected status. |
| Set value from URL | Resolve a value from another endpoint into a header/query parameter. |
| Set host URL | Replace the host from connection, header, or query values. |
| Set HTTP header | Add or update request, response, or failure headers. |
| Set property | Add or update a body property from constants or expressions. |
| Set query parameter | Add or update a query parameter with override, skip, or append behavior. |
| Expressions | Read selected headers, query values, connection parameters, and runtime values. |

Common documented expression forms include:

```text
@headers('headerName')
@queryParameters('queryParameterName')
@connectionParameters('connectionParameterName')
@body().property
@environmentVariables("environmentVariableName")
```

Expression support is template-specific. In particular, the training material
allows `@body()` for Set Property but says other expression forms are not
supported in that field. Do not assume that an expression accepted by one
policy is accepted by every policy.

Sources: [policy overview](https://learn.microsoft.com/en-us/connectors/custom-connectors/policy-templates);
[policy expressions](https://learn.microsoft.com/en-us/connectors/custom-connectors/policy-templates/expressions/expressions);
[policy training module](https://learn.microsoft.com/en-us/training/modules/policy-templates-custom-connectors/).

## 9. Custom C# code

Custom code is an optional C# transformation or operation implementation. It
can inspect or change requests and responses, call additional endpoints, or
implement an operation without using its normal declared backend path.

The required shape is based on `ScriptBase`:

```csharp
public class Script : ScriptBase
{
    public override Task<HttpResponseMessage> ExecuteAsync()
    {
        // Select behavior with Context.OperationId.
        // Inspect or modify Context.Request.
        // Call the backend with Context.SendAsync(...).
        // Return a response.
    }
}
```

Use `Context.OperationId` for operation-specific branching,
`Context.Request` for the current request, `Context.SendAsync` for backend
calls, `Context.Logger` where available, the cancellation token, and
`CreateJsonContent` for JSON response content. When code is enabled, it takes
precedence over the codeless definition; explicitly forward operations that
should retain normal behavior.

The current documentation describes .NET Standard 2.0, common System/HTTP/XML/
regex/compression namespaces, logging, and Newtonsoft JSON. Custom assemblies
cannot be referenced. The script is limited to 1 MB and one script file/class.
Custom code is not supported with the on-premises data gateway, and
`Context.SendAsync` cannot reach private VNet endpoints because it uses a
public endpoint.

There is a direct documentation conflict on timeout: the training material
says fewer than five seconds, while the current `write-code` FAQ says newly
created connectors have a two-minute timeout and existing connectors need an
update to receive the newer timeout. Treat the current FAQ and target tenant
behavior as authoritative for a concrete deployment, and keep transformations
small regardless.

Sources: [write code in a custom connector](https://learn.microsoft.com/en-us/connectors/custom-connectors/write-code);
[custom-code training module](https://learn.microsoft.com/en-us/training/modules/custom-code-connectors/);
[create from scratch](https://learn.microsoft.com/en-us/connectors/custom-connectors/define-blank).

## 10. Testing and validation

### Designer test

The documented maker test loop is:

1. Create or update the connector.
2. Open **Test**.
3. Create or select a connection.
4. Refresh connections.
5. Select an operation.
6. Enter required values.
7. Run **Test operation**.
8. Inspect status, headers, body, and raw outputs.

API-key connectors may take several minutes after creation before testing
works. Use a dedicated test account and nonproduction API data. Verify both
success and representative failures, including expired credentials, malformed
payloads, authorization failures, throttling, and empty collections.

### Static validation

Place the connector in an unmanaged solution and run Solution Checker. The
custom-connector validator checks issues such as duplicate or missing operation
IDs, invalid paths, missing path parameters, multiple body parameters, missing
successful responses, invalid dynamic references, invalid notification
extensions, duplicate revisions, excessive schemas, invalid MIME types, and
status/revision inconsistencies.

Sources: [validate a custom connector](https://learn.microsoft.com/en-us/connectors/custom-connectors/validate-custom-connector);
[Swagger validator rules](https://learn.microsoft.com/en-us/connectors/custom-connectors/certification-swagger-validator-rules).

### Local code validation

For custom code, copy the supporting `ScriptBase` and `IScriptContext`
definitions into a local project and compile before uploading. Test operation
selection, normal forwarding, cancellation, response headers, error mapping,
and JSON serialization independently.

## 11. Using the connector

### Power Automate

A flow uses a custom connector like a built-in connector:

1. Open the target environment and create or open a flow.
2. Add a trigger or action.
3. Select the **Custom** category and connector.
4. Create or select a connection.
5. Enter static values or dynamic content.
6. Save and test.
7. Inspect run history and raw outputs.

Schema quality matters. If an operation returns an array, the designer may
automatically create **Apply to each**, even when the maker expects one logical
request. Use exact schemas and test the generated flow shape.

Source: [use a custom connector from a flow](https://learn.microsoft.com/en-us/connectors/custom-connectors/use-custom-connector-flow).

### Power Apps

Power Apps calls connector actions as Power Fx functions. A custom connector
trigger is not directly supported in an app; use a flow for event-driven
behavior. Keep the connector action response shape stable and avoid exposing
implementation-only fields that create brittle formulas.

Source: [use a custom connector from Power Apps](https://learn.microsoft.com/en-us/connectors/custom-connectors/use-custom-connector-powerapps).

### Logic Apps

Logic Apps custom connectors are Azure resources created in the relevant
subscription and region. The Logic Apps connector creation path requires an
OpenAPI 2.0 definition. The separate SOAP path uses WSDL and currently does not
support one-way operations.

Sources: [use a custom connector in Logic Apps](https://learn.microsoft.com/en-us/connectors/custom-connectors/use-custom-connector-logic-apps);
[create a Logic Apps connector](https://learn.microsoft.com/en-us/connectors/custom-connectors/create-logic-apps-connector);
[SOAP connector](https://learn.microsoft.com/en-us/connectors/custom-connectors/create-register-logic-apps-soap-connector).

### Copilot Studio

Connectors are part of the shared platform and current connector documentation
links to Copilot Studio agent use. Treat agent-specific authoring, grounding,
authentication, and action-confirmation behavior as a separate handoff to
Copilot Studio documentation; this research only establishes the connector
operation boundary.

## 12. Solutions, environment variables, and ALM

### Solution model

Solutions are the Power Platform ALM mechanism. Unmanaged solutions are the
development source; managed solutions are deployed to downstream environments.
Solutions also carry publishers, components, dependencies, and lifecycle
operations such as update, upgrade, and patch.

For custom connectors:

- the connector definition and connection references can be included;
- the credential-bearing connection is not included;
- target users must select or create a target-environment connection;
- import order matters: connector, then connection references, then dependent
  flows/apps;
- role assignments are not preserved automatically;
- solution custom connectors use Dataverse role-based security;
- custom connectors are not available in classic solution explorer.

Source: [custom connectors in solutions](https://learn.microsoft.com/en-us/connectors/custom-connectors/customconnectorssolutions);
[solution concepts with Power Platform](https://learn.microsoft.com/en-us/power-platform/alm/solution-concepts-alm).

### Environment variables

The custom-connector environment-variable page documents values for host, base
URL, client ID, client secret, login URL, and refresh URL. Values are resolved
when the connector is saved; changing a variable does not automatically update
the connector, so resave it.

Do not place client secrets in ordinary text variables. The page recommends
Azure Key Vault for secret values. There is a documentation inconsistency:
the environment-variable page says actions, triggers, and policies do not
directly support environment variables, while policy documentation exposes
`@environmentVariables(...)`. Validate the exact supported location in the
target service before designing around it.

Source: [environment variables in solution custom connectors](https://learn.microsoft.com/en-us/connectors/custom-connectors/environment-variables).

### Dataverse Web API

The solution custom-API page documents:

```text
GET    /connectors
GET    /connectors(<guid>)
POST   /connectors
PATCH  /connectors(<guid>)
DELETE /connectors(<guid>)
```

Create requires values such as `connectorid`, `name`, `displayname`,
`openapidefinition`, and `connectortype: 1`. Secrets are not stored in
Dataverse; secret values are blanked and must be supplied through the supported
UI or connection process.

Source: [manage solution custom connectors with Dataverse APIs](https://learn.microsoft.com/en-us/connectors/custom-connectors/solution-custom-api).

## 13. Versioning and breaking changes

Operational versioning uses:

- `deprecated`;
- `x-ms-api-annotation.status`;
- `family`;
- `revision`;
- `expires`;
- `x-ms-visibility`.

For a breaking operation, use a new operation ID and path where necessary,
increase the revision, publish the new operation initially as Preview, and
deprecate the old operation only after migration. Deprecated operations remain
functional for existing flows/apps but are hidden from new designer experiences.

Certified-connector breaking changes include removing an authentication method
or connection parameter, deleting/hiding operations, deleting output fields,
changing output types or formats, removing response schemas, changing required
status, or changing the connector tier to Premium. Preserve existing
connection parameters during multi-auth migration.

Sources: [operational versioning](https://learn.microsoft.com/en-us/connectors/custom-connectors/operational-versioning);
[deprecate an operation](https://learn.microsoft.com/en-us/connectors/custom-connectors/deprecate-operation);
[update a certified connector](https://learn.microsoft.com/en-us/connectors/custom-connectors/certification-updates).

## 14. Security, data protection, and networking

### Data protection

The service, not the connector label alone, determines where data is ultimately
stored and which privacy policy governs it. Microsoft validates connectors that
leave Microsoft infrastructure, but an external service controls its own
retention, geography, privacy, and GDPR obligations. Power Platform connector
processing follows the selected geography boundary; an external service may
then process the data under its own policy.

At runtime, the platform validates the user's permission and retrieves the
token or secret needed for the call. Basic credentials are encrypted in the
internal token store; OAuth user credentials are not stored as raw passwords,
but access tokens are stored for connector use.

Source: [data protection in connectors](https://learn.microsoft.com/en-us/connectors/protection).

### VNet behavior

For an environment linked to a virtual network:

- custom connectors created before VNet association must be resaved;
- triggers returning a `Location` header but not calling back into the
  connector are unsupported;
- OAuth and token requests do not transit the linked VNet;
- API endpoint requests do transit the linked VNet;
- custom-code `Context.SendAsync` uses a public endpoint and cannot reach
  private VNet endpoints.

Source: [custom connector overview](https://learn.microsoft.com/en-us/connectors/custom-connectors/);
[custom connector code](https://learn.microsoft.com/en-us/connectors/custom-connectors/write-code).

### DLP and boundary checks

Environment admins can configure data-loss-prevention policies. A future skill
must tell the user to check DLP connector groups, environment role access,
gateway/VNet reachability, tenant geography, and external-service privacy
before concluding that a connector is deployable.

## 15. Limits and conflicts to surface

The following values are useful design guards, not eternal constants:

| Area | Evidence and current statement |
| --- | --- |
| Definition size | OpenAPI/Postman definition below 1 MB in the custom-connector FAQ. |
| Swagger body schemas | FAQ documents a maximum of 512. |
| Operations | FAQ documents a maximum of 256. |
| Schemas per operation | FAQ documents 16,384. |
| Custom code | 1 MB; one script file/class. |
| Logic Apps custom connectors | FAQ documents 1,000 per Azure subscription. |
| Power Platform custom-connector calls | The FAQ and Power Automate limits page currently show different per-connection values (10,000 vs 500 requests/minute). |
| Custom-code timeout | Training says under five seconds; current FAQ says two minutes for new connectors. |
| Postman | One current tutorial says Collection v1; FAQ says v2 support exists. |
| Environment variables | Connector page restricts direct use in actions/triggers/policies; policy docs expose an environment-variable expression. |
| Certification timeline | Current pages state estimates ranging from 10-14 days to 15 business days or 5-6 weeks. |
| OAuth redirect | Current overview favors per-connector redirect URIs; older examples retain legacy global settings. |

When a task approaches a limit or depends on a preview feature, the skill
should load the current page, quote the relevant product/plan scope, and ask
the implementer to validate in a test environment.

Sources: [custom connector FAQ](https://learn.microsoft.com/en-us/connectors/custom-connectors/faq);
[custom connector code](https://learn.microsoft.com/en-us/connectors/custom-connectors/write-code);
[Power Automate limits](https://learn.microsoft.com/en-us/power-automate/limits-and-config).

## 16. Sharing and certification

### Internal sharing

Power Apps and Power Automate custom connectors are private to the creator by
default. They can be shared with users or groups with **Can view** or
**Can edit** permissions. Sharing an app or team flow can make the connector
usable within that resource. Logic Apps visibility is tied to the author,
tenant, Azure subscription, and region. Deleting a shared connector deletes its
associated connections, so dependency checks are mandatory before deletion.

Source: [share a custom connector](https://learn.microsoft.com/en-us/connectors/custom-connectors/share).

### Public certification

Certification is required for public connector availability. Preparation
guidance calls for supported authentication, support contact, production HTTPS
host, valid OpenAPI 2.0, a unique English title of no more than 30 characters,
a 30-500 character description, exact response schemas, TLS 1.2 or higher, no
secrets in submitted files, a test flow and solution, introduction/readme
documentation, and the required package structure.

Verified publishers own or have rights to the underlying service and submit
through Partner Center. Independent publishers do not own the service and
follow the independent-publisher process, including verified credentials.

The certification test process requires coverage of all actions, triggers, and
fields. Current pages disagree on deployment duration; treat published
estimates as nonbinding. Preview-to-GA criteria include a production backend,
99.95% availability, 99.5% SLO, and more than 80% success rate; recommended
usage criteria are also documented.

Sources: [certification overview](https://learn.microsoft.com/en-us/connectors/custom-connectors/submit-certification);
[certification preparation](https://learn.microsoft.com/en-us/connectors/custom-connectors/certification-submission);
[verified publisher process](https://learn.microsoft.com/en-us/connectors/custom-connectors/submit-for-certification);
[independent publisher process](https://learn.microsoft.com/en-us/connectors/custom-connectors/certification-submission-ip);
[certification testing](https://learn.microsoft.com/en-us/connectors/custom-connectors/certification-testing);
[preview to GA](https://learn.microsoft.com/en-us/connectors/custom-connectors/certification-to-ga).

## 17. Recommended future `martix-power-platform` skill

### Activation and boundaries

Activate for:

- Power Platform environments, solutions, Dataverse, and ALM;
- Power Automate cloud-flow design, troubleshooting, limits, and run history;
- custom connector authoring, OpenAPI 2.0, `x-ms-*` extensions, `paconn`;
- API key, Basic, OAuth, Microsoft Entra ID, managed identity, and redirect URI
  decisions;
- polling/webhook triggers, policy templates, custom C# code, test connection,
  dynamic values/schema, validation, sharing, or certification.

Do not make this skill the default for generic REST API implementation,
general Azure API Management, generic C# development, desktop UI automation,
Power BI modeling, or Copilot Studio agent design. Use clear handoffs.

### Progressive-disclosure layout

The future standalone package should keep `SKILL.md` as a compact router and
place detail in package-local references:

| Reference | Load when |
| --- | --- |
| Flow fundamentals | The task changes a flow type, trigger, action graph, limits, or run behavior. |
| Environment and ALM | The task crosses environments, solutions, connection references, or variables. |
| Connector authoring | The task creates or imports a connector. |
| Authentication | The task configures API keys, OAuth, Entra, managed identity, or redirects. |
| OpenAPI extensions | The task changes schemas, visibility, dynamic fields, triggers, or capabilities. |
| Triggers | The API is webhook- or polling-driven. |
| Policies | The API needs runtime routing or data conversion. |
| Custom code | Codeless OpenAPI and policies cannot express the transformation. |
| Testing and troubleshooting | A connector or flow fails, throttles, or returns a wrong shape. |
| Certification | The user wants public publishing or preview-to-GA. |

Keep the complete source map in a reference file and retain the resource
inventory from [`resources.md`](./resources.md) as a refresh checklist.

### Safe workflow

1. Inspect the repository and confirm the target product (Power Automate,
   Power Apps, Logic Apps, or Copilot Studio).
2. Resolve the target environment, role, region, Dataverse state, license,
   DLP/gateway/VNet boundary, and solution status.
3. Inspect the API contract, authentication grant, endpoint reachability,
   pagination, idempotency, webhook lifecycle, and rate limits.
4. Choose the smallest authoring path: blank designer, OpenAPI 2.0, Postman
   after current-format verification, CLI, or solution/API automation.
5. Define stable operations, schemas, summaries, visibility, success responses,
   and error behavior before adding policies or code.
6. Add only the required `x-ms-*` extensions and validate dynamic references.
7. Test authentication, test connection, every operation, representative
   failures, array behavior, retries, and long-running work.
8. Run Swagger validation and Solution Checker in a nonproduction environment.
9. Package the connector in an unmanaged solution, bind connection references
   and environment values in the target, and export/import as managed where
   appropriate.
10. Version breaking operations instead of mutating a live contract; monitor
    runs, API responses, and connector quotas after deployment.

### Skill eval cases

The eventual skill should be evaluated on:

- choosing automated vs instant vs scheduled cloud flows;
- identifying a missing premium license;
- converting an OpenAPI 3 input into a validated OpenAPI 2.0 connector;
- rejecting client-credentials OAuth and selecting delegated Entra guidance;
- designing a webhook with registration, callback, `Location`, and DELETE;
- designing a polling trigger with state and batch response shape;
- choosing dynamic values versus dynamic schema;
- deciding between an OpenAPI extension, policy, and custom code;
- preserving connection references while excluding secrets from a solution;
- surfacing custom-code timeout and quota documentation conflicts;
- versioning a breaking operation instead of silently changing a published schema;
- refusing to claim VNet-private custom-code support;
- separating generic REST, Azure, Power Apps, Logic Apps, and Copilot Studio
  handoffs from connector-specific guidance.

## 18. High-value source set

The complete inventory is in [`resources.md`](./resources.md). The most
important entry points for implementation are:

- [Power Platform documentation hub](https://learn.microsoft.com/en-us/power-platform/)
- [Power Platform environments overview](https://learn.microsoft.com/en-us/power-platform/admin/environments-overview)
- [Solution concepts with Power Platform](https://learn.microsoft.com/en-us/power-platform/alm/solution-concepts-alm)
- [What is Power Automate?](https://learn.microsoft.com/en-us/power-automate/flow-types)
- [Overview of cloud flows](https://learn.microsoft.com/en-us/power-automate/overview-cloud)
- [Power Automate limits](https://learn.microsoft.com/en-us/power-automate/limits-and-config)
- [Connectors overview](https://learn.microsoft.com/en-us/connectors/overview)
- [Connectors architecture](https://learn.microsoft.com/en-us/connectors/connector-architecture)
- [Custom connectors overview](https://learn.microsoft.com/en-us/connectors/custom-connectors/)
- [OpenAPI extensions](https://learn.microsoft.com/en-us/connectors/custom-connectors/openapi-extensions)
- [Connection parameters](https://learn.microsoft.com/en-us/connectors/custom-connectors/connection-parameters)
- [Create polling and webhook triggers](https://learn.microsoft.com/en-us/connectors/custom-connectors/create-polling-trigger)
- [Create webhook triggers](https://learn.microsoft.com/en-us/connectors/custom-connectors/create-webhook-trigger)
- [Policy templates](https://learn.microsoft.com/en-us/connectors/custom-connectors/policy-templates)
- [Write code](https://learn.microsoft.com/en-us/connectors/custom-connectors/write-code)
- [Custom connectors in solutions](https://learn.microsoft.com/en-us/connectors/custom-connectors/customconnectorssolutions)
- [Operational versioning](https://learn.microsoft.com/en-us/connectors/custom-connectors/operational-versioning)
- [Certification preparation](https://learn.microsoft.com/en-us/connectors/custom-connectors/certification-submission)

## Conclusion

The future skill should treat a custom connector as a product contract spanning
API design, identity, OpenAPI metadata, runtime behavior, flow composition,
environment governance, ALM, and support. The most reliable path is to keep
codeless definitions and schemas explicit, use policies only for narrow
runtime adaptations, reserve custom code for cases that cannot be expressed
otherwise, test in a solution-aware nonproduction environment, and surface
current documentation conflicts instead of hiding them behind stale defaults.
