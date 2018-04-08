//
//  LoginVC.swift
//  Rio2C
//
//  Created by Carlos Doki on 07/04/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper
import Alamofire

class LoginVC: UIViewController {
    
    @IBOutlet weak var nroCelularTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let user = KeychainWrapper.standard.string(forKey: KEY_UID) {
//            userUUID = user
//            print("DOKI: ID found in keychain")
//            performSegue(withIdentifier: "localizacao", sender: nil)
//        } else {
//        }
        
        

        
        Auth.auth().signIn(withEmail: "carlosdoki@gmail.com", password: "123456") { (user, error) in
            if error == nil {
                print("DOKI: User authenticated with Firebase")
                if let user = user {
                    let userData = ["id": KeychainWrapper.standard.string(forKey: KEY_UID)!,
                                    "celular" : "(11)989696606",
                                    "email" : "carlosdoki@gmail.com",
                                    "nome" : "Carlos Doki" ]
                    
                    //self.completeSignIn(id: user.uid, userData: userData)
                    //let userData = ["id": user.providerID]
                    //DataService.ds.createFirebaseDBUser(uid: (user.uid), userData: userData as! Dictionary<String, String>)
                    self.completeSignIn(id: user.uid, userData: userData)
                    let keychainResult = KeychainWrapper.standard.set((user.uid), forKey: KEY_UID)
                    self.performSegue(withIdentifier: "localizacao", sender: self)
                }
            }
        }

    }
    
    @IBAction func btnEntrarPressed(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: nroCelularTxt.text!, password: "123456") { (user, error) in
            if error == nil {
                print("DOKI: User authenticated with Firebase")
                if let user = user {
                    let userData = ["id": user.providerID]
                    //                DataService.ds.createFirebaseDBUser(uid: (user?.uid)!, userData: userData as! Dictionary<String, String>)
                    let keychainResult = KeychainWrapper.standard.set((user.uid), forKey: KEY_UID)
                    self.performSegue(withIdentifier: "localizacao", sender: self)
                }
            } else {
                let alert = UIAlertController(title: "Erro ao Entrar", message: "E-mail ou senha inválidos ou não cadastrado!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("DOKI: Data saved to keychain \(keychainResult)")
        //performSegue(withIdentifier: "TelaPrincipal", sender: nil)
    }
    
}



