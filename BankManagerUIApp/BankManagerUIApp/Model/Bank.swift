//
//  Bank.swift
//  BankManagerConsoleApp
//
//  Created by Taeangel, Tiana 2022/04/26.
//

import Foundation

private enum ClientCount: Int {
    case minimum = 10
    case maximum = 30
    case first = 1
}

struct Bank: Measurable {
    private var loanClients: Queue<Client> = Queue()
    private var depositClients: Queue<Client> = Queue()
    private let workGroup = DispatchGroup()
    private var lastClient = 0
    
    func open(beforeProcess: @escaping (Client) -> Void, afterProcess: @escaping (Client) -> Void) {
        while let client = depositClients.dequeue() {
            DispatchQueue.global().async(group: workGroup) {
                BankClerk.work(client: client, group: workGroup, beforeProcess: beforeProcess, afterProcess: afterProcess)
            }
        }
        while let client = loanClients.dequeue() {
            DispatchQueue.global().async(group: workGroup) {
                BankClerk.work(client: client, group: workGroup, beforeProcess: beforeProcess, afterProcess: afterProcess)
            }
        }
    }
    
    mutating func resetLastClient() {
        lastClient = 0
    }
    
    mutating func addNewClient() -> Client? {
        guard let newClient: Client = giveWaitingNumber() else {
            return nil
        }
        
        switch newClient.task {
        case .deposit:
            depositClients.enqueue(data: newClient)
        case .loan:
            loanClients.enqueue(data: newClient)
        }
        
        return newClient
    }
    
    mutating private func giveWaitingNumber() -> Client? {
        guard let task = Task.random else {
            return nil
        }
        
        let waitingNuber = lastClient + 1
        lastClient = waitingNuber
        
        return Client(waitingNumber: waitingNuber, task: task)
    }
    
    func clearClient() {
        loanClients.clear()
        depositClients.clear()
    }
    
}
