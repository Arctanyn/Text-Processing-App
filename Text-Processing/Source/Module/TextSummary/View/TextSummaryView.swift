//
//  TextSummaryView.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

import SwiftUI

struct TextSummaryView: View {
    
    // MARK: Properties

    @StateObject private var viewModel = TextSummaryViewModel()

    @State private var enteredText = String()

    // MARK: Body

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 14) {
                TextInputView(
                    onStartLoadingFile: {}, onUpdateText: { text in
                        enteredText = text
                    }
                )
                .clipShape(.rect(cornerRadius: 16, style: .continuous))

                HStack {
                    Text("\(LocalizableStrings.TextSummary.textCompressionRatio):")

                    Picker(selection: $viewModel.selectedSummarizationLevel) {
                        ForEach(viewModel.summarizationLevels, id: \.self) {
                            Text(viewModel.titleForSummarizationLevel($0))
                        }
                    } label: {
                        Text("\(LocalizableStrings.TextSummary.textCompressionRatio):")
                    }
                    .pickerStyle(.menu)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                Button {
                    viewModel.makeSummary(of: enteredText)
                } label: {
                    Group {
                        if viewModel.isTextProcessing {
                            HStack(spacing: 10) {
                                ProgressView()
                                Text(LocalizableStrings.processing)
                                    .foregroundStyle(.secondary)
                            }
                        } else {
                            Text(LocalizableStrings.TextSummary.makeSummaryButtonTitle)
                        }
                    }
                    .transition(.opacity.animation(.easeInOut(duration: 0.2)))
                }
                .buttonStyle(
                    ActionButtonStyle(
                        disabled: enteredText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    )
                )
            }
            .padding()
            .allowsHitTesting(!viewModel.isTextProcessing)
            .disabled(viewModel.isTextProcessing)
            .animation(.easeInOut(duration: 0.2), value: viewModel.isTextProcessing)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(LocalizableStrings.TextSummary.title)
        .sheet(isPresented: $viewModel.isShowSummarizedText) {
            VStack {
                SummarizedTextView(text: viewModel.summarizedText ?? "")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    NavigationStack {
        TextSummaryView()
    }
}
