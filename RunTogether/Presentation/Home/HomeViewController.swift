//
//  HomeViewController.swift
//  RunTogether
//
//  Created by Jooeun Kim on 2024-06-17.
//

import UIKit
import RxFlow
import RxRelay

class HomeViewController: UIViewController, Stepper {
    var steps = PublishRelay<Step>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"
    }
}
