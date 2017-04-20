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

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var stepTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func start(_ sender: UIButton) {
        stepTimer = Timer.scheduledTimer(timeInterval: 3,
                                            target: self,
                                            selector: #selector(ViewController.restEnd(_:)),
                                            userInfo: nil,
                                            repeats: false)
    }

    @IBAction func stop(_ sender: UIButton) {
        stepTimer?.invalidate()
    }
    

    
    
    func workBegin(_ timer: Timer) {
        print("workBegin")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        stepTimer = Timer.scheduledTimer(timeInterval: 15,
                                        target: self,
                                        selector: #selector(ViewController.work15(_:)),
                                        userInfo: nil,
                                        repeats: false)
    }

    func work15(_ timer: Timer) {
        print("work15")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        stepTimer = Timer.scheduledTimer(timeInterval: 15,
                                        target: self,
                                        selector: #selector(ViewController.work30(_:)),
                                        userInfo: nil,
                                        repeats: false)
    }
    func work30(_ timer: Timer) {
        print("work30")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        stepTimer = Timer.scheduledTimer(timeInterval: 15,
                                        target: self,
                                        selector: #selector(ViewController.workEnd(_:)),
                                        userInfo: nil,
                                        repeats: false)
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
        stepTimer = Timer.scheduledTimer(timeInterval: 7,
                                        target: self,
                                        selector: #selector(ViewController.restHalf(_:)),
                                        userInfo: nil,
                                        repeats: false)
    }
    func restHalf(_ timer: Timer) {
        print("restHalf")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        stepTimer = Timer.scheduledTimer(timeInterval: 7,
                                        target: self,
                                        selector: #selector(ViewController.restEnd(_:)),
                                        userInfo: nil,
                                        repeats: false)
    }
    func restEnd(_ timer: Timer) {
        print("restEnd")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        stepTimer = Timer.scheduledTimer(timeInterval: 0.5,
                                        target: self,
                                        selector: #selector(ViewController.workBegin(_:)),
                                        userInfo: nil,
                                        repeats: false)
    }


}

