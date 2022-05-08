//
//  Bank.swift
//  BankManagerConsoleApp
//
//  Created by Taeangel, Tiana 2022/04/26.
//

import Foundation

struct Bank: Measurable {
    var bankDelegate: BankDelegate?
    let depositOperationQueue = OperationQueue()
    let loanOperationQueue = OperationQueue()
    private(set) var loanClients: Queue<Client> = Queue()
    private(set) var depositClients: Queue<Client> = Queue()
    private var lastClient = 0
    
    func cancelAllBankOperations() {
        depositOperationQueue.cancelAllOperations()
        loanOperationQueue.cancelAllOperations()
    }
    
    func setClerkCount(loan: Int, deposit: Int) {
        loanOperationQueue.maxConcurrentOperationCount = loan
        depositOperationQueue.maxConcurrentOperationCount = deposit
    }
    
    func startLoanWork() {
        while let client = loanClients.dequeue() {
            loanOperationQueue.addOperation {
                bankDelegate?.startClerkProcess(client: client)
                Thread.sleep(forTimeInterval: client.task.time)
                bankDelegate?.completeClerkProcess(client: client)
            }
        }
    }
    
    func startDepositWork() {
        while let client = depositClients.dequeue() {
            depositOperationQueue.addOperation {
                bankDelegate?.startClerkProcess(client: client)
                Thread.sleep(forTimeInterval: client.task.time)
                bankDelegate?.completeClerkProcess(client: client)
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
