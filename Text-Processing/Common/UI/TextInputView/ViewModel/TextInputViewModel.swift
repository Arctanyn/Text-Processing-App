//
//  TextInputViewModel.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

import Foundation
import PDFKit

final class TextInputViewModel: ObservableObject {
    
    // MARK: Properties
    
    @MainActor var text: String {
        get {
            self._text
        }
        
        set {
            guard let wordsCountLimit else {
                _text = newValue
                onUpdateText?(newValue)
                return
            }
            
            var words = newValue.components(separatedBy: .whitespaces)
            
            guard words.count > wordsCountLimit else {
                _text = newValue
                onUpdateText?(newValue)
                return
            }
            
            words.removeLast(words.count - wordsCountLimit)
            
            let limitedText = words.joined(separator: " ")
            _text = limitedText
            
            onUpdateText?(limitedText)
        }
    }
    
    @MainActor @Published private var _text = String()
    @MainActor @Published var isLoading = false

    @Published private(set) var error: Error?
    
    private var fileContentFetchTask: Task<Void, Never>?

    private var onStartLoadingFile: (() -> Void)?
    private var onUpdateText: ((String) -> Void)?
    
    private let wordsCountLimit: Int?

    // MARK: Init

    @MainActor init(
        wordsCountLimit: Int? = nil,
        onStartLoadingFile: (() -> Void)? = nil,
        onUpdateText: ((String) -> Void)? = nil
    ) {
        self.wordsCountLimit = wordsCountLimit
        self.onStartLoadingFile = onStartLoadingFile
        self.onUpdateText = onUpdateText
    }

    // MARK: Methods

    @MainActor
    func processFileChoose(with result: Result<URL, Error>) {
        onStartLoadingFile?()
        isLoading = true

        do {
            let fileURL = try result.get()
            fileContentFetchTask = Task { @MainActor in
                defer {
                    isLoading = false
                }

                guard !Task.isCancelled else { return }
                await getFileContent(fileURL: fileURL)
            }
        } catch {
            self.error = error
        }
    }

    @MainActor
    func cancelFileLoadingTask() {
        fileContentFetchTask?.cancel()
        isLoading = false
    }
}

// MARK: - Private Methods

private extension TextInputViewModel {
    func getFileContent(fileURL: URL) async {
        do {
            let fileContent = try fetchFileTextContent(with: fileURL)
            await MainActor.run {
                text = fileContent
            }
        } catch {
            self.error = error
        }
    }

    func fetchFileTextContent(with url: URL) throws -> String {
        if let pdf = PDFDocument(url: url) {
            let pageCount = pdf.pageCount
            let documentContent = NSMutableAttributedString()

            for i in 0..<pageCount {
                guard
                    let page = pdf.page(at: i),
                    let pageContent = page.attributedString
                else {
                    continue
                }

                documentContent.append(pageContent)
            }

            return documentContent.string
        }
        
        guard let textFileExtension = TextFilesExtension(rawValue: url.pathExtension) else {
            throw FileDecodingError()
        }
        
        switch textFileExtension {
        case .txt, .plain:
            return try String(contentsOf: url, encoding: .utf8)
        case .pdf:
            return try fetchPDFFilesContent(from: url)
        case .rtf:
            return try NSAttributedString(
                url: url,
                options: [.documentType: NSAttributedString.DocumentType.rtf],
                documentAttributes: nil
            )
            .string
        case .rtfd:
            return try NSAttributedString(
                url: url,
                options: [.documentType: NSAttributedString.DocumentType.rtfd],
                documentAttributes: nil
            )
            .string
        }
    }
    
    private func fetchPDFFilesContent(from url: URL) throws -> String {
        guard let pdf = PDFDocument(url: url) else {
            throw FileDecodingError()
        }
        
        let pageCount = pdf.pageCount
        let documentContent = NSMutableAttributedString()

        for i in 0..<pageCount {
            guard let page = pdf.page(at: i), let pageContent = page.attributedString else {
                continue
            }

            documentContent.append(pageContent)
        }

        return documentContent.string
    }
}

private struct FileDecodingError: Error { }

private enum TextFilesExtension: String {
    case txt
    case plain
    case pdf
    case rtf
    case rtfd
}
