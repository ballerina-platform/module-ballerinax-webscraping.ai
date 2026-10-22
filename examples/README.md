# Examples

The `ballerinax/webscraping.ai` connector provides practical examples illustrating usage in various scenarios.

1. [Page content summarizer](./page_content_summarizer/page_content_summarizer.md) - Check the account quota, convert a web page to Markdown and ask an LLM a question about it.
2. [Search result extractor](./search_result_extractor/search_result_extractor.md) - Run a search query and extract a structured field from the top result.

## Prerequisites

1. A WebScraping.AI API key. See the [setup guide](../ballerina/README.md#setup-guide).

2. Create a `Config.toml` file in the example directory with the `apiKey` and the values listed in the example's document.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
