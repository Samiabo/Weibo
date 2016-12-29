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

}
