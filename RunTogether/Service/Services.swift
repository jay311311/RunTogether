//
//  Services.swift
//  RunTogether
//
//  Created by Jooeun Kim on 2024-06-18.
//

import Foundation


protocol ServiceType {
    var timerService: TimerServiceType { get set }
}

class Services: ServiceType {
    var timerService: TimerServiceType
    init() {
        self.timerService = TimerService()
    }
}
