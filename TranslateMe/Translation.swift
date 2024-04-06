//
//  Translation.swift
//  TranslateMe
//
//  Created by Helen Hoang on 4/5/24.
//

import Foundation

// Define the structure of the JSON response
struct TranslationResponse: Codable {
    struct ResponseData: Codable {
        let translatedText: String
    }
    let responseData: ResponseData
}

struct Translation: Identifiable, Hashable {
    let id = UUID()
    let originalText: String
    let translatedText: String
}
