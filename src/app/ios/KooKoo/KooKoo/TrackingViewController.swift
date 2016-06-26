//
//  TrackingViewController.swift
//  KooKoo
//
//  Created by Channa Karunathilake on 6/25/16.
//  Copyright © 2016 KooKoo. All rights reserved.
//

import UIKit
import SwiftLocation
import ZAlertView

class TrackingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var disabledButtons: [UIButton]!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var passengersCountLabel: UILabel!
    @IBOutlet weak var waveView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var codeButton: UIButton!
    var passengerCount = 0;
    var locationRequest: LocationRequest?
    var zones = [String]()
    var passengerCountForZone = [Int]()

    var lastZone: String?

    //Demo zones for the presentation
    private var tempZoneIndex = 0
    private var simulatedZones = ["Klagenfurt", "Krumpendorf", "Pörtschach", "Velden", "Villach", "Spittal a.d. Drau"]

    private var viewHasAppeared = false

    override func viewDidLoad() {
        super.viewDidLoad()

        passengersCountLabel.alpha = 0

        startSimulatedTracking()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if viewHasAppeared { return }

        stopButton.alpha = 0
        tableView.alpha = 0
        addButton.alpha = 0
        codeButton.alpha = 0
        minusButton.alpha = 0
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if viewHasAppeared { return }
        viewHasAppeared = true

        stopButton.popIn { (finished) in

            self.animateWave()

            UIView.animateWithDuration(0.2, animations: { 
                self.tableView.alpha = 1
            })
        }

        addButton.alpha = 0
        addButton.transform = CGAffineTransformIdentity

        codeButton.alpha = 0
        codeButton.transform = CGAffineTransformIdentity

        UIView.animateWithDuration(0.8,
                                   delay: 0.0,
                                   usingSpringWithDamping: 0.7,
                                   initialSpringVelocity: 0,
                                   options: [],
                                   animations: {

                                    let t = CGFloat(0 * M_PI / 180.0)

                                    self.codeButton.alpha = 0.75
                                    self.codeButton.transform = CGAffineTransformMakeTranslation(100 * cos(t), -100 * sin(t))
                                    
            }, completion: nil)

        UIView.animateWithDuration(0.8,
                                   delay: 0.1,
                                   usingSpringWithDamping: 0.7,
                                   initialSpringVelocity: 0,
                                   options: [],
                                   animations: {

                                    let t = CGFloat(-45 * M_PI / 180.0)
                                    self.addButton.alpha = 0.75
                                    self.addButton.transform = CGAffineTransformMakeTranslation(100 * cos(t), -100 * sin(t))
                                    
            }, completion: nil)

        var delay = 0.2
        var startAngle = 180.0

        for button in disabledButtons {

            UIView.animateWithDuration(0.5,
                                       delay: delay,
                                       usingSpringWithDamping: 0.7,
                                       initialSpringVelocity: 0,
                                       options: [],
                                       animations: {

                                        let t = CGFloat(startAngle * M_PI / 180.0)
                                        button.alpha = 0.6
                                        button.transform = CGAffineTransformMakeTranslation(100 * cos(t), -100 * sin(t))
                                        
                }, completion: nil)

            startAngle -= 30
            delay += 0.05
        }
    }

    func animateWave() {

        waveView.alpha = 0.95
        waveView.transform = CGAffineTransformIdentity

        UIView.animateWithDuration(1.5, delay: 0, options: [], animations: {
            self.waveView.transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.waveView.alpha = 0
        }) { (finished) in
            self.animateWave()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        applyStyles()
    }

    func applyStyles() {
        stopButton.layer.cornerRadius = stopButton.bounds.width / 2
        waveView.layer.cornerRadius = waveView.bounds.width / 2
        passengersCountLabel.layer.cornerRadius = passengersCountLabel.bounds.width / 2
        addButton.layer.cornerRadius = addButton.bounds.width / 2
        addButton.layer.masksToBounds = true
        codeButton.layer.cornerRadius = codeButton.bounds.width / 2
        codeButton.layer.masksToBounds = true
        minusButton.layer.cornerRadius = minusButton.bounds.width / 2
        minusButton.layer.masksToBounds = true
        passengersCountLabel.layer.masksToBounds = true

        for button in disabledButtons {
            button.layer.cornerRadius = button.bounds.width / 2
            button.layer.masksToBounds = true
        }
    }

    @IBAction func didTapStopButton(sender: AnyObject) {

        stopTracking()
    }

    @IBAction func didTapCodeButton(sender: AnyObject) {

        let transition: CATransition = CATransition()
        transition.duration = 0.15
        transition.type = kCATransitionFade
        navigationController?.view.layer.addAnimation(transition, forKey: nil)

        performSegueWithIdentifier("code", sender: self)
    }

    @IBAction func didTapAddButton(sender: AnyObject) {

        passengerCount += 1

        passengersCountLabel.text = "+\(passengerCount)"
        passengersCountLabel.popIn(nil)

        if passengerCount == 1 {

            minusButton.alpha = 0
            minusButton.transform = CGAffineTransformIdentity

            UIView.animateWithDuration(0.8,
                                       delay: 0.1,
                                       usingSpringWithDamping: 0.7,
                                       initialSpringVelocity: 0,
                                       options: [],
                                       animations: {

                                        let t = CGFloat(-67 * M_PI / 180.0)

                                        self.minusButton.alpha = 0.75
                                        self.minusButton.transform = CGAffineTransformMakeTranslation(100 * cos(t), -100 * sin(t))
                                        
                }, completion: nil)
        }
    }

    @IBAction func didTapMinusButton(sender: AnyObject) {

        passengerCount -= 1

        passengersCountLabel.text = "+\(passengerCount)"

        if passengerCount == 0 {

            UIView.animateWithDuration(0.2, animations: {

                self.passengersCountLabel.alpha = 0
                self.passengersCountLabel.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.minusButton.alpha = 0
                self.minusButton.transform = CGAffineTransformIdentity
            })

        } else {
            passengersCountLabel.popIn(nil)
        }
    }

    func startTracking() {

        LocationManager.shared.allowsBackgroundEvents = true

        //TODO: change continouous to distance
        locationRequest = LocationManager.shared.observeLocations(.Block, frequency: .Continuous, onSuccess: { (location) in

            APIClient.shared.sendLocation(location, completion: { (response, error) in

                guard error == nil else {
                    return
                }

                guard let dict = response as? [String: AnyObject] else {
                    return
                }

                if let tempZones = dict["Zones"] as? [[String: AnyObject]] {
                    if self.tempZoneIndex < tempZones.count {

                        let currentZone = tempZones[self.tempZoneIndex]["Name"] as! String

                        if self.lastZone != currentZone {
                            self.zones.insert(currentZone, atIndex: 0)
                            self.passengerCountForZone.insert(self.passengerCount, atIndex: 0)
                            self.lastZone = currentZone

                            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
                        }
                    } else {

                        
                    }
                }
            })

        }) { (error) in

            print(error)
        }
    }

    func startSimulatedTracking() {

        guard simulatedZones.count > 0 else { return }

        let z = simulatedZones.removeFirst()

        zones.insert(z, atIndex: 0)
        passengerCountForZone.insert(passengerCount, atIndex: 0)

        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)

        self.performSelector(#selector(startSimulatedTracking), withObject: nil, afterDelay: NSTimeInterval(5 * zones.count))
    }
    
    func stopTracking() {

        LocationManager.shared.allowsBackgroundEvents = false

        locationRequest?.stop()

        let transition: CATransition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        navigationController?.view.layer.addAnimation(transition, forKey: nil)
        navigationController?.popViewControllerAnimated(false)
    }

    // MARK: - 

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zones.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(String(ZoneCell), forIndexPath: indexPath)

        if let zoneCell = cell as? ZoneCell {

            zoneCell.zoneNameLabel.text = zones[indexPath.row]

            let coef = 1 / CGFloat(indexPath.row + 1)
            let scaleCoef = 1 - (CGFloat(indexPath.row) / 5)
            zoneCell.zoneNameLabel.alpha = coef
            zoneCell.bulletView.transform = CGAffineTransformMakeScale(scaleCoef, scaleCoef)
            zoneCell.zoneLabel.text = (indexPath.row == 0) ? "Zone" : ""
            zoneCell.topLine.hidden = (indexPath.row == 0)
            zoneCell.bottomLine.hidden = (indexPath.row == zones.count - 1)
            zoneCell.countLabel.hidden = (passengerCountForZone[indexPath.row] == 0)
            zoneCell.countLabel.text = "+\(passengerCountForZone[indexPath.row])"
        }

        return cell
    }
}
