//
//  UserAccount.swift
//  Weibo
//
//  Created by han xuelong on 2017/1/3.
//  Copyright © 2017年 han xuelong. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    var access_token: String?
    var expires_in: TimeInterval = 0.0 {
        didSet {
            expire_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    var uid: String?
    var expire_date: NSDate?
    var screen_name: String?
    var avatar_large: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        return dictionaryWithValues(forKeys: ["access_token","expire_date","uid","screen_name","avatar_large"]).description
    }
    
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as! String?
        expire_date = aDecoder.decodeObject(forKey: "expire_date") as? NSDate
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expire_date, forKey: "expire_date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
}
