//
//  PairCardViewController.swift
//  FoobarGuidance
//
//  Created by Jakub Mazur on 15/03/2017.
//  Copyright © 2017 wingu AG. All rights reserved.
//

import UIKit
import CoreLocation

class PairCardViewController: UIViewController {
    
    @IBOutlet weak var bigCardImageView: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let locationManager : LocationManager = LocationManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        self.cardNumberLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //code
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //code
        super.viewWillDisappear(animated)
    }

    @IBAction func pairButtonTapped(_ sender: Any) {
        self.locationManager.scanForCard()
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
}

extension PairCardViewController : CardSearcherProtocol {
    func cardFound(_ beacon: CLBeacon) {
        self.addCardButton.isHidden = true
        self.cardNumberLabel.isHidden = false
        self.bigCardImageView.isHidden = false
        self.activityIndicator.isHidden = true
        self.cardNumberLabel.text = "Your card number is: \(beacon.major)\(beacon.minor)"
    }
}
