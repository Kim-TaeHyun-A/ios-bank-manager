//
//  BankClerk.swift
//  BankManagerConsoleApp
//
//  Created by Taeangel, Tiana 2022/04/26.

import Foundation

private enum ClerkCount {
    static let deposit = 2
    static let loan = 1
}

enum BankClerk {
    static let deposit = DispatchSemaphore(value: ClerkCount.deposit)
    static let loan = DispatchSemaphore(value: ClerkCount.loan)
    static let clerks = DispatchQueue(label: "clerks", attributes: .concurrent)
    
    static func work(client: Client, group: DispatchGroup, beforeProcess: @escaping (Client) -> Void, afterProcess: @escaping (Client) -> Void) {
        let semaphore = client.task.clerk
        semaphore.wait()
        clerks.async(group: group) {
            beforeProcess(client)
            print("\(client.waitingNumber)번 고객 \(client.task.rawValue)업무 시작")
            Thread.sleep(forTimeInterval: client.task.time)
            print("\(client.waitingNumber)번 고객 \(client.task.rawValue)업무 완료")
            afterProcess(client)
            semaphore.signal()
        }
    }
}
