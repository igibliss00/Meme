//
//  Meme.swift
//  Meme
//
//  Created by J on 2020-04-25.
//  Copyright © 2020 J. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}

//func generateMemedImage() -> UIImage {
//
//    // Render view to an image
//    UIGraphicsBeginImageContext(self.view.frame.size)
//    view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
//    let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//    UIGraphicsEndImageContext()
//
//    return memedImage
//}
