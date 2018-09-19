//
//  FirebaseReference.swift
//  Get Parking
//
//  Created by Hadi on 07/09/2018.
//

import Foundation
import Firebase



enum DbReference {
    
    case root
    case users(uid: String)
    
    // MARK: - Public
    
    func reference() -> DatabaseReference
    {
        switch self {
        case .root:
            return rootRef
        default:
            return rootRef.child(path)
        }
    }
    
    private var rootRef: DatabaseReference {
        return Database.database().reference()
    }
    
    private var path: String {
        switch self {
        case .root:
            return ""
        case .users(let uid):
            return "users/\(uid)"
        }
    }
}

enum StoreReference
{
    case root
    case profileImages
    
    func reference() -> StorageReference {
        switch self {
        case .root:
            return rootRef
        default:
            return rootRef.child(path)
        }
    }
    
    private var rootRef: StorageReference {
        return Storage.storage().reference()
    }
    
    private var path: String {
        switch self {
        case .root:
            return ""
        case .profileImages:
            return "profileImages"
        }
    }
}

