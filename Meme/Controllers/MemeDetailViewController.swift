//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by J on 2020-04-26.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedMeme: Meme! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memedImage = selectedMeme?.memedImage {
            imageView.image = memedImage
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
