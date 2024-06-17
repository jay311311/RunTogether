//
//  SettingsViewController.swift
//  RunTogether
//
//  Created by Jooeun Kim on 2024-06-17.
//

import UIKit
import RxFlow
import RxRelay

class SettingsViewController: UIViewController, Stepper {
    var steps = PublishRelay<Step>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        title = "Setteings"
    }

}
