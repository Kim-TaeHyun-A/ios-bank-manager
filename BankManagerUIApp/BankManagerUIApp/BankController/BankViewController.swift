//
//  BankManagerUIApp - ViewController.swift
//  Created by Taeangel, Tiana 2022/05/04.
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class BankViewController: UIViewController {
    private lazy var baseView = BankView(frame: view.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()

        view = baseView
    }
}

