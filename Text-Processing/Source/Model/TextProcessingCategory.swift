//
//  TextProcessingCategory.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

// MARK: - TextProcessingCategory

enum TextProcessingCategory: CaseIterable {
    case summarization
    case askQuestions
    case continuationGenerating

    var title: String {
        switch self {
        case .summarization: LocalizableStrings.TextProcessingCategories.textSummaryTitle
        case .askQuestions: LocalizableStrings.TextProcessingCategories.textAskQuestionsTitle
        case .continuationGenerating: LocalizableStrings.TextProcessingCategories.textContinuationGeneratingTitle
        }
    }

    var description: String {
        switch self {
        case .summarization: LocalizableStrings.TextProcessingCategories.textSummaryDescription
        case .askQuestions: LocalizableStrings.TextProcessingCategories.textAskQuestionsDescription
        case .continuationGenerating: LocalizableStrings.TextProcessingCategories.textContinuationGeneratingDescription
        }
    }
}
