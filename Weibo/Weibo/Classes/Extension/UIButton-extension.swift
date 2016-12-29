//
//  UIButton-extension.swift
//  Weibo
//
//  Created by han xuelong on 2016/12/29.
//  Copyright © 2016年 han xuelong. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init (imageName: String, bgImageName: String) {
        self.init()
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
}
