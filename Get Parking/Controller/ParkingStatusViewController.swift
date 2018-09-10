//
//  ParkingStatusViewController.swift
//  Get Parking
//
//  Created by adil on 08/09/2018.
//

import UIKit
import Firebase


class ParkingStatusViewController: UIViewController {

    struct Storyboard {
  //      static let showStatus = "parkingStatus"
        static let showWelcome = "showWelcome"
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        // one time sign-in if the user is already signed in or not
//        Auth.auth().addStateDidChangeListener { (auth, user) in
//            if user != nil{
//                //we do have the user. the user did login
//                // TODO: fetch the parking status
//            }
//            else{
//                // the user dont login or alredy logged out
//                self.performSegue(withIdentifier: Storyboard.showStatus, sender: nil)
//            }
//
//
//        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "welcome", sender: nil)
    }
    
    
    

    

}
