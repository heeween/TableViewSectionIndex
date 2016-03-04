//
//  ViewController.swift
//  TableviewIndexViewDemo
//
//  Created by heew on 16/3/4.
//  Copyright © 2016年 adhx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let QGBrandCellID = "QGBrandCellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSBundle.mainBundle().pathForResource("brand", ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        
        for dict in array! {
            self.brandList.append(QGBrandLevelOne(dict: dict as! [String : AnyObject]))
        }
        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        tableView.registerClass(QGBrandCell.self, forCellReuseIdentifier: QGBrandCellID)
        
        tableView.setIndexViewWith(self.brandList.map{ $0.letter! })
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return brandList.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandList[section].BrandList.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return brandList[section].letter
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(QGBrandCellID) as! QGBrandCell
        let brandLevelTwo = brandList[indexPath.section].BrandList[indexPath.row]
        cell.brandLevelTwo = brandLevelTwo
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    private var brandList = [QGBrandLevelOne]()
}

