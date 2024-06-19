//
//  HomeViewController.swift
//  RunTogether
//
//  Created by Jooeun Kim on 2024-06-17.
//

import UIKit
import RxFlow
import RxRelay
import RxSwift
import SnapKit

class HomeViewController: UIViewController, Stepper {
    var steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
//        label.text = ""
        return label
    }() a
    
    lazy var starBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        bindViewModel()
    }
    
    private func bindViewModel(){
        viewModel.timeString
            .bind(to: timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        starBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tapTimerBtn()
            })
            .disposed(by: disposeBag)
    }
    
    
    private func setupLayout() {
        view.addSubview(timerLabel)
        view.addSubview(starBtn)
        
        timerLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().offset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        starBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(60)
            $0.width.equalTo(150)
            $0.bottom.equalToSuperview().inset(120)
        }
    }
}


