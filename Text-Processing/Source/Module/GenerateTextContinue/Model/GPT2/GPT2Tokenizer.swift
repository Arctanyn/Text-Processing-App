//
//  GPT2Tokenizer.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.06.2024.
//

import Foundation

struct BytePair: Hashable {
    let first: String
    let second: String
}

fileprivate extension String {
    
    func ranges(of string: String, options: CompareOptions = .regularExpression) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(
                range.lowerBound,
                offsetBy: 1,
                limitedBy: endIndex
            ) ?? endIndex
        }
        
        return result
    }
}




final class GPT2Tokenizer {
    
    // MARK: Properties
    
    private let bpeRanks: Dictionary<BytePair, Int>
    private let encoder: [String: Int]
    private let decoder: [Int: String]
    
    // MARK: Init
    
    init() {
        let bpeMergesTxt = try! String(
            contentsOf: Bundle.main.url(
                forResource: "gpt2-merges",
                withExtension: "txt"
            )!
        )
        
        let arr = bpeMergesTxt.split(separator: "\n").map { String($0) }
        var bpeRanks: Dictionary<BytePair, Int> = [:]
        
        for i in 1..<arr.count {
            let bytePair = arr[i].split(separator: " ").map { String($0) }
            let bp = BytePair(first: bytePair[0], second: bytePair[1])
            bpeRanks[bp] = i - 1
        }
        self.bpeRanks = bpeRanks
        
        self.encoder = {
            let json = try! Data(
                contentsOf: Bundle.main.url(
                    forResource: "gpt2-vocab",
                    withExtension: "json"
                )!
            )
            
            let vocab = try! JSONDecoder().decode([String: Int].self, from: json)
            return vocab
        }()
        
        self.decoder = self.encoder.inverted
    }
    
    // MARK: Methods
    
    func encode(text: String) -> [Int] {
        return tokenize(text: text).map { encoder[$0]! }
    }
    
    func decode(tokens: [Int]) -> String {
        let text = tokens.map { decoder[$0]! }.joined(separator: "")
        let utfCodepoints = text.map { byteDecoder[String($0)]! }
        return String(decoding: utfCodepoints, as: UTF8.self)
    }
    
    // MARK: Private Methods
    
    private func byteEncode(text: String) -> [String] {
        let tokensSplitRegEx = #"'s|'t|'re|'ve|'m|'ll|'d| ?\p{L}+| ?\p{N}+| ?[^\s\p{L}\p{N}]+|\s+(?!\S)|\s+"#
        let tokens = text.ranges(of: tokensSplitRegEx).map { String(text[$0]) }
        
        return tokens.map {
            Array($0.utf8).map { byteEncoder[$0]! }.joined()
        }
    }
    
    private func getPairs(word: [String]) -> Set<BytePair> {
        var s = Set<BytePair>()
        
        for i in 0..<word.count-1 {
            let bp = BytePair(first: word[i], second: word[i+1])
            s.insert(bp)
        }
        
        return s
    }
    
    private func bytePairEncoding(token: String) -> String {
        guard !token.isEmpty else { return token }
        
        var word = Array(token).map { String($0) }
        var pairs = Array(getPairs(word: word))
        
        while true {
            let bigrams = pairs.filter { bpeRanks[$0] != nil }
            
            guard !bigrams.isEmpty else { break }
            
            let bigram = bigrams.min { firstBytePair, secondBytePair in
                bpeRanks[firstBytePair]! < bpeRanks[secondBytePair]!
            }!

            let first = bigram.first
            let second = bigram.second
            
            var newWord: [String] = []
            var i = 0

            while i < word.count {
                if let j = word[i..<word.count].firstIndex(of: first) {
                    newWord.append(contentsOf: word[i..<j])
                    i = j
                } else {
                    newWord.append(contentsOf: word[i..<word.count])
                    break
                }
                
                if word[i] == first && i < word.count - 1 && word[i+1] == second {
                    newWord.append(first+second)
                    i += 2
                } else {
                    newWord.append(word[i])
                    i += 1
                }
            }
            word = newWord
            
            guard word.count != 1 else { break }
            pairs = Array(getPairs(word: word))
        }
        
        return word.joined(separator: " ")
    }
    
    private func tokenize(text: String) -> [String] {
        var tokens: [String] = []
        for token in self.byteEncode(text: text) {
            let xx = self.bytePairEncoding(token: token).split(separator: " ").map { String($0) }
            tokens.append(contentsOf: xx)
        }
        return tokens
    }
}
