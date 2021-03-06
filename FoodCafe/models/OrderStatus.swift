//
//  OrderStatus.swift
//  FoodCafe
//
//  Created by Nishain on 2/28/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import Foundation
struct OrderStatus : Codable{
    var orderID:Int = 0
    var status:Int = 0
    var orderInfo:[PendingOrder]?
    func asDictionary()->[String:Any]{
        let data = try? JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : Any]
    }
    func isRemovable() -> Bool {
        return status == 0 || status > 3
    }
    static func decodeAsStruct(data:[String:Any])->OrderStatus{
        let serializedData = try! JSONSerialization.data(withJSONObject: data, options: [])
        return try! JSONDecoder().decode(OrderStatus.self, from: serializedData)
    }
}
