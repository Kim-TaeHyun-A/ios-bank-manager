//
//  DateFormatter+.swift
//  BankManagerUIApp
//
//  Created by Taeangel, Tiana 2022/05/05.
//

import Foundation

extension DateFormatter {
    static var fomat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss:SSS"
        return dateFormatter
    }
}
