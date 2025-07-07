import Foundation
import Speech

final class SpeechRecognizer: NSObject, ObservableObject, SFSpeechRecognizerDelegate, @unchecked Sendable {
    private var speechRecognizer: SFSpeechRecognizer!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @Published var transcript = ""
    private var isTranscribing = false
    private var audioDurationTimer: Timer?
    private var audioDurationLimit: Int = 2
    
    override init() {
        super.init()
        
        let rawLanguage = Locale.preferredLanguages.first ?? "en"
        let languageCode = Locale(identifier: rawLanguage).language.languageCode?.identifier ?? "en"
        let supportedLocales = SFSpeechRecognizer.supportedLocales()

        let matchedLocale = supportedLocales.first(where: {
            $0.language.languageCode?.identifier == languageCode
        }) ?? Locale(identifier: "en-US")

        speechRecognizer = SFSpeechRecognizer(locale: matchedLocale)
        speechRecognizer.delegate = self
    }
    
    // 음성인식 시작
    func startTranscribing() {
        guard !isTranscribing else { return }
          
          // 음성 인식 시작 판별 프로퍼티 상태 변경
          isTranscribing = true
          
          // 오디오 엔진이 실행 중이면 중지하고 모든 tap을 제거
          if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
          }
          
          // 기존 실행된 음성 인식 작업인, recognitionTask가 있다면 해당 작업 취소
          recognitionTask?.cancel()
          recognitionTask = nil
          
          // 오디오 세션 설정 및 활성화
          let audioSession = AVAudioSession.sharedInstance()
          do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
          } catch {
            print("오디오 세션 설정 실패: \(error)")
            isTranscribing = false
            return
          }
          
          // 음성 인식 요청 생성
          recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
          guard let recognitionRequest = recognitionRequest else {
            // 설정 중 오류 시 음성 인식 상태 변경
            isTranscribing = false
            return
          }
          
          // 부분적 결과 보고 설정
          recognitionRequest.shouldReportPartialResults = true
          
          // 음성 인식 작업 설정
          recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                let text = result.bestTranscription.formattedString
                
                if !text.isEmpty {
                    Task { @MainActor in
                        self.transcript = text
                        print("🎤 실시간 인식 텍스트: \(text)")
                    }
                }
                
                self.stopAudioDurationTimer()
                self.startAudioDurationTimer()
                isFinal = result.isFinal
            }
              
            if error != nil || isFinal {
                self.cleanup()
            }
          }
          
          // 오디오 엔진에 tap을 추가
          let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
          audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
          }
          
          // 오디오 엔진 시작
          do {
            try audioEngine.start()
          } catch {
            print("오디오 엔진 시작 실패: \(error)")
            cleanup()
          }
    }
    
    private func startAudioDurationTimer() {
        audioDurationTimer = Timer.scheduledTimer(
            timeInterval: TimeInterval(self.audioDurationLimit),
            target: self,
            selector: #selector(timeOut),
            userInfo: nil,
            repeats: false
        )
    }
    
    private func stopAudioDurationTimer() {
        if audioDurationTimer != nil {
            audioDurationTimer?.invalidate()
            audioDurationTimer = nil
        }
    }
    
    @objc private func timeOut() {
        stopTranscribing()
   }
    
    // 음성인식 종료
    func stopTranscribing() {
        recognitionTask?.cancel()
        cleanup()
    }
    
    private func cleanup() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask = nil
        isTranscribing = false
    }
}
