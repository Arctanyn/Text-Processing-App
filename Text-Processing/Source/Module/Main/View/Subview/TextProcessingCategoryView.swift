//
//  TextProcessingCategoryView.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

import SwiftUI

struct TextProcessingCategoryView: View {
    
    // MARK: Property
    let category: TextProcessingCategory
    
    // MARK: Body
    var body: some View {
        HStack(alignment: .center) {
            category.image
                .font(.title)
                .foregroundStyle(.primary, .orange)
                .padding(.horizontal, 5)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(category.title)
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                
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
