//
//  SignUpTableViewController.swift
//  Get Parking
//
//  Created by adil on 08/09/2018.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpTableViewController: UITableViewController {
    
    var profilePicture:UIImage!
    @IBAction func changeProfilePicture(_ sender: Any) {
        profilePicture = UIImage(named: "sp")
        
        // Making the profileImageView in round shape
        profileImageView.image = profilePicture
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2.0
        profileImageView.layer.masksToBounds = true
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var carModel: UITextField!
    @IBOutlet weak var carNumber: UITextField!
    @IBOutlet weak var carCompany: UITextField!
    
    
    
    
    @IBAction func createNewAccount(_ sender: Any) {
        
        let fullname = self.fullName.text
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        let contactNumber = self.contactNumber.text
        let carCompany = "Honda" //self.carCompany.text
        let carModel =  "civic"//self.carModel.text
        let carNumber = "567"//self.carNumber.text
        
        profilePicture = UIImage(named: "sp")
        
        if email != "" && fullname != "" && contactNumber != "" && password != "" && carCompany != "" && carModel != "" && carNumber != "" {
            if isValidEmail(emailStr: email!){
                if 2 ... 32 ~= fullname!.count{
                    if (password?.count)! > 6 {
                        if contactNumber?.count == 11{
                            
                            SVProgressHUD.show()
                            // 1. sign up a new account
                            
                            Auth.auth().createUser(withEmail: email!, password: password!, completion: { (firUser, error) in
                                let newUser = User(uid: (firUser?.user.uid)!, name: fullname!, profileImage: self.profilePicture!, email: email!, mobile: contactNumber!, carModel: carModel, carNumber: carCompany, carCompany: carNumber)
                                newUser.save(completion: { (error) in
                                    if error != nil {
                                        print(error as Any)
                                    } else{
                                        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) {
                                            (user, error) in
                                            if error != nil{
                                                print(error!)
                                            }
                                            
                                        }
                                    }
                                })
                                SVProgressHUD.dismiss()
                                let alertController = UIAlertController(title: "Registered Successfull", message: "Please Sign In", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
                                    //run your function here
                                    self.dismiss(animated: true, completion: nil)
                                    
                                })
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            })
                            
                            
                        }else{
                            showAlert(messageStr: "Mobile Number should have 11 digits")
                        }
                    }else{
                        showAlert(messageStr: "The Password field must be at least 7 characters in length.")
                    }
                }else{
                    showAlert(messageStr: "Full name must be between 2 to 32 characters.")
                }
            }else{
                showAlert(messageStr: "Please enter a valid email")
            }
            
        }else{
            showAlert(messageStr: "All field are required")
        }
        
//        if (emailTextField.text?.isEmpty)!{
//            showAlert(messageStr: "Email Field is empty")
//        }
//         else if !isValidEmail(emailStr: emailTextField.text!){
//              showAlert(messageStr: "Enter a valid email")
//        }
//        else if (fullName.text?.isEmpty)!{
//            showAlert(messageStr: "Enter Full name")
//        } else if (contactNumber.text?.isEmpty)!{
//            showAlert(messageStr: "Please enter contact number")
//        }else if (passwordTextField.text?.isEmpty)!{
//            showAlert(messageStr: "Password Field is empty")
//        }else if (carCompany.text?.isEmpty)!{
//            showAlert(messageStr: "Enter car company")
//        }else if (carModel.text?.isEmpty)!{
//            showAlert(messageStr: "Enter car model")
//        }else if (carNumber.text?.isEmpty)!{
//            showAlert(messageStr: "Enter car Number")
//        }
        
        
    }
    
    @IBAction func backToWelcome(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func showAlert(messageStr: String){
        let emptyAlert = UIAlertController(title: "Error", message: messageStr, preferredStyle: .alert)
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






