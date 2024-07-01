//
//  GPT2.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.06.2024.
//

import Foundation
import CoreML

enum GPTModel: String, CaseIterable {
    case Distil_GPT2_64_6
    case GPT2_64_12
    case GPT2_512
    
    fileprivate var seqLen: Int {
        switch self {
        case .Distil_GPT2_64_6, .GPT2_64_12: 64
        case .GPT2_512: 512
        }
    }
}

final class GPT2 {
    
    private let model: AnyGPTModel
    public let tokenizer = GPT2Tokenizer()
    public let seqLen: Int
    
    init(model: GPTModel) {
        self.seqLen = model.seqLen
        
        do {
            let configuration = MLModelConfiguration()
            
            switch model {
            case .Distil_GPT2_64_6:
                self.model = try distilgpt2_64_6(configuration: configuration)
            case .GPT2_64_12:
                self.model = try gpt2_64_12(configuration: configuration)
            case .GPT2_512:
                self.model = try gpt2_512(configuration: configuration)
            }
        } catch {
            fatalError("Couldn't load GPT model due to: \(error.localizedDescription)")
        }
    }
    
    func generate(text: String, nTokens: Int = 50, callback: ((String) -> Void)? = nil) -> String {
        let text = text.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        
        var tokens = tokenizer.encode(text: text)
        var newTokens: [Int] = []
        
        (0..<nTokens).forEach { _ in
            let nextToken = predict(tokens: tokens, topK: 50)
            
            tokens.append(nextToken)
            newTokens.append(nextToken)
            
            callback?(tokenizer.decode(tokens: newTokens))
        }
        
        return tokenizer.decode(tokens: newTokens)
    }
    
    private func predict(tokens: [Int], topK: Int) -> Int {
        let maxTokens = (tokens.count > seqLen)
            ? Array(tokens[..<seqLen])
            : tokens
        
        let input_ids = MLMultiArray.from(
            maxTokens + Array(repeating: 0, count: seqLen - maxTokens.count)
        )
        
        let position_ids = MLMultiArray.from(Array(0..<seqLen))
        
        let output_logits = switch model {
        case let distilGPT2 as distilgpt2_64_6:
            try! distilGPT2.prediction(input_ids: input_ids, position_ids: position_ids).output_logits
        case let gpt2_64_model as gpt2_64_12:
            try! gpt2_64_model.prediction(input_ids: input_ids, position_ids: position_ids).output_logits
        case let gpt2_512_model as gpt2_512:
            try! gpt2_512_model.prediction(input_ids: input_ids, position_ids: position_ids).output_logits
        default:
            fatalError("Unknown model")
        }
        
        let outputLogits = MLMultiArray.slice(
            output_logits,
            indexing: [
                .select(0),
                .select(maxTokens.count - 1),
                .slice,
                .select(0),
                .select(0)
            ]
        )
        
        let logits = MLMultiArray.toDoubleArray(outputLogits)
        
        let topk = Math.topK(arr: logits, k: topK)
        let sampleIndex = Math.sample(indexes: topk.indexes, probs: topk.probs)
        
        return sampleIndex
    }
}

protocol AnyGPTModel { }

extension distilgpt2_64_6: AnyGPTModel { }
extension gpt2_64_12: AnyGPTModel { }
extension gpt2_512: AnyGPTModel { }
