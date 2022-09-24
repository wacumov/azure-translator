public struct DictionaryLookup: Decodable {
    public let normalizedSource: String
    public let displaySource: String
    public let translations: [Translation]

    public struct Translation: Decodable {
        public let normalizedTarget: String
        public let displayTarget: String
        public let posTag: String
        public let confidence: Double
        public let prefixWord: String
        public let backTranslations: [BackTranslation]

        public struct BackTranslation: Decodable {
            public let normalizedText: String
            public let displayText: String
            public let numExamples: Int
            public let frequencyCount: Int
        }
    }
}
