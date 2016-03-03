//
//  myTableViewCell.swift
//  zhiHuDemo
//
//  Created by 胡胡赛军 on 3/1/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

import UIKit

class myTableViewCell: UITableViewCell {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet weak var myImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myView.layer.cornerRadius = 5
        myView.layer.borderColor = UIColor.grayColor().CGColor
        myView.layer.borderWidth = 2
        myLabel.numberOfLines = 3
        myLabel.textAlignment = .Left
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
