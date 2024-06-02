//
//  ChatMessage.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 02.06.2024.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let participant: ChatParticipant
    let message: String
}

// MARK: - ChatParticipant

extension ChatMessage {
    enum ChatParticipant {
        case user
        case app
    }
}
