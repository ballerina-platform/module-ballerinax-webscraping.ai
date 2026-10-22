_Author_:  @DimuthuMadushan \
_Created_: 2026/10/22 \
_Updated_: 2026/10/22 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from WebScraping.AI. 
The OpenAPI specification is obtained from [WebScraping.AI OpenAPI specification](https://github.com/wso2/api-specs/blob/main/openapi/webscraping.ai/webscraping.ai/3.2.2/openapi.yml).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Downgrade the OpenAPI version from `3.1.0` to `3.0.3` and replace the type arrays `["string", "null"]` and `["object", "null"]` with `type` plus `nullable: true`.

   _Reason_: The flatten step drops `type` from parameter schemas in a `3.1.0` document, which leaves parameters such as `selector`, `selectors`, `fields` and `text_format` without a type and makes client generation crash. The change was made in `docs/spec/openapi.yml`.

2. Rename operation IDs for readability and consistent naming: `getQuestion` to `getAnswer`, `getHTML` to `getHtml`, `account` to `getAccount`.

   _Reason_: Intent-revealing, consistently cased method names. The decisions are persisted in `docs/spec/ai-mappings.json`.

3. Rename schemas: `SerpResultOrganicResults` to `OrganicResult` and `SerpResultRelatedSearches` to `RelatedSearch`. The inline `/ai/fields` response is promoted to a named `FieldsResult` schema in `docs/spec/openapi.yml`.

   _Reason_: Generated names were generic or verbose. The renames are persisted in `docs/spec/ai-mappings.json`.

4. Fill missing schema and property descriptions in `docs/spec/openapi.yml` (schemas `Error`, `SerpResult`, `DataResult`, `Account`, and the properties of `SerpResult` and `DataResult` such as the search parameters, organic results, related searches, pagination and request parameters), applied from `docs/spec/description-decisions.json` with `tooling/apply_descriptions.py`.

   _Reason_: Generated record fields without a description produce `undocumented field` warnings.

5. Add descriptions to the aligned spec `docs/spec/aligned_ballerina_openapi.json`: the properties `DataResult.request_parameters`, `Error.next_step`, `Error.request_parameters`, `SerpResult.search_information` and `SerpResult.search_parameters` (flatten turns these inline objects into `$ref`s and drops the property description), the schemas `OrganicResult` and `RelatedSearch`, and the `api_key` security scheme.

   _Reason_: Remove `undocumented field` warnings and improve generated documentation. These edits were made in the aligned spec and must be re-applied after a re-align.

6. Add `properties` to the object-typed query parameters `fields` (property `title`) and `headers` (property `Cookie`), keeping `additionalProperties`, in `docs/spec/openapi.yml`. The inline `fields` schema is named `FieldDescriptions` through `docs/spec/ai-mappings.json`.

   _Reason_: For a free-form `type: object` + `additionalProperties` query parameter the generator drops `style: deepObject`, so the client sent `?title=x` instead of `?fields[title]=x`. With a declared property it emits the `DEEPOBJECT` encoding map for `fields` and `headers`.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json --mode client --license docs/license.txt -o ballerina --client-methods remote
```
Note: The license year is hardcoded to 2024, change if necessary.
