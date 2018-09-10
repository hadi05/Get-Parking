//
//  SignIn.swift
//  Get Parking
//
//  Created by adil on 09/09/2018.
//

import UIKit
import Firebase
import SVProgressHUD

class SignIn: UITableViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func signInPressed(_ sender: Any) {
        if (emailTextField.text?.isEmpty)!{
            showAlert(titleStr: "Error", messageStr: "Enter email")
            
        }
        else if (passwordTextField.text?.isEmpty)!{
            showAlert(titleStr: "Error", messageStr: "Enter password")
            //
        }
            
        else {
            SVProgressHUD.show()
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!)
            {
                (user, error) in
                if error != nil{
                    print(error!)
                }
                else{
                    print("Login successful")
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "parkingStatus", sender: self)
                }
                
            }
        }
    }
    
    @IBAction func backToWelcome(_ sender: Any) {
        self.dismiss(animated: false) {
        }
    }
    
    func showAlert(titleStr: String, messageStr: String){
        let emptyAlert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: .alert)
        emptyAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(emptyAlert, animated: true)
    }
    
    //function to validate email address
    func isValidEmail(emailStr:String) -> Bool {
        // print("validate calendar: \(emailStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
    
   
    
}


