//
//  TextToSpeechViewModel.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 08.06.2024.
//

import Foundation
import Combine

final class TextToSpeechViewModel: ObservableObject {
    
    // MARK: SpeechStatus
    
    enum SpeechStatus {
        case stopped
        case playing
        case paused
    }
    
    enum SpeechVoiceSpeed: CaseIterable {
        case doubleSpeed
        case veryFast
        case fast
        case normal
        case halfSpeed
        
        var value: Float {
            switch self {
            case .doubleSpeed: 2.0
            case .veryFast: 1.5
            case .fast: 1.25
            case .normal: 1.0
            case .halfSpeed: 0.5
            }
        }
        
        fileprivate var speechServiceValue: Float {
            switch self {
            case .doubleSpeed: 1.0
            case .veryFast: 0.875
            case .fast: 0.625
            case .normal: 0.5
            case .halfSpeed: 0.0
            }
        }
    }
    
    // MARK: Properties
    
    @MainActor @Published var text: String?
    @MainActor @Published var speed = SpeechVoiceSpeed.normal
    
    @MainActor @Published private(set) var speechStatus = SpeechStatus.stopped
    @MainActor @Published private(set) var error: Error?
    
    private let textToSpeechService = TextToSpeechService()
    
    // MARK: Init
    
    init() {
        makeSubscriptions()
    }
    
    // MARK: Methods
    
    @MainActor
    func startSpeech() {
        guard let text else { return }
        
        do {
            try textToSpeechService.startSpeech(for: text, speed: speed.speechServiceValue)
            speechStatus = .playing
        } catch {
            self.error = error
        }
        
    }
    
    @MainActor
    func pauseSpeech() {
        textToSpeechService.pauseSpeech()
        speechStatus = .paused
    }
    
    @MainActor
    func continueSpeech() {
        textToSpeechService.continueSpeech()
        speechStatus = .playing
    }
    
    @MainActor
    func stopSpeech() {
        textToSpeechService.stopSpeech()
        speechStatus = .stopped
    }
    
    // MARK: Private Methods
    
    private func makeSubscriptions() {
        
        textToSpeechService.finishTrigger
            .map { SpeechStatus.stopped }
            .assign(to: &$speechStatus)
    }
}
