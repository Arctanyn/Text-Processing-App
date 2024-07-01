//
//  GenerateTextContinueViewModel.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.06.2024.
//

import Foundation

final class GenerateTextContinueViewModel: ObservableObject {
    
    @Published var text = String()
    
    @Published var gptModel = GPTModel.Distil_GPT2_64_6 {
        didSet {
            gpt2 = .init(model: gptModel)
        }
    }
    
    @Published private(set) var isGenerating = false
    
    private var gpt2 = GPT2(model: .Distil_GPT2_64_6)
    
    func generate() {
        isGenerating = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let text = self?.text else { return }
            
            _ = self?.gpt2.generate(text: self?.text ?? "") { completion in
                
                var initialText = text
                initialText.append(completion)
                
                DispatchQueue.main.async {
                    self?.text = initialText
                }
            }
            
            DispatchQueue.main.async {
                self?.isGenerating = false
            }
        }
    }
}
