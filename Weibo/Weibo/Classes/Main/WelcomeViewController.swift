//
//  WelcomeViewController.swift
//  Weibo
//
//  Created by han xuelong on 2017/1/4.
//  Copyright © 2017年 han xuelong. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    @IBOutlet weak var iconViewBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var iconView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let avatarURLString = UserAccountTool.shareInstance.account?.avatar_large
        let url = NSURL(string: avatarURLString ?? "")
        
        iconView.sd_setImage(with: url as URL!, placeholderImage: UIImage(named: "avatar_default_big"))
        
        iconViewBottomCons.constant = UIScreen.main.bounds.size.height - 250
        
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [], animations: {() -> Void in
            self.view.layoutIfNeeded()
        }){(_) -> Void in
            UIApplication.shared.keyWindow?.rootViewController = MainViewController()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
