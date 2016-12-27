//
//  QBBrandTableViewCell.swift
//  TableviewIndexViewDemo
//
//  Created by heew on 16/3/4.
//  Copyright © 2016年 adhx. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
class QGBrandCell : UITableViewCell {
    var iconView : UIImageView?
    var titleLabel : UILabel?
    //    var topSeperator : UIView?
    var brandLevelTwo: QGBrandLevelTwo?{
        didSet {
            iconView?.sd_setImage(with: URL(string: (brandLevelTwo?.imagePath)!))
            titleLabel?.text = brandLevelTwo?.name
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        iconView = UIImageView()
        titleLabel = UILabel()
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        iconView?.contentMode = .scaleAspectFit
        iconView?.clipsToBounds = true
        iconView?.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.white
        addSubview(iconView!)
        addSubview(titleLabel!)
        iconView?.snp.makeConstraints({ (make) -> Void in
            make.left.equalTo(self.contentView).offset(20)
            make.top.equalTo(self.contentView).offset(9.5)
            make.width.equalTo(42.5)
            make.height.equalTo(25)
        })
        titleLabel?.snp.makeConstraints({ (make) -> Void in
            make.left.equalTo((self.iconView?.snp.right)!).offset(15)
            make.centerY.equalTo(self.iconView!.snp.centerY)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





class QGBrandLevelOne:NSObject {
    var letter : String?
    var BrandList = [QGBrandLevelTwo]()
    init(dict:[String : AnyObject]) {
        super.init()
        letter = dict["letter"] as? String
        let brandlist = dict["BrandList"] as! [[String : AnyObject]]
        for dict in brandlist {
            BrandList.append(QGBrandLevelTwo(dict: dict))
        }
    }
}



class QGBrandLevelTwo:NSObject {
    var ID : String?
    var name : String?
    var imagePath : String?
    var isChecked : Bool = false
    init(dict: [String : AnyObject]) {
        super.init()
        
        if let id = dict["id"]{
            ID = String(describing: id)
        }
        name = dict["name"] as? String
        imagePath = dict["imagePath"] as? String
    }
}
