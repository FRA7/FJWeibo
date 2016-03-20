//
//  NSDate+Extention.swift
//  FJWeibo
//
//  Created by Francis on 16/3/17.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import Foundation

extension NSDate{
    
    class func createTimeString(createAtString : String) -> String {
        // 1.创建时间格式化对象
        let fmt = NSDateFormatter()
        
        // 2.设置对象的格式
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = NSLocale(localeIdentifier: "en")
        
        // 3.将字符串转成时间
        guard let createDate = fmt.dateFromString(createAtString) else {
            return ""
        }
        
        // 4.获取当前的时间
        let nowDate = NSDate()
        
        // 5.获取当前时间和创建时间之间的时间差
        let intervalTime = Int(nowDate.timeIntervalSinceDate(createDate))
        
        // 6.如果是一分钟之内
        if intervalTime < 60 {
            return "刚刚"
        }
        
        // 7.如果是一小时之内
        if intervalTime < 60 * 60 {
            return "\(intervalTime / 60)分钟前"
        }
        
        // 8.一天之内
        if intervalTime < 60 * 60 * 24 {
            return "\(intervalTime / 60 / 60)小时前"
        }
        
        // 9.创建日历对象
        let calendar = NSCalendar.currentCalendar()
        
        // 10.判断是否在昨天
        if calendar.isDateInYesterday(createDate) {
            fmt.dateFormat = "HH:mm"
            let timeString = fmt.stringFromDate(createDate)
            return "昨天 \(timeString)"
        }
        
        // 11.判断一年之内
        let cmps = calendar.components(.Year, fromDate: createDate, toDate: nowDate, options: [])
        if cmps.year < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeString = fmt.stringFromDate(createDate)
            
            return timeString
        }
        
        // 12.大于一年
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeString = fmt.stringFromDate(createDate)
        
        return timeString
    }
    
}
