# C# Web API Medium vs xhigh Workflow Comparison

Generated on 2026-08-06. This report compares a second controlled run using `gpt-5.6-luna` at medium effort with the earlier run requested as max. The task-agent API exposed `xhigh`, not a literal `max`, for the earlier child calls; therefore the earlier baseline is labeled **xhigh/max-requested** throughout.

## Comparison setup

All eight subagents received the same library-lending ASP.NET Core Web API request: .NET 10/C# 14, books and borrowers, CRUD and checkout/return operations, in-memory persistence, DTO boundaries, cancellation-aware async APIs, validation, ProblemDetails, 400/404/409/422 behavior, concurrent double-checkout protection, and OpenAPI-friendly metadata. Each subagent produced one Markdown-only artifact containing its generated file inventory and complete C# listings. No generated `.cs` files, project directories, builds, or tests were created for the benchmark.

The four medium workflows were:

| Approach | Medium workflow aids |
| --- | --- |
| Pure LLM | None: no skill and no LSP |
| Skill-guided | `martix-dotnet-csharp` and its selected references |
| LSP-guided | C# LSP only |
| Hybrid | `martix-dotnet-csharp` plus C# LSP |

Prices are reported as AI-credit usage because local telemetry exposed `total_nano_aiu`, but no currency conversion or USD/EUR price was available. Exact token counts are sums of `assistant_usage_events` grouped by each subagent's parent task call.

## Medium-run telemetry

| Approach | Input tokens | Output tokens | Model requests | AI credits* | Usage-event span | Aggregate model-call duration |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Pure LLM | 123,342 | 7,266 | 5 | 1.311453 | 143.592 s | 51.017 s |
| Skill-guided | 202,581 | 6,356 | 8 | 1.367655 | 195.399 s | 45.972 s |
| LSP-guided | 253,097 | 8,731 | 7 | 2.590695 | 222.197 s | 54.817 s |
| Hybrid | 315,446 | 8,634 | 9 | 2.199609 | 245.458 s | 61.266 s |

\* AI credits are `total_nano_aiu / 1,000,000,000`. The usage-event span is the elapsed time between the first and last model-usage event for that workflow. Aggregate model-call duration is the sum of model-call durations and is not the same as wall-clock span. The local artifact stopwatch in several medium artifacts measured only final Markdown writing and is not used as the comparable timing metric.

## Earlier xhigh/max-requested baseline

The earlier report is preserved in `csharp-web-api-comparison.md`. Its task-agent calls recorded `xhigh`, the highest exposed child-task setting, rather than literal `max`.

| Approach | Input tokens | Output tokens | Model requests | AI credits* | Usage-event span | Aggregate model-call duration |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Pure LLM | 683,749 | 32,296 | 15 | 6.021366 | 302.246 s | 225.544 s |
| Skill-guided | 3,586,354 | 57,509 | 39 | 16.246565 | 1,042.443 s | 442.134 s |
| LSP-guided | 1,141,320 | 39,729 | 22 | 8.484783 | 581.871 s | 276.018 s |
| Hybrid | 3,521,004 | 55,684 | 46 | 17.656881 | 1,054.112 s | 432.678 s |

## Medium as a percentage of xhigh/max-requested

| Approach | Input tokens | Output tokens | AI credits | Usage-event span | Aggregate model duration |
| --- | ---: | ---: | ---: | ---: | ---: |
| Pure LLM | 18.0% | 22.5% | 21.8% | 47.5% | 22.6% |
| Skill-guided | 5.6% | 11.1% | 8.4% | 18.7% | 10.4% |
| LSP-guided | 22.2% | 22.0% | 30.5% | 38.2% | 19.9% |
| Hybrid | 9.0% | 15.5% | 12.5% | 23.3% | 14.2% |

Across the four workflows, medium used 894,466 input tokens, 30,987 output tokens, 29 model requests, and 7.469412 AI credits, versus 8,932,427 input tokens, 185,218 output tokens, 122 requests, and 48.409595 AI credits for xhigh. The medium totals were 10.0% of xhigh input tokens, 16.7% of output tokens, 15.4% of AI credits, and 15.5% of aggregate model-call duration. Because the workflows ran in parallel, the sum of individual spans is useful for comparison but is not a single end-to-end elapsed time.

## Static quality review of the medium outputs

This is a source-level review of Markdown artifacts, not a build or test result. The artifacts were intentionally not materialized as projects, so compile-time and runtime claims remain unverified.

### Ranking for the medium run

1. **Skill-guided** is the best medium result as delivered. It has the clearest service/store separation, DTO-only HTTP contracts, cloned snapshots, duplicate ISBN and email checks, explicit validation and ProblemDetails mapping, correct `201`/`204` response paths, and an atomic checkout operation. Its main correctness caveat is that uniqueness checks occur in a separate operation from insertion, and its checked-out deletion pre-check is separate from deletion; concurrent requests could therefore bypass those invariants. It also validates ISBN shape rather than check digits.
2. **Pure LLM** is the strongest low-cost baseline. Its central locked store makes checkout and uniqueness checks atomic, and its endpoint surface includes typed status decisions for the main book operations. It is less complete around borrower listing and contract detail, and its ISBN normalization removes every non-digit character before validation, so malformed input can be accepted after being silently rewritten.
3. **LSP-guided** has solid snapshots, an atomic `SemaphoreSlim` store gate, DTO boundaries, and explicit `201`, `204`, `404`, `409`, and `422` mappings. The actual LSP assistance was limited to a `workspaceSymbol` query that found no matching symbols, so it contributed little framework-specific guidance. The project snippet also uses `LangVersion=preview` instead of the requested released C# 14 setting.
4. **Hybrid** has the richest endpoint metadata and typed Minimal API results, but the medium implementation has the most important static defects: its store returns mutable domain objects from read methods and maps them after releasing the lock, creating race-prone snapshots, and it does not enforce duplicate ISBN or borrower-email uniqueness. It does atomically prevent double checkout and checked-out deletion, but the broader workflow did not compensate for these missing invariants.

### Medium versus xhigh quality

The medium run retained the core architecture across all four workflows, but it was less polished than the xhigh/max-requested run in several areas. The medium skill result remained the best overall workflow, while its xhigh counterpart had stronger time abstraction and broader defensive detail. The medium hybrid fixed the earlier xhigh hybrid's checked-out-delete omission, but introduced or retained other issues such as mutable read results and absent uniqueness checks; this shows that higher effort did not produce a uniformly better implementation and that each artifact still needs a requirement-by-requirement review.

The main quality conclusion is that medium is acceptable for generating a reviewable first draft, not for skipping verification. The savings are substantial, but the generated code should still be compiled, tested for concurrent operations, and checked against invariant cases such as duplicate ISBN/email, malformed ISBN characters, checked-out deletion, and concurrent create/update races.

## Workflow and cost observations

- The pure medium run was the cheapest and had the fewest model requests: 1.311453 AI credits and 5 requests.
- The skill medium run was unusually efficient among the aided workflows: it used fewer input tokens and credits than both LSP and hybrid while producing the strongest medium implementation.
- LSP alone did not reduce usage in this setup. It used 253,097 input tokens and 2.590695 AI credits, and its only reported workspace symbol query returned no matching repository symbols.
- Hybrid produced the broadest HTTP metadata, but it used the most medium input tokens and model requests and still missed simple domain invariants. More workflow aids increased context and output, not guaranteed correctness.
- The earlier xhigh run made far more model requests, especially for the skill and hybrid workflows. The large reduction at medium is the clearest performance/cost effect in this comparison; quality differences are real but not monotonic.

## Common implementation patterns

- All four medium agents independently used a single mutation gate or equivalent atomic store operation for checkout, so the concurrency requirement strongly shaped every design.
- Snapshot isolation separated the skill and LSP results from the hybrid result; the hybrid's mutable read objects are the main concurrency-quality outlier.
- All medium artifacts stayed within the requested ASP.NET Core/BCL dependency boundary and included a project support snippet plus source listings in Markdown.
- None of the artifacts included a compiled OpenAPI document or automated tests, so the comparison cannot certify build correctness or runtime behavior.

## Overall recommendation

For a medium-effort starting point, use the **skill-guided** artifact, then make the uniqueness checks and checked-out deletion decision atomic and add ISBN check-digit validation before compiling and testing. If the primary goal is lowest generation cost, the **pure LLM** artifact is a credible baseline, but its permissive ISBN normalization should be fixed immediately. The **hybrid** workflow is not the default recommendation for this run despite having the most aids; its read-side mutability and missing uniqueness invariants are more consequential than its richer endpoint metadata.

---

## Full medium artifacts
## Medium Approach 1 - Pure LLM

# Approach 1 — medium-pure-llm

- **Approach label:** medium-pure-llm
- **Model ID:** gpt-5.6-luna
- **Reasoning setting:** medium
- **ISO start timestamp:** 2026-08-06T03:54:55.9483761+02:00
- **ISO end timestamp:** 2026-08-06T03:55:51.8528506+02:00
- **Elapsed wall-clock duration:** 00:00:55.9044745
- **Exact input tokens:** `123,342` (sum of `input_tokens` across 5 model requests)
- **Exact output tokens:** `7,266` (sum of `output_tokens` across 5 model requests)
- **AI-credit usage:** `1.311453` AI credits (`1,311,453,000 total_nano_aiu`); currency-denominated price was not exposed.
- **Telemetry timing:** `143.592` seconds from first to last model-usage event; aggregate model-call duration `51.017` seconds.
- **Telemetry source:** Local session SQLite `assistant_usage_events`, grouped by parent task call `call_PycFhCkubE2kVYY0SUMr74LY`. The artifact stopwatch above is separate from model-call telemetry.

## File inventory

### `Library.Api/Library.Api.csproj`

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>net10.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
    <LangVersion>14.0</LangVersion>
  </PropertyGroup>
</Project>
```

### `Library.Api/Program.cs`

```csharp
using Library.Api.Endpoints;
using Library.Api.Persistence;
using Library.Api.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddProblemDetails();
builder.Services.AddSingleton<LibraryStore>();
builder.Services.AddSingleton<LibraryService>();

var app = builder.Build();

app.UseExceptionHandler();
app.UseStatusCodePages();
app.MapLibraryEndpoints();

app.Run();
```

### `Library.Api/Domain/Book.cs`

```csharp
namespace Library.Api.Domain;

public sealed class Book
{
    public Guid Id { get; init; }
    public required string Title { get; set; }
    public required string Isbn { get; set; }
    public int PublishedYear { get; set; }
    public Guid? BorrowerId { get; set; }
    public DateOnly? DueDate { get; set; }
}
```

### `Library.Api/Domain/Borrower.cs`

```csharp
namespace Library.Api.Domain;

public sealed class Borrower
{
    public Guid Id { get; init; }
    public required string Name { get; set; }
    public required string Email { get; set; }
}
```

### `Library.Api/DTOs/BookDtos.cs`

```csharp
namespace Library.Api.DTOs;

public sealed record CreateBookRequest(string? Title, string? Isbn, int PublishedYear);

public sealed record UpdateBookRequest(string? Title, string? Isbn, int PublishedYear);

public sealed record CheckoutBookRequest(Guid BorrowerId, DateOnly DueDate);

public sealed record BookResponse(
    Guid Id,
    string Title,
    string Isbn,
    int PublishedYear,
    bool IsCheckedOut,
    Guid? BorrowerId,
    DateOnly? DueDate);
```

### `Library.Api/DTOs/BorrowerDtos.cs`

```csharp
namespace Library.Api.DTOs;

public sealed record CreateBorrowerRequest(string? Name, string? Email);

public sealed record BorrowerResponse(Guid Id, string Name, string Email);
```

### `Library.Api/Persistence/LibraryStore.cs`

```csharp
using Library.Api.Domain;

namespace Library.Api.Persistence;

public sealed class LibraryStore
{
    private readonly Lock sync = new();
    private readonly Dictionary<Guid, Book> books = [];
    private readonly Dictionary<Guid, Borrower> borrowers = [];

    public TResult Read<TResult>(Func<IReadOnlyDictionary<Guid, Book>, IReadOnlyDictionary<Guid, Borrower>, TResult> action)
    {
        ArgumentNullException.ThrowIfNull(action);

        lock (sync)
        {
            return action(
                books.ToDictionary(pair => pair.Key, pair => Clone(pair.Value)),
                borrowers.ToDictionary(pair => pair.Key, pair => Clone(pair.Value)));
        }
    }

    public TResult Write<TResult>(Func<IDictionary<Guid, Book>, IDictionary<Guid, Borrower>, TResult> action)
    {
        ArgumentNullException.ThrowIfNull(action);

        lock (sync)
        {
            return action(books, borrowers);
        }
    }

    private static Book Clone(Book book) => new()
    {
        Id = book.Id,
        Title = book.Title,
        Isbn = book.Isbn,
        PublishedYear = book.PublishedYear,
        BorrowerId = book.BorrowerId,
        DueDate = book.DueDate
    };

    private static Borrower Clone(Borrower borrower) => new()
    {
        Id = borrower.Id,
        Name = borrower.Name,
        Email = borrower.Email
    };
}
```

### `Library.Api/Services/LibraryService.cs`

```csharp
using System.Net.Mail;
using Library.Api.Domain;
using Library.Api.DTOs;
using Library.Api.Persistence;

namespace Library.Api.Services;

public sealed class LibraryService(LibraryStore store)
{
    public Task<IReadOnlyList<BookResponse>> ListBooksAsync(CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var result = store.Read((books, _) => books.Values
            .OrderBy(book => book.Title, StringComparer.OrdinalIgnoreCase)
            .Select(ToResponse)
            .ToArray());
        return Task.FromResult<IReadOnlyList<BookResponse>>(result);
    }

    public Task<BookResponse?> GetBookAsync(Guid id, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var result = store.Read((books, _) => books.TryGetValue(id, out var book) ? ToResponse(book) : null);
        return Task.FromResult(result);
    }

    public Task<(BookResponse? Response, string? Error)> CreateBookAsync(
        CreateBookRequest request,
        CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var validationError = ValidateBook(request.Title, request.Isbn, request.PublishedYear);
        if (validationError is not null)
        {
            return Task.FromResult<(BookResponse?, string?)>((null, validationError));
        }

        var result = store.Write((books, _) =>
        {
            var isbn = NormalizeIsbn(request.Isbn!);
            if (books.Values.Any(book => book.Isbn == isbn))
            {
                return (null, "A book with this ISBN already exists.");
            }

            var book = new Book
            {
                Id = Guid.NewGuid(),
                Title = request.Title!.Trim(),
                Isbn = isbn,
                PublishedYear = request.PublishedYear
            };
            books.Add(book.Id, book);
            return (ToResponse(book), null);
        });

        return Task.FromResult(result);
    }

    public Task<(BookResponse? Response, string? Error)> UpdateBookAsync(
        Guid id,
        UpdateBookRequest request,
        CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var validationError = ValidateBook(request.Title, request.Isbn, request.PublishedYear);
        if (validationError is not null)
        {
            return Task.FromResult<(BookResponse?, string?)>((null, validationError));
        }

        var result = store.Write((books, _) =>
        {
            if (!books.TryGetValue(id, out var book))
            {
                return (null, "not-found");
            }

            var isbn = NormalizeIsbn(request.Isbn!);
            if (books.Values.Any(other => other.Id != id && other.Isbn == isbn))
            {
                return (null, "A book with this ISBN already exists.");
            }

            book.Title = request.Title!.Trim();
            book.Isbn = isbn;
            book.PublishedYear = request.PublishedYear;
            return (ToResponse(book), null);
        });

        return Task.FromResult(result);
    }

    public Task<string?> DeleteBookAsync(Guid id, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var error = store.Write((books, _) =>
        {
            if (!books.TryGetValue(id, out var book))
            {
                return "not-found";
            }

            if (book.BorrowerId is not null)
            {
                return "A checked-out book cannot be deleted.";
            }

            books.Remove(id);
            return null;
        });
        return Task.FromResult(error);
    }

    public Task<(BookResponse? Response, string? Error)> CheckoutAsync(
        Guid id,
        CheckoutBookRequest request,
        CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        if (request.DueDate < DateOnly.FromDateTime(DateTime.UtcNow.Date))
        {
            return Task.FromResult<(BookResponse?, string?)>((null, "The due date must be today or later."));
        }

        var result = store.Write((books, borrowers) =>
        {
            if (!books.TryGetValue(id, out var book))
            {
                return (null, "not-found");
            }

            if (!borrowers.ContainsKey(request.BorrowerId))
            {
                return (null, "borrower-not-found");
            }

            if (book.BorrowerId is not null)
            {
                return (null, "The book is already checked out.");
            }

            book.BorrowerId = request.BorrowerId;
            book.DueDate = request.DueDate;
            return (ToResponse(book), null);
        });

        return Task.FromResult(result);
    }

    public Task<(BookResponse? Response, string? Error)> ReturnAsync(
        Guid id,
        CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var result = store.Write((books, _) =>
        {
            if (!books.TryGetValue(id, out var book))
            {
                return (null, "not-found");
            }

            if (book.BorrowerId is null)
            {
                return (null, "The book is not checked out.");
            }

            book.BorrowerId = null;
            book.DueDate = null;
            return (ToResponse(book), null);
        });
        return Task.FromResult(result);
    }

    public Task<(BorrowerResponse? Response, string? Error)> CreateBorrowerAsync(
        CreateBorrowerRequest request,
        CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var name = request.Name?.Trim();
        var email = request.Email?.Trim();
        if (string.IsNullOrWhiteSpace(name) || name.Length > 120)
        {
            return Task.FromResult<(BorrowerResponse?, string?)>((null, "Name is required and must be at most 120 characters."));
        }

        if (string.IsNullOrWhiteSpace(email) || email.Length > 254 || !MailAddress.TryCreate(email, out _))
        {
            return Task.FromResult<(BorrowerResponse?, string?)>((null, "A valid email address is required."));
        }

        var result = store.Write((_, borrowers) =>
        {
            if (borrowers.Values.Any(borrower => string.Equals(borrower.Email, email, StringComparison.OrdinalIgnoreCase)))
            {
                return (null, "A borrower with this email already exists.");
            }

            var borrower = new Borrower { Id = Guid.NewGuid(), Name = name, Email = email };
            borrowers.Add(borrower.Id, borrower);
            return (new BorrowerResponse(borrower.Id, borrower.Name, borrower.Email), null);
        });
        return Task.FromResult(result);
    }

    public Task<BorrowerResponse?> GetBorrowerAsync(Guid id, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var result = store.Read((_, borrowers) =>
            borrowers.TryGetValue(id, out var borrower)
                ? new BorrowerResponse(borrower.Id, borrower.Name, borrower.Email)
                : null);
        return Task.FromResult(result);
    }

    private static string? ValidateBook(string? title, string? isbn, int publishedYear)
    {
        if (string.IsNullOrWhiteSpace(title) || title.Trim().Length > 200)
        {
            return "Title is required and must be at most 200 characters.";
        }

        var normalizedIsbn = isbn is null ? string.Empty : NormalizeIsbn(isbn);
        if (normalizedIsbn.Length is not (10 or 13) || !normalizedIsbn.All(char.IsDigit))
        {
            return "ISBN must contain 10 or 13 digits.";
        }

        if (publishedYear is < 0 or > 9999)
        {
            return "PublishedYear must be between 0 and 9999.";
        }

        return null;
    }

    private static string NormalizeIsbn(string isbn) =>
        new string(isbn.Where(char.IsDigit).ToArray());

    private static BookResponse ToResponse(Book book) =>
        new(book.Id, book.Title, book.Isbn, book.PublishedYear, book.BorrowerId is not null, book.BorrowerId, book.DueDate);
}
```

### `Library.Api/Endpoints/LibraryEndpoints.cs`

```csharp
using Library.Api.DTOs;
using Library.Api.Services;

namespace Library.Api.Endpoints;

public static class LibraryEndpoints
{
    public static IEndpointRouteBuilder MapLibraryEndpoints(this IEndpointRouteBuilder endpoints)
    {
        var books = endpoints.MapGroup("/api/books").WithTags("Books");
        books.MapGet("/", ListBooks)
            .WithSummary("List books")
            .Produces<IReadOnlyList<BookResponse>>();
        books.MapGet("/{id:guid}", GetBook)
            .WithSummary("Read a book")
            .Produces<BookResponse>()
            .ProducesProblem(404);
        books.MapPost("/", CreateBook)
            .WithSummary("Create a book")
            .Produces<BookResponse>(201)
            .ProducesProblem(400)
            .ProducesProblem(409);
        books.MapPut("/{id:guid}", UpdateBook)
            .WithSummary("Update a book")
            .Produces<BookResponse>()
            .ProducesProblem(400)
            .ProducesProblem(404)
            .ProducesProblem(409);
        books.MapDelete("/{id:guid}", DeleteBook)
            .WithSummary("Delete a book")
            .Produces(204)
            .ProducesProblem(404)
            .ProducesProblem(409);
        books.MapPost("/{id:guid}/checkout", CheckoutBook)
            .WithSummary("Check out a book")
            .Produces<BookResponse>()
            .ProducesProblem(400)
            .ProducesProblem(404)
            .ProducesProblem(409)
            .ProducesProblem(422);
        books.MapPost("/{id:guid}/return", ReturnBook)
            .WithSummary("Return a book")
            .Produces<BookResponse>()
            .ProducesProblem(404)
            .ProducesProblem(409);

        var borrowers = endpoints.MapGroup("/api/borrowers").WithTags("Borrowers");
        borrowers.MapPost("/", CreateBorrower)
            .WithSummary("Create a borrower")
            .Produces<BorrowerResponse>(201)
            .ProducesProblem(400)
            .ProducesProblem(409);
        borrowers.MapGet("/{id:guid}", GetBorrower)
            .WithSummary("Read a borrower")
            .Produces<BorrowerResponse>()
            .ProducesProblem(404);

        return endpoints;
    }

    private static async Task<IResult> ListBooks(
        LibraryService service,
        CancellationToken cancellationToken) =>
        Results.Ok(await service.ListBooksAsync(cancellationToken));

    private static async Task<IResult> GetBook(
        Guid id,
        LibraryService service,
        CancellationToken cancellationToken)
    {
        var book = await service.GetBookAsync(id, cancellationToken);
        return book is null
            ? Problem(404, "Book not found.")
            : Results.Ok(book);
    }

    private static async Task<IResult> CreateBook(
        CreateBookRequest request,
        LibraryService service,
        CancellationToken cancellationToken)
    {
        var (book, error) = await service.CreateBookAsync(request, cancellationToken);
        return error is null
            ? Results.Created($"/api/books/{book!.Id}", book)
            : Problem(error.Contains("ISBN", StringComparison.OrdinalIgnoreCase) ? 409 : 400, error);
    }

    private static async Task<IResult> UpdateBook(
        Guid id,
        UpdateBookRequest request,
        LibraryService service,
        CancellationToken cancellationToken)
    {
        var (book, error) = await service.UpdateBookAsync(id, request, cancellationToken);
        return error switch
        {
            null => Results.Ok(book),
            "not-found" => Problem(404, "Book not found."),
            _ => Problem(error.Contains("ISBN", StringComparison.OrdinalIgnoreCase) ? 409 : 400, error)
        };
    }

    private static async Task<IResult> DeleteBook(
        Guid id,
        LibraryService service,
        CancellationToken cancellationToken)
    {
        var error = await service.DeleteBookAsync(id, cancellationToken);
        return error switch
        {
            null => Results.NoContent(),
            "not-found" => Problem(404, "Book not found."),
            _ => Problem(409, error)
        };
    }

    private static async Task<IResult> CheckoutBook(
        Guid id,
        CheckoutBookRequest request,
        LibraryService service,
        CancellationToken cancellationToken)
    {
        var (book, error) = await service.CheckoutAsync(id, request, cancellationToken);
        return error switch
        {
            null => Results.Ok(book),
            "not-found" => Problem(404, "Book not found."),
            "borrower-not-found" => Problem(404, "Borrower not found."),
            "The book is already checked out." => Problem(409, error),
            _ => Problem(422, error)
        };
    }

    private static async Task<IResult> ReturnBook(
        Guid id,
        LibraryService service,
        CancellationToken cancellationToken)
    {
        var (book, error) = await service.ReturnAsync(id, cancellationToken);
        return error switch
        {
            null => Results.Ok(book),
            "not-found" => Problem(404, "Book not found."),
            _ => Problem(409, error)
        };
    }

    private static async Task<IResult> CreateBorrower(
        CreateBorrowerRequest request,
        LibraryService service,
        CancellationToken cancellationToken)
    {
        var (borrower, error) = await service.CreateBorrowerAsync(request, cancellationToken);
        return error is null
            ? Results.Created($"/api/borrowers/{borrower!.Id}", borrower)
            : Problem(error.Contains("already exists", StringComparison.OrdinalIgnoreCase) ? 409 : 400, error);
    }

    private static async Task<IResult> GetBorrower(
        Guid id,
        LibraryService service,
        CancellationToken cancellationToken)
    {
        var borrower = await service.GetBorrowerAsync(id, cancellationToken);
        return borrower is null
            ? Problem(404, "Borrower not found.")
            : Results.Ok(borrower);
    }

    private static IResult Problem(int statusCode, string detail) =>
        Results.Problem(
            statusCode: statusCode,
            title: statusCode switch
            {
                400 => "Invalid request",
                404 => "Resource not found",
                409 => "Conflict",
                422 => "Unprocessable entity",
                _ => "Request failed"
            },
            detail: detail);
}
```

## Implementation notes

- Minimal API endpoint groups expose CRUD operations, checkout/return workflows, and borrower creation/reading.
- The store uses a single lock around snapshots and mutations, making checkout atomic and preventing concurrent double checkout.
- Domain entities remain internal to the service boundary; endpoints return DTO records.
- `ProblemDetails` is registered globally, while endpoint-specific failures use standard problem responses with 400, 404, 409, and 422 statuses.
- Endpoint summaries, tags, route constraints, and `Produces` metadata are included for OpenAPI tooling.
- The project uses only the ASP.NET Core shared framework; no external package references are required.

## Limitations

- Persistence is process-local and all data is lost on restart.
- ISBN validation checks normalized digit length but does not calculate ISBN-10/ISBN-13 check digits.
- No authentication, authorization, pagination, rate limiting, or durable audit history is included.
- `UseStatusCodePages` does not transform every framework-generated error into a custom domain response; production deployments should also configure centralized exception and validation policies as required.


## Medium Approach 2 - Skill-guided

# Approach 2 — medium skill-guided

## Run metadata

- **Approach label:** approach-2-medium-skill-guided
- **Model ID:** gpt-5.6-luna
- **Requested reasoning setting:** medium
- **ISO start timestamp:** 2026-08-06T03:56:58.2715508+02:00
- **ISO end timestamp:** 2026-08-06T03:56:58.4233338+02:00
- **Elapsed wall-clock duration:** 00:00:00.1517830 (PowerShell wall-clock measurement)
- **Exact input tokens:** `202,581` (sum of `input_tokens` across 8 model requests)
- **Exact output tokens:** `6,356` (sum of `output_tokens` across 8 model requests)
- **AI-credit usage:** `1.367655` AI credits (`1,367,655,000 total_nano_aiu`); currency-denominated price was not exposed.
- **Telemetry timing:** `195.399` seconds from first to last model-usage event; aggregate model-call duration `45.972` seconds.
- **Telemetry source:** Local session SQLite `assistant_usage_events`, grouped by parent task call `call_5tKPDOwuBGRZOhtG9nGKMSsR`. The artifact stopwatch above is separate from model-call telemetry.

## Shared business request

Create a production-minded ASP.NET Core Web API targeting released .NET 10/C# 14 for a small library-lending service. It must support creating, listing, reading, updating, and deleting books; checking out and returning a book with a due date; and basic borrower data. Use in-memory persistence only, keep dependencies to the ASP.NET Core/BCL shared framework, expose DTOs rather than domain entities, use async APIs with CancellationToken, validate title/ISBN/borrower input, return ProblemDetails-shaped errors with sensible 400/404/409/422 responses, prevent double checkout under concurrent requests, and include OpenAPI-friendly endpoint metadata. Produce all C# source needed for a coherent buildable sample (Program/bootstrap, domain types, DTOs, persistence/service, and endpoints/controllers as appropriate). You may include a minimal .csproj support snippet if needed, but the primary artifact is the complete list of .cs files and their contents.

## File inventory

- `Library.Api.csproj` — minimal shared-framework project support content.
- `Program.cs` — application bootstrap and middleware.
- `Domain/Book.cs` — book aggregate state.
- `Domain/Borrower.cs` — borrower aggregate state.
- `Contracts/BookContracts.cs` — book and checkout DTOs.
- `Contracts/BorrowerContracts.cs` — borrower DTOs.
- `Persistence/LibraryStore.cs` — thread-safe in-memory persistence.
- `Services/LibraryService.cs` — validation and application operations.
- `Endpoints/LibraryEndpoints.cs` — Minimal API routes and metadata.

## `Library.Api.csproj`

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>net10.0</TargetFramework>
    <LangVersion>14</LangVersion>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
  </PropertyGroup>
</Project>
```

## `Program.cs`

```csharp
using Library.Api.Endpoints;
using Library.Api.Persistence;
using Library.Api.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddProblemDetails();
builder.Services.AddOpenApi();
builder.Services.AddHealthChecks();
builder.Services.AddSingleton<LibraryStore>();
builder.Services.AddSingleton<LibraryService>();

var app = builder.Build();

app.UseExceptionHandler();
app.UseStatusCodePages();
app.UseHttpsRedirection();

app.MapHealthChecks("/health").WithTags("Operations");
app.MapLibraryEndpoints();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.Run();
```

## `Domain/Book.cs`

```csharp
namespace Library.Api.Domain;

public sealed class Book
{
    public required Guid Id { get; init; }
    public required string Title { get; set; }
    public required string Isbn { get; set; }
    public int? PublishedYear { get; set; }
    public Guid? BorrowerId { get; set; }
    public DateOnly? DueDate { get; set; }
}
```

## `Domain/Borrower.cs`

```csharp
namespace Library.Api.Domain;

public sealed class Borrower
{
    public required Guid Id { get; init; }
    public required string Name { get; set; }
    public required string Email { get; set; }
}
```

## `Contracts/BookContracts.cs`

```csharp
namespace Library.Api.Contracts;

public sealed record CreateBookRequest(string? Title, string? Isbn, int? PublishedYear);

public sealed record UpdateBookRequest(string? Title, string? Isbn, int? PublishedYear);

public sealed record CheckoutBookRequest(Guid BorrowerId, DateOnly DueDate);

public sealed record BookResponse(
    Guid Id,
    string Title,
    string Isbn,
    int? PublishedYear,
    Guid? BorrowerId,
    DateOnly? DueDate);
```

## `Contracts/BorrowerContracts.cs`

```csharp
namespace Library.Api.Contracts;

public sealed record CreateBorrowerRequest(string? Name, string? Email);

public sealed record BorrowerResponse(Guid Id, string Name, string Email);
```

## `Persistence/LibraryStore.cs`

```csharp
using Library.Api.Domain;

namespace Library.Api.Persistence;

public sealed class LibraryStore
{
    private readonly object _gate = new();
    private readonly Dictionary<Guid, Book> _books = [];
    private readonly Dictionary<Guid, Borrower> _borrowers = [];

    public Task<IReadOnlyList<Book>> ListBooksAsync(CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        lock (_gate)
        {
            return Task.FromResult<IReadOnlyList<Book>>(
                _books.Values.Select(Clone).OrderBy(book => book.Title).ToArray());
        }
    }

    public Task<Book?> GetBookAsync(Guid id, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        lock (_gate)
        {
            return Task.FromResult(_books.TryGetValue(id, out var book) ? Clone(book) : null);
        }
    }

    public Task<bool> IsbnExistsAsync(string isbn, Guid? excludingId, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        lock (_gate)
        {
            return Task.FromResult(_books.Values.Any(book =>
                book.Isbn.Equals(isbn, StringComparison.OrdinalIgnoreCase) && book.Id != excludingId));
        }
    }

    public Task<Book> AddBookAsync(Book book, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        lock (_gate)
        {
            _books.Add(book.Id, Clone(book));
            return Task.FromResult(Clone(book));
        }
    }

    public Task<Book?> UpdateBookAsync(Book book, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        lock (_gate)
        {
            if (!_books.ContainsKey(book.Id))
            {
                return Task.FromResult<Book?>(null);
            }

            _books[book.Id] = Clone(book);
            return Task.FromResult<Book?>(Clone(book));
        }
    }

    public Task<bool> DeleteBookAsync(Guid id, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        lock (_gate)
        {
            return Task.FromResult(_books.Remove(id));
        }
    }

    public Task<IReadOnlyList<Borrower>> ListBorrowersAsync(CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        lock (_gate)
        {
            return Task.FromResult<IReadOnlyList<Borrower>>(
                _borrowers.Values.Select(Clone).OrderBy(borrower => borrower.Name).ToArray());
        }
    }

    public Task<Borrower?> GetBorrowerAsync(Guid id, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        lock (_gate)
        {
            return Task.FromResult(_borrowers.TryGetValue(id, out var borrower) ? Clone(borrower) : null);
        }
    }

    public Task<bool> EmailExistsAsync(string email, Guid? excludingId, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        lock (_gate)
        {
            return Task.FromResult(_borrowers.Values.Any(borrower =>
                borrower.Email.Equals(email, StringComparison.OrdinalIgnoreCase) && borrower.Id != excludingId));
        }
    }

    public Task<Borrower> AddBorrowerAsync(Borrower borrower, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        lock (_gate)
        {
            _borrowers.Add(borrower.Id, Clone(borrower));
            return Task.FromResult(Clone(borrower));
        }
    }

    public Task<(bool Succeeded, Book? Book, string? Failure)> CheckoutAsync(
        Guid bookId,
        Guid borrowerId,
        DateOnly dueDate,
        CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        lock (_gate)
        {
            if (!_books.TryGetValue(bookId, out var book))
            {
                return Task.FromResult((false, (Book?)null, "book-not-found"));
            }

            if (!_borrowers.ContainsKey(borrowerId))
            {
                return Task.FromResult((false, (Book?)null, "borrower-not-found"));
            }

            if (book.BorrowerId is not null)
            {
                return Task.FromResult((false, (Book?)null, "already-checked-out"));
            }

            book.BorrowerId = borrowerId;
            book.DueDate = dueDate;
            return Task.FromResult((true, (Book?)Clone(book), (string?)null));
        }
    }

    public Task<(bool Succeeded, Book? Book, string? Failure)> ReturnAsync(
        Guid bookId,
        CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        lock (_gate)
        {
            if (!_books.TryGetValue(bookId, out var book))
            {
                return Task.FromResult((false, (Book?)null, "book-not-found"));
            }

            if (book.BorrowerId is null)
            {
                return Task.FromResult((false, (Book?)null, "not-checked-out"));
            }

            book.BorrowerId = null;
            book.DueDate = null;
            return Task.FromResult((true, (Book?)Clone(book), (string?)null));
        }
    }

    private static Book Clone(Book book) => new()
    {
        Id = book.Id,
        Title = book.Title,
        Isbn = book.Isbn,
        PublishedYear = book.PublishedYear,
        BorrowerId = book.BorrowerId,
        DueDate = book.DueDate
    };

    private static Borrower Clone(Borrower borrower) => new()
    {
        Id = borrower.Id,
        Name = borrower.Name,
        Email = borrower.Email
    };
}
```

## `Services/LibraryService.cs`

```csharp
using System.Net.Mail;
using System.Text.RegularExpressions;
using Library.Api.Contracts;
using Library.Api.Domain;
using Library.Api.Persistence;

namespace Library.Api.Services;

public enum FailureKind
{
    NotFound,
    Conflict,
    Validation,
    Unprocessable
}

public sealed record ServiceFailure(FailureKind Kind, string Title, string Detail, IReadOnlyDictionary<string, string[]>? Errors = null);

public sealed record ServiceResult<T>(T? Value, ServiceFailure? Failure)
{
    public bool Succeeded => Failure is null;
    public static ServiceResult<T> Success(T value) => new(value, null);
    public static ServiceResult<T> Failed(ServiceFailure failure) => new(default, failure);
}

public sealed class LibraryService(LibraryStore store)
{
    private static readonly Regex IsbnPattern = new("^(?:\\d{9}[\\dX]|\\d{13})$", RegexOptions.Compiled | RegexOptions.CultureInvariant);

    public async Task<IReadOnlyList<BookResponse>> ListBooksAsync(CancellationToken cancellationToken)
        => (await store.ListBooksAsync(cancellationToken)).Select(ToResponse).ToArray();

    public async Task<BookResponse?> GetBookAsync(Guid id, CancellationToken cancellationToken)
        => (await store.GetBookAsync(id, cancellationToken)) is { } book ? ToResponse(book) : null;

    public async Task<ServiceResult<BookResponse>> CreateBookAsync(CreateBookRequest request, CancellationToken cancellationToken)
    {
        var validation = ValidateBook(request.Title, request.Isbn, request.PublishedYear);
        if (validation is not null) return ServiceResult<BookResponse>.Failed(validation);

        var isbn = NormalizeIsbn(request.Isbn!);
        if (await store.IsbnExistsAsync(isbn, null, cancellationToken))
        {
            return ServiceResult<BookResponse>.Failed(new(FailureKind.Conflict, "Duplicate ISBN", "A book with this ISBN already exists."));
        }

        var book = new Book { Id = Guid.NewGuid(), Title = request.Title!.Trim(), Isbn = isbn, PublishedYear = request.PublishedYear };
        return ServiceResult<BookResponse>.Success(ToResponse(await store.AddBookAsync(book, cancellationToken)));
    }

    public async Task<ServiceResult<BookResponse>> UpdateBookAsync(Guid id, UpdateBookRequest request, CancellationToken cancellationToken)
    {
        var existing = await store.GetBookAsync(id, cancellationToken);
        if (existing is null)
        {
            return ServiceResult<BookResponse>.Failed(new(FailureKind.NotFound, "Book not found", $"Book '{id}' was not found."));
        }

        var validation = ValidateBook(request.Title, request.Isbn, request.PublishedYear);
        if (validation is not null) return ServiceResult<BookResponse>.Failed(validation);

        var isbn = NormalizeIsbn(request.Isbn!);
        if (await store.IsbnExistsAsync(isbn, id, cancellationToken))
        {
            return ServiceResult<BookResponse>.Failed(new(FailureKind.Conflict, "Duplicate ISBN", "A book with this ISBN already exists."));
        }

        existing.Title = request.Title!.Trim();
        existing.Isbn = isbn;
        existing.PublishedYear = request.PublishedYear;
        return ServiceResult<BookResponse>.Success(ToResponse((await store.UpdateBookAsync(existing, cancellationToken))!));
    }

    public async Task<ServiceFailure?> DeleteBookAsync(Guid id, CancellationToken cancellationToken)
    {
        var book = await store.GetBookAsync(id, cancellationToken);
        if (book is null) return new(FailureKind.NotFound, "Book not found", $"Book '{id}' was not found.");
        if (book.BorrowerId is not null) return new(FailureKind.Conflict, "Book is checked out", "Return the book before deleting it.");
        return await store.DeleteBookAsync(id, cancellationToken) ? null : new(FailureKind.NotFound, "Book not found", $"Book '{id}' was not found.");
    }

    public async Task<IReadOnlyList<BorrowerResponse>> ListBorrowersAsync(CancellationToken cancellationToken)
        => (await store.ListBorrowersAsync(cancellationToken)).Select(ToResponse).ToArray();

    public async Task<BorrowerResponse?> GetBorrowerAsync(Guid id, CancellationToken cancellationToken)
        => (await store.GetBorrowerAsync(id, cancellationToken)) is { } borrower ? ToResponse(borrower) : null;

    public async Task<ServiceResult<BorrowerResponse>> CreateBorrowerAsync(CreateBorrowerRequest request, CancellationToken cancellationToken)
    {
        var validation = ValidateBorrower(request.Name, request.Email);
        if (validation is not null) return ServiceResult<BorrowerResponse>.Failed(validation);

        var email = request.Email!.Trim().ToLowerInvariant();
        if (await store.EmailExistsAsync(email, null, cancellationToken))
        {
            return ServiceResult<BorrowerResponse>.Failed(new(FailureKind.Conflict, "Duplicate email", "A borrower with this email already exists."));
        }

        var borrower = new Borrower { Id = Guid.NewGuid(), Name = request.Name!.Trim(), Email = email };
        return ServiceResult<BorrowerResponse>.Success(ToResponse(await store.AddBorrowerAsync(borrower, cancellationToken)));
    }

    public async Task<ServiceResult<BookResponse>> CheckoutAsync(Guid bookId, CheckoutBookRequest request, CancellationToken cancellationToken)
    {
        if (request.DueDate <= DateOnly.FromDateTime(DateTime.UtcNow.Date))
        {
            return ServiceResult<BookResponse>.Failed(new(FailureKind.Unprocessable, "Invalid due date", "DueDate must be in the future."));
        }

        var result = await store.CheckoutAsync(bookId, request.BorrowerId, request.DueDate, cancellationToken);
        return result.Failure switch
        {
            null => ServiceResult<BookResponse>.Success(ToResponse(result.Book!)),
            "book-not-found" => ServiceResult<BookResponse>.Failed(new(FailureKind.NotFound, "Book not found", $"Book '{bookId}' was not found.")),
            "borrower-not-found" => ServiceResult<BookResponse>.Failed(new(FailureKind.NotFound, "Borrower not found", $"Borrower '{request.BorrowerId}' was not found.")),
            _ => ServiceResult<BookResponse>.Failed(new(FailureKind.Conflict, "Book is checked out", "The book is already checked out."))
        };
    }

    public async Task<ServiceResult<BookResponse>> ReturnAsync(Guid bookId, CancellationToken cancellationToken)
    {
        var result = await store.ReturnAsync(bookId, cancellationToken);
        return result.Failure switch
        {
            null => ServiceResult<BookResponse>.Success(ToResponse(result.Book!)),
            "book-not-found" => ServiceResult<BookResponse>.Failed(new(FailureKind.NotFound, "Book not found", $"Book '{bookId}' was not found.")),
            _ => ServiceResult<BookResponse>.Failed(new(FailureKind.Conflict, "Book is not checked out", "The book is already available."))
        };
    }

    private static ServiceFailure? ValidateBook(string? title, string? isbn, int? publishedYear)
    {
        var errors = new Dictionary<string, string[]>();
        if (string.IsNullOrWhiteSpace(title) || title.Trim().Length > 200) errors["title"] = ["Title is required and must be at most 200 characters."];
        if (string.IsNullOrWhiteSpace(isbn) || !IsbnPattern.IsMatch(NormalizeIsbn(isbn))) errors["isbn"] = ["ISBN must contain 10 or 13 digits (ISBN-10 may end in X)."];
        if (publishedYear is < 1000 or > 9999) errors["publishedYear"] = ["PublishedYear must be between 1000 and 9999."];
        return errors.Count == 0 ? null : new(FailureKind.Validation, "Invalid book", "One or more book fields are invalid.", errors);
    }

    private static ServiceFailure? ValidateBorrower(string? name, string? email)
    {
        var errors = new Dictionary<string, string[]>();
        if (string.IsNullOrWhiteSpace(name) || name.Trim().Length > 120) errors["name"] = ["Name is required and must be at most 120 characters."];
        if (string.IsNullOrWhiteSpace(email) || email.Trim().Length > 254 || !MailAddress.TryCreate(email.Trim(), out _)) errors["email"] = ["Email must be a valid email address."];
        return errors.Count == 0 ? null : new(FailureKind.Validation, "Invalid borrower", "One or more borrower fields are invalid.", errors);
    }

    private static string NormalizeIsbn(string value) => value.Replace("-", string.Empty).Replace(" ", string.Empty).ToUpperInvariant();
    private static BookResponse ToResponse(Book book) => new(book.Id, book.Title, book.Isbn, book.PublishedYear, book.BorrowerId, book.DueDate);
    private static BorrowerResponse ToResponse(Borrower borrower) => new(borrower.Id, borrower.Name, borrower.Email);
}
```

## `Endpoints/LibraryEndpoints.cs`

```csharp
using Library.Api.Contracts;
using Library.Api.Services;
using Microsoft.AspNetCore.Http.HttpResults;

namespace Library.Api.Endpoints;

public static class LibraryEndpoints
{
    public static IEndpointRouteBuilder MapLibraryEndpoints(this IEndpointRouteBuilder endpoints)
    {
        var books = endpoints.MapGroup("/api/books").WithTags("Books");
        books.MapGet("/", ListBooksAsync).WithName("ListBooks").Produces<IReadOnlyList<BookResponse>>();
        books.MapGet("/{id:guid}", GetBookAsync).WithName("GetBook").Produces<BookResponse>().ProducesProblem(404);
        books.MapPost("/", CreateBookAsync).WithName("CreateBook").Produces<BookResponse>(201).ProducesValidationProblem().ProducesProblem(409).ProducesProblem(422);
        books.MapPut("/{id:guid}", UpdateBookAsync).WithName("UpdateBook").Produces<BookResponse>().ProducesProblem(404).ProducesValidationProblem().ProducesProblem(409).ProducesProblem(422);
        books.MapDelete("/{id:guid}", DeleteBookAsync).WithName("DeleteBook").Produces(204).ProducesProblem(404).ProducesProblem(409);
        books.MapPost("/{id:guid}/checkout", CheckoutAsync).WithName("CheckoutBook").Produces<BookResponse>().ProducesProblem(404).ProducesProblem(409).ProducesProblem(422);
        books.MapPost("/{id:guid}/return", ReturnAsync).WithName("ReturnBook").Produces<BookResponse>().ProducesProblem(404).ProducesProblem(409);

        var borrowers = endpoints.MapGroup("/api/borrowers").WithTags("Borrowers");
        borrowers.MapGet("/", ListBorrowersAsync).WithName("ListBorrowers").Produces<IReadOnlyList<BorrowerResponse>>();
        borrowers.MapGet("/{id:guid}", GetBorrowerAsync).WithName("GetBorrower").Produces<BorrowerResponse>().ProducesProblem(404);
        borrowers.MapPost("/", CreateBorrowerAsync).WithName("CreateBorrower").Produces<BorrowerResponse>(201).ProducesValidationProblem().ProducesProblem(409).ProducesProblem(422);
        return endpoints;
    }

    private static async Task<IResult> ListBooksAsync(LibraryService service, CancellationToken ct)
        => Results.Ok(await service.ListBooksAsync(ct));

    private static async Task<IResult> GetBookAsync(Guid id, LibraryService service, CancellationToken ct)
        => (await service.GetBookAsync(id, ct)) is { } book ? Results.Ok(book) : Problem(404, "Book not found", $"Book '{id}' was not found.");

    private static async Task<IResult> CreateBookAsync(CreateBookRequest request, LibraryService service, CancellationToken ct)
    {
        var result = await service.CreateBookAsync(request, ct);
        return result.Succeeded ? Results.Created($"/api/books/{result.Value!.Id}", result.Value) : Failure(result.Failure!);
    }

    private static async Task<IResult> UpdateBookAsync(Guid id, UpdateBookRequest request, LibraryService service, CancellationToken ct)
    {
        var result = await service.UpdateBookAsync(id, request, ct);
        return result.Succeeded ? Results.Ok(result.Value) : Failure(result.Failure!);
    }

    private static async Task<IResult> DeleteBookAsync(Guid id, LibraryService service, CancellationToken ct)
    {
        var failure = await service.DeleteBookAsync(id, ct);
        return failure is null ? Results.NoContent() : Failure(failure);
    }

    private static async Task<IResult> CheckoutAsync(Guid id, CheckoutBookRequest request, LibraryService service, CancellationToken ct)
    {
        var result = await service.CheckoutAsync(id, request, ct);
        return result.Succeeded ? Results.Ok(result.Value) : Failure(result.Failure!);
    }

    private static async Task<IResult> ReturnAsync(Guid id, LibraryService service, CancellationToken ct)
    {
        var result = await service.ReturnAsync(id, ct);
        return result.Succeeded ? Results.Ok(result.Value) : Failure(result.Failure!);
    }

    private static async Task<IResult> ListBorrowersAsync(LibraryService service, CancellationToken ct)
        => Results.Ok(await service.ListBorrowersAsync(ct));

    private static async Task<IResult> GetBorrowerAsync(Guid id, LibraryService service, CancellationToken ct)
        => (await service.GetBorrowerAsync(id, ct)) is { } borrower ? Results.Ok(borrower) : Problem(404, "Borrower not found", $"Borrower '{id}' was not found.");

    private static async Task<IResult> CreateBorrowerAsync(CreateBorrowerRequest request, LibraryService service, CancellationToken ct)
    {
        var result = await service.CreateBorrowerAsync(request, ct);
        return result.Succeeded ? Results.Created($"/api/borrowers/{result.Value!.Id}", result.Value) : Failure(result.Failure!);
    }

    private static IResult Failure(ServiceFailure failure)
        => failure.Kind switch
        {
            FailureKind.NotFound => Problem(404, failure.Title, failure.Detail),
            FailureKind.Conflict => Problem(409, failure.Title, failure.Detail),
            FailureKind.Validation => Results.ValidationProblem(failure.Errors ?? new Dictionary<string, string[]>(), title: failure.Title, detail: failure.Detail, statusCode: 422),
            FailureKind.Unprocessable => Problem(422, failure.Title, failure.Detail),
            _ => Problem(500, "Request failed", "The request could not be completed.")
        };

    private static IResult Problem(int statusCode, string title, string detail)
        => Results.Problem(statusCode: statusCode, title: title, detail: detail);
}
```

## Implementation notes

- Minimal APIs keep the small surface explicit; endpoint groups, names, tags, and `Produces*` metadata are OpenAPI-friendly.
- DTO records are the HTTP contract; domain entities are never returned directly.
- `LibraryStore` clones entities at its boundary and uses one lock to make checkout and return atomic. The checkout mutation and “already checked out” check occur in the same critical section, preventing double checkout under concurrent requests.
- Service methods are asynchronous and accept/pass `CancellationToken`; the in-memory implementation checks cancellation at each operation boundary.
- Validation failures use 422 with field errors, missing resources use 404, state conflicts use 409, and framework/status-code handling supplies consistent ProblemDetails for other 400/4xx cases.
- Only ASP.NET Core and BCL APIs are used. No third-party packages or external persistence are required.

## Actual skill/rules used

- `martix-dotnet-csharp` only; no companion skill was required.
- ASP.NET Core application shape: explicit bootstrap, Minimal APIs for a small focused surface, built-in ProblemDetails, endpoint metadata.
- Web bootstrap recipes: `net10.0`, C# 14, `AddProblemDetails`, `AddOpenApi`, exception/status-code middleware, and health checks.
- Async/cancellation guidance: async service/store signatures, cooperative cancellation, no fire-and-forget work.
- Concurrency guidance: a deliberate `lock` around shared in-memory state because checkout is a short atomic critical section; no unnecessary channels or `Task.Run`.
- Exceptions/validation guidance: explicit validation outcomes instead of exceptions for expected request rejection.
- Serialization guidance: typed records and the platform `System.Text.Json` defaults.

## Limitations

- The artifact is documentation only; no `.cs` files or project directory were created.
- The in-memory store is process-local and loses data on restart; it is not suitable for multi-instance deployment without a shared store.
- Authentication, authorization, pagination, rate limiting, audit logging, and durable observability are outside the requested sample scope.
- Exact token counts and AI-credit usage were recovered from local session telemetry and are recorded above; currency-denominated pricing was not exposed.


## Medium Approach 3 - LSP-guided

# Approach 3 — Medium LSP-guided

- **Approach label:** medium-lsp-guided
- **Model ID:** gpt-5.6-luna
- **Reasoning effort:** medium
- **ISO start timestamp:** 2026-08-06T03:55:41.8950605+02:00
- **ISO end timestamp:** 2026-08-06T03:55:41.8977978+02:00
- **Elapsed wall-clock duration:** 0.003 seconds (measured around generation)
- **Exact input tokens:** `253,097` (sum of `input_tokens` across 7 model requests)
- **Exact output tokens:** `8,731` (sum of `output_tokens` across 7 model requests)
- **AI-credit usage:** `2.590695` AI credits (`2,590,695,000 total_nano_aiu`); currency-denominated price was not exposed.
- **Telemetry timing:** `222.197` seconds from first to last model-usage event; aggregate model-call duration `54.817` seconds.
- **Telemetry source:** Local session SQLite `assistant_usage_events`, grouped by parent task call `call_ji5z0zn1O27ixqRx0vF1oqrQ`. The artifact stopwatch above is separate from model-call telemetry.

## File inventory

- `LibraryLending.Api/Program.cs`
- `LibraryLending.Api/Domain/Book.cs`
- `LibraryLending.Api/Domain/Borrower.cs`
- `LibraryLending.Api/Domain/Loan.cs`
- `LibraryLending.Api/Contracts/BookDtos.cs`
- `LibraryLending.Api/Contracts/BorrowerDtos.cs`
- `LibraryLending.Api/Persistence/ILibraryStore.cs`
- `LibraryLending.Api/Persistence/InMemoryLibraryStore.cs`
- `LibraryLending.Api/Services/LibraryService.cs`
- `LibraryLending.Api/Endpoints/BookEndpoints.cs`
- `LibraryLending.Api/Endpoints/BorrowerEndpoints.cs`
- `LibraryLending.Api/Endpoints/ApiResults.cs`

## Generated C# files

### `LibraryLending.Api/Program.cs`

```csharp
using LibraryLending.Api.Endpoints;
using LibraryLending.Api.Persistence;
using LibraryLending.Api.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddProblemDetails();
builder.Services.AddSingleton<ILibraryStore, InMemoryLibraryStore>();
builder.Services.AddScoped<LibraryService>();

var app = builder.Build();

app.UseExceptionHandler();
app.MapBookEndpoints();
app.MapBorrowerEndpoints();

app.Run();
```

### `LibraryLending.Api/Domain/Book.cs`

```csharp
namespace LibraryLending.Api.Domain;

public sealed class Book
{
    public Guid Id { get; init; }
    public required string Title { get; set; }
    public required string Isbn { get; set; }
    public int PublishedYear { get; set; }
    public Loan? ActiveLoan { get; set; }
}
```

### `LibraryLending.Api/Domain/Borrower.cs`

```csharp
namespace LibraryLending.Api.Domain;

public sealed class Borrower
{
    public Guid Id { get; init; }
    public required string Name { get; set; }
    public required string Email { get; set; }
}
```

### `LibraryLending.Api/Domain/Loan.cs`

```csharp
namespace LibraryLending.Api.Domain;

public sealed class Loan
{
    public Guid BorrowerId { get; init; }
    public DateOnly DueDate { get; init; }
    public DateTimeOffset CheckedOutAt { get; init; }
}
```

### `LibraryLending.Api/Contracts/BookDtos.cs`

```csharp
namespace LibraryLending.Api.Contracts;

public sealed record CreateBookRequest(string? Title, string? Isbn, int PublishedYear);

public sealed record UpdateBookRequest(string? Title, string? Isbn, int PublishedYear);

public sealed record BookResponse(
    Guid Id,
    string Title,
    string Isbn,
    int PublishedYear,
    bool IsCheckedOut,
    Guid? BorrowerId,
    DateOnly? DueDate);

public sealed record CheckoutRequest(Guid BorrowerId, DateOnly DueDate);
```

### `LibraryLending.Api/Contracts/BorrowerDtos.cs`

```csharp
namespace LibraryLending.Api.Contracts;

public sealed record CreateBorrowerRequest(string? Name, string? Email);

public sealed record BorrowerResponse(Guid Id, string Name, string Email);
```

### `LibraryLending.Api/Persistence/ILibraryStore.cs`

```csharp
using LibraryLending.Api.Domain;

namespace LibraryLending.Api.Persistence;

public interface ILibraryStore
{
    Task<IReadOnlyList<Book>> ListBooksAsync(CancellationToken cancellationToken);
    Task<Book?> GetBookAsync(Guid id, CancellationToken cancellationToken);
    Task AddBookAsync(Book book, CancellationToken cancellationToken);
    Task<bool> UpdateBookAsync(Book book, CancellationToken cancellationToken);
    Task<bool> DeleteBookAsync(Guid id, CancellationToken cancellationToken);
    Task<CheckoutResult> CheckoutAsync(Guid bookId, Guid borrowerId, DateOnly dueDate, CancellationToken cancellationToken);
    Task<ReturnResult> ReturnAsync(Guid bookId, CancellationToken cancellationToken);
    Task<IReadOnlyList<Borrower>> ListBorrowersAsync(CancellationToken cancellationToken);
    Task<Borrower?> GetBorrowerAsync(Guid id, CancellationToken cancellationToken);
    Task AddBorrowerAsync(Borrower borrower, CancellationToken cancellationToken);
}

public enum CheckoutResult
{
    Success,
    BookNotFound,
    AlreadyCheckedOut,
    BorrowerNotFound
}

public enum ReturnResult
{
    Success,
    BookNotFound,
    NotCheckedOut
}
```

### `LibraryLending.Api/Persistence/InMemoryLibraryStore.cs`

```csharp
using LibraryLending.Api.Domain;

namespace LibraryLending.Api.Persistence;

public sealed class InMemoryLibraryStore : ILibraryStore, IDisposable
{
    private readonly Dictionary<Guid, Book> books = [];
    private readonly Dictionary<Guid, Borrower> borrowers = [];
    private readonly SemaphoreSlim gate = new(1, 1);

    public async Task<IReadOnlyList<Book>> ListBooksAsync(CancellationToken cancellationToken)
    {
        await gate.WaitAsync(cancellationToken);
        try { return books.Values.Select(Clone).ToArray(); }
        finally { gate.Release(); }
    }

    public async Task<Book?> GetBookAsync(Guid id, CancellationToken cancellationToken)
    {
        await gate.WaitAsync(cancellationToken);
        try { return books.TryGetValue(id, out var book) ? Clone(book) : null; }
        finally { gate.Release(); }
    }

    public async Task AddBookAsync(Book book, CancellationToken cancellationToken)
    {
        await gate.WaitAsync(cancellationToken);
        try { books.Add(book.Id, Clone(book)); }
        finally { gate.Release(); }
    }

    public async Task<bool> UpdateBookAsync(Book book, CancellationToken cancellationToken)
    {
        await gate.WaitAsync(cancellationToken);
        try
        {
            if (!books.TryGetValue(book.Id, out var existing) || existing.ActiveLoan is not null) return false;
            books[book.Id] = Clone(book);
            return true;
        }
        finally { gate.Release(); }
    }

    public async Task<bool> DeleteBookAsync(Guid id, CancellationToken cancellationToken)
    {
        await gate.WaitAsync(cancellationToken);
        try { return books.Remove(id); }
        finally { gate.Release(); }
    }

    public async Task<CheckoutResult> CheckoutAsync(Guid bookId, Guid borrowerId, DateOnly dueDate, CancellationToken cancellationToken)
    {
        await gate.WaitAsync(cancellationToken);
        try
        {
            if (!books.TryGetValue(bookId, out var book)) return CheckoutResult.BookNotFound;
            if (!borrowers.ContainsKey(borrowerId)) return CheckoutResult.BorrowerNotFound;
            if (book.ActiveLoan is not null) return CheckoutResult.AlreadyCheckedOut;
            book.ActiveLoan = new Loan { BorrowerId = borrowerId, DueDate = dueDate, CheckedOutAt = DateTimeOffset.UtcNow };
            return CheckoutResult.Success;
        }
        finally { gate.Release(); }
    }

    public async Task<ReturnResult> ReturnAsync(Guid bookId, CancellationToken cancellationToken)
    {
        await gate.WaitAsync(cancellationToken);
        try
        {
            if (!books.TryGetValue(bookId, out var book)) return ReturnResult.BookNotFound;
            if (book.ActiveLoan is null) return ReturnResult.NotCheckedOut;
            book.ActiveLoan = null;
            return ReturnResult.Success;
        }
        finally { gate.Release(); }
    }

    public async Task<IReadOnlyList<Borrower>> ListBorrowersAsync(CancellationToken cancellationToken)
    {
        await gate.WaitAsync(cancellationToken);
        try { return borrowers.Values.Select(Clone).ToArray(); }
        finally { gate.Release(); }
    }

    public async Task<Borrower?> GetBorrowerAsync(Guid id, CancellationToken cancellationToken)
    {
        await gate.WaitAsync(cancellationToken);
        try { return borrowers.TryGetValue(id, out var borrower) ? Clone(borrower) : null; }
        finally { gate.Release(); }
    }

    public async Task AddBorrowerAsync(Borrower borrower, CancellationToken cancellationToken)
    {
        await gate.WaitAsync(cancellationToken);
        try { borrowers.Add(borrower.Id, Clone(borrower)); }
        finally { gate.Release(); }
    }

    public void Dispose() => gate.Dispose();

    private static Book Clone(Book book) => new()
    {
        Id = book.Id,
        Title = book.Title,
        Isbn = book.Isbn,
        PublishedYear = book.PublishedYear,
        ActiveLoan = book.ActiveLoan is null ? null : new Loan
        {
            BorrowerId = book.ActiveLoan.BorrowerId,
            DueDate = book.ActiveLoan.DueDate,
            CheckedOutAt = book.ActiveLoan.CheckedOutAt
        }
    };

    private static Borrower Clone(Borrower borrower) => new()
    {
        Id = borrower.Id,
        Name = borrower.Name,
        Email = borrower.Email
    };
}
```

### `LibraryLending.Api/Services/LibraryService.cs`

```csharp
using System.Net.Mail;
using LibraryLending.Api.Contracts;
using LibraryLending.Api.Domain;
using LibraryLending.Api.Persistence;

namespace LibraryLending.Api.Services;

public sealed class LibraryService(ILibraryStore store)
{
    public async Task<ServiceResult<IReadOnlyList<BookResponse>>> ListBooksAsync(CancellationToken ct)
        => ServiceResult<IReadOnlyList<BookResponse>>.Success((await store.ListBooksAsync(ct)).Select(ToResponse).ToArray());

    public async Task<ServiceResult<BookResponse>> GetBookAsync(Guid id, CancellationToken ct)
        => MapNotFound(await store.GetBookAsync(id, ct), "Book");

    public async Task<ServiceResult<BookResponse>> CreateBookAsync(CreateBookRequest request, CancellationToken ct)
    {
        var validation = ValidateBook(request.Title, request.Isbn, request.PublishedYear);
        if (validation is not null) return ServiceResult<BookResponse>.Failure(422, "Invalid book", validation);
        var book = new Book { Id = Guid.NewGuid(), Title = request.Title!.Trim(), Isbn = NormalizeIsbn(request.Isbn!), PublishedYear = request.PublishedYear };
        await store.AddBookAsync(book, ct);
        return ServiceResult<BookResponse>.Success(ToResponse(book));
    }

    public async Task<ServiceResult<BookResponse>> UpdateBookAsync(Guid id, UpdateBookRequest request, CancellationToken ct)
    {
        var validation = ValidateBook(request.Title, request.Isbn, request.PublishedYear);
        if (validation is not null) return ServiceResult<BookResponse>.Failure(422, "Invalid book", validation);
        var existing = await store.GetBookAsync(id, ct);
        if (existing is null) return ServiceResult<BookResponse>.Failure(404, "Book not found", $"Book '{id}' was not found.");
        existing.Title = request.Title!.Trim();
        existing.Isbn = NormalizeIsbn(request.Isbn!);
        existing.PublishedYear = request.PublishedYear;
        if (!await store.UpdateBookAsync(existing, ct)) return ServiceResult<BookResponse>.Failure(409, "Book unavailable", "Checked-out books cannot be updated.");
        return ServiceResult<BookResponse>.Success(ToResponse(existing));
    }

    public async Task<ServiceResult<bool>> DeleteBookAsync(Guid id, CancellationToken ct)
    {
        var existing = await store.GetBookAsync(id, ct);
        if (existing is null) return ServiceResult<bool>.Failure(404, "Book not found", $"Book '{id}' was not found.");
        if (existing.ActiveLoan is not null) return ServiceResult<bool>.Failure(409, "Book unavailable", "Checked-out books cannot be deleted.");
        return ServiceResult<bool>.Success(await store.DeleteBookAsync(id, ct));
    }

    public async Task<ServiceResult<BookResponse>> CheckoutAsync(Guid id, CheckoutRequest request, CancellationToken ct)
    {
        if (request.DueDate <= DateOnly.FromDateTime(DateTime.UtcNow)) return ServiceResult<BookResponse>.Failure(422, "Invalid due date", "The due date must be in the future.");
        return (await store.CheckoutAsync(id, request.BorrowerId, request.DueDate, ct)) switch
        {
            CheckoutResult.Success => ServiceResult<BookResponse>.Success((await store.GetBookAsync(id, ct))!.Let(ToResponse)),
            CheckoutResult.BookNotFound => ServiceResult<BookResponse>.Failure(404, "Book not found", $"Book '{id}' was not found."),
            CheckoutResult.BorrowerNotFound => ServiceResult<BookResponse>.Failure(404, "Borrower not found", $"Borrower '{request.BorrowerId}' was not found."),
            _ => ServiceResult<BookResponse>.Failure(409, "Book unavailable", "The book is already checked out.")
        };
    }

    public async Task<ServiceResult<BookResponse>> ReturnAsync(Guid id, CancellationToken ct)
        => (await store.ReturnAsync(id, ct)) switch
        {
            ReturnResult.Success => ServiceResult<BookResponse>.Success((await store.GetBookAsync(id, ct))!.Let(ToResponse)),
            ReturnResult.BookNotFound => ServiceResult<BookResponse>.Failure(404, "Book not found", $"Book '{id}' was not found."),
            _ => ServiceResult<BookResponse>.Failure(409, "Book unavailable", "The book is not currently checked out.")
        };

    public async Task<ServiceResult<IReadOnlyList<BorrowerResponse>>> ListBorrowersAsync(CancellationToken ct)
        => ServiceResult<IReadOnlyList<BorrowerResponse>>.Success((await store.ListBorrowersAsync(ct)).Select(ToResponse).ToArray());

    public async Task<ServiceResult<BorrowerResponse>> GetBorrowerAsync(Guid id, CancellationToken ct)
        => MapNotFound(await store.GetBorrowerAsync(id, ct), "Borrower");

    public async Task<ServiceResult<BorrowerResponse>> CreateBorrowerAsync(CreateBorrowerRequest request, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(request.Name) || request.Name.Trim().Length > 120) return ServiceResult<BorrowerResponse>.Failure(422, "Invalid borrower", "Name is required and must be at most 120 characters.");
        if (string.IsNullOrWhiteSpace(request.Email) || !MailAddress.TryCreate(request.Email.Trim(), out _)) return ServiceResult<BorrowerResponse>.Failure(422, "Invalid borrower", "A valid email address is required.");
        var borrower = new Borrower { Id = Guid.NewGuid(), Name = request.Name.Trim(), Email = request.Email.Trim() };
        await store.AddBorrowerAsync(borrower, ct);
        return ServiceResult<BorrowerResponse>.Success(ToResponse(borrower));
    }

    private static string? ValidateBook(string? title, string? isbn, int year)
    {
        if (string.IsNullOrWhiteSpace(title) || title.Trim().Length > 200) return "Title is required and must be at most 200 characters.";
        var normalized = NormalizeIsbn(isbn ?? string.Empty);
        if (normalized.Length is not (10 or 13) || normalized.Any(c => !char.IsDigit(c))) return "ISBN must contain 10 or 13 digits.";
        if (year is < 0 or > 9999) return "Published year must be between 0 and 9999.";
        return null;
    }

    private static string NormalizeIsbn(string value) => new(value.Where(char.IsDigit).ToArray());
    private static BookResponse ToResponse(Book b) => new(b.Id, b.Title, b.Isbn, b.PublishedYear, b.ActiveLoan is not null, b.ActiveLoan?.BorrowerId, b.ActiveLoan?.DueDate);
    private static BorrowerResponse ToResponse(Borrower b) => new(b.Id, b.Name, b.Email);
    private static ServiceResult<T> MapNotFound<T>(T? value, string kind) where T : class => value is null ? ServiceResult<T>.Failure(404, $"{kind} not found", $"{kind} was not found.") : ServiceResult<T>.Success(value);
}

public sealed record ServiceResult<T>(T? Value, int? Status, string? Title, string? Detail)
{
    public static ServiceResult<T> Success(T value) => new(value, null, null, null);
    public static ServiceResult<T> Failure(int status, string title, string detail) => new(default, status, title, detail);
}

file static class ResultExtensions
{
    public static TResult Let<T, TResult>(this T value, Func<T, TResult> transform) => transform(value);
}
```

### `LibraryLending.Api/Endpoints/ApiResults.cs`

```csharp
using LibraryLending.Api.Services;

namespace LibraryLending.Api.Endpoints;

internal static class ApiResults
{
    public static IResult From<T>(ServiceResult<T> result) => result.Status is null
        ? Results.Ok(result.Value)
        : Results.Problem(statusCode: result.Status, title: result.Title, detail: result.Detail);
}
```

### `LibraryLending.Api/Endpoints/BookEndpoints.cs`

```csharp
using LibraryLending.Api.Contracts;
using LibraryLending.Api.Services;

namespace LibraryLending.Api.Endpoints;

public static class BookEndpoints
{
    public static RouteGroupBuilder MapBookEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/books").WithTags("Books");
        group.MapGet("/", List).WithName("ListBooks").WithSummary("List books").Produces<IEnumerable<BookResponse>>();
        group.MapGet("/{id:guid}", Get).WithName("GetBook").WithSummary("Read a book").Produces<BookResponse>().ProducesProblem(404);
        group.MapPost("/", Create).WithName("CreateBook").WithSummary("Create a book").Produces<BookResponse>(201).ProducesProblem(422);
        group.MapPut("/{id:guid}", Update).WithName("UpdateBook").WithSummary("Update a book").Produces<BookResponse>().ProducesProblem(404).ProducesProblem(409).ProducesProblem(422);
        group.MapDelete("/{id:guid}", Delete).WithName("DeleteBook").WithSummary("Delete a book").Produces(204).ProducesProblem(404).ProducesProblem(409);
        group.MapPost("/{id:guid}/checkout", Checkout).WithName("CheckoutBook").WithSummary("Check out a book").Produces<BookResponse>().ProducesProblem(404).ProducesProblem(409).ProducesProblem(422);
        group.MapPost("/{id:guid}/return", Return).WithName("ReturnBook").WithSummary("Return a book").Produces<BookResponse>().ProducesProblem(404).ProducesProblem(409);
        return group;
    }

    private static async Task<IResult> List(LibraryService service, CancellationToken ct) => ApiResults.From(await service.ListBooksAsync(ct));
    private static async Task<IResult> Get(Guid id, LibraryService service, CancellationToken ct) => ApiResults.From(await service.GetBookAsync(id, ct));
    private static async Task<IResult> Create(CreateBookRequest request, LibraryService service, CancellationToken ct)
    {
        var result = await service.CreateBookAsync(request, ct);
        return result.Status is null ? Results.Created($"/api/books/{result.Value!.Id}", result.Value) : ApiResults.From(result);
    }
    private static async Task<IResult> Update(Guid id, UpdateBookRequest request, LibraryService service, CancellationToken ct) => ApiResults.From(await service.UpdateBookAsync(id, request, ct));
    private static async Task<IResult> Delete(Guid id, LibraryService service, CancellationToken ct)
    {
        var result = await service.DeleteBookAsync(id, ct);
        return result.Status is null ? Results.NoContent() : ApiResults.From(result);
    }
    private static async Task<IResult> Checkout(Guid id, CheckoutRequest request, LibraryService service, CancellationToken ct) => ApiResults.From(await service.CheckoutAsync(id, request, ct));
    private static async Task<IResult> Return(Guid id, LibraryService service, CancellationToken ct) => ApiResults.From(await service.ReturnAsync(id, ct));
}
```

### `LibraryLending.Api/Endpoints/BorrowerEndpoints.cs`

```csharp
using LibraryLending.Api.Contracts;
using LibraryLending.Api.Services;

namespace LibraryLending.Api.Endpoints;

public static class BorrowerEndpoints
{
    public static RouteGroupBuilder MapBorrowerEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/borrowers").WithTags("Borrowers");
        group.MapGet("/", List).WithName("ListBorrowers").WithSummary("List borrowers").Produces<IEnumerable<BorrowerResponse>>();
        group.MapGet("/{id:guid}", Get).WithName("GetBorrower").WithSummary("Read a borrower").Produces<BorrowerResponse>().ProducesProblem(404);
        group.MapPost("/", Create).WithName("CreateBorrower").WithSummary("Create a borrower").Produces<BorrowerResponse>(201).ProducesProblem(422);
        return group;
    }

    private static async Task<IResult> List(LibraryService service, CancellationToken ct) => ApiResults.From(await service.ListBorrowersAsync(ct));
    private static async Task<IResult> Get(Guid id, LibraryService service, CancellationToken ct) => ApiResults.From(await service.GetBorrowerAsync(id, ct));
    private static async Task<IResult> Create(CreateBorrowerRequest request, LibraryService service, CancellationToken ct)
    {
        var result = await service.CreateBorrowerAsync(request, ct);
        return result.Status is null ? Results.Created($"/api/borrowers/{result.Value!.Id}", result.Value) : ApiResults.From(result);
    }
}
```

## Optional project support

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>net10.0</TargetFramework>
    <LangVersion>preview</LangVersion>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>
</Project>
```

## Implementation notes

- The sample uses minimal API route groups, DTO-only contracts, an in-memory singleton store, and a scoped service layer.
- `SemaphoreSlim` protects every store operation; checkout validates and mutates the book while holding the same gate, preventing concurrent double checkout.
- Validation failures use 422, missing resources use 404, state conflicts use 409, and all failures are emitted with `Results.Problem`, producing ProblemDetails-shaped responses.
- Endpoint names, summaries, tags, response types, and documented error statuses provide OpenAPI-friendly metadata.

## LSP operations used

- `workspaceSymbol` with query `Library` and language `csharp`; no matching symbols were present in the workspace.

## Limitations

- No repository files were modified and no build/test command was run, per the controlled-run constraints.
- Exact token counts and AI-credit usage were recovered from local session telemetry and are recorded above; currency-denominated pricing was not exposed.
- The project support snippet uses `LangVersion=preview` because released .NET 10/C# 14 toolchain availability is runtime-dependent.

## Medium Approach 4 - Hybrid

# Sample API Request — medium-hybrid

- **Approach label:** medium-hybrid
- **Model:** gpt-5.6-luna
- **Requested reasoning setting:** medium
- **Generation start (ISO):** 2026-08-06T03:57:06.7971753+02:00
- **Generation end (ISO):** 2026-08-06T03:57:06.7994838+02:00
- **Elapsed wall-clock duration:** 00:00:00.0023085
- **Exact input tokens:** `315,446` (sum of `input_tokens` across 9 model requests)
- **Exact output tokens:** `8,634` (sum of `output_tokens` across 9 model requests)
- **AI-credit usage:** `2.199609` AI credits (`2,199,609,000 total_nano_aiu`); currency-denominated price was not exposed.
- **Telemetry timing:** `245.458` seconds from first to last model-usage event; aggregate model-call duration `61.266` seconds.
- **Telemetry source:** Local session SQLite `assistant_usage_events`, grouped by parent task call `call_6wd98x8NGpLB4QKsriwfLZUZ`. The artifact stopwatch above is separate from model-call telemetry.

## Complete file inventory

1. `LibraryApi.csproj` (support snippet)
2. `Program.cs`
3. `Domain/Book.cs`
4. `Domain/Borrower.cs`
5. `Contracts/BookDtos.cs`
6. `Contracts/BorrowerDtos.cs`
7. `Persistence/InMemoryLibraryStore.cs`
8. `Services/LibraryService.cs`

### `LibraryApi.csproj`

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>net10.0</TargetFramework>
    <LangVersion>14</LangVersion>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>
</Project>
```

### `Program.cs`

```csharp
using LibraryApi.Contracts;
using LibraryApi.Persistence;
using LibraryApi.Services;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddProblemDetails();
builder.Services.AddSingleton<InMemoryLibraryStore>();
builder.Services.AddSingleton<LibraryService>();

var app = builder.Build();

app.UseExceptionHandler();
app.UseStatusCodePages();

var books = app.MapGroup("/api/books")
    .WithTags("Books");

books.MapPost("/", async Task<Results<Created<BookDto>, ValidationProblem>> (
    CreateBookRequest request,
    LibraryService service,
    CancellationToken cancellationToken) =>
{
    var result = await service.CreateBookAsync(request, cancellationToken);
    return result.IsSuccess
        ? TypedResults.Created($"/api/books/{result.Value!.Id}", result.Value)
        : TypedResults.ValidationProblem(result.Errors!);
})
    .WithName("CreateBook")
    .Accepts<CreateBookRequest>("application/json")
    .Produces<BookDto>(StatusCodes.Status201Created)
    .ProducesValidationProblem(StatusCodes.Status422UnprocessableEntity);

books.MapGet("/", async Task<Ok<IReadOnlyList<BookDto>>> (
    LibraryService service,
    CancellationToken cancellationToken) =>
    TypedResults.Ok(await service.ListBooksAsync(cancellationToken)))
    .WithName("ListBooks")
    .Produces<IReadOnlyList<BookDto>>();

books.MapGet("/{id:guid}", async Task<Results<Ok<BookDto>, NotFound<ProblemDetails>>> (
    Guid id,
    LibraryService service,
    CancellationToken cancellationToken) =>
{
    var book = await service.GetBookAsync(id, cancellationToken);
    return book is null
        ? TypedResults.NotFound(Problem("Book was not found.", StatusCodes.Status404NotFound))
        : TypedResults.Ok(book);
})
    .WithName("GetBook")
    .Produces<BookDto>()
    .ProducesProblem(StatusCodes.Status404NotFound);

books.MapPut("/{id:guid}", async Task<Results<Ok<BookDto>, NotFound<ProblemDetails>, ValidationProblem>> (
    Guid id,
    UpdateBookRequest request,
    LibraryService service,
    CancellationToken cancellationToken) =>
{
    var result = await service.UpdateBookAsync(id, request, cancellationToken);
    if (result.IsSuccess)
    {
        return TypedResults.Ok(result.Value!);
    }

    return result.NotFound
        ? TypedResults.NotFound(Problem("Book was not found.", StatusCodes.Status404NotFound))
        : TypedResults.ValidationProblem(result.Errors!);
})
    .WithName("UpdateBook")
    .Accepts<UpdateBookRequest>("application/json")
    .Produces<BookDto>()
    .ProducesProblem(StatusCodes.Status404NotFound)
    .ProducesValidationProblem(StatusCodes.Status422UnprocessableEntity);

books.MapDelete("/{id:guid}", async Task<Results<NoContent, NotFound<ProblemDetails>, Conflict<ProblemDetails>>> (
    Guid id,
    LibraryService service,
    CancellationToken cancellationToken) =>
{
    var result = await service.DeleteBookAsync(id, cancellationToken);
    return result switch
    {
        DeleteBookResult.Deleted => TypedResults.NoContent(),
        DeleteBookResult.NotFound => TypedResults.NotFound(Problem("Book was not found.", StatusCodes.Status404NotFound)),
        _ => TypedResults.Conflict(Problem("A checked-out book cannot be deleted.", StatusCodes.Status409Conflict))
    };
})
    .WithName("DeleteBook")
    .Produces(StatusCodes.Status204NoContent)
    .ProducesProblem(StatusCodes.Status404NotFound)
    .ProducesProblem(StatusCodes.Status409Conflict);

books.MapPost("/{id:guid}/checkout", async Task<Results<Ok<BookDto>, NotFound<ProblemDetails>, Conflict<ProblemDetails>, ValidationProblem>> (
    Guid id,
    CheckoutBookRequest request,
    LibraryService service,
    CancellationToken cancellationToken) =>
{
    var result = await service.CheckoutBookAsync(id, request, cancellationToken);
    if (result.IsSuccess)
    {
        return TypedResults.Ok(result.Value!);
    }

    if (result.Errors is not null)
    {
        return TypedResults.ValidationProblem(result.Errors);
    }

    return result.NotFound
        ? TypedResults.NotFound(Problem("Book or borrower was not found.", StatusCodes.Status404NotFound))
        : TypedResults.Conflict(Problem(result.ConflictMessage!, StatusCodes.Status409Conflict));
})
    .WithName("CheckoutBook")
    .Accepts<CheckoutBookRequest>("application/json")
    .Produces<BookDto>()
    .ProducesProblem(StatusCodes.Status404NotFound)
    .ProducesProblem(StatusCodes.Status409Conflict)
    .ProducesValidationProblem(StatusCodes.Status422UnprocessableEntity);

books.MapPost("/{id:guid}/return", async Task<Results<Ok<BookDto>, NotFound<ProblemDetails>, Conflict<ProblemDetails>>> (
    Guid id,
    LibraryService service,
    CancellationToken cancellationToken) =>
{
    var result = await service.ReturnBookAsync(id, cancellationToken);
    return result.IsSuccess
        ? TypedResults.Ok(result.Value!)
        : result.NotFound
            ? TypedResults.NotFound(Problem("Book was not found.", StatusCodes.Status404NotFound))
            : TypedResults.Conflict(Problem("The book is not currently checked out.", StatusCodes.Status409Conflict));
})
    .WithName("ReturnBook")
    .Produces<BookDto>()
    .ProducesProblem(StatusCodes.Status404NotFound)
    .ProducesProblem(StatusCodes.Status409Conflict);

var borrowers = app.MapGroup("/api/borrowers")
    .WithTags("Borrowers");

borrowers.MapPost("/", async Task<Results<Created<BorrowerDto>, ValidationProblem>> (
    CreateBorrowerRequest request,
    LibraryService service,
    CancellationToken cancellationToken) =>
{
    var result = await service.CreateBorrowerAsync(request, cancellationToken);
    return result.IsSuccess
        ? TypedResults.Created($"/api/borrowers/{result.Value!.Id}", result.Value)
        : TypedResults.ValidationProblem(result.Errors!);
})
    .WithName("CreateBorrower")
    .Accepts<CreateBorrowerRequest>("application/json")
    .Produces<BorrowerDto>(StatusCodes.Status201Created)
    .ProducesValidationProblem(StatusCodes.Status422UnprocessableEntity);

borrowers.MapGet("/", async Task<Ok<IReadOnlyList<BorrowerDto>>> (
    LibraryService service,
    CancellationToken cancellationToken) =>
    TypedResults.Ok(await service.ListBorrowersAsync(cancellationToken)))
    .WithName("ListBorrowers")
    .Produces<IReadOnlyList<BorrowerDto>>();

borrowers.MapGet("/{id:guid}", async Task<Results<Ok<BorrowerDto>, NotFound<ProblemDetails>>> (
    Guid id,
    LibraryService service,
    CancellationToken cancellationToken) =>
{
    var borrower = await service.GetBorrowerAsync(id, cancellationToken);
    return borrower is null
        ? TypedResults.NotFound(Problem("Borrower was not found.", StatusCodes.Status404NotFound))
        : TypedResults.Ok(borrower);
})
    .WithName("GetBorrower")
    .Produces<BorrowerDto>()
    .ProducesProblem(StatusCodes.Status404NotFound);

app.Run();

static ProblemDetails Problem(string detail, int status) => new()
{
    Status = status,
    Title = status switch
    {
        StatusCodes.Status404NotFound => "Resource not found",
        StatusCodes.Status409Conflict => "Conflict",
        _ => "Request failed"
    },
    Detail = detail,
    Type = $"https://httpstatuses.com/{status}"
};
```

### `Domain/Book.cs`

```csharp
namespace LibraryApi.Domain;

public sealed class Book
{
    public Book(Guid id, string title, string isbn)
    {
        Id = id;
        Title = title;
        Isbn = isbn;
    }

    public Guid Id { get; }
    public string Title { get; private set; }
    public string Isbn { get; private set; }
    public Guid? BorrowerId { get; private set; }
    public DateOnly? DueDate { get; private set; }

    public bool IsCheckedOut => BorrowerId.HasValue;

    public void Update(string title, string isbn)
    {
        Title = title;
        Isbn = isbn;
    }

    public void Checkout(Guid borrowerId, DateOnly dueDate)
    {
        if (IsCheckedOut)
        {
            throw new InvalidOperationException("The book is already checked out.");
        }

        BorrowerId = borrowerId;
        DueDate = dueDate;
    }

    public void Return()
    {
        if (!IsCheckedOut)
        {
            throw new InvalidOperationException("The book is not checked out.");
        }

        BorrowerId = null;
        DueDate = null;
    }
}
```

### `Domain/Borrower.cs`

```csharp
namespace LibraryApi.Domain;

public sealed class Borrower
{
    public Borrower(Guid id, string name, string email)
    {
        Id = id;
        Name = name;
        Email = email;
    }

    public Guid Id { get; }
    public string Name { get; }
    public string Email { get; }
}
```

### `Contracts/BookDtos.cs`

```csharp
namespace LibraryApi.Contracts;

public sealed record CreateBookRequest(string? Title, string? Isbn);

public sealed record UpdateBookRequest(string? Title, string? Isbn);

public sealed record CheckoutBookRequest(Guid BorrowerId, DateOnly DueDate);

public sealed record BookDto(
    Guid Id,
    string Title,
    string Isbn,
    bool IsCheckedOut,
    Guid? BorrowerId,
    DateOnly? DueDate);
```

### `Contracts/BorrowerDtos.cs`

```csharp
namespace LibraryApi.Contracts;

public sealed record CreateBorrowerRequest(string? Name, string? Email);

public sealed record BorrowerDto(Guid Id, string Name, string Email);
```

### `Persistence/InMemoryLibraryStore.cs`

```csharp
using LibraryApi.Domain;

namespace LibraryApi.Persistence;

public sealed class InMemoryLibraryStore
{
    private readonly object _gate = new();
    private readonly Dictionary<Guid, Book> _books = [];
    private readonly Dictionary<Guid, Borrower> _borrowers = [];

    public IReadOnlyList<Book> ListBooks()
    {
        lock (_gate)
        {
            return [.. _books.Values];
        }
    }

    public Book? GetBook(Guid id)
    {
        lock (_gate)
        {
            return _books.GetValueOrDefault(id);
        }
    }

    public void AddBook(Book book)
    {
        lock (_gate)
        {
            _books.Add(book.Id, book);
        }
    }

    public bool UpdateBook(Guid id, string title, string isbn)
    {
        lock (_gate)
        {
            if (!_books.TryGetValue(id, out var book))
            {
                return false;
            }

            book.Update(title, isbn);
            return true;
        }
    }

    public DeleteBookResult DeleteBook(Guid id)
    {
        lock (_gate)
        {
            if (!_books.TryGetValue(id, out var book))
            {
                return DeleteBookResult.NotFound;
            }

            return book.IsCheckedOut
                ? DeleteBookResult.CheckedOut
                : _books.Remove(id) ? DeleteBookResult.Deleted : DeleteBookResult.NotFound;
        }
    }

    public CheckoutResult CheckoutBook(Guid bookId, Guid borrowerId, DateOnly dueDate)
    {
        lock (_gate)
        {
            if (!_books.TryGetValue(bookId, out var book) || !_borrowers.ContainsKey(borrowerId))
            {
                return CheckoutResult.NotFound;
            }

            if (book.IsCheckedOut)
            {
                return CheckoutResult.AlreadyCheckedOut;
            }

            book.Checkout(borrowerId, dueDate);
            return CheckoutResult.Success;
        }
    }

    public ReturnResult ReturnBook(Guid id)
    {
        lock (_gate)
        {
            if (!_books.TryGetValue(id, out var book))
            {
                return ReturnResult.NotFound;
            }

            if (!book.IsCheckedOut)
            {
                return ReturnResult.NotCheckedOut;
            }

            book.Return();
            return ReturnResult.Success;
        }
    }

    public IReadOnlyList<Borrower> ListBorrowers()
    {
        lock (_gate)
        {
            return [.. _borrowers.Values];
        }
    }

    public Borrower? GetBorrower(Guid id)
    {
        lock (_gate)
        {
            return _borrowers.GetValueOrDefault(id);
        }
    }

    public void AddBorrower(Borrower borrower)
    {
        lock (_gate)
        {
            _borrowers.Add(borrower.Id, borrower);
        }
    }
}

public enum DeleteBookResult { Deleted, NotFound, CheckedOut }
public enum CheckoutResult { Success, NotFound, AlreadyCheckedOut }
public enum ReturnResult { Success, NotFound, NotCheckedOut }
```

### `Services/LibraryService.cs`

```csharp
using System.Net.Mail;
using System.Text.RegularExpressions;
using LibraryApi.Contracts;
using LibraryApi.Domain;
using LibraryApi.Persistence;

namespace LibraryApi.Services;

public sealed class LibraryService(InMemoryLibraryStore store)
{
    public Task<OperationResult<BookDto>> CreateBookAsync(CreateBookRequest request, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var errors = ValidateBook(request.Title, request.Isbn);
        if (errors.Count > 0)
        {
            return Task.FromResult(OperationResult<BookDto>.Invalid(errors));
        }

        var book = new Book(Guid.NewGuid(), request.Title!.Trim(), NormalizeIsbn(request.Isbn!));
        store.AddBook(book);
        return Task.FromResult(OperationResult<BookDto>.Success(ToDto(book)));
    }

    public Task<IReadOnlyList<BookDto>> ListBooksAsync(CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        return Task.FromResult<IReadOnlyList<BookDto>>(store.ListBooks().Select(ToDto).ToArray());
    }

    public Task<BookDto?> GetBookAsync(Guid id, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        return Task.FromResult(store.GetBook(id) is { } book ? ToDto(book) : null);
    }

    public Task<OperationResult<BookDto>> UpdateBookAsync(Guid id, UpdateBookRequest request, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var errors = ValidateBook(request.Title, request.Isbn);
        if (errors.Count > 0)
        {
            return Task.FromResult(OperationResult<BookDto>.Invalid(errors));
        }

        if (!store.UpdateBook(id, request.Title!.Trim(), NormalizeIsbn(request.Isbn!)))
        {
            return Task.FromResult(OperationResult<BookDto>.Missing());
        }

        return Task.FromResult(OperationResult<BookDto>.Success(ToDto(store.GetBook(id)!)));
    }

    public Task<DeleteBookResult> DeleteBookAsync(Guid id, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        return Task.FromResult(store.DeleteBook(id));
    }

    public Task<OperationResult<BookDto>> CheckoutBookAsync(Guid id, CheckoutBookRequest request, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var errors = new Dictionary<string, string[]>();
        if (request.BorrowerId == Guid.Empty)
        {
            errors[nameof(request.BorrowerId)] = ["BorrowerId is required."];
        }

        if (request.DueDate <= DateOnly.FromDateTime(DateTime.UtcNow))
        {
            errors[nameof(request.DueDate)] = ["DueDate must be in the future."];
        }

        if (errors.Count > 0)
        {
            return Task.FromResult(OperationResult<BookDto>.Invalid(errors));
        }

        var outcome = store.CheckoutBook(id, request.BorrowerId, request.DueDate);
        return outcome switch
        {
            CheckoutResult.Success => Task.FromResult(OperationResult<BookDto>.Success(ToDto(store.GetBook(id)!))),
            CheckoutResult.NotFound => Task.FromResult(OperationResult<BookDto>.Missing()),
            _ => Task.FromResult(OperationResult<BookDto>.Conflict("The book is already checked out."))
        };
    }

    public Task<OperationResult<BookDto>> ReturnBookAsync(Guid id, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var outcome = store.ReturnBook(id);
        return outcome switch
        {
            ReturnResult.Success => Task.FromResult(OperationResult<BookDto>.Success(ToDto(store.GetBook(id)!))),
            ReturnResult.NotFound => Task.FromResult(OperationResult<BookDto>.Missing()),
            _ => Task.FromResult(OperationResult<BookDto>.Conflict("The book is not currently checked out."))
        };
    }

    public Task<OperationResult<BorrowerDto>> CreateBorrowerAsync(CreateBorrowerRequest request, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var errors = ValidateBorrower(request.Name, request.Email);
        if (errors.Count > 0)
        {
            return Task.FromResult(OperationResult<BorrowerDto>.Invalid(errors));
        }

        var borrower = new Borrower(Guid.NewGuid(), request.Name!.Trim(), request.Email!.Trim());
        store.AddBorrower(borrower);
        return Task.FromResult(OperationResult<BorrowerDto>.Success(ToDto(borrower)));
    }

    public Task<IReadOnlyList<BorrowerDto>> ListBorrowersAsync(CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        return Task.FromResult<IReadOnlyList<BorrowerDto>>(store.ListBorrowers().Select(ToDto).ToArray());
    }

    public Task<BorrowerDto?> GetBorrowerAsync(Guid id, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        return Task.FromResult(store.GetBorrower(id) is { } borrower ? ToDto(borrower) : null);
    }

    private static Dictionary<string, string[]> ValidateBook(string? title, string? isbn)
    {
        var errors = new Dictionary<string, string[]>();
        if (string.IsNullOrWhiteSpace(title) || title.Trim().Length > 200)
        {
            errors[nameof(CreateBookRequest.Title)] = ["Title is required and must be at most 200 characters."];
        }

        var normalized = isbn is null ? string.Empty : NormalizeIsbn(isbn);
        if (normalized.Length is not (10 or 13) || !normalized.All(char.IsDigit))
        {
            errors[nameof(CreateBookRequest.Isbn)] = ["ISBN must contain 10 or 13 digits, with optional hyphens or spaces."];
        }

        return errors;
    }

    private static Dictionary<string, string[]> ValidateBorrower(string? name, string? email)
    {
        var errors = new Dictionary<string, string[]>();
        if (string.IsNullOrWhiteSpace(name) || name.Trim().Length > 120)
        {
            errors[nameof(CreateBorrowerRequest.Name)] = ["Name is required and must be at most 120 characters."];
        }

        try
        {
            _ = new MailAddress(email ?? string.Empty);
        }
        catch (FormatException)
        {
            errors[nameof(CreateBorrowerRequest.Email)] = ["Email must be a valid email address."];
        }

        return errors;
    }

    private static string NormalizeIsbn(string isbn) => Regex.Replace(isbn, "[\\s-]", string.Empty);

    private static BookDto ToDto(Book book) => new(book.Id, book.Title, book.Isbn, book.IsCheckedOut, book.BorrowerId, book.DueDate);
    private static BorrowerDto ToDto(Borrower borrower) => new(borrower.Id, borrower.Name, borrower.Email);
}

public sealed record OperationResult<T>(T? Value, Dictionary<string, string[]>? Errors, bool NotFound, string? ConflictMessage)
{
    public bool IsSuccess => Value is not null && Errors is null && !NotFound && ConflictMessage is null;
    public static OperationResult<T> Success(T value) => new(value, null, false, null);
    public static OperationResult<T> Invalid(Dictionary<string, string[]> errors) => new(default, errors, false, null);
    public static OperationResult<T> Missing() => new(default, null, true, null);
    public static OperationResult<T> Conflict(string message) => new(default, null, false, message);
}
```

## Implementation notes

- Uses Minimal APIs with explicit route names, tags, accepted content types, typed success metadata, and ProblemDetails/validation metadata.
- Uses only the ASP.NET Core/BCL shared framework; the `.csproj` snippet has no package references.
- Uses DTOs at the HTTP boundary and keeps domain entities internal to the service/store flow.
- Uses `Task` APIs and propagates `CancellationToken`; the in-memory operations are intentionally synchronous internally because they do not perform I/O.
- Checkout is atomic inside one store lock, preventing double checkout under concurrent requests.
- Validation failures are 422; malformed/unsupported framework-level requests remain 400, missing resources are 404, and state conflicts are 409.

## Aids actually used

- `martix-dotnet-csharp` skill: loaded and applied its .NET 10/C# 14 routing, Minimal API, DTO, validation, cancellation, and concurrency guidance.
- Local skill references read: `AGENTS.md`, `references/web-bootstrap-recipes.md`, `rules/web-aspnet-core.md`, `rules/async-concurrency-channels.md`, and `rules/design-exceptions-validation.md`.
- C# LSP/code intelligence: executed `documentSymbol` against the repository's existing `Program.cs`; it confirmed the available C# language server and returned the `Program` symbol.
- Built-in guidance beyond the above: none.
- Repository source files were inspected only for LSP availability; no repository files were modified.

## Limitations

- The artifact was not compiled because the request prohibited creating a project or source files outside this Markdown artifact.
- Exact token counts and AI-credit usage were recovered from local session telemetry and are recorded above; currency-denominated pricing was not exposed.
- The sample intentionally omits authentication/authorization and external persistence because they were outside the requested shared-framework, in-memory scope.


---

## Report provenance

The four full artifacts below are the exact Markdown outputs from the medium subagents after their headers were updated with recovered local telemetry. The previous xhigh/max-requested artifacts remain in `csharp-web-api-comparison.md`; this report intentionally avoids duplicating those thousands of lines while retaining their exact benchmark metrics and review conclusions above.