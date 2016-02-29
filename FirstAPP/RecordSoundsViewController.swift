//
//  RecordSoundsViewController.swift
//  FirstAPP
//
//  Created by Jiawei Chen on 12/16/15.
//  Copyright (c) 2015 UCSD. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordStopButton: UIButton!
    @IBOutlet weak var recordInProgress: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var filePath: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        recordStopButton.enabled = false
        recordInProgress.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueTest") {
            let playSoundsVC: PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            // This segue should be connected by two view directly not via button
            // Otherwise sender's type is UIButton which is not allowed to transfer to RecordedAudio
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        //recordInPogress.hidden = false
        recordButton.enabled = false
        recordInProgress.hidden = false
        recordStopButton.enabled = true
        // TODO: Record of the user audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
//        var currentDateTime = NSDate()
//        var formatter = NSDateFormatter()
//        formatter.dateFormat = "ddMMyyyy-HHmmss"
//        var recordName = formatter.stringFromDate(currentDateTime) + ".wav"
//        println(recordName)
        let recordName = "my_audio.wav"
        let pathArray = [dirPath, recordName]
        filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // create session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        let recordSettings: [String: AnyObject] = [
            AVSampleRateKey: 8000.0,
            AVNumberOfChannelsKey: 2
        ]
        audioRecorder = try? AVAudioRecorder(URL: filePath, settings: recordSettings)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
    
    // this function will execute after the audioRecorder finish recording
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("segueTest", sender: recordedAudio)
        }
        else {
            print("Recording not successfully finished")
            recordButton.enabled = true
            recordStopButton.enabled = true
        }
    }

    @IBAction func recordStop(sender: UIButton) {
        recordInProgress.hidden = true
        recordButton.enabled = true
        recordStopButton.enabled = false
        
        // stop the record
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
        } catch _ {
        }
    }
}

