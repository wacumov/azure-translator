import AzureTranslator
import XCTest

final class TranslatorTests: XCTestCase {
    let translator = Translator(apiKey: "KEY", region: "REGION")

    func testLanguages() async throws {
        let languages = try await translator.languages()
        XCTAssertFalse(languages.translation.isEmpty)
    }

    func testTranslate() async throws {
        let translations = try await translator.translate(["white"], from: "en", to: ["et"])
        XCTAssertFalse(translations.isEmpty)
    }

    func testDictionaryLookup() async throws {
        let lookupResults = try await translator.dictionaryLookup(["valge"], from: "et", to: "en")
        XCTAssertFalse(lookupResults.isEmpty)
    }
}
