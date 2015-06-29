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
    
    let labelHowToStart = "HOLD button to start recording."
    let labelHowToStop = "RELEASE button to stop recording."
    let labelAskToWait = "Please wait for saving..."
    let labelTryAgain = "Recording failed! HOLD button to try again."
    
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    
    @IBOutlet weak var m_recordingButton: UIButton!
    @IBOutlet weak var m_recordingLabel: UILabel!
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        m_recordingButton.enabled = true
        m_recordingLabel.text = labelHowToStart
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        let filePath = generateFilePath()
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        m_recordingLabel.text = labelHowToStop
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        m_recordingButton.enabled = false
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        m_recordingLabel.text = labelAskToWait
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            performSegueWithIdentifier("finishRecording", sender: RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent))
        } else {
            m_recordingButton.enabled = true
            m_recordingLabel.text = labelTryAgain
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "finishRecording") {
            let soundConverterVC = segue.destinationViewController as! SoundConverterViewController
            soundConverterVC.recordedAudio = sender as! RecordedAudio
        }
    }
    
    func generateFilePath() -> NSURL? {
        let filename = "my_record.wav"
        return NSURL.fileURLWithPathComponents([dirPath, filename])
    }
}

