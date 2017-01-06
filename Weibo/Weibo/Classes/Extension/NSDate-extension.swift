//
//  NSDate-extension.swift
//  Weibo
//
//  Created by han xuelong on 2017/1/4.
//  Copyright © 2017年 han xuelong. All rights reserved.
//

import Foundation

extension NSDate {
    class func createDateStr(createAtStr: String) -> String {
        
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = NSLocale(localeIdentifier: "en") as Locale!
        guard let createDate = fmt.date(from: createAtStr) else {
            return ""
        }
        let nowDate = NSDate()
        let interval = Int(nowDate.timeIntervalSince(createDate))
        
        if interval < 60 {
            return "just"
        }
        
        if interval < 60 * 60 {
            return "\(interval / 60) minutes ago"
        }
        
        if interval < 60 * 60 * 24 {
            return "\(interval / (60 * 60)) hours ago"
        }
        
        let calendar = NSCalendar.current
        if calendar.isDateInYesterday(createDate) {
            fmt.dateFormat = "yesterday HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        
        let cmps = calendar.dateComponents([.year], from: createDate, to: nowDate as Date)
        if cmps.year! < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = fmt.string(from: createDate)
        return timeStr
    }
}
