//
//  CadastroVC.swift
//  Rio2C
//
//  Created by Carlos Doki on 07/04/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import FirebaseAuth

class CadastroVC: UIViewController, AuthUIDelegate {

    @IBOutlet weak var nomeTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var celularTxt: UITextField!
    
    var telefone :String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        celularTxt.text = telefone
        // Do any additional setup after loading the view.
    }

    @IBAction func CadastroBrnPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Nro. Telefone", message: "Confirma o número do celular? \n\(celularTxt.text!)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Sim", style: .default) { (UIAlertAction) in
            //self.CarregandoV.isHidden = false
            //self.IndicadorAIV.startAnimating()
            //telefonecompleto = "\(self.dddTxt.text!)\(self.celularTxt.text!)"
            PhoneAuthProvider.provider().verifyPhoneNumber(self.celularTxt.text!, uiDelegate: self) { (verificationID, error) in
                //self.CarregandoV.isHidden = true
                //self.IndicadorAIV.stopAnimating()
                if error != nil {
                    print("Error: \(String(describing: error?.localizedDescription))")
                    //self.showMessagePrompt(error.localizedDescription)
                    return
                } else {
                    let defaults = UserDefaults.standard
                    defaults.set(verificationID, forKey: "authVID")
                    //                    defaults.set("54FjYF8UwBS5IVbeitX9Pq6IbfF3", forKey: "authVID")
                    self.performSegue(withIdentifier: "localizacao2", sender: self)
                }
            }
        }
        let cancel = UIAlertAction(title: "Não", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
}
