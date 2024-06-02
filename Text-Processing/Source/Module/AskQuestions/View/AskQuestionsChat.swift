//
//  AskQuestionsChat.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 01.05.2024.
//

import SwiftUI

struct AskQuestionsChat: View {
    @ObservedObject var viewModel: AskQuestionsViewModel
    @State private var question = String()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground).ignoresSafeArea()
            
            VStack {
                
                GeometryReader { geometry in
                    let size = geometry.size
                    
                    if viewModel.chatMessages.isEmpty {
                        ContentUnavailableView(
                            LocalizableStrings.AskQuestions.emptyChatTitle,
                            systemImage: "message",
                            description: Text(LocalizableStrings.AskQuestions.emptyChatDescription)
                        )
                        .padding()
                        
                    } else {
                        ScrollView {
                            VStack(spacing: 14) {
                                ForEach(viewModel.chatMessages) { chatMessage in
                                    messageView(
                                        forMessage: chatMessage,
                                        containerSize: size
                                    )
                                    .id(chatMessage.id)
                                }
                            }
                            .padding()
                        }
                        .transition(.opacity)
                    }
                }
                .animation(
                    .easeOut(duration: 0.2),
                    value: viewModel.chatMessages.count
                )
                .onTapGesture {
                    isFocused = false
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                HStack(spacing: 20) {
                    TextField(
                        LocalizableStrings.AskQuestions.enterQuestions,
                        text: $question,
                        axis: .vertical
                    )
                    .lineLimit(1...2)
                    .focused($isFocused)
                    
                    Button {
                        viewModel.findAnswer(forQuestion: question)
                        question = String()
                    } label: {
                        Image(systemName: "paperplane")
                            .symbolVariant(.fill)
                            .font(.system(size: 20))
                    }
                    .disabled(question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
                .background(Color(.tertiarySystemBackground))
            }
        }
        .onAppear {
            isFocused = true
        }
    }
    
    private func messageView(forMessage msg: ChatMessage, containerSize: CGSize) -> some View {
        let alignment: Alignment = msg.participant == .user ? .trailing : .leading
        
        return VStack(alignment: msg.participant == .user ? .trailing : .leading) {
            HStack {
                Text(msg.message)
                    .padding(14)
                    .background {
                        msg.participant == .user
                            ? Color.accentColor
                            : Color(.tertiarySystemBackground)
                    }
                    .clipShape(.rect(cornerRadius: 16, style: .continuous))
            }
            .frame(maxWidth: containerSize.width * 0.7, alignment: alignment)
        }
        .frame(maxWidth: .infinity, alignment: alignment)
    }
}

#Preview {
    AskQuestionsChat(viewModel: AskQuestionsViewModel())
}
