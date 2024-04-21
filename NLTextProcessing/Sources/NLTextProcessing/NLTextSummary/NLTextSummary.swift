//
//  NLTextSummary.swift
//
//
//  Created by Malil Dugulubgov on 22.03.2024.
//

import NaturalLanguage

public final class NLTextSummary {
    
    // MARK: Methods

    public func summarize(text: String, method: SummarizationMethod) -> String {
        let rankedSentences = getRankedSenteces(from: text)
        return makeSummary(with: rankedSentences, usingMethod: method)
    }

    // MARK: Init

    public init() { }
}

// MARK: - Public Entity

public extension NLTextSummary {
    enum SummarizationLevel: Int, CaseIterable {
        case low = 60
        case medium = 40
        case high = 20
    }

    enum SummarizationMethod {
        case sentences(count: Int)
        case level(SummarizationLevel)
    }
}

// MARK: - Private Methods

private extension NLTextSummary {
    func getRankedSenteces(from text: String) -> [RankedText] {
        let wordsFrequency = calculateWordsFrequency(in: text)
        let sentences = splitText(text, by: .sentence)

        let rankedSentences = {
            var rankedSentences = [RankedText]()
            rankedSentences.reserveCapacity(sentences.count)

            for (index, sentence) in sentences.enumerated() {
                let rank = getWordsFrequencySum(of: sentence, with: wordsFrequency)
                rankedSentences.append(
                    .init(text: sentence, rank: rank, index: index)
                )
            }

            rankedSentences.sort { $0.rank > $1.rank }
            return rankedSentences
        }()

        return rankedSentences
    }

    func makeSummary(with rankedSentences: [RankedText], usingMethod method: SummarizationMethod) -> String {
        var prefix: Int = {
            switch method {
            case let .sentences(count):
                return count
            case let .level(summarizationLevel):
                let calculatedPrefix = Double(summarizationLevel.rawValue) / 100 * Double(rankedSentences.count)
                let roundedPrefix = Int(calculatedPrefix.rounded())
                return roundedPrefix > 0 ? roundedPrefix : 1
            }
        }()

        var summarizedSentences = [RankedText]()
        summarizedSentences.reserveCapacity(prefix)

        for rankedSentence in rankedSentences where prefix > 0 && rankedSentence.text.count > 1 {
            summarizedSentences.append(rankedSentence)
            prefix -= 1
        }

        return summarizedSentences
            .sorted { $0.index < $1.index }
            .map(\.text)
            .joined()
    }

    func calculateWordsFrequency(in text: String) -> [String: Int] {
        var wordsFrequency = [String: Int]()

        let tagger = NLTagger(tagSchemes: [.tokenType])
        
        let text = text.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty && !checkWordForContainingInStopWords($0) }
            .joined(separator: " ")
            .lowercased()
        
        
        tagger.string = text
        
        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .tokenType,
            options: [
                .omitWhitespace,
                .omitPunctuation,
                .joinNames,
                .joinContractions,
                .omitOther,
            ]
        ) { [unowned self] token, range in
            let word = String(text[range])
            
            if word.count >= 2, !checkWordForContainingInStopWords(word) {
                wordsFrequency[word, default: 0] += 1
            }
            
            return true
        }

        return wordsFrequency
    }

    func splitText(_ text: String, by unit: NLTokenUnit) -> [String] {
        var tokens = [String]()

        let tokenizer = NLTokenizer(unit: unit)
        tokenizer.string = text

        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let substring = text[range]

            if !substring.isEmpty {
                tokens.append(String(text[range]))
            }

            return true
        }

        return tokens
    }

    func checkWordForContainingInStopWords(_ word: String) -> Bool {
        let tagger = NLTagger(tagSchemes: [.language])
        tagger.string = word
        
        let checkStopWordsContains: (String) -> Bool = { word in
            guard let lang = tagger.dominantLanguage else { return false }

            switch lang {
            case .english:
                return StopWords.en.contains(word.lowercased())
            case .russian:
                return StopWords.ru.contains(word.lowercased())
            default:
                return false
            }
        }
        
        return checkStopWordsContains(word)
    }
    
    func getWordsFrequencySum(of sentence: String, with frequencies: [String: Int]) -> Int {
        let wordsList = splitText(sentence, by: .word)
        var rank = 0
        
        for word in wordsList where !checkWordForContainingInStopWords(word) {
            rank += frequencies[word.lowercased(), default: 0]
        }

        return rank
    }
}
