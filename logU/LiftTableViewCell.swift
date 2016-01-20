//
//  LiftTableViewCell.swift
//  logU
//
//  Created by Brett Alcox on 1/11/16.
//  Copyright © 2016 Brett. All rights reserved.
//

import UIKit

class LiftTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var liftLabel: UILabel!
    @IBOutlet weak var poundsLabel: UILabel!
    @IBOutlet weak var setsRepsLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
