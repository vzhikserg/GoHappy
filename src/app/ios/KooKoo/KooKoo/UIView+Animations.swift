//
//  UIView+Animations.swift
//  KooKoo
//
//  Created by Channa Karunathilake on 6/25/16.
//  Copyright © 2016 KooKoo. All rights reserved.
//

import UIKit

extension UIView {

    func popIn(completion: ((Bool) -> Void)?) {

        alpha = 0
        transform = CGAffineTransformMakeScale(0.5, 0.5)

        UIView.animateWithDuration(0.8,
                                   delay: 0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0,
                                   options: [],
                                   animations: { 

                                    self.alpha = 1
                                    self.transform = CGAffineTransformIdentity

            }, completion: completion)
    }
}
