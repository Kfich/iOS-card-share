//
//  SkeletonCell.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//


import UIKit
import Skeleton

class SkeletonCell: UITableViewCell {
    @IBOutlet weak var imagePlaceholderView: UIView!
    @IBOutlet weak var titlePlaceholderView: GradientContainerView!
    @IBOutlet weak var subtitlePlaceholderView: GradientContainerView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imagePlaceholderView.layer.cornerRadius = imagePlaceholderView.bounds.width/2
    }
}

extension SkeletonCell: GradientsOwner {
    var gradientLayers: [CAGradientLayer] {
        return [titlePlaceholderView.gradientLayer, subtitlePlaceholderView.gradientLayer]
    }
}
