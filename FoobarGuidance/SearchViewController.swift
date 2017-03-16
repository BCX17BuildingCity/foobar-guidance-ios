//
//  SearchViewController.swift
//  FoobarGuidance
//
//  Created by Jakub Mazur on 15/03/2017.
//  Copyright © 2017 wingu AG. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class SearchViewController: UIViewController {
    
    var dataRequest : Alamofire.DataRequest?
    
    @IBOutlet weak var tableView: UITableView!
    let locationManager : LocationManager = LocationManager.sharedInstance
    var plainResults : [[String : Any]] = [[String : Any]]() {
        didSet {
            locationManager.results = self.plainResults
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "SearchUITableViewCell", bundle: nil), forCellReuseIdentifier: "searchTableViewCell")

    }

    func requestPlace(_ name : String, coords : CLLocationCoordinate2D) {
        let urlRequest : String = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(name)&location=\(coords.latitude),\(coords.longitude)&radius=100&language=de&key=\(AppDelegate.googleMapsKey)"
        self.dataRequest = Alamofire.request(urlRequest).responseJSON { response in
            if let JSON = response.result.value {
                if JSON is [String : Any] {
                    self.plainResults = (JSON as! [String : Any])["results"] as! [[String : Any]]
                }
            }
        }
    }
}

extension SearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.dataRequest?.cancel()
        self.dataRequest = nil
        self.requestPlace(searchBar.text ?? "", coords: self.locationManager.locationCoords)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension SearchViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.plainResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SearchUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell") as! SearchUITableViewCell
        cell.textLabel?.text = plainResults[indexPath.row]["name"] as! String?
        return cell
    }
    
}
