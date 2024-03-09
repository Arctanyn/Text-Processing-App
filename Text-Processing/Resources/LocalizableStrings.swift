//
//  LocalizableStrings.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

import Foundation

enum LocalizableStrings {
    static let categoriesTitle = "categories.title".localized
}

extension LocalizableStrings {
    enum MainScreen {
        static let textInputPlaceholder = "text.input.placeholder".localized
    }
}

// MARK: - TextProcessingCategories
extension LocalizableStrings {
    enum TextProcessingCategories {
        
        // MARK: Categories Titles
        static let textSummaryTitle = "text.summary.title".localized
        static let textAskQuestionsTitle = "text.ask.questions.title".localized
        static let textContinuationGeneratingTitle = "text.continuation.generating.title".localized
        
        // MARK: Categoris Desriptions
        static let textSummaryDescription = "text.summary.description".localized
        static let textAskQuestionsDescription = "text.ask.questions.description".localized
        static let textContinuationGeneratingDescription = "text.continuation.generating.description".localized
    }
}
