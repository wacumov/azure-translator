
import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public struct Translator {
    private let apiKey: String
    private let region: String?
    private let session = URLSession.shared
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(apiKey: String, region: String? = nil) {
        self.apiKey = apiKey
        self.region = region
    }

    public func languages() async throws -> Languages {
        let url = try makeURL(path: "/languages")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return try await decodedData(for: request)
    }

    public func translate(_ texts: [String], from sourceLanguage: String, to targetLanguages: [String]) async throws -> [Translations] {
        let url = try makeURL(
            path: "/translate",
            query: [
                ("from", sourceLanguage),
            ] + targetLanguages.map {
                ("to", $0)
            }
        )
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        setHeaders(&request)
        try setHTTPBody(&request, texts)
        return try await decodedData(for: request)
    }

    public func dictionaryLookup(_ terms: [String], from sourceLanguage: String, to targetLanguage: String) async throws -> [DictionaryLookup] {
        let url = try makeURL(
            path: "/dictionary/lookup",
            query: [
                ("from", sourceLanguage),
                ("to", targetLanguage),
            ]
        )
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        setHeaders(&request)
        try setHTTPBody(&request, terms)
        return try await decodedData(for: request)
    }

    private func makeURL(path: String, query: [(String, String)] = []) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.cognitive.microsofttranslator.com"
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "api-version", value: "3.0"),
        ] + query.map {
            URLQueryItem(name: $0.0, value: $0.1)
        }
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        return url
    }

    private func setHeaders(_ request: inout URLRequest) {
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        if let region = region {
            request.setValue(region, forHTTPHeaderField: "Ocp-Apim-Subscription-Region")
        }
    }

    private func setHTTPBody(_ request: inout URLRequest, _ texts: [String]) throws {
        struct Element: Encodable {
            let Text: String
        }
        let body = texts.map {
            Element(Text: $0)
        }
        request.httpBody = try encoder.encode(body)
    }

    private func decodedData<Output: Decodable>(for request: URLRequest) async throws -> Output {
        let data = try await session.data(for: request)
        return try decoder.decode(Output.self, from: data)
    }
}

private extension URLSession {
    func data(for request: URLRequest) async throws -> Data {
        var task: URLSessionDataTask?
        let onCancel = {
            task?.cancel()
        }
        return try await withTaskCancellationHandler(
            handler: {
                onCancel()
            },
            operation: {
                try await withCheckedThrowingContinuation { continuation in
                    task = dataTask(with: request) { data, _, error in
                        guard let data = data else {
                            let error = error ?? URLError(.badServerResponse)
                            return continuation.resume(throwing: error)
                        }
                        continuation.resume(returning: data)
                    }
                    task?.resume()
                }
            }
        )
    }
}
