//
//  SummarizedTextView.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 23.03.2024.
//

import SwiftUI
import UIKit

struct SummarizedTextView: View {
    @Environment(\.dismiss) private var dismiss

    let text: String

    var body: some View {
        NavigationStack {
            VStack {
                WordsCountView(count: text.numberOfWords)
                NoKeyboardTextView(text: text)
            }
            .padding()
            .navigationTitle(LocalizableStrings.TextSummary.summarizedText)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(LocalizableStrings.close) {
                        dismiss.callAsFunction()
                    }
                }
            }
        }
    }
}

// MARK: - NoKeyboardTextView

struct NoKeyboardTextView: UIViewRepresentable {
    let text: String

    func makeUIView(context _: Context) -> UITextView {
        let textView = UITextView()
        textView.text = text
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isEditable = false
        return textView
    }

    func updateUIView(_: UITextView, context _: Context) {}
}

#Preview {
    SummarizedTextView(text: """
    Swift - это высокоуровневый многопарадигмальный компилируемый язык программирования общего назначения, разработанный Apple Inc. и сообществом разработчиков с открытым исходным кодом. Swift компилируется в машинный код, поскольку это компилятор на основе LLVM. Swift был впервые выпущен в июне 2014 года[11], а набор инструментов Swift поставляется в Xcode начиная с версии 6, выпущенной в 2014 году.
    """)
}
