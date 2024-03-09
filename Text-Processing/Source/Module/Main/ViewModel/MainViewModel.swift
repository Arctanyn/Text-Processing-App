//
//  MainViewModel.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

import Foundation

final class MainViewModel: ObservableObject {
    
    // MARK: Properties
    let textProcessingCategories = TextProcessingCategory.allCases
    
    @Published var inputText = String()
}
