//
//  BankManagerUIApp - ViewController.swift
//  Created by Taeangel, Tiana 2022/05/04.
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

final class BankViewController: UIViewController {
    private lazy var baseView = BankView(frame: view.bounds)
    private var stopWatch: StopWatch? {
        didSet {
            baseView.timeLabel.text = stopWatch?.calculateTime()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        updata()
    }
    
    private func updata() {
        baseView.timeLabel.text = stopWatch?.initTime
    }
    
    private func bind() {
        view = baseView
        
        baseView.addClientsButton.addTarget(self, action: #selector(didTapaddClientsButton), for: .touchUpInside)
        baseView.resetBankButton.addTarget(self, action: #selector(didTapresetBankButton), for: .touchUpInside)
    }
    
    @objc private func didTapaddClientsButton() {
        stopWatch?.start()
    }
    
    @objc private func didTapresetBankButton() {
        stopWatch?.stop()
    }
}

