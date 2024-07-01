//
//  SpeechToTextView.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 02.06.2024.
//

import SwiftUI
import NaturalLanguage

struct SpeechToTextView: View {
    
    // MARK: Properties
    
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    @State private var isRecording = false
    @State private var language: NLLanguage = .russian
    
    // MARK: Body
    
    var body: some View {
        ZStack {
            VStack {
                if let transcript = speechRecognizer.transcript, !transcript.isEmpty {
                    ScrollView {
                        Text(transcript)
                            .font(.title3)
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }
                    .padding()
                } else if !isRecording {
                    ContentUnavailableView(
                        LocalizableStrings.TextSpeechProcessing.speechToTextContentUnavailableTitle,
                        systemImage: "bubble.left.and.text.bubble.right",
                        description: Text(LocalizableStrings.TextSpeechProcessing.speechToTextContentUnavailableDescription)
                    )
                }
                
                Spacer()
                
                VStack {

                    Button {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            if isRecording {
                                speechRecognizer.stopTranscribing()
                            } else {
                                speechRecognizer.startTranscribing()
                            }
                            
                            isRecording.toggle()
                        }
                    } label: {
                        Image(systemName: !isRecording ? "mic" : "stop")
                            .symbolVariant(.fill)
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .frame(width: 80, height: 80)
                            .background(isRecording ? .red : .teal)
                            .clipShape(.circle)
                    }
                    .buttonStyle(PushDownButtonStyle())
                    
                    Picker(selection: $language) {
                        ForEach(NLLanguage.allCases.sorted(by: { $0.title < $1.title }), id: \.self) {
                            Text($0.title)
                        }
                    } label: {
                        Text(language.title)
                    }
                    .pickerStyle(.menu)
                    .tint(.secondary)
                    .disabled(isRecording)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .padding(.bottom)
                .background(Color(.secondarySystemBackground))
                .clipShape(.rect(topLeadingRadius: 30, topTrailingRadius: 30))
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .onAppear {
            setLanguage(language)
        }
        .onChange(of: language) { _, newValue in
            setLanguage(newValue)
        }
    }
    
    // MARK: Private Methods
    
    private func setLanguage(_ language: NLLanguage) {
        Task {
            await speechRecognizer.setLocale(Locale(identifier: language.rawValue))
        }
    }
}

#Preview {
    TextSpeechProcessingView()
}
