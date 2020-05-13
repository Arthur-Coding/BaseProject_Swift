//
//  TimeCategory.swift
//  BaseProject_Swift
//
//  Created by ArthurShuai on 2018/2/26.
//  Copyright © 2018年 ArthurShuai. All rights reserved.
//
//  文档名称：时间处理工具
//  功能描述：时间处理工具，时间、时间戳、时间字符串相关转换

import Foundation
import LSRouter_Swift

extension LSRouter {

    static let defaultFormatter = DateFormatter.init()

    /// 字符串时间转Date
    ///
    /// - Parameters:
    ///   - timeString: 字符串时间
    ///   - format: 转化格式 如yyyy-MM-dd HH:mm:ss,即2016-07-26 15:00:00
    /// - Returns: 格式化时间
    class func time_dateFromString(timeString:String, format:String) -> Date
    {
        defaultFormatter.dateFormat = format
        return defaultFormatter.date(from: timeString)!
    }

    /// Date转字符串时间
    ///
    /// - Parameters:
    ///   - date: 格式化时间
    ///   - format: 转化格式 如yyyy-MM-dd HH:mm:ss,即2016-07-26 15:00:00
    /// - Returns: 字符串时间
    class func time_dateStrFromDate(date:Date, format:String) -> String
    {
        defaultFormatter.dateFormat = format
        return defaultFormatter.string(from: date)
    }

    /// Date转时间戳
    ///
    /// - Parameter date: 格式化时间
    /// - Returns: 时间戳
    class func time_cTimestampFromDate(date:Date) -> Int
    {
        return Int(date.timeIntervalSince1970)
    }

    /// 字符串时间转时间戳
    ///
    /// - Parameters:
    ///   - timeString: 字符串时间
    ///   - format: 转化格式 如yyyy-MM-dd HH:mm:ss,即2016-07-26 15:00:00
    /// - Returns: 时间戳
    class func time_cTimestampFromString(timeString:String, format:String) -> Int
    {
        let date = time_dateFromString(timeString: timeString, format: format)
        return time_cTimestampFromDate(date: date)
    }

    /// 时间戳转字符串时间
    ///
    /// - Parameters:
    ///   - timeStamp: 时间戳
    ///   - format: 转化格式 如yyyy-MM-dd HH:mm:ss,即2016-07-26 15:00:00
    /// - Returns: 字符串时间
    class func time_dateStrFromCstampTime(timeStamp:Int, format:String) -> String
    {
        return time_dateStrFromDate(date: Date.init(timeIntervalSince1970: TimeInterval(timeStamp)), format: format)
    }
    
    class func timeIntervalToMMSSFormat(_ interval: TimeInterval) -> String
    {
        let ti = Int(interval)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

}
