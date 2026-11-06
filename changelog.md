# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Remote methods for the newer WebScraping.AI endpoints, with the records they use:
  - `getText`, which returns the page text (`GetTextQueries`).
  - `getAnswer`, which answers a question about a page (`GetAnswerQueries`).
  - `getFields`, which extracts structured fields from a page (`GetFieldsQueries`, `FieldDescriptions`, `FieldsResult`).
  - `getSerp`, which returns search engine results (`GetSerpQueries`, `SerpResult`, `SerpResultPagination`, `SerpResultSearchInformation`, `SerpResultSearchParameters`, `OrganicResult`, `RelatedSearch`).
  - `getData`, which returns structured data for a page on a supported site (`GetDataQueries`, `DataResult`, `DataResultRequestParameters`).
- A `*Queries` record for each operation, such as `GetHtmlQueries` and `GetSelectedQueries`, which carries its query parameters.
- New query parameters on the page methods: `country`, `device`, `jsTimeout`, `jsScript`, `waitFor`, `errorOn404`, `errorOnRedirect` and `customProxy`, plus `format` on `getHtml` and `getSelected` and `returnScriptResult` on `getHtml`.
- The `TargetPageHeaders` record, which holds the HTTP headers to pass to the target page.
- New `Account` fields: `remainingTotalCredits`, `remainingPaygCredits`, `remainingMonthlyCredits` and `email`. `remainingApiCalls` is kept but deprecated.
- An optional request-headers parameter on every remote method, for sending extra request headers. It is named `headers1` on the methods that already take a `headers` query parameter, and `headers` on the others.
- New `ConnectionConfig` fields, taken from `http:ClientConfiguration`: `followRedirects`, `cookieConfig`, `socketConfig` and `laxDataBinding`.

### Changed

- **Breaking:** the remote methods are renamed:
  - `getHTML` is now `getHtml`.
  - `account` is now `getAccount`.
- **Breaking:** query parameters are no longer positional. `url`, `selector`, `selectors`, `timeout`, `js`, `proxy` and the others are passed as named arguments, or as the operation's `*Queries` record:

    ```ballerina
    // 1.5.2
    string html = check scraper->getHTML("https://example.com", timeout = 10000);
    ```

    ```ballerina
    // 2.0.0
    string html = check scraper->getHtml(url = "https://example.com", timeout = 10000);
    ```

- **Breaking:** the `headers` query parameter is now the `targetPageHeaders` named argument, a `TargetPageHeaders` record (was `headers`, a `record {}?`). It is still sent as the `headers` query parameter.
- **Breaking:** `proxy` is one of `"datacenter"`, `"residential"`, `"stealth"` or `"auto"` (was `string`).
- **Breaking:** `timeout` defaults to 10000 ms (was 5000) and is constrained to 1–25000.
- **Breaking:** `SelectedAreas` is `string[][]` (was `string[]`).
- **Breaking:** `Account` fields use camel case, mapped to the API's snake-case JSON names with `@jsondata:Name`: `remaining_api_calls` is now `remainingApiCalls`, `resets_at` is now `resetsAt` and `remaining_concurrency` is now `remainingConcurrency`.
- **Breaking:** `ConnectionConfig.http1Settings` is now `http:ClientHttp1Settings` (was the connector's own `ClientHttp1Settings`).
- `ConnectionConfig.timeout` defaults to 30 seconds (was 60).

### Removed

- **Breaking:** the connector's own `ClientHttp1Settings` and `ProxyConfig` records. Use `http:ClientHttp1Settings` and `http:ProxyConfig` instead.
- **Breaking:** the `PageError` and `Error` records. No method returned either.
