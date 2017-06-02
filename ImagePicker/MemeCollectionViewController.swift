//
//  MemeCollectionViewController.swift
//  ImagePicker
//
//  Created by Kim Wayne on 6/1/17.
//  Copyright © 2017 GthomasWADE. All rights reserved.
//


import UIKit

class MemeCollectionViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes: [MemeImage]!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    //MARK: UICollectionViews Delegates
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionCell
        
        let meme = memes[indexPath.item]
        
        cell.memeImg.image = meme.memedImage
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Get the object of DetailMemeViewController from the Storyboard
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailMeme") as! DetailMeme
        
        //Pass the Meme Date
        controller.meme = self.memes[indexPath.item]
        self.navigationController!.pushViewController(controller, animated: true)
    }
}

