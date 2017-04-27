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


    @IBOutlet var mainView: UIView!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var vibrateCheckbox: UISwitch!
    @IBOutlet weak var labelCheckbox: UISwitch!
    @IBOutlet weak var colorCheckbox: UISwitch!
    @IBOutlet weak var timeCheckbox: UISwitch!
    
    let neutralColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    let workColor = UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0)
    let restColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
    
    let backgroundNeutralColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)

    var feedbackVibrate: Bool = true
    var feedbackLabel: Bool = true
    var feedbackColor: Bool = true
    var feedbackTime: Bool = true
    
    var stepTimer: Timer?
    var timeLabelTimer: Timer?
    var timeLabelValue = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        statusLabel.text = ""
        timeLabel.text = ""
        mainView.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func toggleStartStop(_ sender: UIButton) {
        if let _ = stepTimer {
            stepTimer?.invalidate()
            stepTimer = nil
            timeLabelTimer?.invalidate()
            startStopButton.setTitle("Start", for: UIControlState.normal)
            statusLabel.text = ""
            timeLabel.text = ""
        } else {
            stepTimer = Timer.scheduledTimer(timeInterval: 3,
                                             target: self,
                                             selector: #selector(ViewController.restEnd(_:)),
                                             userInfo: nil,
                                             repeats: false)
            startStopButton.setTitle("Stop", for: UIControlState.normal)
        }
    }
    
    
    
    
    
    
    
    @IBAction func vibrateChange(_ sender: UISwitch) {
        print("vibrateChange = \(sender.isOn)")
        feedbackVibrate = sender.isOn
    }
    
    @IBAction func labelChange(_ sender: UISwitch) {
        print("labelChange = \(sender.isOn)")
        feedbackLabel = sender.isOn
        statusLabel.isHidden = !feedbackLabel
    }
    
    @IBAction func colorChange(_ sender: UISwitch) {
        print("colorChange = \(sender.isOn)")
        feedbackColor = sender.isOn
        if !feedbackColor {
            mainView.backgroundColor = backgroundNeutralColor
        } else {
            if statusLabel.text == "Rest" {
                mainView.backgroundColor = self.restColor
            } else {
                mainView.backgroundColor = self.workColor
            }
        }
    }
    
    @IBAction func timeChange(_ sender: UISwitch) {
        print("timeChange = \(sender.isOn)")
        feedbackTime = sender.isOn
        timeLabel.isHidden = !feedbackTime
    }
    
    
    
    
    
    
    
    
    
    func workBegin(_ timer: Timer) {
        print("workBegin")
        stepTimer = Timer.scheduledTimer(timeInterval: 10,
                                        target: self,
                                        selector: #selector(ViewController.workEnd(_:)),
                                        userInfo: nil,
                                        repeats: false)
        statusLabel.text = "Work"
        if feedbackColor {
            mainView.backgroundColor = workColor
        }
        timeLabelValue = 0
        timeLabelTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.timeLabelValue = self.timeLabelValue+1
            self.timeLabel.text = String(self.timeLabelValue)
        })

        if feedbackVibrate {
            vibrate(numberOfVibrations: 3, timeInterval: 0.5)
        }
    }

    func work10(_ timer: Timer) {
        print("work10")
        stepTimer = Timer.scheduledTimer(timeInterval: 10,
                                        target: self,
                                        selector: #selector(ViewController.work20(_:)),
                                        userInfo: nil,
                                        repeats: false)

        if feedbackVibrate {
            vibrate(numberOfVibrations: 1, timeInterval: 0)
        }
    }
    
    func work20(_ timer: Timer) {
        print("work20")
        stepTimer = Timer.scheduledTimer(timeInterval: 10,
                                        target: self,
                                        selector: #selector(ViewController.work30(_:)),
                                        userInfo: nil,
                                        repeats: false)

        if feedbackVibrate {
            vibrate(numberOfVibrations: 3, timeInterval: 1.0)
        }
    }
    
    func work30(_ timer: Timer) {
        print("work30")
        stepTimer = Timer.scheduledTimer(timeInterval: 10,
                                        target: self,
                                        selector: #selector(ViewController.workEnd(_:)),
                                        userInfo: nil,
                                        repeats: false)
        if feedbackVibrate {
            vibrate(numberOfVibrations: 1, timeInterval: 0)
        }
    }
    
    func workEnd(_ timer: Timer) {
        print("workEnd")
        stepTimer = Timer.scheduledTimer(timeInterval: 1,
                                        target: self,
                                        selector: #selector(ViewController.restBegin(_:)),
                                        userInfo: nil,
                                        repeats: false)
        timeLabelTimer?.invalidate()
        if feedbackVibrate {
            vibrate(numberOfVibrations: 1, timeInterval: 0)
        }
    }
    
    func restBegin(_ timer: Timer) {
        print("restBegin")
        stepTimer = Timer.scheduledTimer(timeInterval: 3,
                                        target: self,
                                        selector: #selector(ViewController.rest3(_:)),
                                        userInfo: nil,
                                        repeats: false)
        statusLabel.text = "Rest"

        if feedbackColor {
            mainView.backgroundColor = restColor
        }
        timeLabelValue = 0
        timeLabel.text = "0"
        timeLabelTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.timeLabelValue = self.timeLabelValue+1
            self.timeLabel.text = String(self.timeLabelValue)
        })

        if feedbackVibrate {
            vibrate(numberOfVibrations: 3, timeInterval: 0.5)
        }
    }
    
    func rest3(_ timer: Timer) {
        print("rest3")
        stepTimer = Timer.scheduledTimer(timeInterval: 3,
                                        target: self,
                                        selector: #selector(ViewController.rest6(_:)),
                                        userInfo: nil,
                                        repeats: false)

        if feedbackVibrate {
            vibrate(numberOfVibrations: 1, timeInterval: 0)
        }
    }
    
    func rest6(_ timer: Timer) {
        print("rest6")
        stepTimer = Timer.scheduledTimer(timeInterval: 3,
                                        target: self,
                                        selector: #selector(ViewController.rest9(_:)),
                                        userInfo: nil,
                                        repeats: false)

        if feedbackVibrate {
            vibrate(numberOfVibrations: 1, timeInterval: 0)
        }
    }
    
    func rest9(_ timer: Timer) {
        print("rest9")
        stepTimer = Timer.scheduledTimer(timeInterval: 3,
                                        target: self,
                                        selector: #selector(ViewController.restEnd(_:)),
                                        userInfo: nil,
                                        repeats: false)

        if feedbackVibrate {
            vibrate(numberOfVibrations: 1, timeInterval: 0)
        }
    }
    
    func restEnd(_ timer: Timer) {
        print("restEnd")
        stepTimer = Timer.scheduledTimer(timeInterval: 1,
                                        target: self,
                                        selector: #selector(ViewController.workBegin(_:)),
                                        userInfo: nil,
                                        repeats: false)

        timeLabelTimer?.invalidate()
        if feedbackVibrate {
            vibrate(numberOfVibrations: 1, timeInterval: 0)
        }
    }
    
    func vibrate(numberOfVibrations: Int, timeInterval: TimeInterval) {
        guard numberOfVibrations > 0 else {
            return
        }
        print("<*>")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { _ in
            self.vibrate(numberOfVibrations: numberOfVibrations-1, timeInterval:timeInterval)
        })
    }

}
