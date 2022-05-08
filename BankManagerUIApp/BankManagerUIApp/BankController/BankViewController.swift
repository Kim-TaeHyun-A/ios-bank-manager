//
//  BankManagerUIApp - ViewController.swift
//  Created by Taeangel, Tiana 2022/05/04.
//  Copyright © yagom academy. All rights reserved.
//

import UIKit

protocol Observer {
    func updateLabel()
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}

final class BankViewController: UIViewController {
    private lazy var baseView = BankView(frame: view.bounds)
    private let stopWatch = StopWatch()
    
    private var bank = Bank()
    private var waitingClients = [Client]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        updata()
    }
    
    private func updata() {
        baseView.timeLabel.text = stopWatch.initTime
    }
    
    private func bind() {
        view = baseView
        
        baseView.addClientsButton.addTarget(self, action: #selector(didTapaddClientsButton), for: .touchUpInside)
        baseView.resetBankButton.addTarget(self, action: #selector(didTapResetBankButton), for: .touchUpInside)
    }
    
    @objc private func didTapaddClientsButton() {
        stopWatch.subscribe(observer: self)
//        stopWatch.start()
        addNewClients(number: 10)
        bank.open { client in
            self.startClerkProcess(client: client)
        } afterProcess: { [self] client in
            completeClerkProcess(client: client)
        }
        
        stopWatch.start()

    }
    
    @objc private func didTapResetBankButton() {
        stopWatch.stop()
        stopWatch.unSubscribe(observer: self)
        clearAllStacks()
    }
    
    func startClerkProcess(client: Client) {
        let processingNumber = client.waitingNumber - 1
        guard let processingClient = waitingClients[safe: processingNumber] else {
            print("ind error")
            return
        }
        removeStack(of: client, in: baseView.waitingClientStackView)
        addStack(client: processingClient, in: baseView.processingClientStackView)
    }
    
    func completeClerkProcess(client: Client) {
        removeStack(of: client, in: baseView.processingClientStackView)
    }
    
    func addNewClients(number: Int) {
        for _ in 1...number {
            guard let newClient = bank.addNewClient() else { return }
            waitingClients.append(newClient)
            
//            waitingClients.insert(newClient, at: newClient.waitingNumber)
            
            print(newClient.waitingNumber)
            addStack(client: newClient, in: baseView.waitingClientStackView)
        }
    }
    
    func addStack(client: Client, in stackView: UIStackView) {
        DispatchQueue.main.async { [self] in
            let label = UILabel()
            
            label.text = "\(client.waitingNumber)-\(client.task.rawValue)"
            label.font = .preferredFont(forTextStyle: .body)
            label.textAlignment = .center
            
            switch client.task {
            case .loan:
                break
            case .deposit:
                label.textColor = .purple
            }
            
            switch stackView {
            case baseView.waitingClientStackView:
                baseView.waitingClientStackView.addArrangedSubview(label)
            case baseView.processingClientStackView:
                baseView.processingClientStackView.addArrangedSubview(label)
            default:
                break
            }
        }
    }
    
    func removeStack(of client: Client, in stackView: UIStackView) {
        DispatchQueue.main.async {
            for stack in stackView.arrangedSubviews {
                guard let clientLabel = stack as? UILabel,
                let clientLabelText = clientLabel.text else { return }
                
                let clientNumber = clientLabelText
                    .compactMap { Int(String($0)) }
                    .reduce("") { $0 + String($1) }
                guard client.waitingNumber == Int(clientNumber) else { continue }
                
                
                stack.removeFromSuperview()
                return
            }
        }
    }
    
    func removeAllStacks(in stackView: UIStackView) {
        DispatchQueue.main.async {
            for labels in stackView.subviews {
                labels.removeFromSuperview()
            }
        }
    }
    
    func clearAllStacks() {
        bank.resetLastClient()
        waitingClients = [Client]()
        removeAllStacks(in: baseView.waitingClientStackView)
        removeAllStacks(in: baseView.processingClientStackView)
    }
}

extension BankViewController: Observer {
    func updateLabel() {
        baseView.timeLabel.text = stopWatch.calculateTime()
    }
}
