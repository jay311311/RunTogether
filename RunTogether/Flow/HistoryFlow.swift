//
//  HistoryFlow.swift
//  RunTogether
//
//  Created by Jooeun Kim on 2024-06-17.
//

import UIKit
import RxFlow

enum HistoryStep: Step {
    case history
}

class HistoryFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? HistoryStep else { return .none }
        
        switch step {
        case .history:
            return navigateToHistoryScreen()
        }
    }
    private func navigateToHistoryScreen() -> FlowContributors {
        let viewController =  HistoryViewController()
        rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))
    }
}
