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
    @IBOutlet weak var reverbEffectSlider: UISlider!
    @IBOutlet weak var reverbEffectLabel: UILabel!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var recordedAudio: RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshReverbEffectLabel(reverbEffectSlider)
    }

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
    
    @IBAction func refreshReverbEffectLabel(sender: UISlider) {
        reverbEffectLabel.text = "Reverb Effect Value: \(reverbEffectSlider.value)"    }
    
    func playAudio(audioUrl: NSURL!, rate: Float, pitch: Float) {
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        
        let pitchNode = AVAudioUnitTimePitch()
        pitchNode.pitch = pitch
        pitchNode.rate = rate
        
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall)
        reverbNode.wetDryMix = reverbEffectSlider.value
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(pitchNode)
        audioEngine.attachNode(reverbNode)
        audioEngine.connect(audioPlayerNode, to: pitchNode, format: nil)
        audioEngine.connect(pitchNode, to: reverbNode, format: nil)
        audioEngine.connect(reverbNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(AVAudioFile(forReading: audioUrl, error: nil), atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        audioConverterLabel.text = labelHowToStop
    }
}
