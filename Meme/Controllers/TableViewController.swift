//
//  TableViewController.swift
//  Meme
//
//  Created by J on 2020-04-26.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UIViewControllerTransitioningDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var addNewMemeButton: UIBarButtonItem!
    
    var memes = [Meme]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.rightBarButtonItem = self.addNewMemeButton
        self.tableView.rowHeight = 80.0
        memes = appDelegate.memes
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memes = appDelegate.memes
        self.tableView.reloadData"
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        let meme = self.memes[indexPath.row]
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        let itemSize = CGSize(width:100.0, height:80.0)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, 0.0)
        let imageRect = CGRect(x:0.0, y:0.0, width:itemSize.width, height:itemSize.height)
        cell.imageView?.image!.draw(in:imageRect)
        cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToDetail":
            let destinationVC = segue.destination as! MemeDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedMeme = memes[indexPath.row]
            }
        case "goToEdit":
            print("segue for goToEdit")
        default:
            print("default segue")
        }
    }
}
