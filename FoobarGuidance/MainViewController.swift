//
//  MainViewController.swift
//  FoobarGuidance
//
//  Created by Jakub Mazur on 15/03/2017.
//  Copyright © 2017 wingu AG. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var locationManager : LocationManager = LocationManager.sharedInstance
    var wishlist : [String] = [String]()
    @IBOutlet weak var findButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reset()
        
        self.collectionView.register(UINib(nibName: "MainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainCell")
    }
    
    func reset() {
        self.wishlist = ["Brandenburger Tor","Mustafas Gemuese Kebab","Reichstag","Tante Dampf"]
        self.collectionView.reloadData()
        findButton.setTitle("Find the best path", for: .normal)
    }
    
    func request(lon : CGFloat, lat : CGFloat) {
        let urlRequest : String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lon)&radius=500&types=food&name=cruise&key=\(AppDelegate.googleMapsKey)"
        Alamofire.request(urlRequest).responseJSON { response in
            print(response.result)   // result of response serialization
        }
    }
    @IBAction func findButtonTapped(_ sender: Any) {
        if findButton.titleLabel?.text == "Reset" {
            self.reset()
            return
        }
        self.wishlist = ["Reichstag","Brandenburger Tor","Tante Dampf","Mustafas Gemuese Kebab"]
        sleep(2)
        self.collectionView.moveItem(at: IndexPath(row: 1, section: 0), to: IndexPath(row: 3, section: 0))
        self.collectionView.moveItem(at: IndexPath(row: 2, section: 0), to: IndexPath(row: 2, section: 0))
        self.collectionView.moveItem(at: IndexPath(row: 1, section: 0), to: IndexPath(row: 0, section: 0))
        self.collectionView.performBatchUpdates({
            self.collectionView.reloadData()
        }) { (complete) in
            self.findButton.setTitle("Reset", for: .normal)
        }
    }
    
}

extension MainViewController : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MainCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath as IndexPath) as! MainCollectionViewCell
        cell.mainLabel.text = self.wishlist[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width-16, height: 44)
    }
}
