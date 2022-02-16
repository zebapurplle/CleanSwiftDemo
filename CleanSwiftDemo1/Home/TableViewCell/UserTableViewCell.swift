//
//  UserTableViewCell.swift
//  CleanSwiftDemo1
//
//  Created by Purplle on 16/02/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension UserTableViewCell {
    
    func loadDataInCell(userInfo: UserModel) {
        
        nameLbl.text = userInfo.name ?? ""
        emailLbl.text = userInfo.email ?? ""
        genderLbl.text = userInfo.gender ?? ""
    }
}
