//
//  BankView.swift
//  BankManagerUIApp
//
//  Created by Taeangel, Tiana 2022/05/04.
//

import UIKit

final class BankView: UIView {
    private var baseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var addClientsButton: UIButton = {
        let button = UIButton()
        button.setTitle("고객 10명 추가", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        return button
    }()
    
    lazy var resetBankButton: UIButton = {
        let button = UIButton()
        button.setTitle("초기화", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        return button
    }()
    
    private lazy var centerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()

    private lazy var timeLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var workingHoursLabel: UILabel = {
        let label = UILabel()
        label.text = "업무시간 - "
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private lazy var listLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var waitingClientLabel: UILabel = {
        let label = UILabel()
        label.text = "대기중"
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var processingClientLabel: UILabel = {
        let label = UILabel()
        label.text = "업무중"
        label.textColor = .white
        label.backgroundColor = .systemIndigo
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var scrollStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var waitingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var processingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var waitingClientStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var processingClientStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        addSubViews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        backgroundColor = .systemBackground
    }
}

extension BankView {
    
    //MARK: - addView
    
    private func addSubViews() {
        addSubview(baseStackView)

        buttonStackView.addArrangedSubviews(addClientsButton, resetBankButton)
        timeLabelStackView.addArrangedSubviews(workingHoursLabel, timeLabel)
        centerStackView.addArrangedSubviews(timeLabelStackView)
        listLabelStackView.addArrangedSubviews(waitingClientLabel, processingClientLabel)
        scrollStackView.addArrangedSubviews(waitingScrollView, processingScrollView)
        waitingScrollView.addSubview(waitingClientStackView)
        processingScrollView.addSubview(processingClientStackView)
        
        baseStackView.addArrangedSubviews(buttonStackView, centerStackView, listLabelStackView, scrollStackView)
    }
    
    //MARK: - layout
    
    private func layout() {
        
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            baseStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            waitingClientStackView.topAnchor.constraint(equalTo: waitingScrollView.contentLayoutGuide.topAnchor),
            waitingClientStackView.bottomAnchor.constraint(equalTo: waitingScrollView.contentLayoutGuide.bottomAnchor),
            waitingClientStackView.leadingAnchor.constraint(equalTo: waitingScrollView.contentLayoutGuide.leadingAnchor),
            waitingClientStackView.trailingAnchor.constraint(equalTo: waitingScrollView.contentLayoutGuide.trailingAnchor),
            waitingClientStackView.widthAnchor.constraint(equalTo: waitingScrollView.frameLayoutGuide.widthAnchor),
            
            processingClientStackView.topAnchor.constraint(equalTo: processingScrollView.contentLayoutGuide.topAnchor),
            processingClientStackView.bottomAnchor.constraint(equalTo: processingScrollView.contentLayoutGuide.bottomAnchor),
            processingClientStackView.leadingAnchor.constraint(equalTo: processingScrollView.contentLayoutGuide.leadingAnchor),
            processingClientStackView.trailingAnchor.constraint(equalTo: processingScrollView.contentLayoutGuide.trailingAnchor),
            processingClientStackView.widthAnchor.constraint(equalTo: processingScrollView.frameLayoutGuide.widthAnchor)
        ])
    }
}


