//
//  UserAccountTool.swift
//  Weibo
//
//  Created by han xuelong on 2017/1/4.
//  Copyright © 2017年 han xuelong. All rights reserved.
//

import UIKit

class UserAccountTool: NSObject {
    
    static let shareInstance: UserAccountTool = UserAccountTool()
    
    var account: UserAccount?
    
    var accountPath: String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return (accountPath as NSString).appendingPathComponent("acount.plist")
    }
    
    var isLogin: Bool {
        if account == nil {
            return false
        }
        guard let expire_date = account?.expire_date else {
            return false
        }
        return expire_date.compare(NSDate() as Date) == ComparisonResult.orderedDescending
    }
    
    override init() {
        super.init()
        print(accountPath)
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
        
    }
    
}
