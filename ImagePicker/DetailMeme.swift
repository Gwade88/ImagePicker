//
//  DetailMeme.swift
//  ImagePicker
//
//  Created by Kim Wayne on 6/2/17.
//  Copyright © 2017 GthomasWADE. All rights reserved.
//

import UIKit

class DetailMeme: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    var meme: MemeImage! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = meme.memedImage
    }
    
    
}
