//
//  MemeTableViewController.swift
//  ImagePicker
//
//  Created by Kim Wayne on 6/1/17.
//  Copyright © 2017 GthomasWADE. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController : UITableViewController {
    
    
    var memes: [MemeImage] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell", for: indexPath) as! MemeTableCell
        let meme = memes[indexPath.row]
        cell.memeImg.image = meme.memedImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeView = self.storyboard?.instantiateViewController(withIdentifier: "DetailMeme") as! DetailMeme
        memeView.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(memeView, animated: true)
    }
}

