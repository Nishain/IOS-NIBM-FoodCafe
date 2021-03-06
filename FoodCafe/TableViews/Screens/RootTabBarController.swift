//
//  RootTabBarController.swift
//  FoodCafe
//
//  Created by Nishain on 3/5/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .black
        for barItem in tabBar.items!{
            barItem.setTitleTextAttributes([.font:UIFont.systemFont(ofSize: 20)], for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        tabBar.selectionIndicatorImage = UIColor.systemYellow.image(CGSize(width: tabBar.frame.width/3, height: tabBar.frame.height))
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
