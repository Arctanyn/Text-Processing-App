//
//  GenerateTextContinueView.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.06.2024.
//

import SwiftUI

struct GenerateTextContinueView: View {
    
    typealias ViewModel = GenerateTextContinueViewModel
    
    @StateObject private var viewModel = ViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Image(.openaiLogo)
                        .resizable()
                        .scaledToFit()
                    .frame(width: 30, height: 30)
                    
                    Text("GPT2 Model")
                        .font(.headline)
                }
                
                
                Picker("", selection: $viewModel.gptModel) {
                    ForEach(GPTModel.allCases, id: \.self) { gptModel in
                        Text(gptModel.rawValue)
                    }
                }
            }
            
            TextField("Введите текст", text: $viewModel.text, axis: .vertical)
                .focused($isFocused)
                .lineLimit(1...)
                .disabled(viewModel.isGenerating)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding()
                .background {
                    Color(.secondarySystemBackground)
                }
                .clipShape(.rect(cornerRadius: 16, style: .continuous))
            
            Button {
                viewModel.generate()
            } label: {
                if viewModel.isGenerating {
                    HStack(spacing: 10) {
                        ProgressView()
                            .tint(.white)
                            .foregroundStyle(.white)
                        
                        Text("Генерация")
                    }
                } else {
                    Text("Сгенерировать")
                }
            }
            .buttonStyle(ActionButtonStyle(disabled: viewModel.isGenerating))
            .opacity(viewModel.isGenerating ? 0.5 : 1.0)
            .animation(.smooth, value: viewModel.isGenerating)
            .padding(.top)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Очистить") {
                    viewModel.text.removeAll()
                }
                .disabled(viewModel.text.isEmpty || viewModel.isGenerating)
            }
        }
    }
}

#Preview {
    NavigationStack {
        GenerateTextContinueView()
            .tint(.teal)
    }
}
