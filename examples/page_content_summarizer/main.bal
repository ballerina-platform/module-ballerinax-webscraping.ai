import ballerina/io;
import ballerinax/webscraping.ai;

configurable string apiKey = ?;
configurable string pageUrl = ?;
configurable string question = "What is this page about?";

// Checks the remaining credits, then converts a web page to Markdown text and asks an LLM a question about it.
public function main() returns error? {
    ai:Client scraper = check new ({apiKey});

    ai:Account account = check scraper->getAccount();
    io:println("Remaining credits: ", account?.remainingTotalCredits);

    string pageText = check scraper->getText(url = pageUrl);
    io:println("Page text length: ", pageText.length());
    io:println("Page text preview: ", pageText.substring(0, int:min(pageText.length(), 300)));

    string answer = check scraper->getAnswer(url = pageUrl, question = question);
    io:println("Answer: ", answer);
}
