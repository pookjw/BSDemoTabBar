//
//  TabBarController.swift
//  BSDemoTabBar
//
//  Created by Jinwoo Kim on 4/12/23.
//

import UIKit

@MainActor
final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.bsCategory_itemSpacing = 40.0
    }
}
