public struct Languages: Decodable {
    public let translation: [String: TranslationLanguage]
    public let transliteration: [String: TransliterationLanguage]
    public let dictionary: [String: DictionaryLanguage]

    public struct TranslationLanguage: Decodable {
        public let name: String
        public let nativeName: String
        public let dir: String
    }

    public struct TransliterationLanguage: Decodable {
        public let name: String
        public let nativeName: String
        public let scripts: [Script]

        public struct Script: Decodable {
            public let code: String
            public let name: String
            public let nativeName: String
            public let dir: String
            public let toScripts: [Script]

            public struct Script: Decodable {
                public let code: String
                public let name: String
                public let nativeName: String
                public let dir: String
            }
        }
    }

    public struct DictionaryLanguage: Decodable {
        public let name: String
        public let nativeName: String
        public let dir: String
        public let translations: [Translation]

        public struct Translation: Decodable {
            public let name: String
            public let nativeName: String
            public let dir: String
            public let code: String
        }
    }
}
