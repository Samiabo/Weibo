//
//  StatusViewModel.swift
//  Weibo
//
//  Created by han xuelong on 2017/1/4.
//  Copyright © 2017年 han xuelong. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    
    var status: StatusModel?
    
    var sourceText: String?
    var createAtText: String?
    var verifiedImage: UIImage?
    var vipImage: UIImage?
    var profileURL: NSURL?
    var picURLs: [URL] = [URL]()
    
    init(status: StatusModel) {
        
        self.status = status
        
        if let source = status.source, source != "" {
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
        
        
        if let create_at = status.created_at {
            createAtText = NSDate.createDateStr(createAtStr: create_at)
        }
        
        let verified_type = status.user?.verified_type ?? -1
        switch verified_type {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        let profileURLString = status.user?.profile_image_url ?? ""        
        profileURL = NSURL(string: profileURLString)
        
        if let picURLDicts = status.pic_urls {
            for picURLDict in picURLDicts {
                guard let picURLString = picURLDict["thumbnail_pic"] else {
                    continue
                }
                picURLs.append(URL(string: picURLString)!)
            }
        }
    }
}
