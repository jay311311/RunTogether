//
//  TimerService.swift
//  RunTogether
//
//  Created by Jooeun Kim on 2024-06-18.
//

import Foundation
import RxSwift
import RxRelay

enum TimerState{
    case start
    case reset
}

protocol TimerServiceType {
    var timeSecond: Observable<TimeInterval> { get }
    func toggleBtn()
    func start()
    func stop()
    func reset()
    func appMovedToBackground()
    func appMovedToForeground()
}

class TimerService: TimerServiceType {
    private var timer: Timer? = nil
      private var isTimerOn: Bool = false
      private var timeWhenGoBackground: Date?
      private var startTime: Date?
      private var accumulatedTime: TimeInterval = 0
      private let timeSecondRelay = BehaviorRelay<TimeInterval>(value: 0)
      
      var timeSecond: Observable<TimeInterval> {
          return timeSecondRelay.asObservable()
      }
      
      func toggleBtn() {
          if isTimerOn {
              reset()
          } else {
              start()
          }
          isTimerOn = !isTimerOn
      }
      
      func start() {
          startTime = Date()
          self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
              guard let self = self else { return }
              let currentTime = Date()
              let elapsed = self.accumulatedTime + currentTime.timeIntervalSince(self.startTime!)
              self.timeSecondRelay.accept(elapsed)
              print("\(elapsed) \(timer)")
          }
      }
      
      func stop() {
          timer?.invalidate()
          if let startTime = startTime {
              accumulatedTime += Date().timeIntervalSince(startTime)
          }
      }
      
      func reset() {
          stop()
          timeSecondRelay.accept(0)
          accumulatedTime = 0
          startTime = nil
      }
      
      func appMovedToBackground() {
          print("App moved to background!")
          if isTimerOn {
              stop()
              timeWhenGoBackground = Date()
              print("Save")
          }
      }
      
      func appMovedToForeground() {
          if let backTime = timeWhenGoBackground {
              accumulatedTime += Date().timeIntervalSince(backTime)
              startTime = Date()
              timeWhenGoBackground = nil
              start()
          }
      }
}
