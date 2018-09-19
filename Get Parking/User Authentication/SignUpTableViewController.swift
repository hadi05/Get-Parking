//
//  SignUpTableViewController.swift
//  Get Parking
//
//  Created by adil on 08/09/2018.
//

//    var carBrand = ["Toyota","Suzuki","Honda","Audi","BMW","Porsche","Lexus","Nissan","Hyundai","Mercedes","Land Rover"]
//    var toyotaModel = ["Crown", "Camry", "Sai", "Mark X", "Premio", "Prius", "Corrola", "Land Cruiser", "Hilux", "Vitz"]
//    var suzukiModel = ["Mehran", "Cultus", "Wagon R","APV", "Ciaz", "Jimny","Carry", "Alto", "Vitara"]
//    var hondaModel = ["City", "Civic", "BR-V","Ballade", "Accord", "Amaze","Vezel", "N-One", "Freed","Fit Hybrid"]
//    var audiModel = ["A3", "A4", "A6","Q7", "A8"]
//    var BMWModel = ["X1", "X2", "X3","X4", "X5", "X6"]



import UIKit
import Firebase
import SVProgressHUD

class SignUpTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    /* Outlets */
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var carModel: UITextField!
    @IBOutlet weak var carNumber: UITextField!
    @IBOutlet weak var carCompany: UITextField!
    
    var profilePicture:UIImage!
    
    var picker =  UIPickerView()
    
    let ref = Database.database().reference()
    var selectedCarBrand : String?
    var selectedCarModel : String?

    var carBrand: NSArray!
    var carModelArray: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCarBrandData()
        carModel.delegate = self
        carCompany.delegate = self
        
        picker.dataSource = self
        picker.delegate = self
        carCompany.inputView = picker
        carModel.inputView = picker
    }
    
    
    // Mark: UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (carCompany.isFirstResponder) {
//            if (carBrand.count <= 0) {
//                return 1
//            } else {
            return carBrand.count ?? 1
//            }
        } else if (carModel.isFirstResponder) {
            return carModelArray.count ?? 1
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (carCompany.isFirstResponder) {
            carCompany.text = carBrand[row] as? String
            selectedCarBrand = carCompany.text
            self.view.endEditing(false)
            getCarModel(carCompany: carCompany.text!)
        } else {
            carModel.text = carModelArray[row] as? String
            selectedCarModel = carModel.text
            self.view.endEditing(false)
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // self.view.endEditing(true)
        if (carCompany.isFirstResponder) {
            return carBrand[row] as! String
        } else if (carModel.isFirstResponder) {
            return carModelArray[row] as! String ?? "Empty"
        }
        return "Empty"
    }
    
    func getCarBrandData(){
        SVProgressHUD.show()
        ref.child("cars").observe(.value, with: { snapshot in
       //     print(snapshot)
            let values = snapshot.value as! [String : AnyObject]
            self.carBrand = values ["carBrand"] as! NSArray
            SVProgressHUD.dismiss()
        })
    }
    
    func getCarModel(carCompany: String) {
        SVProgressHUD.show()
        ref.child("cars").observe(.value, with: { snapshot in
            let values = snapshot.value as! [String : AnyObject]
            self.carModelArray = values ["\(carCompany)"] as! NSArray
            SVProgressHUD.dismiss()
        })
    }
    
    // Actions
    @IBAction func changeProfilePicture(_ sender: Any) {
        profilePicture = UIImage(named: "sp")
        
        // Making the profileImageView in round shape
        profileImageView.image = profilePicture
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2.0
        profileImageView.layer.masksToBounds = true
    }
    
    @IBAction func createNewAccount(_ sender: Any) {
        
        let fullname = self.fullName.text
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        let contactNumber = self.contactNumber.text
        let carCompany = self.carCompany.text //self.carCompany.text
        let carModel =  self.carModel.text
        let carNumber = self.carNumber.text
        
        profilePicture = UIImage(named: "sp")
        
        if email != "" && fullname != "" && contactNumber != "" && password != "" && carCompany != "" && carModel != "" && carNumber != "" {
            if isValidEmail(emailStr: email!){
                if 2 ... 32 ~= fullname!.count{
                    if (password?.count)! > 6 {
                        if contactNumber?.count == 11{
                            
                            SVProgressHUD.show()
                            // 1. sign up a new account
                            
                            Auth.auth().createUser(withEmail: email!, password: password!, completion: { (firUser, error) in
                                let newUser = User(uid: (firUser?.user.uid)!, name: fullname!, profileImage: self.profilePicture!, email: email!, mobile: contactNumber!, carModel: carModel!, carNumber: carNumber!, carCompany: carCompany!)
                                newUser.save(completion: { (error) in
                                    if error != nil {
                                        print(error as Any)
                                    } else {
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
                                 //   self.performSegue(withIdentifier: "login", sender: nil)
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
    
    // Mark: TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (carCompany.isFirstResponder) {
            self.carModel.text = ""
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        picker.reloadAllComponents()
    }
}








