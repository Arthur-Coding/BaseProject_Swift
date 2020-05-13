//
//  UIView+Extension.swift
//  MangQiLai
//
//  Created by 刘帅 on 2020/3/29.
//  Copyright © 2020 ArthurShuai. All rights reserved.
//

import UIKit
import MJRefresh

extension UIScrollView {
    
    @discardableResult
    func headerRefreshAction(_ action:@escaping (()->Void)) -> UIScrollView
    {
        if mj_header != nil {
            mj_header!.refreshingBlock = action
        } else {
            mj_header = MJRefreshNormalHeader(refreshingBlock: action)
        }
        return self
    }
    
    @discardableResult
    func footerRefreshAction(_ action:@escaping (()->Void)) -> UIScrollView
    {
        if mj_footer != nil {
            mj_footer!.refreshingBlock = action
        } else {
            mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: action)
        }
        return self
    }
    
    func endRefresh()
    {
        if mj_header != nil {
            mj_header!.endRefreshing()
        }
        if mj_footer != nil {
            mj_footer!.endRefreshing()
        }
    }
    
    func endRefreshWithNoMoreData()
    {
        if mj_footer != nil {
            mj_footer!.endRefreshingWithNoMoreData()
        }
    }
    
}
