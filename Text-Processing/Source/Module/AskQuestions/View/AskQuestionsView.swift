//
//  AskQuestionsView.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 01.05.2024.
//

import SwiftUI

struct AskQuestionsView: View {
    
    @StateObject private var viewModel = AskQuestionsViewModel()
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            VStack(spacing: 14) {
                TextInputView(
                    wordsCountLimit: viewModel.wordsLimit,
                    onUpdateText: { updatedText in
                        viewModel.text = updatedText
                        viewModel.clearChat()
                    }
                )
                .clipShape(.rect(cornerRadius: 16, style: .continuous))
                
                NavigationLink {
                    AskQuestionsChat(viewModel: viewModel)
                } label: {
                    HStack {
                        Spacer()
                        Text(LocalizableStrings.AskQuestions.askQuestions)
                        Spacer()
                        Image(systemName: "arrowshape.right")
                            .symbolVariant(.fill)
                    }
                }
                .buttonStyle(
                    ActionButtonStyle(
                        disabled: viewModel.text.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                        .isEmpty
                    )
                )
            }
            .padding()
        }
        .navigationTitle("Задать вопросы")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AskQuestionsView()
    }
}
