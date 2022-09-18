public struct Translations: Decodable {
    public let translations: [Translation]

    public struct Translation: Decodable {
        public let to: String
        public let text: String
    }
}
