//
//  SignOutViewCell.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 4/3/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class SignOutViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var camp: UILabel!
    @IBOutlet weak var guardian: UILabel!
    @IBOutlet weak var specialNote: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}