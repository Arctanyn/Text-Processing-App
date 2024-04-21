//
//  Text_ProcessingApp.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

import NLTextProcessing
import SwiftUI

@main
struct Text_ProcessingApp: App {
    var body: some Scene {
        WindowGroup {
            ProcessingCategoriesView()
                .tint(.teal)
        }
    }
}
