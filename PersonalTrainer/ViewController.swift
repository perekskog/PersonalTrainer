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
        print("\(Log.timestamp()): TimeAnim.setValue")

        value = newValue
    }
    func start() {
        print("\(Log.timestamp()): TimeAnim.start")

        if let _ = timer {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.value = self.value+1
            self.label.text = String(self.value)
        })
    }
    func stop() {
        print("\(Log.timestamp()): TimeAnim.stop")
        timer?.invalidate()
        self.label.text = ""
    }
    func setVisibility(visible: Bool) {
        print("\(Log.timestamp()): TimeAnim.setVisibility")
        label.isHidden = !visible
    }
}


class Log {
    class func timestamp() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm.ss.SSSS"
        return formatter.string(from: date)
    }
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
        print("\(Log.timestamp()): toggleStartStop")

        if feedbackVibrate {
            vibrate(numberOfVibrations: 1, timeInterval: 0, skipInitial: false, completed: {_ in
                print("\(Log.timestamp()): toggleStartStop...completed")
            }, id: "toggleStartStop")
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
            timeAnim?.start()
        }
    }
    
    
    
    
    @IBAction func vibrateToggle(_ sender: UISwitch) {
        print("\(Log.timestamp()): vibrateToggle = \(sender.isOn)")
        feedbackVibrate = sender.isOn
    }
    
    @IBAction func timeToggle(_ sender: UISwitch) {
        print("\(Log.timestamp()): timeToggle = \(sender.isOn)")
        timeAnim?.setVisibility(visible: sender.isOn)
    }
    
    @IBAction func colorToggle(_ sender: UISwitch) {
        print("\(Log.timestamp()): colorToggle = \(sender.isOn)")
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
        print("\(Log.timestamp()): labelToggle = \(sender.isOn)")
        feedbackTime = sender.isOn
        statusLabel.isHidden = !feedbackTime
    }
    
    
    
    
    
    func vibrate(numberOfVibrations: Int, timeInterval: TimeInterval, skipInitial: Bool, completed:@escaping () -> Void, id: String) {
        print("\(Log.timestamp()): vibrate(\(id))")
        guard numberOfVibrations > 0 else {
            completed()
            return
        }
        if(!skipInitial) {
            print("\(Log.timestamp()): <* \(id)>")
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        } else {
            print("\(Log.timestamp()): <skipped \(id)>")
        }
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { _ in
            self.vibrate(numberOfVibrations: numberOfVibrations-1, timeInterval:timeInterval, skipInitial: false, completed: completed, id: id)
        })
    }

    
    
    func workBegin(_ timer: Timer) {
        print("\(Log.timestamp()): workBegin")
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

        if feedbackVibrate {
            vibrate(numberOfVibrations: 3, timeInterval: 0.5, skipInitial: false, completed: { () -> Void in
                print("\(Log.timestamp()): workBegin... completed")
                self.vibrate(numberOfVibrations: 2, timeInterval: 2.0, skipInitial: true, completed: { _ in print("\(Log.timestamp()): working completed")}, id: "working");
            }, id: "workBegin")
        }
    }


    
    func restBegin(_ timer: Timer) {
        print("\(Log.timestamp()): restBegin")
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
            vibrate(numberOfVibrations: 3, timeInterval: 0.5, skipInitial: false, completed: { () -> Void in
                print("\(Log.timestamp()): restBegin... completed")
                self.vibrate(numberOfVibrations: 2, timeInterval: 3.0, skipInitial: true, completed: {_ in print("\(Log.timestamp()): resting... completed")}, id: "resting")
            }, id: "restBegin")
        }
    }
    
    

}
