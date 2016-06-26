//
//  ZoneCell.swift
//  KooKoo
//
//  Created by Channa Karunathilake on 6/25/16.
//  Copyright © 2016 KooKoo. All rights reserved.
//

import UIKit

class ZoneCell: UITableViewCell {

    @IBOutlet weak var zoneLabel: UILabel!
    @IBOutlet weak var zoneNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var bulletView: UIView!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        bulletView.layer.cornerRadius = 5
        countLabel.layer.cornerRadius = 5
        countLabel.layer.masksToBounds = true
    }
}
