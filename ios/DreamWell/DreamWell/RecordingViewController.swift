//
//  RecordingViewController.swift
//  DreamWell
//
//  Created by Rohin Bhushan on 4/1/17.
//  Copyright © 2017 rohin. All rights reserved.
//

import UIKit
import Speech

class RecordingViewController: UIViewController, SFSpeechRecognizerDelegate {
	@IBOutlet weak var startRecordingButton: UIButton!

	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
	
	private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!

	private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
	private var recognitionTask: SFSpeechRecognitionTask?
	private let audioEngine = AVAudioEngine()
	
	private var recordedLines = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
		Services.postSleepLogs(text: "hello wassup it worked maddafacka")
        // Do any additional setup after loading the view.
		speechRecognizer.delegate = self  //3
		
		SFSpeechRecognizer.requestAuthorization { (authStatus) in
			print(authStatus)
		}
		startRecordingButton.layer.cornerRadius = 4.0
		textView.layoutManager.allowsNonContiguousLayout = false
    }
	
	func textViewDidChange(_ textView: UITextView) {
		let lines = numberOfLines(textView: textView)
		if lines > recordedLines {
			recordedLines = lines
			moveTextViewUp()
		}
	}
	
	func moveTextViewUp() {
		textViewHeightConstraint.constant = CGFloat(40 * recordedLines) + 40.0
		let stringLength:Int = self.textView.text.characters.count
		self.textView.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
		
	}
	
	// get number of lines
	func numberOfLines(textView: UITextView) -> Int {
		let layoutManager = textView.layoutManager
		let numberOfGlyphs = layoutManager.numberOfGlyphs
		var lineRange: NSRange = NSMakeRange(0, 1)
		var index = 0
		var numberOfLines = 0
		
		while index < numberOfGlyphs {
			layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
			index = NSMaxRange(lineRange)
			numberOfLines += 1
		}
		return numberOfLines
	}
	
	
	@IBAction func startRecording(_ sender: Any) { //button press
		if recognitionTask != nil { // stop
			recognitionTask?.cancel()
			recognitionTask = nil
			startRecordingButton.setTitle("Start Recording", for: UIControlState())
			sendText()
			return
		}
		startRecordingButton.setTitle("Stop Recording", for: UIControlState())
		
		let audioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.setCategory(AVAudioSessionCategoryRecord)
			try audioSession.setMode(AVAudioSessionModeMeasurement)
			try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
		} catch {
			print("audioSession properties weren't set because of an error.")
		}
		
		recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
		
		guard let inputNode = audioEngine.inputNode else {
			fatalError("Audio engine has no input node")
		}
		
		guard let recognitionRequest = recognitionRequest else {
			fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
		}
		
		recognitionRequest.shouldReportPartialResults = true
		
		recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
			
			var isFinal = false
			
			if result != nil {
				
				self.textView.text = result?.bestTranscription.formattedString
				self.textViewDidChange(self.textView)
				isFinal = (result?.isFinal)!
			}
			
			if error != nil || isFinal {
				self.audioEngine.stop()
				inputNode.removeTap(onBus: 0)
				
				self.recognitionRequest = nil
				self.recognitionTask = nil
				
			}
		})
		
		let recordingFormat = inputNode.outputFormat(forBus: 0)
		inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
			self.recognitionRequest?.append(buffer)
		}
		
		audioEngine.prepare()
		
		do {
			try audioEngine.start()
		} catch {
			print("audioEngine couldn't start because of an error.")
		}
	}
	
	func sendText() {
		//
	}
}






