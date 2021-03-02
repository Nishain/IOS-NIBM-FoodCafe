//
//  Reciept.swift
//  FoodCafe
//
//  Created by Nishain on 2/28/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import Foundation
struct Reciept:Codable {
    var date:String
    var products:[PendingOrder]
    var totalCost:Int = 0
    
    func asDictionary()->[String:Any]{
        let data = try? JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : Any]
    }
    static func decodeAsStruct(data:[String:Any])->Reciept{
        let serializedData = try! JSONSerialization.data(withJSONObject: data, options: [])
        return try! JSONDecoder().decode(Reciept.self, from: serializedData)
    }
}
