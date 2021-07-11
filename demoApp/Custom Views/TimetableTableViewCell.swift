//
//  TimetableTableViewCell.swift
//  demoApp
//
//  Created by Ashish Sharma on 05.07.21.
//

import UIKit

class TimetableTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLineNumberAndDirection: UILabel!
    
    @IBOutlet weak var lblRouteDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ data: TimetableTableViewCellViewModel) {
        self.lblTime.text = data.shortTime
        self.lblLineNumberAndDirection.text = data.lineDirection
        self.lblRouteDetail.text = data.routeString
    }
}
