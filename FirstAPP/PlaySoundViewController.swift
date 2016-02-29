//
//  PlaySoundViewController.swift
//  FirstAPP
//
//  Created by Jiawei Chen on 12/17/15.
//  Copyright (c) 2015 UCSD. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(receivedAudio.filePathURL)
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
//            var filePathURL = NSURL(fileURLWithPath: filePath)
//            
//        }
//        else {
//            println("Empty file path")
//        }
        audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathURL)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func commPlayAudio(rate: float_t) {
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0 // play from start point again
        audioPlayer.play()
    }
    
    @IBAction func PlaySlowAudoi(sender: UIButton) {
        commPlayAudio(0.5)
    }

    @IBAction func PlayFastAudio(sender: UIButton) {
        commPlayAudio(2)
    }
    
    @IBAction func PlayChipmunkAudio(sender: UIButton) {
        PlayWithVariablePitch(1000)
    }
    
    @IBAction func PlayDarthvaderAudio(sender: UIButton) {
        PlayWithVariablePitch(-1000)
    }

    func PlayWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format:nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch _ {
        }
        audioPlayerNode.play()
    }
    
    @IBAction func StopAudioButton(sender: UIButton) {
        audioPlayer.stop()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
