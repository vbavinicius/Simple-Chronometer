//
//  Chronometer.swift
//  Simples Chronometer
//
//  Created by Vinícius Barcelos on 29/04/18.
//  Copyright © 2018 Vinícius Barcelos. All rights reserved.
//

import Foundation
import UIKit

class Chronometer {

    enum CronometerStates {
        case paused
        case active
        case zeroed
    }
    
    // Last Date
    var date: Date? {
        didSet {
            centisecondsFrom1970WithtimePassed = Int((date?.timeIntervalSince1970)! * Double(100)) - timePassedInCentesimos
        }
    }
    
    var centisecondsFrom1970WithtimePassed: Int = 0
    
    // Timer
    var timer: Timer?
    
    // Labels
    var cronoLabel: UILabel?
    var hourLabel: UILabel?
    var minutesLabel: UILabel?
    var secoundsLabel: UILabel?
    var centiSecondsLabel: UILabel?
    
    // Status
    var status: CronometerStates = .zeroed {
        didSet {
            switch status {
            case .active:
                print("active")
            case .paused:
                print("paused")
            case .zeroed:
                print("zeroed")
            }
        }
    }
    
    var timePassedInCentesimos: Int = 0 {
        didSet {
            // Centesimos
            centesimos = timePassedInCentesimos % 100
            twoDigitCentesimos = String(format: "%02d", centesimos)
            
            // Segundos
            timePassedInsegundos = timePassedInCentesimos / 100
            segundos = timePassedInsegundos % 60
            twoDigitSegundos = String(format: "%02d", segundos)
            
            // Minutos
            timePassedInMinutos = timePassedInsegundos / 60
            minutos = timePassedInMinutos % 60
            twoDigitMinutos = String(format: "%02d", minutos)
            
            // Horas
            timePassedInHours = timePassedInMinutos / 60
            horas = timePassedInHours % 99
            twoDigitHours = String(format: "%02d", horas)
        }
    }
    
    var centesimos: Int = 0 //{
    var twoDigitCentesimos: String = ""
    
    var timePassedInsegundos: Int = 0
    var segundos: Int = 0
    var twoDigitSegundos: String = ""
    
    var timePassedInMinutos: Int = 0
    var minutos: Int = 0
    var twoDigitMinutos: String = ""
    
    var timePassedInHours: Int = 0
    var horas: Int = 0
    var twoDigitHours: String = ""
    
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer) in
            self.timePassedInCentesimos += 1
            
            self.updateLabels(full: self.cronoLabel, hours: self.hourLabel, minutes: self.minutesLabel, seconds: self.secoundsLabel, centiseconds: self.centiSecondsLabel)
        }
        
        // Change status
        self.status = .active
        
        // Register last start/resume moment
        self.date = Date()
    }
    
    func pause() {
        timer?.invalidate()
        self.status = .paused

    }
    
    func zero() {
        
        timer?.invalidate()
        
        timePassedInCentesimos = 0

        self.updateLabels(full: self.cronoLabel, hours: self.hourLabel, minutes: self.minutesLabel, seconds: self.secoundsLabel, centiseconds: self.centiSecondsLabel)
        
        self.status = .zeroed
    }
    
    func restart() {
        zero()
        start()
    }
    
    func updateLabels(full: UILabel?, hours: UILabel?, minutes: UILabel?, seconds: UILabel?, centiseconds: UILabel?) {
        
        if let fullLabel = full {
            fullLabel.text = "\(twoDigitHours):\(twoDigitMinutos):\(twoDigitSegundos):\(twoDigitCentesimos)"
        }
        
        if let centisecondsLabel = centiseconds {
            centisecondsLabel.text = twoDigitCentesimos
        }
        
        if let secondsLabel = seconds {
            secondsLabel.text = twoDigitSegundos
        }
        
        if let minutesLabel = minutes {
            minutesLabel.text = twoDigitMinutos
        }
        
        if let hoursLabel = hours {
            hoursLabel.text = twoDigitHours
        }
    }
    
}
