//
//  FoodCategoryList.swift
//  FoodCafe
//
//  Created by Nishain on 2/24/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

class FoodCategoryList: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource {
    var selectedIndex = 0
    var data:[String] = []
    var onCatergorySelected : ((Int,String)->Void)?
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        delegate = self
        dataSource = self
    }
    func setData(_ newData:[String]){
        data = newData
        reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCatergoryCell", for: indexPath) as! FoodCategoryCell
        cell.bodyBtn.setTitle(data[indexPath.row], for:.normal)
        if(selectedIndex == indexPath.row){//the cell is selected
            cell.bodyBtn.backgroundColor = .link
            cell.bodyBtn.setTitleColor(.white, for: .normal)
            cell.tag = 2
        }else if(cell.tag == 2){//turn the unselected, which was previously selected item back to normal
            cell.bodyBtn.backgroundColor = nil
            cell.bodyBtn.setTitleColor(.black, for: .normal)
            cell.tag = 0
        }
        cell.userPressBtn = {button in
            self.selectedIndex = indexPath.row
            self.reloadData()
            self.onCatergorySelected?(indexPath.row,self.data[indexPath.row])
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
