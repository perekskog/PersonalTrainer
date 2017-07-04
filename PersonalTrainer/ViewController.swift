//
//  ViewController.swift
//  PersonalTrainer
//
//  Created by Per Ekskog on 2017-04-19.
//  Copyright © 2017 Per Ekskog. All rights reserved.
//

import UIKit
import AudioToolbox


class TimeAnim {
    var timer: Timer?
    var value: Int = 0
    var label: UILabel

    init(aLabel: UILabel) {
        label = aLabel
        label.text = ""
    }
    func setValue(newValue: Int) {
        print("TimeAnim.setValue")

        value = newValue
    }
    func start() {
        print("TimeAnim.start")

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.value = self.value+1
            self.label.text = String(self.value)
        })
    }
    func stop() {
        print("TimeAnim.stop")
        timer?.invalidate()
        self.label.text = ""
    }
    func setVisibility(visible: Bool) {
        print("TimeAnim.setVisibility")
        label.isHidden = !visible
    }
}

class Vibrator {
    
}

class ViewController: UIViewController {


    @IBOutlet var mainView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startStopView: UIImageView!
    
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
    
    var timeAnim: TimeAnim?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        statusLabel.text = ""
        mainView.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.toggleStartStop(_:))))
        
        timeAnim = TimeAnim(aLabel: timeLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func toggleStartStop(_ sender: UIButton) {
        if feedbackVibrate {
            vibrate(numberOfVibrations: 1, timeInterval: 0, skipInitial: false)
        }

        if let _ = stepTimer {
            stepTimer?.invalidate()
            stepTimer = nil
            timeAnim?.stop()
            statusLabel.text = ""

            startStopView.image = UIImage(named: "play")
        } else {
            stepTimer = Timer.scheduledTimer(timeInterval: 0,
                                             target: self,
                                             selector: #selector(ViewController.workBegin(_:)),
                                             userInfo: nil,
                                             repeats: false)
            
            startStopView.image = UIImage(named: "stop")
        }
    }
    
    
    
    
    @IBAction func vibrateToggle(_ sender: UISwitch) {
        print("vibrateChange = \(sender.isOn)")
        feedbackVibrate = sender.isOn
    }
    
    @IBAction func timeToggle(_ sender: UISwitch) {
        print("timeChange = \(sender.isOn)")
        timeAnim?.setVisibility(visible: sender.isOn)
    }
    
    @IBAction func colorToggle(_ sender: UISwitch) {
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
    
    @IBAction func labelToggle(_ sender: UISwitch) {
        print("labelChange = \(sender.isOn)")
        feedbackTime = sender.isOn
        statusLabel.isHidden = !feedbackTime
    }
    
    
    
    
    
    func vibrate(numberOfVibrations: Int, timeInterval: TimeInterval, skipInitial: Bool) {
        guard numberOfVibrations > 0 else {
            return
        }
        if(!skipInitial) {
            print("<*>")
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { _ in
            self.vibrate(numberOfVibrations: numberOfVibrations-1, timeInterval:timeInterval, skipInitial: skipInitial)
        })
    }

    
    
    
    
    
    
    func workBegin(_ timer: Timer) {
        print("workBegin")
        stepTimer = Timer.scheduledTimer(timeInterval: 10,
                                        target: self,
                                        selector: #selector(ViewController.restBegin(_:)),
                                        userInfo: nil,
                                        repeats: false)
        statusLabel.text = "Work"
        if feedbackColor {
            mainView.backgroundColor = workColor
        }
        timeAnim?.setValue(newValue: 0)
        timeAnim?.start()

        if feedbackVibrate {
            vibrate(numberOfVibrations: 3, timeInterval: 0.5, skipInitial: false)
            vibrate(numberOfVibrations: 3, timeInterval: 10.0, skipInitial: true);
        }
    }


    
    func restBegin(_ timer: Timer) {
        print("restBegin")
        stepTimer = Timer.scheduledTimer(timeInterval: 15,
                                        target: self,
                                        selector: #selector(ViewController.workBegin(_:)),
                                        userInfo: nil,
                                        repeats: false)
        statusLabel.text = "Rest"

        if feedbackColor {
            mainView.backgroundColor = restColor
        }
        timeAnim?.setValue(newValue: 0)

        if feedbackVibrate {
            vibrate(numberOfVibrations: 3, timeInterval: 0.5, skipInitial: false)
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in 
                self.vibrate(numberOfVibrations: 4, timeInterval: 3.0, skipInitial: true)
            })
        }
    }

}
