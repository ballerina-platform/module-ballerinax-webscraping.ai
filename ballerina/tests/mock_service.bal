// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/data.jsondata;
import ballerina/http;

listener http:Listener ep0 = new (9090);

@http:ServiceConfig {treatNilableAsOptional: true}
service / on ep0 {
    # Information about your account calls quota
    #
    # + return - returns can be any of following types 
    # http:Forbidden (Wrong or missing API key. Get a key at https://webscraping.ai/dashboard)
    # http:Ok (The retrieved account)
    resource function get account() returns ErrorForbidden|Account {
        Account account = {
            email: "user@example.com",
            remainingApiCalls: 4800,
            remainingMonthlyCredits: 4800,
            remainingPaygCredits: 200,
            remainingTotalCredits: 5000,
            resetsAt: 1767225600,
            remainingConcurrency: 5
        };
        return account;
    }

    # Extract structured data fields from a web page
    #
    # + url - URL of the target page
    # + request - The incoming request, used to read the deepObject `fields[name]` query parameters
    # + headers - HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&headers[One]=value1&headers[Another]=value2) or as a JSON encoded object (...&headers={"One": "value1", "Another": "value2"})
    # + timeout - Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 25000; larger values are capped at 25000)
    # + js - Execute on-page JavaScript using a headless browser (true by default)
    # + jsTimeout - Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page
    # + waitFor - CSS selector to wait for before returning the page content. Useful for pages with dynamic content loading. Overrides js_timeout. If the element doesn't appear within the request timeout, the request fails with a 500 error naming the selector and including the target page's HTTP status code and a preview of the page body
    # + proxy - Type of proxy. Use `residential` if your site restricts traffic from datacenters, or `stealth` for the most heavily protected sites with advanced anti-bot detection (`datacenter` by default). Residential and stealth proxy requests are more expensive than datacenter, see the pricing page for details.
    # `auto` walks the tiers cheapest-first inside one request (datacenter, then residential, then stealth; anti-bot challenge pages skip straight to stealth) and bills only the tier that succeeded. Failed attempts are free. The API remembers, per domain, the cheapest tier that worked and starts there for 30 days, so repeat requests to a protected site do not re-pay the failed rungs in latency. Cannot be combined with `custom_proxy`
    # + country - Country of the proxy to use (US by default)
    # + customProxy - Your own proxy URL to use instead of our built-in proxy pool in "http://user:password@host:port" format (<a target="_blank" href="https://webscraping.ai/proxies/smartproxy">Decodo</a>, formerly Smartproxy, for example)
    # + device - Type of device emulation
    # + errorOn404 - Return error on 404 HTTP status on the target page (false by default)
    # + errorOnRedirect - Return error on redirect on the target page (false by default)
    # + jsScript - Custom JavaScript code to execute on the target page. It is evaluated as a script whose result is the value of its last expression (a top-level `return` is a syntax error), and it is only run by /html; the other endpoints accept the parameter but ignore it
    # + return - returns can be any of following types 
    # http:BadRequest (Parameters validation error)
    # http:PaymentRequired (Out of API credits — upgrade your plan or top up your pay-as-you-go balance on https://webscraping.ai/dashboard/billing)
    # http:Forbidden (Wrong or missing API key. Get a key at https://webscraping.ai/dashboard)
    # http:TooManyRequests (Too many concurrent requests for your plan. Wait for a running request to finish and retry, or upgrade for a higher limit.)
    # http:InternalServerError (The target page could not be scraped (blocked, anti-bot challenge, non-2xx status, DNS failure) or an unexpected error occurred. Failed requests are not billed (the one exception is a redirect returned because of `error_on_redirect=true`, which is a successful outcome you asked for).
# Failures on the scraping endpoints (/html, /text, /selected, /selected-multiple, /ai/*) carry a machine-readable `error_code` and, when a better configuration exists, a `next_step` with the parameters to retry with and their credit cost. /serp and /data have their own error envelopes.
# )
    # http:GatewayTimeout (Timeout error, try increasing timeout parameter value)
    # http:Ok (The retrieved fields)
    resource function get ai/fields(string url, http:Request request, record{|string...;|}? headers, @http:Query {name: "wait_for"} string? waitFor, @http:Query {name: "custom_proxy"} string? customProxy, @http:Query {name: "js_script"} string? jsScript, int timeout = 10000, boolean js = true, @http:Query {name: "js_timeout"} int jsTimeout = 2000, "datacenter"|"residential"|"stealth"|"auto" proxy = "datacenter", "us"|"gb"|"de"|"it"|"fr"|"ca"|"es"|"ru"|"jp"|"kr"|"in"|"hk"|"tr" country = "us", "desktop"|"mobile"|"tablet" device = "desktop", @http:Query {name: "error_on_404"} boolean errorOn404 = false, @http:Query {name: "error_on_redirect"} boolean errorOnRedirect = false) returns ErrorBadRequest|ErrorPaymentRequired|ErrorForbidden|ErrorTooManyRequests|ErrorInternalServerError|ErrorGatewayTimeout|FieldsResult {
        if request.getQueryParamValue("fields[title]") is () {
            ErrorBadRequest badRequest = {body: {message: "fields[title] is required", statusCode: 400}};
            return badRequest;
        }
        FieldsResult fieldsResult = {result: {"title": "Example Product", "price": "$99.99", "description": "This is a sample product description"}};
        return fieldsResult;
    }

    # Get an answer to a question about a given web page
    #
    # + url - URL of the target page
    # + question - Question or instructions to ask the LLM model about the target page
    # + headers - HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&headers[One]=value1&headers[Another]=value2) or as a JSON encoded object (...&headers={"One": "value1", "Another": "value2"})
    # + timeout - Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 25000; larger values are capped at 25000)
    # + js - Execute on-page JavaScript using a headless browser (true by default)
    # + jsTimeout - Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page
    # + waitFor - CSS selector to wait for before returning the page content. Useful for pages with dynamic content loading. Overrides js_timeout. If the element doesn't appear within the request timeout, the request fails with a 500 error naming the selector and including the target page's HTTP status code and a preview of the page body
    # + proxy - Type of proxy. Use `residential` if your site restricts traffic from datacenters, or `stealth` for the most heavily protected sites with advanced anti-bot detection (`datacenter` by default). Residential and stealth proxy requests are more expensive than datacenter, see the pricing page for details.
    # `auto` walks the tiers cheapest-first inside one request (datacenter, then residential, then stealth; anti-bot challenge pages skip straight to stealth) and bills only the tier that succeeded. Failed attempts are free. The API remembers, per domain, the cheapest tier that worked and starts there for 30 days, so repeat requests to a protected site do not re-pay the failed rungs in latency. Cannot be combined with `custom_proxy`
    # + country - Country of the proxy to use (US by default)
    # + customProxy - Your own proxy URL to use instead of our built-in proxy pool in "http://user:password@host:port" format (<a target="_blank" href="https://webscraping.ai/proxies/smartproxy">Decodo</a>, formerly Smartproxy, for example)
    # + device - Type of device emulation
    # + errorOn404 - Return error on 404 HTTP status on the target page (false by default)
    # + errorOnRedirect - Return error on redirect on the target page (false by default)
    # + jsScript - Custom JavaScript code to execute on the target page. It is evaluated as a script whose result is the value of its last expression (a top-level `return` is a syntax error), and it is only run by /html; the other endpoints accept the parameter but ignore it
    # + format - Format of the response (text by default). "text" returns the plain text/HTML response. "json" wraps it in a JSON object with a `result` key, for tools such as Zapier that only accept JSON
    # + return - returns can be any of following types 
    # http:BadRequest (Parameters validation error)
    # http:PaymentRequired (Out of API credits — upgrade your plan or top up your pay-as-you-go balance on https://webscraping.ai/dashboard/billing)
    # http:Forbidden (Wrong or missing API key. Get a key at https://webscraping.ai/dashboard)
    # http:TooManyRequests (Too many concurrent requests for your plan. Wait for a running request to finish and retry, or upgrade for a higher limit.)
    # http:InternalServerError (The target page could not be scraped (blocked, anti-bot challenge, non-2xx status, DNS failure) or an unexpected error occurred. Failed requests are not billed (the one exception is a redirect returned because of `error_on_redirect=true`, which is a successful outcome you asked for).
# Failures on the scraping endpoints (/html, /text, /selected, /selected-multiple, /ai/*) carry a machine-readable `error_code` and, when a better configuration exists, a `next_step` with the parameters to retry with and their credit cost. /serp and /data have their own error envelopes.
# )
    # http:GatewayTimeout (Timeout error, try increasing timeout parameter value)
    # http:Ok (The retrieved answer)
    resource function get ai/question(string url, string? question, record{|string...;|}? headers, @http:Query {name: "wait_for"} string? waitFor, @http:Query {name: "custom_proxy"} string? customProxy, @http:Query {name: "js_script"} string? jsScript, int timeout = 10000, boolean js = true, @http:Query {name: "js_timeout"} int jsTimeout = 2000, "datacenter"|"residential"|"stealth"|"auto" proxy = "datacenter", "us"|"gb"|"de"|"it"|"fr"|"ca"|"es"|"ru"|"jp"|"kr"|"in"|"hk"|"tr" country = "us", "desktop"|"mobile"|"tablet" device = "desktop", @http:Query {name: "error_on_404"} boolean errorOn404 = false, @http:Query {name: "error_on_redirect"} boolean errorOnRedirect = false, "json"|"text" format = "text") returns ErrorBadRequest|ErrorPaymentRequired|ErrorForbidden|ErrorTooManyRequests|ErrorInternalServerError|ErrorGatewayTimeout|string {
        return "This page is an example domain used for illustrative examples in documents.";
    }

    # Structured data for a page on a supported site
    #
    # + url - URL of a page on a supported site
    # + country - Two-letter country code of the proxy used to fetch the page (`us` by default). Must be one of the API's proxy countries (see the `country` parameter of the page endpoints); other values are rejected with a 400
    # + transcript - YouTube videos only. Also fetch the video's transcript into `data.transcript` (null when no matching captions are available). If the transcript fetch itself fails, the whole request fails with a 500 and is not charged
    # + transcriptLanguage - YouTube videos only, with `transcript=true`. Caption language to pick, e.g. `en` or `de`. Without it, English is preferred, then the first available track. If the video has no captions in that language, `data.transcript` is null
    # + return - returns can be any of following types 
    # http:BadRequest (Parameters validation error)
    # http:PaymentRequired (Out of API credits — upgrade your plan or top up your pay-as-you-go balance on https://webscraping.ai/dashboard/billing)
    # http:Forbidden (Wrong or missing API key. Get a key at https://webscraping.ai/dashboard)
    # http:TooManyRequests (Too many concurrent requests for your plan. Wait for a running request to finish and retry, or upgrade for a higher limit.)
    # http:InternalServerError (The target page could not be scraped (blocked, anti-bot challenge, non-2xx status, DNS failure) or an unexpected error occurred. Failed requests are not billed (the one exception is a redirect returned because of `error_on_redirect=true`, which is a successful outcome you asked for).
# Failures on the scraping endpoints (/html, /text, /selected, /selected-multiple, /ai/*) carry a machine-readable `error_code` and, when a better configuration exists, a `next_step` with the parameters to retry with and their credit cost. /serp and /data have their own error envelopes.
# )
    # http:GatewayTimeout (Timeout error, try increasing timeout parameter value)
    # http:Ok (The retrieved data)
    resource function get data(string url, @http:Query {name: "transcript_language"} string? transcriptLanguage, string country = "us", boolean transcript = false) returns ErrorBadRequest|ErrorPaymentRequired|ErrorForbidden|ErrorTooManyRequests|ErrorInternalServerError|ErrorGatewayTimeout|DataResult {
        DataResult dataResult = {
            requestParameters: {url: url, provider: "youtube", 'type: "video"},
            parseStatus: "ok",
            data: {"title": "Example video", "channel": "Example Channel", "views": 1024}
        };
        return dataResult;
    }

    # Page HTML by URL
    #
    # + url - URL of the target page
    # + headers - HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&headers[One]=value1&headers[Another]=value2) or as a JSON encoded object (...&headers={"One": "value1", "Another": "value2"})
    # + timeout - Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 25000; larger values are capped at 25000)
    # + js - Execute on-page JavaScript using a headless browser (true by default)
    # + jsTimeout - Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page
    # + waitFor - CSS selector to wait for before returning the page content. Useful for pages with dynamic content loading. Overrides js_timeout. If the element doesn't appear within the request timeout, the request fails with a 500 error naming the selector and including the target page's HTTP status code and a preview of the page body
    # + proxy - Type of proxy. Use `residential` if your site restricts traffic from datacenters, or `stealth` for the most heavily protected sites with advanced anti-bot detection (`datacenter` by default). Residential and stealth proxy requests are more expensive than datacenter, see the pricing page for details.
    # `auto` walks the tiers cheapest-first inside one request (datacenter, then residential, then stealth; anti-bot challenge pages skip straight to stealth) and bills only the tier that succeeded. Failed attempts are free. The API remembers, per domain, the cheapest tier that worked and starts there for 30 days, so repeat requests to a protected site do not re-pay the failed rungs in latency. Cannot be combined with `custom_proxy`
    # + country - Country of the proxy to use (US by default)
    # + customProxy - Your own proxy URL to use instead of our built-in proxy pool in "http://user:password@host:port" format (<a target="_blank" href="https://webscraping.ai/proxies/smartproxy">Decodo</a>, formerly Smartproxy, for example)
    # + device - Type of device emulation
    # + errorOn404 - Return error on 404 HTTP status on the target page (false by default)
    # + errorOnRedirect - Return error on redirect on the target page (false by default)
    # + jsScript - Custom JavaScript code to execute on the target page. It is evaluated as a script whose result is the value of its last expression (a top-level `return` is a syntax error), and it is only run by /html; the other endpoints accept the parameter but ignore it
    # + returnScriptResult - Return result of the custom JavaScript code (js_script parameter) execution on the target page (false by default, page HTML will be returned)
    # + format - Format of the response (text by default). "text" returns the plain text/HTML response. "json" wraps it in a JSON object with a `result` key, for tools such as Zapier that only accept JSON
    # + return - returns can be any of following types 
    # http:BadRequest (Parameters validation error)
    # http:PaymentRequired (Out of API credits — upgrade your plan or top up your pay-as-you-go balance on https://webscraping.ai/dashboard/billing)
    # http:Forbidden (Wrong or missing API key. Get a key at https://webscraping.ai/dashboard)
    # http:TooManyRequests (Too many concurrent requests for your plan. Wait for a running request to finish and retry, or upgrade for a higher limit.)
    # http:InternalServerError (The target page could not be scraped (blocked, anti-bot challenge, non-2xx status, DNS failure) or an unexpected error occurred. Failed requests are not billed (the one exception is a redirect returned because of `error_on_redirect=true`, which is a successful outcome you asked for).
# Failures on the scraping endpoints (/html, /text, /selected, /selected-multiple, /ai/*) carry a machine-readable `error_code` and, when a better configuration exists, a `next_step` with the parameters to retry with and their credit cost. /serp and /data have their own error envelopes.
# )
    # http:GatewayTimeout (Timeout error, try increasing timeout parameter value)
    # http:Ok (The retrieved html)
    resource function get html(string url, record{|string...;|}? headers, @http:Query {name: "wait_for"} string? waitFor, @http:Query {name: "custom_proxy"} string? customProxy, @http:Query {name: "js_script"} string? jsScript, int timeout = 10000, boolean js = true, @http:Query {name: "js_timeout"} int jsTimeout = 2000, "datacenter"|"residential"|"stealth"|"auto" proxy = "datacenter", "us"|"gb"|"de"|"it"|"fr"|"ca"|"es"|"ru"|"jp"|"kr"|"in"|"hk"|"tr" country = "us", "desktop"|"mobile"|"tablet" device = "desktop", @http:Query {name: "error_on_404"} boolean errorOn404 = false, @http:Query {name: "error_on_redirect"} boolean errorOnRedirect = false, @http:Query {name: "return_script_result"} boolean returnScriptResult = false, "json"|"text" format = "text") returns ErrorBadRequest|ErrorPaymentRequired|ErrorForbidden|ErrorTooManyRequests|ErrorInternalServerError|ErrorGatewayTimeout|string {
        return "<html><head><title>Example Domain</title></head><body><h1>Example Domain</h1><p>This domain is for use in illustrative examples in documents.</p></body></html>";
    }

    # HTML of a selected page area by URL and CSS selector
    #
    # + selector - CSS selector of the page area to return. The inner HTML of the first matching element is returned; if nothing matches, the request fails with a 400 "Element not found"
    # + url - URL of the target page
    # + headers - HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&headers[One]=value1&headers[Another]=value2) or as a JSON encoded object (...&headers={"One": "value1", "Another": "value2"})
    # + timeout - Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 25000; larger values are capped at 25000)
    # + js - Execute on-page JavaScript using a headless browser (true by default)
    # + jsTimeout - Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page
    # + waitFor - CSS selector to wait for before returning the page content. Useful for pages with dynamic content loading. Overrides js_timeout. If the element doesn't appear within the request timeout, the request fails with a 500 error naming the selector and including the target page's HTTP status code and a preview of the page body
    # + proxy - Type of proxy. Use `residential` if your site restricts traffic from datacenters, or `stealth` for the most heavily protected sites with advanced anti-bot detection (`datacenter` by default). Residential and stealth proxy requests are more expensive than datacenter, see the pricing page for details.
    # `auto` walks the tiers cheapest-first inside one request (datacenter, then residential, then stealth; anti-bot challenge pages skip straight to stealth) and bills only the tier that succeeded. Failed attempts are free. The API remembers, per domain, the cheapest tier that worked and starts there for 30 days, so repeat requests to a protected site do not re-pay the failed rungs in latency. Cannot be combined with `custom_proxy`
    # + country - Country of the proxy to use (US by default)
    # + customProxy - Your own proxy URL to use instead of our built-in proxy pool in "http://user:password@host:port" format (<a target="_blank" href="https://webscraping.ai/proxies/smartproxy">Decodo</a>, formerly Smartproxy, for example)
    # + device - Type of device emulation
    # + errorOn404 - Return error on 404 HTTP status on the target page (false by default)
    # + errorOnRedirect - Return error on redirect on the target page (false by default)
    # + jsScript - Custom JavaScript code to execute on the target page. It is evaluated as a script whose result is the value of its last expression (a top-level `return` is a syntax error), and it is only run by /html; the other endpoints accept the parameter but ignore it
    # + format - Format of the response (text by default). "text" returns the plain text/HTML response. "json" wraps it in a JSON object with a `result` key, for tools such as Zapier that only accept JSON
    # + return - returns can be any of following types 
    # http:BadRequest (Parameters validation error)
    # http:PaymentRequired (Out of API credits — upgrade your plan or top up your pay-as-you-go balance on https://webscraping.ai/dashboard/billing)
    # http:Forbidden (Wrong or missing API key. Get a key at https://webscraping.ai/dashboard)
    # http:TooManyRequests (Too many concurrent requests for your plan. Wait for a running request to finish and retry, or upgrade for a higher limit.)
    # http:InternalServerError (The target page could not be scraped (blocked, anti-bot challenge, non-2xx status, DNS failure) or an unexpected error occurred. Failed requests are not billed (the one exception is a redirect returned because of `error_on_redirect=true`, which is a successful outcome you asked for).
# Failures on the scraping endpoints (/html, /text, /selected, /selected-multiple, /ai/*) carry a machine-readable `error_code` and, when a better configuration exists, a `next_step` with the parameters to retry with and their credit cost. /serp and /data have their own error envelopes.
# )
    # http:GatewayTimeout (Timeout error, try increasing timeout parameter value)
    # http:Ok (The retrieved selected)
    resource function get selected(string? selector, string url, record{|string...;|}? headers, @http:Query {name: "wait_for"} string? waitFor, @http:Query {name: "custom_proxy"} string? customProxy, @http:Query {name: "js_script"} string? jsScript, int timeout = 10000, boolean js = true, @http:Query {name: "js_timeout"} int jsTimeout = 2000, "datacenter"|"residential"|"stealth"|"auto" proxy = "datacenter", "us"|"gb"|"de"|"it"|"fr"|"ca"|"es"|"ru"|"jp"|"kr"|"in"|"hk"|"tr" country = "us", "desktop"|"mobile"|"tablet" device = "desktop", @http:Query {name: "error_on_404"} boolean errorOn404 = false, @http:Query {name: "error_on_redirect"} boolean errorOnRedirect = false, "json"|"text" format = "text") returns ErrorBadRequest|ErrorPaymentRequired|ErrorForbidden|ErrorTooManyRequests|ErrorInternalServerError|ErrorGatewayTimeout|string {
        return "<h1>Example Domain</h1>";
    }

    resource function get selected\-multiple(string[]? selectors, string url, record{|string...;|}? headers, @http:Query {name: "wait_for"} string? waitFor, @http:Query {name: "custom_proxy"} string? customProxy, @http:Query {name: "js_script"} string? jsScript, int timeout = 10000, boolean js = true, @http:Query {name: "js_timeout"} int jsTimeout = 2000, "datacenter"|"residential"|"stealth"|"auto" proxy = "datacenter", "us"|"gb"|"de"|"it"|"fr"|"ca"|"es"|"ru"|"jp"|"kr"|"in"|"hk"|"tr" country = "us", "desktop"|"mobile"|"tablet" device = "desktop", @http:Query {name: "error_on_404"} boolean errorOn404 = false, @http:Query {name: "error_on_redirect"} boolean errorOnRedirect = false) returns ErrorBadRequest|ErrorPaymentRequired|ErrorForbidden|ErrorTooManyRequests|ErrorInternalServerError|ErrorGatewayTimeout|SelectedAreas {
        return [["Example Domain"], ["This domain is for use in illustrative examples."]];
    }

    # Search engine results (SERP) by query
    #
    # + q - Search query
    # + engine - Search engine to query
    # + gl - Two-letter country code for geolocation of the search (Google `gl` parameter)
    # + hl - Two-letter language code for the results (Google `hl` parameter)
    # + page - Results page number (10 results per page), from 1 to 100. Any other value (0, a fraction, a non-number, or above 100) is rejected with a 400 before billing
    # + return - returns can be any of following types 
    # http:BadRequest (Parameters validation error)
    # http:PaymentRequired (Out of API credits — upgrade your plan or top up your pay-as-you-go balance on https://webscraping.ai/dashboard/billing)
    # http:Forbidden (Wrong or missing API key. Get a key at https://webscraping.ai/dashboard)
    # http:TooManyRequests (Too many concurrent requests for your plan. Wait for a running request to finish and retry, or upgrade for a higher limit.)
    # http:InternalServerError (The target page could not be scraped (blocked, anti-bot challenge, non-2xx status, DNS failure) or an unexpected error occurred. Failed requests are not billed (the one exception is a redirect returned because of `error_on_redirect=true`, which is a successful outcome you asked for).
# Failures on the scraping endpoints (/html, /text, /selected, /selected-multiple, /ai/*) carry a machine-readable `error_code` and, when a better configuration exists, a `next_step` with the parameters to retry with and their credit cost. /serp and /data have their own error envelopes.
# )
    # http:GatewayTimeout (Timeout error, try increasing timeout parameter value)
    # http:Ok (The retrieved serp)
    resource function get serp(string q, "google" engine = "google", string gl = "us", string hl = "en", int page = 1) returns ErrorBadRequest|ErrorPaymentRequired|ErrorForbidden|ErrorTooManyRequests|ErrorInternalServerError|ErrorGatewayTimeout|SerpResult {
        SerpResult serpResult = {
            searchParameters: {engine: "google", q: q, gl: gl, hl: hl, page: page},
            searchInformation: {queryDisplayed: q, organicResultsState: "Results for exact spelling"},
            organicResults: [
                {position: 1, title: "Ballerina Programming Language", link: "https://ballerina.io", domain: "ballerina.io", displayedLink: "https://ballerina.io", snippet: "Ballerina is an open source language for cloud native integration."},
                {position: 2, title: "Ballerina (programming language) - Wikipedia", link: "https://en.wikipedia.org/wiki/Ballerina_(programming_language)", domain: "en.wikipedia.org", displayedLink: "https://en.wikipedia.org", snippet: "Ballerina is a general-purpose programming language designed for network-distributed applications."}
            ],
            relatedSearches: [{query: "ballerina language tutorial"}, {query: "ballerina vs java"}],
            pagination: {current: 1, next: 2}
        };
        return serpResult;
    }

    # Page text by URL (Markdown)
    #
    # + text_format - Format of the text response (plain by default). "plain" will return the page body content as Markdown. "json" and "xml" will return a json/xml with "title", "description" and "content" (Markdown) keys
    # + returnLinks - [Works only with text_format=json] Return links from the page body text (false by default). Useful for building web crawlers
    # + url - URL of the target page
    # + headers - HTTP headers to pass to the target page. Can be specified either via a nested query parameter (...&headers[One]=value1&headers[Another]=value2) or as a JSON encoded object (...&headers={"One": "value1", "Another": "value2"})
    # + timeout - Maximum web page retrieval time in ms. Increase it in case of timeout errors (10000 by default, maximum is 25000; larger values are capped at 25000)
    # + js - Execute on-page JavaScript using a headless browser (true by default)
    # + jsTimeout - Maximum JavaScript rendering time in ms. Increase it in case if you see a loading indicator instead of data on the target page
    # + waitFor - CSS selector to wait for before returning the page content. Useful for pages with dynamic content loading. Overrides js_timeout. If the element doesn't appear within the request timeout, the request fails with a 500 error naming the selector and including the target page's HTTP status code and a preview of the page body
    # + proxy - Type of proxy. Use `residential` if your site restricts traffic from datacenters, or `stealth` for the most heavily protected sites with advanced anti-bot detection (`datacenter` by default). Residential and stealth proxy requests are more expensive than datacenter, see the pricing page for details.
    # `auto` walks the tiers cheapest-first inside one request (datacenter, then residential, then stealth; anti-bot challenge pages skip straight to stealth) and bills only the tier that succeeded. Failed attempts are free. The API remembers, per domain, the cheapest tier that worked and starts there for 30 days, so repeat requests to a protected site do not re-pay the failed rungs in latency. Cannot be combined with `custom_proxy`
    # + country - Country of the proxy to use (US by default)
    # + customProxy - Your own proxy URL to use instead of our built-in proxy pool in "http://user:password@host:port" format (<a target="_blank" href="https://webscraping.ai/proxies/smartproxy">Decodo</a>, formerly Smartproxy, for example)
    # + device - Type of device emulation
    # + errorOn404 - Return error on 404 HTTP status on the target page (false by default)
    # + errorOnRedirect - Return error on redirect on the target page (false by default)
    # + jsScript - Custom JavaScript code to execute on the target page. It is evaluated as a script whose result is the value of its last expression (a top-level `return` is a syntax error), and it is only run by /html; the other endpoints accept the parameter but ignore it
    # + return - returns can be any of following types 
    # http:BadRequest (Parameters validation error)
    # http:PaymentRequired (Out of API credits — upgrade your plan or top up your pay-as-you-go balance on https://webscraping.ai/dashboard/billing)
    # http:Forbidden (Wrong or missing API key. Get a key at https://webscraping.ai/dashboard)
    # http:TooManyRequests (Too many concurrent requests for your plan. Wait for a running request to finish and retry, or upgrade for a higher limit.)
    # http:InternalServerError (The target page could not be scraped (blocked, anti-bot challenge, non-2xx status, DNS failure) or an unexpected error occurred. Failed requests are not billed (the one exception is a redirect returned because of `error_on_redirect=true`, which is a successful outcome you asked for).
# Failures on the scraping endpoints (/html, /text, /selected, /selected-multiple, /ai/*) carry a machine-readable `error_code` and, when a better configuration exists, a `next_step` with the parameters to retry with and their credit cost. /serp and /data have their own error envelopes.
# )
    # http:GatewayTimeout (Timeout error, try increasing timeout parameter value)
    # http:Ok (The retrieved text)
    resource function get text(string url, record{|string...;|}? headers, @http:Query {name: "wait_for"} string? waitFor, @http:Query {name: "custom_proxy"} string? customProxy, @http:Query {name: "js_script"} string? jsScript, @http:Query {name: "text_format"} "plain"|"xml"|"json" textFormat = "plain", @http:Query {name: "return_links"} boolean returnLinks = false, int timeout = 10000, boolean js = true, @http:Query {name: "js_timeout"} int jsTimeout = 2000, "datacenter"|"residential"|"stealth"|"auto" proxy = "datacenter", "us"|"gb"|"de"|"it"|"fr"|"ca"|"es"|"ru"|"jp"|"kr"|"in"|"hk"|"tr" country = "us", "desktop"|"mobile"|"tablet" device = "desktop", @http:Query {name: "error_on_404"} boolean errorOn404 = false, @http:Query {name: "error_on_redirect"} boolean errorOnRedirect = false) returns ErrorBadRequest|ErrorPaymentRequired|ErrorForbidden|ErrorTooManyRequests|ErrorInternalServerError|ErrorGatewayTimeout|string|xml {
        return "Example Domain: this domain is for use in illustrative examples in documents.";
    }
}
// Service-mode response types. `bal openapi --mode client` collapses 4XX/5XX
// to `error` and never emits these, so they are defined here for the mock only.
public type ErrorBadRequest record {|
    *http:BadRequest;
    Error body;
|};

public type ErrorForbidden record {|
    *http:Forbidden;
    Error body;
|};

public type ErrorGatewayTimeout record {|
    *http:GatewayTimeout;
    Error body;
|};

public type ErrorInternalServerError record {|
    *http:InternalServerError;
    Error body;
|};

public type ErrorPaymentRequired record {|
    *http:PaymentRequired;
    Error body;
|};

public type ErrorTooManyRequests record {|
    *http:TooManyRequests;
    Error body;
|};

# Error details returned by the API
public type Error record {
    # Target page response HTTP status message
    @jsondata:Name {value: "status_message"}
    string statusMessage?;
    # Target page response HTTP status code (403, 500, etc)
    @jsondata:Name {value: "status_code"}
    int statusCode?;
    @jsondata:Name {value: "next_step"}
    ErrorNextStep nextStep?;
    # Machine-readable failure class, present on 500 and 504 responses from the scraping endpoints (/html, /text, /selected, /selected-multiple, /ai/*).
    # `target_blocked` (403/429/503/999 from the target), `target_challenge` (anti-bot challenge page served as content),
    # `target_error` (other non-2xx status), `target_redirect` (redirect with `error_on_redirect=true`),
    # `target_unreachable` (DNS failure or connection closed during TLS), `invalid_url`, `forbidden_target`,
    # `custom_proxy_error` (your custom_proxy returned 407), `wait_for_timeout`, `response_too_large`, `timeout` (504), `internal_error`
    @jsondata:Name {value: "error_code"}
    "target_blocked"|"target_challenge"|"target_error"|"target_redirect"|"target_unreachable"|"invalid_url"|"forbidden_target"|"custom_proxy_error"|"wait_for_timeout"|"response_too_large"|"timeout"|"internal_error" errorCode?;
    # Error description
    string message?;
    # Target page response body preview (first 500 characters), when the target returned one
    string body?;
    @jsondata:Name {value: "request_parameters"}
    ErrorRequestParameters requestParameters?;
};

# The next configuration worth trying, with its price on current plans. Absent when the request already used the strongest configuration (stealth or a dedicated route), when a retry would not help (bad URL, site's own 4xx), or for Google search URLs (use /serp instead)
public type ErrorNextStep record {
    # Credits per request with those parameters on current plans
    int cost?;
    # Parameters to add to (or change on) the retried request
    record {|string...;|} params?;
    # Human-readable version of the suggestion
    string message?;
    # Parameters to drop from the retried request (present when the failed request used custom_proxy, which otherwise overrides any proxy setting)
    string[] remove?;
};

# The configuration the failed request ran with. Present on target-side errors (blocked, challenge, non-2xx, connection closed, wait_for), not on request-validation errors
public type ErrorRequestParameters record {
    # Proxy tier used. For `proxy=auto` this is the tier the walk ended on
    "datacenter"|"residential"|"stealth"|"custom"|"dedicated" proxy?;
    # Present (true) when the request used `proxy=auto`
    boolean auto?;
    # Whether JavaScript rendering was enabled
    boolean js?;
    # For `proxy=auto`, the tiers walked in order before giving up
    @jsondata:Name {value: "tiers_tried"}
    ("datacenter"|"residential"|"stealth")[] tiersTried?;
};
