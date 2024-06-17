//
//  SettingsFlow.swift
//  RunTogether
//
//  Created by Jooeun Kim on 2024-06-17.
//

import UIKit
import RxFlow

enum SettingsStep: Step {
    case settings
}

class SettingsFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SettingsStep else { return .none }
        
        switch step {
        case .settings:
            return navigateToSettingsScreen()
        }
    }
    
    private func navigateToSettingsScreen() -> FlowContributors {
        let viewController = SettingsViewController()
        rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))
    }
}
