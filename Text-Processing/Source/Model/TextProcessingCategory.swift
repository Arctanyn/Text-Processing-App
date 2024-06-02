//
//  TextProcessingCategory.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

enum TextProcessingCategory: CaseIterable {
    case summarization
    case askQuestions
    case continuationGenerating
    case textAndSpeechProcessing

    var title: String {
        switch self {
        case .summarization: LocalizableStrings.TextProcessingCategories.textSummaryTitle
        case .askQuestions: LocalizableStrings.TextProcessingCategories.textAskQuestionsTitle
        case .continuationGenerating: LocalizableStrings.TextProcessingCategories.textContinuationGeneratingTitle
        case .textAndSpeechProcessing: LocalizableStrings.TextProcessingCategories.textAndSpeechProcessingTitle
        }
    }

    var description: String {
        switch self {
        case .summarization: LocalizableStrings.TextProcessingCategories.textSummaryDescription
        case .askQuestions: LocalizableStrings.TextProcessingCategories.textAskQuestionsDescription
        case .continuationGenerating: LocalizableStrings.TextProcessingCategories.textContinuationGeneratingDescription
        case .textAndSpeechProcessing: LocalizableStrings.TextProcessingCategories.textAndSpeechProcessingDescription
        }
    }
}
