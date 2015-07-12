//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Omar Albeik on 10/07/15.
//  Copyright (c) 2015 Omar Albeik. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
   
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    @IBOutlet weak var slowPlayButton: UIButton!
    @IBOutlet weak var fastPlayButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var darthVaderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePath, error: nil)
        audioPlayer.enableRate = true
        audioPlayer.delegate = self
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePath, error: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func slowPlayButtonTapped(sender: UIButton) {
        audioPlayer.currentTime = 0.0
        turnOffAllButtons()
        slowPlayButton.setImage(UIImage(named: "slowOnButton"), forState: .Normal)
        playAudio(0.5)
    }
    
    @IBAction func fastPlayButtonTapped(sender: UIButton) {
        audioPlayer.currentTime = 0.0
        turnOffAllButtons()
        fastPlayButton.setImage(UIImage(named: "fastOnButton"), forState: .Normal)
        playAudio(2.4)
    }
    
    @IBAction func chipmunkButtonTapped(sender: UIButton) {
        turnOffAllButtons()
        chipmunkButton.setImage(UIImage(named: "chipmunkOnButton"), forState: .Normal)
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func darthVaderButtonTapped(sender: UIButton) {
        turnOffAllButtons()
        darthVaderButton.setImage(UIImage(named: "darthVaderOnButton"), forState: .Normal)
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        stopAudio()
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
    
    @IBAction func stopButtonTapped(sender: UIButton) {
        turnOffAllButtons()
        if let audioPlayer = audioPlayer {
            stopAudio()
        }
    }
    
    func turnOffAllButtons() {
        slowPlayButton.setImage(UIImage(named: "slowOffButton"), forState: .Normal)
        fastPlayButton.setImage(UIImage(named: "fastOffButton"), forState: .Normal)
        chipmunkButton.setImage(UIImage(named: "chipmunkOffButton"), forState: .Normal)
        darthVaderButton.setImage(UIImage(named: "darthVaderOffButton"), forState: .Normal)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        turnOffAllButtons()
        stopAudio()
    }
    
    func stopAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
    func playAudio(speed: Float) {
        stopAudio()
        audioPlayer.rate = speed
        audioPlayer.prepareToPlay()
        audioPlayer.play()

    }
    
}