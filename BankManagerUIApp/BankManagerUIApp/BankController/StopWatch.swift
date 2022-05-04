//
//  Timer.swift
//  BankManagerUIApp
//
//  Created by Taeangel, Tiana 2022/05/05.
//

import Foundation

class StopWatch {
    var timer: Timer?
    var time: Double = 0
    var initTime = "00:00:000"
    
    let dateFormatter: DateFormatter = DateFormatter.fomat
    
    func start() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(addTime), userInfo: nil, repeats: true)
            timer?.fire()
        }
    }
    
    @objc func addTime() {
        time += 0.001
    }
    
    func stopTime() -> String? {
        let duration = calculateTime()
        
        timer?.invalidate()
        time = 0
        timer = nil
        
        return duration
    }
    
    func calculateTime() -> String? {
        guard let convertedInitTime: Date = dateFormatter.date(from: initTime) else { return nil }
        
        let newTime = convertedInitTime + time
        
        return dateFormatter.string(from: newTime)
    }
}
