//
//  SoundConverterViewController.swift
//  PitchPerfect
//
//  Created by Duong Tam Chau on 2015-06-29.
//  Copyright (c) 2015 Duong Tam Chau. All rights reserved.
//

import UIKit
import AVFoundation

class SoundConverterViewController: UIViewController {
    
    let labelHowToStart = "HOLD any button to listen to effect."
    let labelHowToStop = "RELEASE button to stop."
    
    @IBOutlet weak var audioConverterLabel: UILabel!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var recordedAudio: RecordedAudio!

    @IBAction func convertAudioToSlow(sender: UIButton) {
        playAudio(recordedAudio.filePathUrl, rate: 0.5, pitch: 1)
    }
    
    @IBAction func convertAudioToFast(sender: UIButton) {
        playAudio(recordedAudio.filePathUrl, rate: 2, pitch: 1)
    }
    
    @IBAction func convertAudioToChipmunk(sender: UIButton) {
        playAudio(recordedAudio.filePathUrl, rate: 1, pitch: 1000)
    }
    
    @IBAction func convertAudioToDarthVader(sender: UIButton) {
        playAudio(recordedAudio.filePathUrl, rate: 1, pitch: -1000)
    }
    
    @IBAction func stopPlayingAudio(sender: UIButton) {
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioConverterLabel.text = labelHowToStart
    }
    
    func playAudio(audioUrl: NSURL!, rate: Float, pitch: Float) {
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        
        var pitchNode = AVAudioUnitTimePitch()
        pitchNode.pitch = pitch
        pitchNode.rate = rate
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(pitchNode)
        audioEngine.connect(audioPlayerNode, to: pitchNode, format: nil)
        audioEngine.connect(pitchNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(AVAudioFile(forReading: audioUrl, error: nil), atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        audioConverterLabel.text = labelHowToStop
    }
}
