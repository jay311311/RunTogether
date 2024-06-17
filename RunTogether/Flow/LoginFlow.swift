//
//  LoginFlow.swift
//  RunTogether
//
//  Created by Jooeun Kim on 2024-06-17.
//

import UIKit
import RxRelay
import RxFlow

enum LoginStep: Step {
    case loginIsRequired
    case loginIsComplete
}

class LoginFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
    private let loginViewController = LoginViewController()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? LoginStep else { return .none }
        
        switch step {
        case .loginIsRequired:
            return navigateToLoginScreen()
        case .loginIsComplete:
            return .end(forwardToParentFlowWithStep: AppStep.dashboard)
        }
    }
    
    private func navigateToLoginScreen() -> FlowContributors {
        rootViewController.pushViewController(loginViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: loginViewController, withNextStepper: loginViewController))
    }
}

