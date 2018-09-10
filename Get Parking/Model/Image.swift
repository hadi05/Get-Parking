//
//  images.swift
//  Get Parking
//
//  Created by adil on 08/09/2018.
//

import UIKit
import Firebase

class Image
{
    var image: UIImage
    var downloadURL: URL?
    var downloadURLString: String!
    var ref: StorageReference!
    
    init(image: UIImage) {
        self.image = image
    }
    
    func saveProfileImage(_ userUID: String, _ completion: @escaping (Error?) -> Void)
    {
        let resizedImage = image.resize()
        if let imageData = UIImageJPEGRepresentation(resizedImage, 0.9) {
            // 1. get the reference
            ref = StoreReference.profileImages.reference().child(userUID)
            downloadURLString = ref.description
            
            // 2. save that data to the reference
            ref.putData(imageData, metadata: nil, completion: { (metaData, error) in
                completion(error)
                
            })
        }
    }
}

private extension UIImage
{
    func resize() -> UIImage {
        let height: CGFloat = 1000.0
        let ratio = self.size.width / self.size.height
        let width = height * ratio
        
        let newSize = CGSize(width: width, height: height)
        let newRectangle = CGRect(x: 0, y: 0, width: width, height: height)
        
        // context - canvas
        UIGraphicsBeginImageContext(newSize)
        
        // draw the newly sized image on the canvas
        self.draw(in: newRectangle)
        
        // get the new size image into a new varibale
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // close the canvas
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
}
