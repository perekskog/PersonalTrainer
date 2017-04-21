//
//  ViewController.swift
//  PersonalTrainer
//
//  Created by Per Ekskog on 2017-04-19.
//  Copyright © 2017 Per Ekskog. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {


    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var stepTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        statusLabel.text = ""

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func toggleStartStop(_ sender: UIButton) {
        if let _ = stepTimer {
            stepTimer?.invalidate()
            stepTimer = nil
            startStopButton.setTitle("Start", for: UIControlState.normal)
            statusLabel.text = ""
        } else {
            stepTimer = Timer.scheduledTimer(timeInterval: 3,
                                             target: self,
                                             selector: #selector(ViewController.restEnd(_:)),
                                             userInfo: nil,
                                             repeats: false)
            startStopButton.setTitle("Stop", for: UIControlState.normal)
        }
    }
    
    
    func workBegin(_ timer: Timer) {
        print("workBegin")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        sleep(1)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        stepTimer = Timer.scheduledTimer(timeInterval: 10,
                                        target: self,
                                        selector: #selector(ViewController.work10(_:)),
                                        userInfo: nil,
                                        repeats: false)
        statusLabel.text = "Work"
        timeLabel.text = "0"
    }

    func work10(_ timer: Timer) {
        print("work10")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        stepTimer = Timer.scheduledTimer(timeInterval: 10,
                                        target: self,
                                        selector: #selector(ViewController.work20(_:)),
                                        userInfo: nil,
                                        repeats: false)
        timeLabel.text = "10"
    }
    func work20(_ timer: Timer) {
        print("work20")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        sleep(1)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        stepTimer = Timer.scheduledTimer(timeInterval: 10,
                                        target: self,
                                        selector: #selector(ViewController.work30(_:)),
                                        userInfo: nil,
                                        repeats: false)
        timeLabel.text = "20"
    }
    func work30(_ timer: Timer) {
        print("work30")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        stepTimer = Timer.scheduledTimer(timeInterval: 10,
                                        target: self,
                                        selector: #selector(ViewController.workEnd(_:)),
                                        userInfo: nil,
                                        repeats: false)
        timeLabel.text = "30"
    }
    func workEnd(_ timer: Timer) {
        print("workEnd")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        stepTimer = Timer.scheduledTimer(timeInterval: 1,
                                        target: self,
                                        selector: #selector(ViewController.restBegin(_:)),
                                        userInfo: nil,
                                        repeats: false)
    }
    func restBegin(_ timer: Timer) {
        print("restBegin")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        sleep(1)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        stepTimer = Timer.scheduledTimer(timeInterval: 3,
                                        target: self,
                                        selector: #selector(ViewController.rest3(_:)),
                                        userInfo: nil,
                                        repeats: false)
        statusLabel.text = "Rest"
        timeLabel.text = "0"
    }
    func rest3(_ timer: Timer) {
        print("rest3")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        stepTimer = Timer.scheduledTimer(timeInterval: 3,
                                        target: self,
                                        selector: #selector(ViewController.rest6(_:)),
                                        userInfo: nil,
                                        repeats: false)
        timeLabel.text = "3"
    }
    func rest6(_ timer: Timer) {
        print("rest6")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        stepTimer = Timer.scheduledTimer(timeInterval: 3,
                                        target: self,
                                        selector: #selector(ViewController.rest9(_:)),
                                        userInfo: nil,
                                        repeats: false)
        timeLabel.text = "6"
    }
    func rest9(_ timer: Timer) {
        print("rest9")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        stepTimer = Timer.scheduledTimer(timeInterval: 3,
                                        target: self,
                                        selector: #selector(ViewController.restEnd(_:)),
                                        userInfo: nil,
                                        repeats: false)
        timeLabel.text = "9"
    }
    func restEnd(_ timer: Timer) {
        print("restEnd")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        stepTimer = Timer.scheduledTimer(timeInterval: 1,
                                        target: self,
                                        selector: #selector(ViewController.workBegin(_:)),
                                        userInfo: nil,
                                        repeats: false)
    }


}

