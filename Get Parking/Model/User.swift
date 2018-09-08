//
//  User.swift
//  Get Parking
//
//  Created by adil on 08/09/2018.
//

import UIKit

class User
{
    var name: String
    let uid: String
    var mobile: String
    var profileImage: UIImage!
    var email: String
    
    init(uid: String, name: String, profileImage: UIImage, email: String, mobile: String)
    {
        self.uid = uid
        self.name = name
        self.profileImage = profileImage
        self.email = email
        self.mobile = mobile
    }
    
   
    
    // save the user information
    
    func save(completion: @escaping (Error?) -> Void)
    {
        // 1. reference to the database
        let ref = DbReference.users(uid: uid).reference()
        
        // 2. setValue of the reference
        ref.setValue(toDictionary())
        
        // 3. save the user's profile Image
        if let profileImage = self.profileImage {
            let image = Image(image: profileImage)
            image.saveProfileImage(uid, { (error) in
                // is caleld whenever the profile image is successfully uploaded - takes time!!!!!!
                completion(error)
            })
        }
    }
    
    func toDictionary() -> [String : Any]
    {
        return [
            "uid" : uid,
            "name" : name,
            "mobile" : mobile,
            "email" : email
        ]
    }
}

