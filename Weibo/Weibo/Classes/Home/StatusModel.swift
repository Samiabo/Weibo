//
//  StatusModel.swift
//  Weibo
//
//  Created by han xuelong on 2017/1/4.
//  Copyright © 2017年 han xuelong. All rights reserved.
//

import UIKit

class StatusModel: NSObject {
    
    var created_at: String?
    var source: String?
    var text: String?
    var mid: Int = 0
    var user: User?
    var pic_urls: [[String: String]]?
    var retweeted_status: StatusModel?
    
    // MARK: - 自定义构造方法
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        if let userDict = dict["user"] as? [String: AnyObject] {
            user = User(dict: userDict)
        }
        
        if let retweetedStatusDict = dict["retweeted_status"] as? [String: AnyObject] {
            retweeted_status = StatusModel(dict: retweetedStatusDict)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
