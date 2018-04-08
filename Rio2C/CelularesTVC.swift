//
//  CelularesTVC.swift
//  Rio2C
//
//  Created by Carlos Doki on 07/04/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import Firebase

class CelularesTVC: UITableViewCell {

    @IBOutlet weak var celularLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(celular: String) {
        
        self.celularLbl.text = celular
    }
    
}
