//
//  SecurityViewController.swift
//  KooKoo
//
//  Created by Channa Karunathilake on 6/25/16.
//  Copyright © 2016 KooKoo. All rights reserved.
//

import UIKit
import CircleProgressBar

class SecurityViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var securityContainer: UIView!
    @IBOutlet weak var progressBar: CircleProgressBar!

    let icons = ["bird", "cat", "elephant", "pig"]

    override func viewDidLoad() {
        super.viewDidLoad()

        let img = UIImage(named: icons[Int((NSDate().timeIntervalSince1970 / 10) % 4)])?.imageWithRenderingMode(.AlwaysTemplate)
        iconImageView.image = img
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        securityContainer.alpha = 0
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        securityContainer.popIn { (finished) in

            self.progressBar.setProgress(0, animated: true, duration: 4)

            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {

                let transition: CATransition = CATransition()
                transition.duration = 0.15
                transition.type = kCATransitionFade
                self.navigationController?.view.layer.addAnimation(transition, forKey: nil)
                self.navigationController?.popViewControllerAnimated(false)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        securityContainer.layer.cornerRadius = securityContainer.bounds.width / 2
    }
}
