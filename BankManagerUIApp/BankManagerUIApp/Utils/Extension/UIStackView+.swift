//
//  UIView+.swift
//  BankManagerUIApp
//
//  Created by Taeangel, Tiana 2022/05/04.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
