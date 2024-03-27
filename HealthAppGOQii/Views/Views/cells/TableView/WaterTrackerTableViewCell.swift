//
//  WaterTrackerTableViewCell.swift
//  HealthAppGOQii
//
//  Created by Apple on 27/03/24.
//

import UIKit

class WaterTrackerTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var glassesLbl: UILabel!
    @IBOutlet weak var currrentDateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupUI(){
        self.editBtn.layer.cornerRadius = 15
        self.editBtn.clipsToBounds = true
        self.deleteBtn.layer.cornerRadius = 15
        self.deleteBtn.clipsToBounds = true
        
    }
}
