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

import ballerina/http;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.webscraping.ai" : "http://localhost:9090";
final string apiKey = isLiveServer ? os:getEnv("WEBSCRAPING_AI_API_KEY") : "test_api_key";

final Client webScraping = check new ({apiKey}, {httpVersion: http:HTTP_1_1}, serviceUrl);

const string TARGET_URL = "https://example.com";

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetAccount() returns error? {
    Account response = check webScraping->getAccount();
    test:assertTrue(response?.remainingTotalCredits is int);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetAnswer() returns error? {
    string response = check webScraping->getAnswer(url = TARGET_URL, question = "What is this page about?");
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetFields() returns error? {
    FieldsResult response = check webScraping->getFields(url = TARGET_URL, fields = {"title": "Page title"});
    test:assertTrue(response?.result !is ());
}

@test:Config {groups: ["mock_tests"]}
isolated function testGetFieldsRequiresDeepObjectFields() returns error? {
    // The mock rejects the request unless the `fields[title]` nested query parameter is received.
    FieldsResult response = check webScraping->getFields(url = TARGET_URL, fields = {"title": "Page title", "price": "Product price"});
    test:assertTrue(response?.result !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetHtml() returns error? {
    string response = check webScraping->getHtml(url = TARGET_URL);
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetText() returns error? {
    string response = check webScraping->getText(url = TARGET_URL);
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetSelected() returns error? {
    string response = check webScraping->getSelected(url = TARGET_URL, selector = "h1");
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetSelectedMultiple() returns error? {
    SelectedAreas response = check webScraping->getSelectedMultiple(url = TARGET_URL, selectors = ["h1", "p"]);
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetSerp() returns error? {
    SerpResult response = check webScraping->getSerp(q = "ballerina language");
    test:assertTrue(response?.organicResults !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetData() returns error? {
    DataResult response = check webScraping->getData(url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ");
    test:assertTrue(response?.parseStatus !is ());
}
