//
//  ViewController.swift
//  Simples Chronometer
//
//  Created by Vinícius Barcelos on 28/04/18.
//  Copyright © 2018 Vinícius Barcelos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var fullChronoLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var hundredthsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    // MARK: - Variables
    var chronometer: Chronometer!
    var uDefaults: UserDefaults!
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Chronometer config
        chronometer = Chronometer()
        chronometer.cronoLabel = fullChronoLabel
        chronometer.hourLabel = hoursLabel
        chronometer.minutesLabel = minutesLabel
        chronometer.secoundsLabel = secondsLabel
        chronometer.centiSecondsLabel = hundredthsLabel
        
        // Buttons config
        startButton.setTitle("START", for: .normal)
        restartButton.setTitle("RESTART", for: .normal)
        clearButton.setTitle("CLEAR", for: .normal)
        
        // UserDefaults
        uDefaults = UserDefaults.standard
    
        // Check status on VDL or WEF
        checkChronometerStatus()
        NotificationCenter.default.addObserver(self, selector: #selector(checkChronometerStatus), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // Check chronometer method
    @objc func checkChronometerStatus(){
        
        // Get uDefaults status
        let status = uDefaults.string(forKey: "status")
        
        // Switch status
        switch status {
            
        // Active
        case "active":
            
            // Calculate current time
            let lastDateInCentisecond = uDefaults.integer(forKey: "dateWithTimePassed")
            let nowDateInCentiseconds = Int((Date().timeIntervalSince1970) * Double(100))

            // Set new time
            chronometer.timePassedInCentesimos = nowDateInCentiseconds - lastDateInCentisecond
            
            // If chronometer is zeroed, start chronometer
            if chronometer.status == .zeroed {
                chronometer.start()
            }
            
            // Set button to pause
            startButton.setTitle("PAUSE", for: .normal)

        // Paused
        case "paused":
            
            // Get time passed before pause
            let timePassedBeforePause = uDefaults.integer(forKey: "timePassedBeforePause")
            
            // Set time
            chronometer.timePassedInCentesimos = timePassedBeforePause
            
            // Update labels
            chronometer.updateLabels(full: fullChronoLabel, hours: hoursLabel, minutes: minutesLabel, seconds: secondsLabel, centiseconds: hundredthsLabel)
            
            // Set status
            chronometer.status = .paused
            
            // Set button to resume
            startButton.setTitle("RESUME", for: .normal)
            
        case "cleared":
            // Set time
            chronometer.timePassedInCentesimos = 0
            
            // Update labels
            chronometer.updateLabels(full: fullChronoLabel, hours: hoursLabel, minutes: minutesLabel, seconds: secondsLabel, centiseconds: hundredthsLabel)
            
            // Set status
            chronometer.status = .zeroed
            
            // Set button to resume
            startButton.setTitle("START", for: .normal)
            
            
        case nil:
            // Set time
            chronometer.timePassedInCentesimos = 0
            
            // Set status
            chronometer.status = .zeroed
            
            // Set button to resume
            startButton.setTitle("START", for: .normal)
            
        default:
            return
        }
    }
    
    // Deinit to remove notifications
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = startButton.bounds.size.height / 2
    }
    

    // MARK: - IBActions
    @IBAction func startButtonDidPressed(_ sender: UIButton) {
        
        if chronometer.status == .paused || chronometer.status == .zeroed{
            chronometer.start()
            startButton.setTitle("PAUSE", for: .normal)
            
            uDefaults.set("active", forKey: "status")
            uDefaults.set(chronometer.centisecondsFrom1970WithtimePassed, forKey: "dateWithTimePassed")
            
        } else if chronometer.status == .active {
            chronometer.pause()
            startButton.setTitle("RESUME", for: .normal)
            
            uDefaults.set("paused", forKey: "status")
            uDefaults.set(chronometer.timePassedInCentesimos, forKey: "timePassedBeforePause")
            
        }

    }
    
    @IBAction func restartButtonDidPressed(_ sender: UIButton) {
        if chronometer.status == .zeroed {
            return
        } else {
            chronometer.restart()
            startButton.setTitle("PAUSE", for: .normal)
        }
    }
    
    @IBAction func clearButtonDidPressed(_ sender: UIButton) {
        chronometer.zero()
        startButton.setTitle("START", for: .normal)
        
        uDefaults.set("cleared", forKey: "status")
    }
    
}

