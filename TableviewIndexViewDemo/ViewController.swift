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
    fileprivate let QGBrandCellID = "QGBrandCellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "brand", ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        
        for dict in array! {
            self.brandList.append(QGBrandLevelOne(dict: dict as! [String : AnyObject]))
        }
        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        tableView.register(QGBrandCell.self, forCellReuseIdentifier: QGBrandCellID)
        tableView.yw_index = YWIndexView.IndexViewWith(sectionTitles: self.brandList.map{ $0.letter! })
    }

    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return brandList.count 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandList[section].BrandList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return brandList[section].letter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QGBrandCellID) as! QGBrandCell
        let brandLevelTwo = brandList[indexPath.section].BrandList[indexPath.row]
        cell.brandLevelTwo = brandLevelTwo
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 44
    }
    fileprivate var brandList = [QGBrandLevelOne]()
}

