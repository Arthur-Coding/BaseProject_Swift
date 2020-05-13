//
//  MQL_BaseListVC.swift
//  MangQiLai
//
//  Created by 刘帅 on 2020/3/27.
//  Copyright © 2020 ArthurShuai. All rights reserved.
//

import UIKit
import SwiftyJSON

class LS_BaseListVC: UITableViewController {

    var list = [JSON]()
    
    private var isCustom = false
    private var style: UITableViewCell.CellStyle?
    private var customNibName: String?
    private var idx = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {}
        tableView.backgroundColor = .groupTableViewBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func BS_registerList(_ count: Int)
    {
        for _ in 0..<count {
            list.append(JSON(""))
        }
    }

    func BS_registerCell(withClassName name: String)
    {
        tableView.register(NSClassFromString(name), forCellReuseIdentifier: "cell")
    }
    
    func BS_registerNibCell(withNibName name: String)
    {
        tableView.register(UINib.init(nibName: name, bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func BS_createCell(withStyle cellStyle: UITableViewCell.CellStyle)
    {
        isCustom = true
        style = cellStyle
    }
    
    func BS_createCell(withNibName name: String, at index: Int)
    {
        customNibName = name
        idx = index
    }
    
    func BS_configCell(_ cell: UITableViewCell, at indexPath: IndexPath) {}
    
    func BS_selectCell(at indexPath: IndexPath) {}

    // MARK: - Table view data source and delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableView.style == .plain ? 1 : list.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.style == .plain ? list.count : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")

        if cell == nil {
            if isCustom {
                cell = UITableViewCell(style: style!, reuseIdentifier: "cell")
            } else {
                cell = Bundle.main.loadNibNamed(nibName!, owner: nil, options: nil)![idx] as? UITableViewCell
            }
        }
        
        if(tableView.style == .plain && indexPath.row < list.count) || (tableView.style != .plain && indexPath.section < list.count)  {
            BS_configCell(cell!, at: indexPath)
        }

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.style == .plain && indexPath.row < list.count) || (tableView.style != .plain && indexPath.section < list.count)  {
            BS_selectCell(at: indexPath)
        }
    }

}
