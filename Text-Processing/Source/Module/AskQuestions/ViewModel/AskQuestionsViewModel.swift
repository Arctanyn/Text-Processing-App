//
//  AskQuestionsViewModel.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 01.05.2024.
//

import Foundation

final class AskQuestionsViewModel: ObservableObject {
    
    @MainActor @Published private(set) var chatMessages: [ChatMessage] = []
    
    var text = String()
    
    let wordsLimit = 300
    
    private let bert = BERT()
    
    @MainActor
    func findAnswer(forQuestion question: String) {
        let question = question.components(separatedBy: .newlines).joined(separator: " ")
        
        chatMessages.append(
            .init(
                participant: .user,
                message: question
            )
        )
        
        Task.detached { [weak self] in
            guard let self else { return }
            
            let result = bert.findAnswer(forQuestion: question, in: text)
            
            await MainActor.run {
                self.chatMessages.append(
                    .init(
                        participant: .app,
                        message: result.answer
                    )
                )
            }
        }
    }
    
    @MainActor
    func clearChat() {
        chatMessages.removeAll()
    }
}
