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
    
    var timer: Timer? = nil
    var isTimerOn = false
    var timeWhenGoBackground: Date?
    private let disposeBag = DisposeBag()
    
    var timeSecond = 0 {
        willSet(newValue) {
            var hours = String(newValue / 3600)
            var minutes = String(newValue / 60)
            var seconds = String(newValue % 60)
            if hours.count == 1 { hours = "0"+hours }
            if minutes.count == 1 { minutes = "0"+minutes }
            if seconds.count == 1 { seconds = "0"+seconds }
            timerLabel.text = "\(hours):\(minutes):\(seconds)"
        }
    }
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        return label
    }()
    
    lazy var starBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작", for: .normal)
        button.addTarget(self, action: #selector(timeBtnClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"
        setupLayout()
        setupNotificationObservers()
    }
    
    
    private func setupNotificationObservers() {
        NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
            .subscribe(onNext: { [weak self] _ in
                self?.appMovedToBackground()
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .subscribe(onNext: { [weak self] _ in
                self?.appMovedToForeground()
            }).disposed(by: disposeBag)
    }
    
    func appMovedToBackground() {
        print("App moved to background!")
        if isTimerOn {
            timeWhenGoBackground = Date()
            print("Save")
        }
    }
    
    func appMovedToForeground() {
        if let backTime = timeWhenGoBackground {
            let elapsed = Date().timeIntervalSince(backTime)
            let duration = Int(elapsed)
            timeSecond += duration
            timeWhenGoBackground = nil
        }
    }
    
    @objc func timeBtnClicked(_ sender: Any) {
        if isTimerOn {
            timer?.invalidate()
            starBtn.setTitle("START", for: .normal)
        } else {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.timeSecond += 1
                print("\(self.timeSecond)")
            }
            RunLoop.current.add(self.timer!, forMode: .common)
            starBtn.setTitle("STOP", for: .normal)
        }
        isTimerOn = !isTimerOn
    }
    
    
    private func setupLayout() {
        view.addSubview(timerLabel)
        view.addSubview(starBtn)
        
        timerLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(50)
        }
        
        starBtn.snp.makeConstraints {
            $0.leading.equalTo(timerLabel.snp.leading)
            $0.width.equalTo(50)
            $0.top.equalTo(timerLabel.snp.bottom)
        }
    }
}


