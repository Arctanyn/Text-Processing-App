//
//  TextSpeechProcessingView.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 02.06.2024.
//

import SwiftUI

struct TextSpeechProcessingView: View {
    
    // MARK: TextSpeechProcessingType
    
    enum TextSpeechProcessingType: CaseIterable {
        case speechToText
        case textToSpeech
        
        var title: String {
            switch self {
            case .speechToText:
                String(localized: "Речь в текст")
            case .textToSpeech:
                String(localized: "Текст в речь")
            }
        }
    }
    
    // MARK: Properties
    
    @State private var processingType: TextSpeechProcessingType = .speechToText
    
    // MARK: Init
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemTeal
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor.white
        ], for: .selected)
    }
    
    // MARK: Body
    
    var body: some View {
        VStack {
            Picker(selection: $processingType) {
                ForEach(TextSpeechProcessingType.allCases, id: \.self) {
                    Text($0.title)
                }
            } label: {
                Text(processingType.title)
            }
            .pickerStyle(.segmented)
            .padding()
            
            Spacer()
            
            switch processingType {
            case .speechToText:
                SpeechProcessingView()
                    .ignoresSafeArea(.all, edges: .bottom)
            case .textToSpeech:
                EmptyView()
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(LocalizableStrings.TextSpeechProcessing.title)
    }
}

#Preview {
    NavigationStack {
        TextSpeechProcessingView()
            .tint(.teal)
    }
}
