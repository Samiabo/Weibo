//
//  MainViewController.swift
//  Weibo
//
//  Created by han xuelong on 2016/12/27.
//  Copyright © 2016年 han xuelong. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    lazy var addBtn: UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let path = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else {
            return
        }
        
        guard let jsonData = NSData(contentsOfFile: path) else {
            return
        }
        
        guard let anyObject = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) else {
            return
        }
        
        guard let dictArray = anyObject as? [[String : AnyObject]] else {
            return
        }
        
        for dict in dictArray {
            guard let vcName = dict["vcName"] as? String else {
                continue
            }
            guard let title = dict["title"] as? String else {
                continue
            }
            guard let imageName = dict["imageName"] as? String else {
                continue
            }
            addChildViewController(childVcName: vcName, title: title, imageName: imageName)
        }
        setupUI()
    }


    private func addChildViewController(childVcName: String, title: String, imageName: String) {
        
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            return
        }
        
        guard let childVcClass = NSClassFromString(nameSpace + "." + childVcName) else {
            return
        }
        
        guard let childVcType = childVcClass as? UIViewController.Type else {
            return
        }
        
        let childVc = childVcType.init()

        childVc.title = title
        childVc.tabBarItem.image = UIImage(named: imageName)
        childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        let childNav = UINavigationController(rootViewController: childVc)
        addChildViewController(childNav)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()        
    }
    
}

extension MainViewController {
    func setupUI() {
        tabBar.addSubview(addBtn)
        addBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        addBtn.addTarget(self, action: #selector(MainViewController.addBtnClick), for: .touchUpInside)
    }
    func setupTabBar() {
        for i in 0..<childViewControllers.count {
            if i == 2 {
                let vc = childViewControllers[i]
                vc.tabBarItem.isEnabled = false
                return
            }
        }
    }
}



extension MainViewController {
    func addBtnClick() {
        LSLog(message: "click addBtn")
    }
}





















