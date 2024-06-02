//
//  TextProcessingCategoryView.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

import SwiftUI

struct TextProcessingCategoryView: View {
    // MARK: Properties

    let category: TextProcessingCategory

    // MARK: Body

    var body: some View {
        HStack(alignment: .center) {
            categoryImage(for: category)

            VStack(alignment: .leading, spacing: 10) {
                Text(category.title)
                    .font(.system(.title3, design: .rounded, weight: .semibold))

                Text(category.description)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .padding(.leading)
        }
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .padding(.vertical, 8)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 5)
    }
}

// MARK: - Local Views

private extension TextProcessingCategoryView {
    func categoryImage(for category: TextProcessingCategory) -> some View {
        Group {
            switch category {
            case .summarization:
                category.image
                    .foregroundStyle(.white, .tint)
            case .askQuestions:
                category.image
                    .foregroundStyle(.white, .tint)
            case .continuationGenerating:
                category.image
                    .foregroundStyle(.primary, .tint)
            case .textAndSpeechProcessing:
                category.image
                    .foregroundStyle(.primary, .tint)
            }
        }
        .font(.title)
        .padding(.horizontal, 5)
    }
}

// MARK: - Text Processing Category Icon

private extension TextProcessingCategory {
    var image: Image {
        switch self {
        case .summarization:
            Image(systemName: "text.bubble.fill")
        case .askQuestions:
            Image(systemName: "questionmark.circle.fill")
        case .continuationGenerating:
            Image(systemName: "character.cursor.ibeam")
        case .textAndSpeechProcessing:
            Image(systemName: "bubble.left.and.text.bubble.right.fill")
        }
    }
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()

        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(TextProcessingCategory.allCases, id: \.self) { category in
                    TextProcessingCategoryView(category: category)
                }
            }
        }
    }
}
