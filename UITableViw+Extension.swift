//
//  UITableView+Addtionss.swift
//  B2BAutoziMall
//
//  Created by heew on 16/3/14.
//  Copyright © 2016年 qeegoo. All rights reserved.
//

import UIKit
import ObjectiveC

private var YWIndexViewKey:UInt8 = 0

extension UITableView {
    
    var yw_index:YWIndexView? {
        set(indexView) {
            yw_index?.removeFromSuperview()
            objc_setAssociatedObject(self, &YWIndexViewKey, indexView, .OBJC_ASSOCIATION_ASSIGN)
            guard let _ = indexView else { return }
            //            if indexView == yw_index { return }
            guard let controllerView:UIView = superview
                else { assertionFailure("tableView的父控件必须为控制器view"); return }
            layoutIndexView()
            controllerView.addSubview(indexView!)
        }
        get {
            return objc_getAssociatedObject(self, &YWIndexViewKey) as? YWIndexView
        }
    }
    
    private func layoutIndexView() {
        let tableViewH = bounds.size.height
        let tableViewW = bounds.size.width
        let tableViewY = frame.origin.y
        let tableViewInsetTop = contentInset.top
        let tableViewInsetBottom = contentInset.bottom
        let indexViewH = (tableViewH - tableViewInsetTop - tableViewInsetBottom) * 0.71
        let indexViewY = (tableViewH - tableViewInsetTop - tableViewInsetBottom) * 0.29 * 0.5 + tableViewY + tableViewInsetTop
        let indexViewW = CGFloat(55)
        let indexViewX = tableViewW - indexViewW
        let count = yw_index!.sectionTitles!.count
        yw_index!.frame = CGRect(x: indexViewX, y: indexViewY, width: indexViewW, height: indexViewH)
        for index in 0..<count {
            let letterLabel = yw_index!.subviews[index] as! UILabel
            let letterLabelX = CGFloat(0)
            let letterLabelH = indexViewH / CGFloat(count)
            let letterLabelY = letterLabelH * CGFloat(index)
            let letterLabelW = CGFloat(50)
            letterLabel.frame = CGRect(x: letterLabelX, y: letterLabelY , width: letterLabelW, height: letterLabelH)
        }
        let touch = UITapGestureRecognizer(target: self, action: #selector(UITableView.indexViewTap(tap:)))
        yw_index!.addGestureRecognizer(touch)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.indexViewPan(pan:)))
        yw_index?.addGestureRecognizer(pan)
    }
    
    func indexViewPan(pan:UIPanGestureRecognizer) {
        let indexView = pan.view as! YWIndexView
        let touchY = pan.location(in: pan.view).y
        let index = Int(touchY / indexView.bounds.height * CGFloat(indexView.sectionTitles!.count))
        if pan.state == .began { indexView.labelABC.isHidden = false }
        if pan.state == .ended { indexView.labelABC.isHidden = true }
        if index < 0 || index > numberOfSections - 1 { return }
        let indexPath = IndexPath(row: 0, section: index)
        if pan.state == .changed { scrollToRow(at: indexPath as IndexPath, at: .top, animated: false) }
        let letterLabel = yw_index!.subviews[index] as! UILabel
        indexView.labelABC.text = letterLabel.text
    }
    
    func indexViewTap(tap: UITapGestureRecognizer) {
        let indexView = tap.view as! YWIndexView
        let touchY = tap.location(in: tap.view).y
        let index = Int(touchY / indexView.bounds.height * CGFloat(indexView.sectionTitles!.count))
        let indexPath = IndexPath(row: 0, section: index)
        scrollToRow(at: indexPath, at: .top, animated: true)
        let letterLabel = yw_index!.subviews[index] as! UILabel
        if tap.state == .began { letterLabel.backgroundColor = indexView.letterTrackingColor }
        if tap.state == .ended { letterLabel.backgroundColor = indexView.indexBgColor }
    }
}


class YWIndexView : UIView {
    var sectionTitles : [String]?
    var sectionIndexMinimumDisplayRowCount:Int = 2
    var letterColor = UIColor(red: 85.0/255.0, green: 141.0/255.0, blue: 215.0/255.0, alpha: 1)
    var letterFont : UIFont = UIFont.systemFont(ofSize: 12)
    var letterTrackingColor : UIColor = UIColor(red: 27 / 255.0, green: 61 / 255.0, blue: 249 / 255.0, alpha: 1)
    var indexBgColor : UIColor = UIColor.clear
    lazy var labelABC : UILabel = {
        let l = UILabel(frame:CGRect(x: 0 , y: 0 , width: 60, height: 60))
        self.window!.addSubview(l)
        l.font = UIFont.systemFont(ofSize: 32)
        l.textColor = UIColor.white
        l.backgroundColor = UIColor.darkGray
        l.textAlignment = .center
        l.layer.cornerRadius = 8
        l.clipsToBounds = true
        l.center.x = self.window!.center.x - 40
        l.center.y = self.window!.center.y
        return l
    }()
    class func IndexViewWith(sectionTitles:[String]?,letterColor:UIColor? = nil,letterFont:UIFont? = nil,letterTrackingColor:UIColor? = nil,sectionIndexMinimumDisplayRowCount:Int? = nil,indexBgColor:UIColor? = nil) ->YWIndexView? {
        let indexView = YWIndexView(frame: .zero)
        if let sectionTitles = sectionTitles { indexView.sectionTitles = sectionTitles }
        if let letterColor = letterColor { indexView.letterColor = letterColor }
        if let letterFont = letterFont { indexView.letterFont = letterFont }
        if let rowCount = sectionIndexMinimumDisplayRowCount {indexView.sectionIndexMinimumDisplayRowCount = rowCount }
        if let letterTrackingColor = letterTrackingColor { indexView.letterTrackingColor = letterTrackingColor }
        guard let sectionTitles = sectionTitles else { return nil }
        if sectionTitles.count < indexView.sectionIndexMinimumDisplayRowCount { return nil }
        sectionTitles.forEach{
            let letterLabel = UILabel(frame: .zero)
            letterLabel.text = $0
            letterLabel.textColor = indexView.letterColor
            letterLabel.font = indexView.letterFont
            letterLabel.textAlignment = .right
            indexView.addSubview(letterLabel)
        }
        return indexView
    }
}
