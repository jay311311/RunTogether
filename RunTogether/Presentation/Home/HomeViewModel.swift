//
//  HomeViewModel.swift
//  RunTogether
//
//  Created by Jooeun Kim on 2024-06-18.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeViewModel {
    private var service: ServiceType
    private let disposeBag = DisposeBag()
    
    // Output
    var timeString: Observable<String>
    
    init(service: ServiceType) {
        self.service = service
        
        timeString = service.timerService.timeSecond
            .map { interval in
                let hours = Int(interval) / 3600
                let minutes = Int(interval) / 60 % 60
                let seconds = Int(interval) % 60
                return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
            }
        
        setupNotificationObservers()
    }
    
    func tapTimerBtn() {
        service.timerService.toggleBtn()
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
            .subscribe(onNext: { [weak self] _ in
                self?.service.timerService.appMovedToBackground()
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .subscribe(onNext: { [weak self] _ in
                self?.service.timerService.appMovedToForeground()
            }).disposed(by: disposeBag)
    }
}
