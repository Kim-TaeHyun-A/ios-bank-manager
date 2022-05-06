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
    private let workGroup = DispatchGroup()
    private var lastClientsNumber = 0
    
    private var loanClerks: [DispatchQueue] = []
    private var depositClerks: [DispatchQueue] = []
    
    let raceCondition = DispatchQueue(label: "raceCondition")
    
    private var loanClients = Queue<Client>()
    private var depositClients = Queue<Client>()
    
    private var totalClientsCount: Int {
        return Int.random(in: ClientCount.minimum.rawValue...ClientCount.maximum.rawValue)
    }
    
    func measureWorkingHours() -> Double {
        let duration = measureTime {
            open()
        }
        return duration
    }
    
    mutating func resetClerk() {
        loanClerks.removeAll()
        depositClerks.removeAll()
    }
    
    mutating func setClerks(loan: Int, deposit: Int) {
        for number in 1...loan {
            loanClerks.append(DispatchQueue(label: "loanClerk\(number)"))
        }
        
        for number in 1...deposit {
            depositClerks.append(DispatchQueue(label: "depositClerk\(number)"))
        }
    }
    
    private func open() {
        DispatchQueue.global().async(group: workGroup) {
            while !loanClients.isEmpty {
                for clerk in loanClerks {
                    clerk.async(group: workGroup) {
                        operateClerkWork(clerk: clerk, task: Task.loan)
                    }
                }
            }
        }
        
        DispatchQueue.global().async(group: workGroup) {
            while !depositClients.isEmpty {
                for clerk in depositClerks {
                    clerk.async(group: workGroup) {
                        operateClerkWork(clerk: clerk, task: Task.deposit)
                    }
                }
            }
        }
        workGroup.wait()
    }
    
    func operateClerkWork(clerk: DispatchQueue, task: Task) {
        var client: Client?
        var clientQueue: Queue<Client>?
        
        switch task {
        case .deposit:
            clientQueue = depositClients
        case .loan:
            clientQueue = loanClients
        }

        raceCondition.sync {
            client = clientQueue?.dequeue()
        }

        guard let client = client else {
            return
        }

        clerk.async(group: workGroup) {
            clerkWork(client: client)
        }
    }
    
    func clerkWork(client: Client) {
        print("\(client.waitingNumber)번 고객 \(client.task.rawValue)업무 시작")
        Thread.sleep(forTimeInterval: client.task.time)
        print("\(client.waitingNumber)번 고객 \(client.task.rawValue)업무 완료")
    }
    
    func giveWaitingNumber() -> Int? {
        let totalClients = totalClientsCount
        for waitingNumber in ClientCount.first.rawValue...totalClients {
            guard let task = Task.random else {
                return nil
            }
            
            switch task {
            case .deposit:
                depositClients.enqueue(data: Client(waitingNumber: waitingNumber, task: task))
            case .loan:
                loanClients.enqueue(data: Client(waitingNumber: waitingNumber, task: task))
            }
        }
        return totalClients
    }
}
