//
//  AppFlow.swift
//  RunTogether
//
//  Created by Jooeun Kim on 2024-06-17.
//

import UIKit
import RxFlow
import RxRelay
import RxSwift

enum AppStep: Step {
    case dashboard
    case login
}

class AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    var initialStep: Step {
        return AppStep.dashboard
    }
}

class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UITabBarController()
    private let homeFlow = HomeFlow()
    private let historyFlow = HistoryFlow()
    private let settingsFlow = SettingsFlow()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .dashboard:
            return navigateToDashboard()
        case .login:
            return .end(forwardToParentFlowWithStep: AppStep.login)
        }
    }
    
    func navigateToDashboard() -> FlowContributors {
        Flows.use(homeFlow, settingsFlow, historyFlow, when: .created) { (homeRoot, settingsRoot, historyRoot) in
            let homeItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: nil)
            let settingsItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), selectedImage: nil)
            let historyItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: nil)
            
            homeRoot.tabBarItem = homeItem
            historyRoot.tabBarItem = historyItem
            settingsRoot.tabBarItem = settingsItem
            
            self.rootViewController.setViewControllers([homeRoot, historyRoot, settingsRoot], animated: false)
            self.rootViewController.selectedIndex = 0 // 첫 화면으로 Home을 설정
            
        }
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow, withNextStepper: OneStepper(withSingleStep: HomeStep.home)),
            .contribute(withNextPresentable: historyFlow, withNextStepper: OneStepper(withSingleStep: HistoryStep.history)),
            .contribute(withNextPresentable: settingsFlow, withNextStepper: OneStepper(withSingleStep: SettingsStep.settings))
        ])
    }
}
