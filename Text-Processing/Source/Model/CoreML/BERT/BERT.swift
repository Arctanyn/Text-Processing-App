//
//  BERT.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 01.05.2024.
//

import CoreML

final class BERT {
    
    // MARK: Properties
    
    private let model: BERTSQUADFP16 = {
        do {
            let defaultConfiguration = MLModelConfiguration()
            return try BERTSQUADFP16(configuration: defaultConfiguration)
        } catch {
            fatalError("Couldn't load BERT model due to: \(error.localizedDescription)")
        }
    }()
    
    private let tokenizer = BERTTokenizer()
    private let seqLen = 384
    
    // MARK: - Methods
    
    func findAnswer(forQuestion question: String, in context: String) -> (start: Int, end: Int, tokens: [String], answer: String) {
        let input = featurizeTokens(question: question, context: context)
        
        let output = try! model.prediction(input: input)
        
        let start = Math.argmax(output.startLogits).0
        let end = Math.argmax(output.endLogits).0
        
        let (idStartIndex, idEndIndex) = (min(start, end), max(start, end))
        
        let tokenIds = Array(
            MLMultiArray.toIntArray(input.wordIDs)[idStartIndex...idEndIndex]
        )
        
        let tokens = tokenizer.unTokenize(tokens: tokenIds)
        let answer = tokenizer.convertWordpieceToBasicTokenList(tokens)
        
        return (start: start, end: end, tokens: tokens, answer: answer)
    }
    
    private func featurizeCommon(question: String, context: String) -> ([Int], [Int], MLMultiArray) {
        let tokensQuestion = tokenizer.tokenizeToIds(text: question)
        var tokensContext = tokenizer.tokenizeToIds(text: context)
        if tokensQuestion.count + tokensContext.count + 3 > seqLen {
            /// This case is fairly rare in the dev set (183/10570),
            /// so we just keep only the start of the context in that case.
            /// In Python, we use a more complex sliding window approach.
            /// see `pytorch-transformers`.
            let toRemove = tokensQuestion.count + tokensContext.count + 3 - seqLen
            tokensContext.removeLast(toRemove)
        }
        
        let nPadding = seqLen - tokensQuestion.count - tokensContext.count - 3
        /// Sequence of input symbols. The sequence starts with a start token (101) followed by question tokens that are followed be a separator token (102) and the document tokens.The document tokens end with a separator token (102) and the sequenceis padded with 0 values to length 384.
        var allTokens: [Int] = []
        /// Would love to create it in a single Swift line but Xcode compiler fails...
        allTokens.append(
            tokenizer.tokenToId(token: "[CLS]")
        )
        allTokens.append(contentsOf: tokensQuestion)
        allTokens.append(
            tokenizer.tokenToId(token: "[SEP]")
        )
        allTokens.append(contentsOf: tokensContext)
        allTokens.append(
            tokenizer.tokenToId(token: "[SEP]")
        )
        allTokens.append(contentsOf: Array(repeating: 0, count: nPadding))
        let input_ids = MLMultiArray.from(allTokens, dims: 2)
        
        return (tokensQuestion, tokensContext, input_ids)
    }
    
    
    func featurizeTokens(question: String, context: String) -> BERTSQUADFP16Input {
        let (tokensQuestion, tokensContext, input_ids) = featurizeCommon(question: question, context: context)
        
        /// Sequence of token-types. Values of 0 for the start token, question tokens and the question separator. Value 1 for the document tokens and the end separator. The sequence is padded with 0 values to length 384.
        var tokenTypes = Array(repeating: 0, count: seqLen)
        let startPos = 2 + tokensQuestion.count
        for i in startPos...startPos+tokensContext.count {
            tokenTypes[i] = 1
        }
        let word_type = MLMultiArray.from(tokenTypes, dims: 2)
        
        return BERTSQUADFP16Input(wordIDs: input_ids, wordTypes: word_type)
    }
    
}
