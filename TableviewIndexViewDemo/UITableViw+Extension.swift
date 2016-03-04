//
//  UITableViw+Extension.swift
//  TableviewIndexViewDemo
//
//  Created by heew on 16/3/4.
//  Copyright © 2016年 adhx. All rights reserved.
//

import UIKit

extension UITableView {
    func setIndexViewWith(sectionTitles:[String],letterColor:UIColor = UIColor.grayColor(),letterFont:UIFont = UIFont.systemFontOfSize(12)) ->YWIndexView? {
        let tableViewH = bounds.size.height
        let insetTop = contentInset.top
        let insetBottom = contentInset.bottom
        let screenW = UIScreen.mainScreen().bounds.width
        let indexViewH = (tableViewH - insetTop - insetBottom) * 0.91
        let indexViewY = (tableViewH - insetTop - insetBottom) * 0.09 * 0.5 + frame.origin.y + insetTop
        let indexView = YWIndexView(frame: CGRect(x: screenW - 15, y: indexViewY, width: 10, height: indexViewH))
        let count = CGFloat(sectionTitles.count)
        for (index,letter) in EnumerateSequence(sectionTitles) {
            let letterLabel = UILabel(frame: CGRect(x: 0, y: indexViewH / count * CGFloat(index) , width: 12, height: indexViewH / count))
            letterLabel.font = letterFont
            letterLabel.textColor = letterColor
            letterLabel.text = letter
            indexView.addSubview(letterLabel)
        }
        indexView.titles = sectionTitles
        let touch = UITapGestureRecognizer(target: self, action: "indexViewTap:")
        indexView.addGestureRecognizer(touch)
        guard let controllerView:UIView = superview else {
            assertionFailure()
            return nil
        }
        controllerView.addSubview(indexView)
        return indexView
    }
    
    func indexViewTap(tap: UITapGestureRecognizer) {
        let indexView = tap.view as! YWIndexView
        let touchY = tap.locationInView(tap.view).y
        let index = Int(touchY / indexView.bounds.height * CGFloat(indexView.titles!.count))
        let indexPath = NSIndexPath(forRow: 0, inSection: index)
        scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
}

class YWIndexView : UIView {
    var titles : [String]?
}
