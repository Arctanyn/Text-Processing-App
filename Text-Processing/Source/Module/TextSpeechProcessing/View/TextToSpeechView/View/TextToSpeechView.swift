//
//  TextToSpeechView.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 08.06.2024.
//

import SwiftUI

struct TextToSpeechView: View {
    
    typealias ViewModel = TextToSpeechViewModel
    
    // MARK: Properties
    
    @Environment(\.editMode) private var editMode
    
    @StateObject private var viewModel = TextToSpeechViewModel()
    
    private var isShownStopButton: Bool {
        switch viewModel.speechStatus {
        case .playing, .paused:
            true
        default:
            false
        }
    }
    
    private var playButtonColor: Color {
        switch viewModel.speechStatus {
        case .stopped, .paused:
            .teal
        case .playing:
            .orange
        }
    }
    
    // MARK: Body
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            VStack {
                TextInputView(
                    showWordsCount: false,
                    onUpdateText: { text in
                        viewModel.text = text
                    }
                )
                .clipShape(.rect(cornerRadius: 16, style: .continuous))
                .disabled(viewModel.speechStatus != .stopped)
                
                HStack {
                    
                    if isShownStopButton {
                        Button {
                            viewModel.stopSpeech()
                        } label: {
                            Image(systemName: "stop")
                                .symbolVariant(.fill)
                        }
                        .buttonStyle(ActionButtonStyle(backgroundColor: .red))
                        .frame(maxWidth: 50)
                        .transition(.opacity.animation(.easeInOut))
                    }
                    
                    Button {
                        UIApplication.shared.endEditing()
                        
                        switch viewModel.speechStatus {
                        case .playing:
                            viewModel.pauseSpeech()
                        case .paused:
                            viewModel.continueSpeech()
                        case .stopped:
                            viewModel.startSpeech()
                        }
                    } label: {
                        HStack {
                            Image(systemName: viewModel.speechStatus == .playing ? "pause" : "play")
                                .symbolVariant(.fill)
                            
                            let title = switch viewModel.speechStatus {
                            case .stopped:
                                LocalizableStrings.TextSpeechProcessing.textToSpeechPlayButtonPlay
                            case .playing:
                                LocalizableStrings.TextSpeechProcessing.textToSpeechPlayButtonPause
                            case .paused:
                                LocalizableStrings.TextSpeechProcessing.textToSpeechPlayButtonContinue
                            }
                            
                            Text(title)
                        }
                        .animation(nil, value: viewModel.speechStatus)
                    }
                    .buttonStyle(ActionButtonStyle(backgroundColor: playButtonColor))
                    .disabled(viewModel.text == nil)
                    .opacity(viewModel.text == nil ? 0.5 : 1.0)
                    
                    
                    HStack(spacing: -8) {
                        Image(systemName: "timer")
                            .foregroundStyle(viewModel.speechStatus == .stopped ? .teal : .secondary.opacity(0.5))
                        
                        Picker(
                            "",
                            selection: $viewModel.speed,
                            content: {
                                ForEach(ViewModel.SpeechVoiceSpeed.allCases.reversed(), id: \.self) { speed in
                                    Text(voiceSpeedTitle(for: speed))
                                }
                            }
                        )
                    }
                    .disabled(viewModel.speechStatus != .stopped)
                }
                .padding(.top)
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }
    
    // MARK: Private Methods
    
    private func voiceSpeedTitle(for speed: ViewModel.SpeechVoiceSpeed) -> String {
        let format = switch speed {
        case .halfSpeed, .normal, .veryFast, .doubleSpeed:
            "%.1f"
        case .fast:
            "%.2f"
        }
        
        return String(format: format, speed.value) + "x"
    }
}

#Preview {
    NavigationStack {
        TextToSpeechView()
            .tint(.teal)
    }
}
