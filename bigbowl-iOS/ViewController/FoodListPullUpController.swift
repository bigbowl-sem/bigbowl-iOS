//
//  FoodListViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 10/23/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import UIKit
import PullUpController


class FoodDetailCell: UITableViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var meal: UILabel!
    @IBOutlet weak var cook: UILabel!
    @IBOutlet weak var stars: UILabel!
    @IBOutlet weak var price: UILabel!
}

class FoodListPullUpController: PullUpController {
    
    enum InitialState {
         case contracted
         case expanded
         case zero
    }
    
    var items: [String] = [
       "yo", "🐱", "🐔", "🐶", "🦊", "🐵", "🐼", "🐷", "💩", "🐰",
       "🤖", "🦄", "🐻", "🐲", "🦁", "💀", "🐨", "🐯", "👻", "🦖",
    ]
    
    var sortBy: [String] = [
        "Rating", "Price", "Distance"
    ]
     
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var picker = UIPickerView()
    var toolBar = UIToolbar()

    var initialState: InitialState = .contracted
    
    
    var initialPointOffset: CGFloat {
        switch initialState {
        case .zero:
            return 0
        case .contracted:
            return 250
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
                              height: bodyView.frame.maxY - 175)
        landscapeFrame = CGRect(x: 5, y: 50, width: 280, height: 300)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    override func loadView() {
        super.loadView()
        
    }

    @IBAction func sortTapped(_ sender: Any) {
        picker = UIPickerView.init()
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        picker.dataSource = self
        picker.delegate = self

//        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
//        toolBar.barStyle = .blackTranslucent
//        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
//        self.view.addSubview(toolBar)
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(identifier: "FilterViewController") as? FilterViewController {
                   navigationController?.pushViewController(viewController, animated: true)
            }
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
        case .zero:
            return [0]
        case .contracted:
            return [topView.frame.maxY]
        case .expanded:
            return [50, topView.frame.maxY]
        }
    }
    
    override var pullUpControllerBounceOffset: CGFloat {
        return 1
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

extension FoodListPullUpController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoodDetailCell", for: indexPath) as! FoodDetailCell
            
            // let item = self.items[indexPath.item]
            cell.cook?.text = "Brad Pitt"
            cell.price?.text = "$5.99"

            cell.meal?.text = "Pad thai"
            cell.stars?.text = "5/5 rating"
    //        cell.foodImage?.image = UIImage(named: "flame")
            return cell
        }
}

extension FoodListPullUpController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
        if let viewController = storyboard?.instantiateViewController(identifier: "FoodDetailViewController") as? FoodDetailViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension FoodListPullUpController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortBy.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortBy[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // do something
    }
    
}
