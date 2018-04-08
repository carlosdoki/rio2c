//
//  SecondViewController.swift
//  Rio2C
//
//  Created by Carlos Doki on 07/04/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class MinhaContaVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var nomeTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var ceclularTxt: UITextField!
    @IBOutlet weak var celularesTbl: UITableView!
    @IBOutlet weak var inclusaoCelularTxt: UITextField!
    
    var celulares = [Celulares]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        celularesTbl.delegate = self
        celularesTbl.dataSource = self
        
        let ref = Database.database().reference()
        _ = ref.child("users").child("\(KeychainWrapper.standard.string(forKey: KEY_UID)!)").observe(.value, with: {
            (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.nomeTxt.text = value?["nome"] as? String ?? ""
            self.emailTxt.text = value?["email"] as? String ?? ""
            self.ceclularTxt.text = value?["celular"] as? String ?? ""
        })
        
        _ = ref.child("users").child("\(KeychainWrapper.standard.string(forKey: KEY_UID)!)").child("panico").observe(.value, with: {
            (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let value = snap.value as? NSDictionary {
                        let key = snap.key
                        let post = Celulares(celular: (value["celular"] as? String)!)
                        self.celulares.append(post)
                    }
                }
                self.celularesTbl.reloadData()
            }
        })
    }
    
    
    @IBAction func IncluirCelularBtn(_ sender: UIButton) {
        if inclusaoCelularTxt.text == "" {
            let alert = UIAlertController(title: "Alerta", message: "Número de celular inválido ou incompleto", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            let panicoRef = ref.child("users").child(uid!).child("panico")
            
            let celular = panicoRef.childByAutoId().child("celular")
            celular.setValue(inclusaoCelularTxt.text)
        }
    }
    
    @IBAction func ExcluirCelularBtn(_ sender: UIButton) {
        celularesTbl.delete(sender)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celulares.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = celulares[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CelularCell") as? CelularesTVC {
            cell.configureCell(celular: post.celular)
            return cell
        } else {
            return CelularesTVC()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let celularex = celulares[indexPath.row]
                let uid = Auth.auth().currentUser?.uid
                let ref = Database.database().reference().child("users").child(uid!).child("panico")
                
                ref.queryOrdered(byChild: "celular").queryEqual(toValue: celularex).observe(.childAdded, with: { (snapshot) in
                    
                    snapshot.ref.removeValue(completionBlock: { (error, reference) in
                        if error != nil {
                            print("There has been an error:\(error)")
                        }
                    })
                    
                })
                
            
            
            celulares.remove(at: indexPath.row)
            celularesTbl.deleteRows(at: [indexPath], with: .left)
        }
    }
    
}

