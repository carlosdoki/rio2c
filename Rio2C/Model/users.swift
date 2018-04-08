//
//  users.swift
//  Rio2C
//
//  Created by Carlos Doki on 07/04/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import Foundation
import Firebase

class users {
    private var _nome: String!
    private var _email: String!
    private var _celular: String!
    private var _postKey: String!
    private var _postRef: DatabaseReference!
    
    var nome: String {
        return _nome
    }
    
    var email: String {
        return _email
    }
    
    var celular: String {
        return _celular
    }
    
    
    init(nome: String, email: String, celular: String) {
        self._nome = nome
        self._email = email
        self._celular = celular
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if (postData["nome"] as? String) != nil {
            self._nome = nome
        }
        
        if (postData["email"] as? String) != nil {
            self._email = email
        }
        
        if (postData["celular"] as? Double) != nil {
            self._celular = celular
        }
        
        //_postRef = DataService.ds.REF_CARTEIRA.child(_postKey)
    }
    
    
}
