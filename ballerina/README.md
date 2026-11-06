## Overview

[WebScraping.AI](https://webscraping.ai) is a web scraping API that provides LLM-powered tools, Chromium JavaScript rendering, rotating proxies and built-in HTML parsing. This connector lets Ballerina applications fetch page HTML and Markdown text, select page areas with CSS selectors, ask questions about a page, extract structured fields, run search engine queries and read structured data from supported sites. It supports version 3.2.2 of the WebScraping.AI API.

### Key features

- Retrieve page HTML or clean Markdown text, with JavaScript rendering and proxy options
- Select one or more page areas by CSS selector
- Ask an LLM questions about a page and extract structured fields from it
- Search engine results (SERP) and structured data for supported sites
- Check your remaining API credits and concurrency

## Setup guide

To use the WebScraping.AI connector, you need an API key.

1. Create an account at [webscraping.ai](https://webscraping.ai) and sign in.

2. Open the dashboard and copy your API key.

3. Store the key in a `Config.toml` file in your project, for example:

    ```toml
    apiKey = "<YOUR_API_KEY>"
    ```

## Quickstart

To use the `webscraping.ai` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerinax/webscraping.ai;
```

### Step 2: Instantiate a new connector

```ballerina
configurable string apiKey = ?;

final ai:Client scraper = check new ({apiKey});
```

### Step 3: Invoke the connector operation

```ballerina
public function main() returns error? {
    ai:Account _ = check scraper->getAccount();
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The `WebScraping.AI` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-webscraping.ai/tree/main/examples/), covering the following use cases:

1. [Page content summarizer](https://github.com/ballerina-platform/module-ballerinax-webscraping.ai/tree/main/examples/page_content_summarizer) - Check the account quota, convert a web page to Markdown and ask an LLM a question about it.
2. [Search result extractor](https://github.com/ballerina-platform/module-ballerinax-webscraping.ai/tree/main/examples/search_result_extractor) - Run a search query and extract a structured field from the top result.
