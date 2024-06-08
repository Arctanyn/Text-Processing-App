//
//  TextToSpeechService.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 08.06.2024.
//

import NaturalLanguage
import AVKit
import Combine

final class TextToSpeechService: NSObject {
    
    // MARK: Properties
    
    let finishTrigger = PassthroughSubject<Void, Never>()
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    private let textLanguageTagger = NLTagger(tagSchemes: [.language])
    
    // MARK: Init
    
    override init() {
        super.init()
        
        speechSynthesizer.delegate = self
    }
    
    // MARK: Methods
    
    func startSpeech(for text: String, speed: Float) throws {
                
        guard !text.isEmpty else { return }
        
        textLanguageTagger.string = text
        
        guard let language = NSLinguisticTagger.dominantLanguage(for: text) else {
            throw SpeechError.unknownLanguage
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = speed
        
        speechSynthesizer.speak(utterance)
    }
    
    func pauseSpeech(at boundary: AVSpeechBoundary = .immediate) {
        guard speechSynthesizer.isSpeaking else { return }
        speechSynthesizer.pauseSpeaking(at: boundary)
    }
    
    func continueSpeech() {
        guard speechSynthesizer.isPaused else { return }
        speechSynthesizer.continueSpeaking()
    }
    
    func stopSpeech(at boundary: AVSpeechBoundary = .immediate) {
        speechSynthesizer.stopSpeaking(at: boundary)
    }
}

// MARK: SpeechError
extension TextToSpeechService {
    
    enum SpeechError: Error {
        case unknownLanguage
    }
}

// MARK: AVSpeechSynthesizerDelegate

extension TextToSpeechService: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        finishTrigger.send()
    }
}
