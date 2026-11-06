import ballerina/io;
import ballerinax/webscraping.ai;

configurable string apiKey = ?;
configurable string searchQuery = ?;
configurable string productFieldName = "title";
configurable string productFieldDescription = "Main title of the page";

// Searches the web, then extracts a structured field from the top organic result.
public function main() returns error? {
    ai:Client scraper = check new ({apiKey});

    ai:SerpResult serp = check scraper->getSerp(q = searchQuery);
    ai:OrganicResult[] results = serp?.organicResults ?: [];
    if results.length() == 0 {
        return error("No organic results found for query: " + searchQuery);
    }

    foreach ai:OrganicResult item in results.slice(0, int:min(results.length(), 5)) {
        io:println(item?.position, ". ", item?.title, " - ", item?.link);
    }

    string? topLink = results[0]?.link;
    if topLink is () {
        return error("The top result has no link");
    }

    ai:FieldsResult fields = check scraper->getFields(url = topLink, fields = {[productFieldName]: productFieldDescription});
    io:println("Extracted fields: ", fields?.result);
}
