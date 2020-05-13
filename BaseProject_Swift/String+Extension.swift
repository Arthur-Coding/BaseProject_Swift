//
//  String+Extension.swift
//  MangQiLai
//
//  Created by 刘帅 on 2020/3/31.
//  Copyright © 2020 ArthurShuai. All rights reserved.
//

import Foundation

extension String {
    
    func urLStrQueryAllow() -> String
    {
        return isIncludeChineseIn() ? addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! : self
    }
    
    func urlQueryAllow() -> URL?
    {
        return URL(string: urLStrQueryAllow())
    }
    
    private func isIncludeChineseIn() -> Bool
    {
        for index in indices {
            if ("\u{4E00}" <= self[index]  && self[index] <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }
    
}
