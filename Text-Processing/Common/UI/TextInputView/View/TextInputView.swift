//
//  TextInputView.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

import SwiftUI

struct TextInputView: View {
    
    // MARK: Properties

    @StateObject private var viewModel: TextInputViewModel
    @State private var isPresentedFileImporter = false
    @FocusState private var isTextEditorFocused: Bool

    // MARK: Init

    init(
        wordsCountLimit: Int? = nil,
        onStartLoadingFile: (() -> Void)? = nil,
        onUpdateText: ((String) -> Void)? = nil
    ) {
        _viewModel = StateObject(
            wrappedValue: TextInputViewModel(
                wordsCountLimit: wordsCountLimit,
                onStartLoadingFile: onStartLoadingFile,
                onUpdateText: onUpdateText
            )
        )
    }

    // MARK: Body

    var body: some View {
        ZStack {
            Color(.secondarySystemGroupedBackground)

            VStack {
                HStack {
                    Button {
                        isPresentedFileImporter = true
                    } label: {
                        HStack {
                            Text(LocalizableStrings.chooseFile)
                            Spacer()
                            Image(systemName: "folder.badge.plus")
                        }
                    }

                    if !viewModel.text.isEmpty {
                        Button {
                            viewModel.text = ""
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                        .transition(
                            .asymmetric(
                                insertion: .push(from: .trailing).combined(with: .opacity),
                                removal: .push(from: .leading).combined(with: .opacity)
                            )
                            .animation(.linear(duration: 0.2))
                        )
                    }
                }
                .buttonStyle(.bordered)

                ZStack {
                    TextEditor(text: $viewModel.text)
                        .focused($isTextEditorFocused, equals: true)
                        .toolbar {
                            ToolbarItem(placement: .keyboard) {
                                HStack {
                                    Spacer()
                                    Button(LocalizableStrings.doneKeyboardButtonTitle) {
                                        isTextEditorFocused = false
                                    }
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)

                    if viewModel.text.isEmpty {
                        Text(LocalizableStrings.textInputPlaceholder)
                            .foregroundStyle(.tertiary)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .allowsHitTesting(false)
                    }
                }

                if !viewModel.text.isEmpty {
                    WordsCountView(count: viewModel.text.numberOfWords)
                        .transition(.opacity.animation(.easeInOut(duration: 0.2)))
                }
            }
            .padding()
        }
        .disabled(viewModel.isLoading)
        .fileImporter(
            isPresented: $isPresentedFileImporter,
            allowedContentTypes: [.pdf, .text, .rtf, .plainText, .rtfd]
        ) { result in
            viewModel.processFileChoose(with: result)
        }
    }
}

#Preview {
    ZStack {
        Color(.secondarySystemBackground).ignoresSafeArea()

        TextInputView()
    }
}
