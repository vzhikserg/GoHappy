//
//  HomeViewController.swift
//  KooKoo
//
//  Created by Channa Karunathilake on 6/24/16.
//  Copyright © 2016 KooKoo. All rights reserved.
//

import UIKit
import SwiftLocation
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet weak var heroButton: UIButton!
    @IBOutlet weak var alertLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        LocationManager.shared.observeLocations(.Country, frequency: .Significant, onSuccess: { (l) in

            }) { (e) in

        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(appDidResume), name: UIApplicationWillEnterForegroundNotification, object: nil)

        updateUIForGpsAuthStatus()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        heroButton.alpha = 0
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        heroButton.popIn(nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        applyStyles()
    }

    func applyStyles() {
        heroButton.layer.cornerRadius = heroButton.bounds.width / 2
    }

    func appDidResume(notification: NSNotification) {

        updateUIForGpsAuthStatus()
    }

    func updateUIForGpsAuthStatus() {

        if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            heroButton.backgroundColor = UIColor(hex6: 0x0080FF)
            alertLabel.text = ""
            heroButton.setTitle("Go", forState: .Normal)
            heroButton.setImage(nil, forState: .Normal)
            heroButton.tag = 0
        } else {
            heroButton.backgroundColor = UIColor.redColor()
            alertLabel.text = localizedString("We need to know where you are. Tap the button to enable Location Services.")
            heroButton.setTitle("", forState: .Normal)
            heroButton.setImage(UIImage(named: "sad-icon"), forState: .Normal)
            heroButton.tag = 1
        }
    }

    @IBAction func didTapHeroButton(sender: AnyObject) {

        if heroButton.tag == 1 {
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            }
            return
        }

        let transition: CATransition = CATransition()
        transition.duration = 0.15
        transition.type = kCATransitionFade
        navigationController?.view.layer.addAnimation(transition, forKey: nil)
        
        performSegueWithIdentifier("tracking", sender: self)
    }
}
