//
//  TextSummaryViewModel.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 22.03.2024.
//

import Foundation
import NLTextProcessing

final class TextSummaryViewModel: ObservableObject {
    
    // MARK: Properties

    @Published var selectedSummarizationLevel = NLTextSummary.SummarizationLevel.medium

    @MainActor @Published var isShowSummarizedText = false
    @MainActor @Published private(set) var summarizedText: String?
    @MainActor @Published var isTextProcessing = false

    let summarizationLevels = NLTextSummary.SummarizationLevel.allCases

    private let textSummarizer = NLTextSummary()

    // MARK: Methods

    func titleForSummarizationLevel(_ level: NLTextSummary.SummarizationLevel) -> String {
        switch level {
        case .low:
            LocalizableStrings.TextSummary.SummarizationLevelTitle.low
        case .medium:
            LocalizableStrings.TextSummary.SummarizationLevelTitle.medium
        case .high:
            LocalizableStrings.TextSummary.SummarizationLevelTitle.hight
        }
    }

    @MainActor
    func makeSummary(of text: String) {
        isTextProcessing = true

        Task.detached { [weak self] in
            guard let self else { return }

            let summarizedText = textSummarizer.summarize(
                text: text,
                method: .level(selectedSummarizationLevel)
            )

            await MainActor.run {
                defer { self.isTextProcessing = false }
                self.summarizedText = summarizedText
                self.isShowSummarizedText = true
            }
        }
    }
}
