//
//  FoodCategoryList.swift
//  FoodCafe
//
//  Created by Nishain on 2/24/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

class FoodCategoryList: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource {
    var selectedIndex = -1
    let data:[String] = ["juices","deserts","breakfast","juices","deserts","breakfast","juices","deserts","breakfast"]
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        delegate = self
        dataSource = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCatergoryCell", for: indexPath) as! FoodCategoryCell
        cell.bodyBtn.setTitle(data[indexPath.row], for:.normal)
        cell.tag = indexPath.row
        if(selectedIndex == indexPath.row){
            cell.bodyBtn.backgroundColor = .link
            cell.bodyBtn.setTitleColor(.white, for: .normal)
        }else {
            cell.bodyBtn.backgroundColor = nil
            cell.bodyBtn.setTitleColor(.black, for: .normal)
        }
        cell.userPressBtn = {button in
            self.selectedIndex = cell.tag
            self.reloadData()
            //self.reloadItems(at: indexesToUpdate)
        }
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
