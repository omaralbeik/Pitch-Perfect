//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Omar Albeik on 10/07/15.
//  Copyright (c) 2015 Omar Albeik. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButon: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        stopButon.hidden = true
        recordingLabel.text = "tap to record"
        recordButton.setImage(UIImage(named: "micOffButton"), forState: .Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func recordButtonTapped(sender: UIButton) {
        
        recordButton.setImage(UIImage(named: "micOnButton"), forState: .Normal)
        recordingLabel.text = "recording"
        stopButon.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        
        var recordingName = "my_audio.wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPlayViewSegue" {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if flag {
            recordedAudio = RecordedAudio(path: recorder.url, title: recorder.url.lastPathComponent!)
            
            self.performSegueWithIdentifier("toPlayViewSegue", sender: recordedAudio)
        } else {
            println("recording failed")
            recordButton.enabled = true
            recordButton.setImage(UIImage(named: "micOffButton"), forState: .Normal)
            stopButon.hidden = true
        }
    }
    
    @IBAction func stopButtonTapped(sender: UIButton) {
        recordButton.setImage(UIImage(named: "micOffButton"), forState: .Normal)
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)
        audioSession.setActive(false, error: nil)
    }

}

