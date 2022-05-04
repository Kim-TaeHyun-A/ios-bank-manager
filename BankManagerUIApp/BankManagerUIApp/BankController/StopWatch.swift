//
//  Timer.swift
//  BankManagerUIApp
//
//  Created by Taeangel, Tiana 2022/05/05.
//

import Foundation

final class StopWatch {
    private var timer: Timer?
    private var time: Double = 0
    var initTime = "00:00:000"
    
    private let dateFormatter: DateFormatter = DateFormatter.fomat
    
    func start() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(addTime), userInfo: nil, repeats: true)
            timer?.fire()
        }
    }
    
    @objc private func addTime() {
        time += 0.001
    }
    
    func stop() {
        timer?.invalidate()
        time = 0
        timer = nil
    }
    
    func calculateTime() -> String {
        guard let convertedInitTime: Date = dateFormatter.date(from: initTime) else {
            return ""
        }
        
        let newTime = convertedInitTime + time
        
        return dateFormatter.string(from: newTime)
    }
}
