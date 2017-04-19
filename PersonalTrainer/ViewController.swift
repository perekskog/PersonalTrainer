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
    
    var vibrateTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func start(_ sender: UIButton) {
        vibrateTimer = Timer.scheduledTimer(timeInterval: 3,
                                            target: self,
                                            selector: #selector(ViewController.vibrate(_:)),
                                            userInfo: nil,
                                            repeats: true)
    }

    @IBAction func stop(_ sender: UIButton) {
        vibrateTimer?.invalidate()
    }
    
    func vibrate(_ timer: Timer) {
        print("vibrate")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}

