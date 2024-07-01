//
//  ProcessingCategoriesView.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

import SwiftUI

struct ProcessingCategoriesView: View {
    
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                VStack {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 20) {
                            ForEach(viewModel.textProcessingCategories, id: \.self) { category in
                                NavigationLink {
                                    switch category {
                                    case .summarization:
                                        TextSummaryView()
                                    case .askQuestions:
                                        AskQuestionsView()
                                    case .continuationGenerating:
                                        GenerateTextContinueView()
                                    case .textAndSpeechProcessing:
                                        TextSpeechProcessingView()
                                    }
                                } label: {
                                    TextProcessingCategoryView(category: category)
                                }
                                .foregroundStyle(.primary)
                                .buttonStyle(PushDownButtonStyle())
                            }
                        }
                        .padding(10)
                    }
                }
            }
            .navigationTitle(LocalizableStrings.categoriesTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {} label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    ProcessingCategoriesView()
        .tint(.teal)
}
