//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Duong Tam Chau on 2015-06-28.
//  Copyright (c) 2015 Duong Tam Chau. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    let LABEL_INSTRUCTION_HOW_TO_START_RECORDING = "HOLD button to start recording."
    let LABEL_INSTRUCTION_HOW_TO_STOP_RECORDING = "RELEASE button to stop recording."
    let LABEL_INSTRUCTION_TO_WAIT_FOR_SAVING = "Please wait for saving..."
    let LABEL_FAIL_TRY_AGAIN = "Recording failed! HOLD button to try again."
    
    let DIR_PATH = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    let DATE_FORMATTER = NSDateFormatter()
    let DATE_FORMAT = "ddMMyyyy-HHmmss"

    @IBOutlet weak var m_recordingButton: UIButton!
    @IBOutlet weak var m_recordingLabel: UILabel!
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DATE_FORMATTER.dateFormat = DATE_FORMAT
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        m_recordingButton.enabled = true
        m_recordingLabel.text = LABEL_INSTRUCTION_HOW_TO_START_RECORDING
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        println("recording in progress")
        let filePath = generateFilePath()
        println("Recording data into '\(filePath)'")
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        m_recordingLabel.text = LABEL_INSTRUCTION_HOW_TO_STOP_RECORDING
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        println("stop recording")
        m_recordingButton.enabled = false
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        m_recordingLabel.text = LABEL_INSTRUCTION_TO_WAIT_FOR_SAVING
        println("start waiting")
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        println("finished recording")
        if (flag) {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("finishRecording", sender: recordedAudio)
        } else {
            println("recording failed")
            m_recordingButton.enabled = true
            m_recordingLabel.text = LABEL_FAIL_TRY_AGAIN
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "finishRecording") {
            let soundConverterVC = segue.destinationViewController as! SoundConverterViewController
            soundConverterVC.recordedAudio = sender as! RecordedAudio
        }
    }
    
    func generateFilePath() -> NSURL? {
        // let filename = "\(DATE_FORMATTER.stringFromDate(NSDate())).wav"
        let filename = "my_record.wav"
        return NSURL.fileURLWithPathComponents([DIR_PATH, filename])
    }
}

