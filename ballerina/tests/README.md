# Running Tests

## Prerequisites

You need a WebScraping.AI API key to run the tests against the live API. The tests run against a mock server by default.

## Running the tests

The suite covers every operation: `getAccount`, `getAnswer`, `getFields`, `getHtml`, `getText`, `getSelected`, `getSelectedMultiple`, `getSerp` and `getData`.

### Against the mock server

```bash
bal test --groups mock_tests
```

### Against the live API

Set the environment variables and run the live group:

```bash
export IS_LIVE_SERVER=true
export WEBSCRAPING_AI_API_KEY=<your-api-key>
bal test --groups live_tests
```
