//
//  MainViewController.swift
//  Weibo
//
//  Created by han xuelong on 2016/12/27.
//  Copyright © 2016年 han xuelong. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewController(childVc: HomeViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(childVc: MessageViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(childVc: ProfileViewController(), title: "我", imageName: "tabbar_profile")
        addChildViewController(childVc: DiscoverViewController(), title: "发现", imageName: "tabbar_discover")
        
    }


    private func addChildViewController(childVc: UIViewController, title: String, imageName: String) {
        
        childVc.title = title
        childVc.tabBarItem.image = UIImage(named: imageName)
        childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        let childNav = UINavigationController(rootViewController: childVc)
        addChildViewController(childNav)
    }

}
