//
//  WordsCountView.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 20.04.2024.
//

import SwiftUI

struct WordsCountView: View {
    let count: Int

    var body: some View {
        HStack(spacing: 14) {
            Text(LocalizableStrings.wordsCount + ":")
            Spacer()
            Text(count, format: .number)
                .font(.system(.body, weight: .semibold))
        }
        .padding(.vertical, 6)
        .padding(.horizontal)
        .background(Color(.tertiarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 8, style: .continuous))
    }
}

#Preview {
    WordsCountView(count: 10)
        .padding()
}
