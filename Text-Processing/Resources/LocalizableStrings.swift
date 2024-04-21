//
//  LocalizableStrings.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

import Foundation

enum LocalizableStrings {
    static let categoriesTitle = "categories.title".localized
    static let doneKeyboardButtonTitle = "done.keyboard.button.title".localized
    static let textInputPlaceholder = "text.input.placeholder".localized
    static let chooseFile = "choose.file".localized
    static let symbolsCount = "symbols.count".localized
    static let close = "close.text".localized
    static let wordsCount = "words.count".localized
    static let processing = "processing.text".localized
}

// MARK: - TextSummary

extension LocalizableStrings {
    enum TextSummary {
        static let title = "text.summary.page.title".localized
        static let makeSummaryButtonTitle = "make.summary.button.title".localized
        static let textCompressionRatio = "text.compression.ratio".localized
        static let summarizedText = "summarized.text".localized

        enum SummarizationLevelTitle {
            static let veryLow = "summarization.level.very.low".localized
            static let low = "summarization.level.low".localized
            static let medium = "summarization.level.medium".localized
            static let hight = "summarization.level.high".localized
            static let veryHigh = "summarization.level.very.high".localized
        }
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

// MARK: - String Extensions

private extension String {
    var localized: String {
        String(localized: String.LocalizationValue(self))
    }
}
