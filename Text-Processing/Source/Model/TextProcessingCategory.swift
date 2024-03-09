//
//  TextProcessingCategory.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

import SwiftUI

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
    
    var image: Image {
        switch self {
        case .summarization:
            Image(systemName: "text.bubble.fill")
        case .askQuestions:
            Image(systemName: "questionmark.circle.fill")
        case .continuationGenerating:
            Image(systemName: "character.cursor.ibeam")
        }
    }
}
