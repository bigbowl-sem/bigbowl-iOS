//
//  FoodListViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 10/23/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import SwiftUI
import PullUpController

class FoodListViewController: PullUpController {
    
    enum InitialState {
         case contracted
         case expanded
     }
     
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bodyView: UIView!
    
    var initialState: InitialState = .contracted
    
    
    var initialPointOffset: CGFloat {
        switch initialState {
        case .contracted:
            return 100
        case .expanded:
            return pullUpControllerPreferredSize.height
        }
    }
        
    public var portraitSize: CGSize = .zero
    public var landscapeFrame: CGRect = .zero
        
    // MARK: - Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        portraitSize = CGSize(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                              height: bodyView.frame.maxY)
        landscapeFrame = CGRect(x: 5, y: 50, width: 280, height: 300)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layer.cornerRadius = 12
    }
        
    override func pullUpControllerWillMove(to stickyPoint: CGFloat) {
//        print("will move to \(stickyPoint)")
    }
    
    override func pullUpControllerDidMove(to stickyPoint: CGFloat) {
//        print("did move to \(stickyPoint)")
    }
    
    override func pullUpControllerDidDrag(to point: CGFloat) {
//        print("did drag to \(point)")
    }
        
    // MARK: - PullUpController
    
    override var pullUpControllerPreferredSize: CGSize {
        return portraitSize
    }
    
    override var pullUpControllerPreferredLandscapeFrame: CGRect {
        return landscapeFrame
    }
    
    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
        switch initialState {
        case .contracted:
            return [topView.frame.maxY]
        case .expanded:
            return [50, topView.frame.maxY]
        }
    }
    
    override var pullUpControllerBounceOffset: CGFloat {
        return 20
    }
        
    override func pullUpControllerAnimate(action: PullUpController.Action,
                                          withDuration duration: TimeInterval,
                                          animations: @escaping () -> Void,
                                          completion: ((Bool) -> Void)?) {
        switch action {
        case .move:
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: animations,
                           completion: completion)
        default:
            UIView.animate(withDuration: 0.3,
                           animations: animations,
                           completion: completion)
        }
    }

}
