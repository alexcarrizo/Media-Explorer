//
//  SpeechRecognizer.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/12/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import UIKit
import AVKit
import Speech
import PromiseKit

protocol SpeechRecognizerDelegate: class {
    func updateSearchDisplay(searchTerm: String) -> Void
    func updateMicrophoneButtonEnabled(enabled: Bool) -> Void
    func search() -> Void
}

final class SpeechRecognizer {

    var searchBySpeechStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    var request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var status = SpeechStatus.ready
    weak var delegate: SpeechRecognizerDelegate?
    
    enum SpeechStatus {
        case ready
        case recognizing
        case unavailable
    }
    
    public func checkForSpeechPermission() {
        switch SFSpeechRecognizer.authorizationStatus() {
        case .notDetermined:
            askSpeechPermission()
        case .authorized:
            self.searchBySpeechStatus = .authorized
        case .denied, .restricted:
            self.searchBySpeechStatus = .denied
        }
    }
    
    public func askSpeechPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            OperationQueue.main.addOperation {
                switch status {
                case .authorized:
                    self.searchBySpeechStatus = .authorized
                default:
                    self.searchBySpeechStatus = .denied
                }
            }
        }
    }
    
    public func startRecording() {
        // Setup audio engine and speech recognizer
        guard let node = audioEngine.inputNode else { return }
        
        request = SFSpeechAudioBufferRecognitionRequest()
        
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        
        // Prepare and start recording
        audioEngine.prepare()
        do {
            try audioEngine.start()
            self.status = .recognizing
        } catch {
            return print(error)
        }
        
        // Analyze the speech
        
        speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                self.delegate?.updateSearchDisplay(searchTerm: result.bestTranscription.formattedString)
            } else if let error = error {
                print(error)
            }
        })
        
        after(interval: 2.0).always { self.completeTask() }
    }
    
    public func cancelRecording() {
        audioEngine.stop()
        if let node = audioEngine.inputNode {
            node.removeTap(onBus: 0)
        }
        recognitionTask?.cancel()
    }
    
    public func completeTask () {
        self.cancelRecording()
        self.status = .ready
        self.request.endAudio()
        self.recognitionTask?.finish()
        self.delegate?.updateMicrophoneButtonEnabled(enabled: true)
        self.delegate?.search()
    }
}
