//
//  AnimationFactory.swift
//  SampleJokes
//
//  Created by Pran Kishore on 04/09/23.
//

import UIKit

struct AnimationFactory {
    static func animateWithSpringBehaviour(_ view: UIView) {
        view.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        view.alpha = 0
        // Animate the cell's content view
        UIView.animate(withDuration: 1.5,
                       delay: 0.1,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.2,
                       options: UIView.AnimationOptions.curveLinear,
                       animations: {
            view.transform = .identity
            view.alpha = 1
        }, completion: nil)
    }
}
