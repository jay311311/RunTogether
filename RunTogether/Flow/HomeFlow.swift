//
//  HomeFlow.swift
//  RunTogether
//
//  Created by Jooeun Kim on 2024-06-17.
//

import UIKit
import RxFlow


enum HomeStep: Step {
    case home
}

class HomeFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? HomeStep else { return .none }
        
        switch step {
        case .home:
            return navigateToHomeScreen()
        }
    }
    
    private func navigateToHomeScreen() -> FlowContributors {
        let viewController = HomeViewController()
        rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))
    }
    
}
