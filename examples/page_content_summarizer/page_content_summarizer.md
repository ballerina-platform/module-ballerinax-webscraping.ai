# Page content summarizer

This example checks the remaining account credits, converts a web page to Markdown text and asks an LLM a question about the page content.

## Prerequisites

1. A WebScraping.AI account and API key. See the [setup guide](https://github.com/ballerina-platform/module-ballerinax-webscraping.ai/blob/main/ballerina/README.md#setup-guide).

2. Create a `Config.toml` file in the example directory with the following content:

    ```toml
    apiKey = "<YOUR_API_KEY>"
    pageUrl = "<PAGE_URL>"
    question = "What is this page about?"
    ```

## Run the example

Execute the following command to run the example:

```bash
bal run
```
