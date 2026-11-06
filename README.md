# Ballerina WebScraping.AI connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-webscraping.ai/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-webscraping.ai/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-webscraping.ai.svg)](https://github.com/ballerina-platform/module-ballerinax-webscraping.ai/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/webscraping.ai.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fwebscraping.ai)

## Overview

[WebScraping.AI](https://webscraping.ai) is a web scraping API that provides LLM-powered tools, Chromium JavaScript rendering, rotating proxies and built-in HTML parsing. This connector lets Ballerina applications fetch page HTML and Markdown text, select page areas with CSS selectors, ask questions about a page, extract structured fields, run search engine queries and read structured data from supported sites. It supports version 3.2.2 of the WebScraping.AI API.

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

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`webscraping.ai` package](https://central.ballerina.io/ballerinax/webscraping.ai/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
