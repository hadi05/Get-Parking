//
//  AppDelegate.swift
//  Get Parking
//
//  Created by Hadi on 06/09/2018.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        
        
//        let user = User(uid: "3", name: "Ali", profileImage: UIImage(named: "logo")!, email: "hadi050892@gmail.com", mobile: "03314154757")
//        user.save { (error) in
//            print(error)
//        }
        
       
        
        return true
    }

}

