//
//  StopWords.swift
//
//
//  Created by Malil Dugulubgov on 21.04.2024.
//

import Foundation

enum StopWords {
    static let en = getWords(forLanguage: .en)
    static let ru = getWords(forLanguage: .ru)
    
    private static func getWords(forLanguage lang: Language) -> Set<String> {
        guard let url = Bundle.module.url(forResource: lang.fileName, withExtension: "json") else {
            return []
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return []
        }
        
        guard let words = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        
        return Set(words)
    }
}

// MARK: - Language

private extension StopWords {
    private enum Language {
        case ru, en
        
        var fileName: String {
            switch self {
            case .ru:
                return "RuStopWords"
            case .en:
                return "EnStopWords"
            }
        }
    }
}
