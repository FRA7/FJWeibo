//
//  NSDate+Extention.swift
//  FJWeibo
//
//  Created by Francis on 16/3/17.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import Foundation

extension NSDate{
    
    class func creatTimeString(creatAtString:String) -> String{
    
        //1.创建时间格式化对象
        let fmt = NSDateFormatter()
        //2.设置对象的格式
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = NSLocale(localeIdentifier: "en")
        
        //3.将字符串转成时间
        guard let creatDate = fmt.dateFromString(creatAtString) else{
            return ""
        }
        
        //4.获取当前时间
        let nowDate = NSDate()
        
        //5.获取发送时间和当前时间的时间差
        let intervalTime = Int(nowDate.timeIntervalSinceDate(creatDate))
        
        //6.返回结果
        //6.1 如果1分钟内
        if intervalTime < 60{
            return "刚刚"
        }
        //6.2 如果一小时内
        if intervalTime < 60 * 60{
            return "\(intervalTime / 60)分钟前"
        }
        //6.3 如果一天之内
        if intervalTime < 60 * 60 * 24{
            return "\(intervalTime / 60 / 60)小时前"
        }
        
        //7.创建日历对象
        let calendar = NSCalendar.currentCalendar()
        
        //7.1 判断是否是昨天
        if calendar.isDateInYesterday(creatDate){
            fmt.dateFormat = "HH:mm"
            let timeString = fmt.stringFromDate(creatDate)
            return "昨天\(timeString)"
        }
        
        //7.2 判断是否是一年之内
        let cmp = calendar.components(.Year, fromDate: creatDate, toDate: nowDate, options: [])
        if cmp.year < 1{
            fmt.dateFormat = "MM-dd HH:mm"
            let timeString = fmt.stringFromDate(creatDate)
            return timeString
        }
        
        //7.3 大于一年
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeString = fmt.stringFromDate(creatDate)
        
        return timeString
    }
    
}
