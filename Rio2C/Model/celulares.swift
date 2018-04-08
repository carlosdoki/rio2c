//
//  celulares.swift
//  Rio2C
//
//  Created by Carlos Doki on 07/04/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import Foundation
import Firebase

class Celulares {
    private var _celular : String!
    
    var celular : String {
        return _celular
    }
    
    init(celular: String) {
        self._celular = celular
    }
    
    init(postData: Dictionary<String, AnyObject>) {
        if let celular = postData["celular"] as? String {
            self._celular = celular
        }
        
    }
}
