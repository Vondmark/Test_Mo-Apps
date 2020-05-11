//
//  ProjectTableViewCell.swift
//  Test_Mo'Apps
//
//  Created by Mark on 10.05.2020.
//  Copyright © 2020 Mark. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var creatingLabel: UILabel!
    @IBOutlet weak var paylabel: UILabel!
    @IBOutlet weak var creatingImage: UIImageView!
    @IBOutlet weak var payImage: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
