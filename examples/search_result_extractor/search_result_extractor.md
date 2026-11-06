# Search result extractor

This example runs a search engine query, lists the top organic results and extracts a structured field from the first result page.

## Prerequisites

1. A WebScraping.AI account and API key. See the [setup guide](https://github.com/ballerina-platform/module-ballerinax-webscraping.ai/blob/main/ballerina/README.md#setup-guide).

2. Create a `Config.toml` file in the example directory with the following content:

    ```toml
    apiKey = "<YOUR_API_KEY>"
    searchQuery = "<SEARCH_QUERY>"
    productFieldName = "title"
    productFieldDescription = "Main title of the page"
    ```

## Run the example

Execute the following command to run the example:

```bash
bal run
```
